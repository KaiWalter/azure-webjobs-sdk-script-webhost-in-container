# Azure Functions WebHost (v1.x) in Docker container

## Background
I had the challenge to get Functions running within our ExpressRoute connected VNet in Azure. 

### ASE was not an option
Using ASE seemed not to be a viable option as deployment times (at least over here in Europe) ranged in multiple hours. Additionally ASE builds up a lot of VMs / resources which we would not utilize properly in a Functions only scenario.

### Service Fabric
Next best approach was to get Functions running in the already VNet integrated Service Fabric clusters. Once Functions v2.x based on .NET Core is available this looks like a simple, almost off-the-shelf scenario. However to get the v1.x WebHost running in Service Fabric, I found no other way then to pack up the application in a container based on Windows Server, IIS and ASP.NET 4.6.2.

To minimize shuffling around files in the image and to avoid creating a new IIS web site I just point the default web site to the downloaded and unpacked Functions extension. From there the environment variable `AzureWebJobsScriptRoot` helps the WebHost to pick up and boot the Function app.

## prerequisites

* Windows 10 or Windows 2016 with Container support
* [docker package](https://blogs.technet.microsoft.com/canitpro/2016/10/26/step-by-step-setup-docker-on-your-windows-2016-server/)
* NuGet installed locally

## build the Docker image

### pack the Function App in App.zip
One script builds and packages the Functions app so that it can be added to the container in one step - as a ZIP file.

```
.\buildFunctionApp.ps1
```

### build and run the container
The other script build the Docker image and starts the container either interactively for debugging or in the background.

```
.\buildAndRunDockerImage.ps1
```

### Environment variables
All environment variables required for the Functions host (e.g. Application Insights Instrumentation Key, connection strings for other resources) can be placed in the `hostvariables.env` file, when executing the container in Docker.


## deploy to Service Fabric
Once build, the docker image can be uploaded to a container registry (e.g. ACR) and then deployed to Service Fabric with a simple compose deployment using a file like `docker-compose.yml`.

To deploy to Service Fabric I used the [Docker Compose deployment](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-docker-compose). 

### Always On / Keep Alive
I tested this setup also with background Service Bus queue processing. Though I set the autostart properties for the Web Site, the background processing only started when the WebHost was initiated by a Http trigger. 
For that reason I keep at least one Http triggered function which I query in the Http health probe of Service Fabrics load balancer. That keeps the WebHost up and running for background processing. 
