# azure-webjobs-sdk-script-webhost-in-container
.NET Core 2.0 Azure Functions WebHost in Docker container

## prerequisites
- Windows 10 or Windows 2016 Server with Docker installed
- `azure-webjobs-sdk-script` repository is cloned to the same parent folder (as this repository)
- in `azure-webjobs-sdk-script`
```
git checkout core
```

## build for container

## pack the WebHost in Host.zip
```
.\buildWebHost.ps1
```
## pack the Function App in App.zip
```
.\buildFunctionApp.ps1
```

## build and run the container
```
.\buildAndRunDockerImage.ps1
```

