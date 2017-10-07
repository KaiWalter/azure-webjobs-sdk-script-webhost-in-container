$hostRepo = "..\azure-webjobs-sdk-script"
$hostPublish = $hostRepo + "\src\WebJobs.Script.WebHost\bin\Debug\netcoreapp2.0\publish"

Push-Location

Set-Location $hostRepo

dotnet clean WebJobs.Script.sln

dotnet build WebJobs.Script.sln

dotnet publish src\WebJobs.Script.WebHost\WebJobs.Script.WebHost.csproj

Pop-Location

Remove-Item .\Host.zip -ErrorAction SilentlyContinue

Compress-Archive $hostPublish .\Host.zip