# Azure Functions WebHost (v1.x) in Docker container
I had the challenge to get Functions running within our ExpressRoute connected VNet in Azure. 

## Background

### ASE was not an option
Using ASE seemed not to be a viable options as deployment times (at least over here in Europe) were multiple hours. Additionally ASE builds up a lot of VMs / resources which we would not utilize properly in a Functions only scenario.

### Service Fabric
Next best approach was to get Functions running in the already VNet integrated Service Fabric clusters. Once Functions v2.x based on .NET Core is available this looks like a simple, almost off-the-shelf scenario. However to get the v1.x WebHost running in Service Fabric I found no other way then to pack up the application in a container based on Windows Server, IIS and ASP.NET 4.6.2.

## prerequisites

* Windows 10 or Windows 2016 with Container support

## build for Docker

### pack the Function App in App.zip
One script builds and packages the Functions app so that it can be added to the container in one step - as a ZIP file.

```
.\buildFunctionApp.ps1
```

### build and run the container
The other script build the docker image and starts the container either interactively for debugging or in the background.

```
.\buildAndRunDockerImage.ps1
```

### Docker IIS issue
When starting the container, this message is printed out several times

> APPCMD failed with error code 4312
> Applied configuration changes to section "system.applicationHost/applicationPools" for "MACHINE/WEBROOT/APPHOST" at configuration commit path "MACHINE/WEBROOT/APPHOST"
> ERROR ( message:Cannot find requested collection element. )

This is a known [issue](https://github.com/Microsoft/aspnet-docker/issues/35) but has no effect.

### Environment variables
All environment variables required for the Functions host (e.g. Application Insights Instrumentation Key, connection strings for other resources) can be placed in the `hostvariables.env` file, when executing the container in Docker.


## deploy to Service Fabric
Once build, the docker image can be uploaded to a container registry (e.g. ACR) and then deployed to Service Fabric with a simple compose deployment using a file like `docker-compose.yml`.
