param(
    $imageName = 'functions-container'
)

# Stop the container, if it is still running
docker stop $imageName|Out-Null

# remove dangling images
docker images --filter "dangling=true" -q | foreach { docker rmi $_ -f}

# Remove the container
docker rm $imageName|Out-Null

# Build the container image
docker build . -t $imageName

# Run the container
$choice = Read-Host "interactive or detached [i/D]"
if ($choice.ToLower() -eq "i") {
    docker run -p 80:80 -it --rm --env-file .\hostvariables.env $imageName
}
else {
    $containerId = (docker run -p 80:80 -d --name $imageName --env-file .\hostvariables.env $imageName)
    Write-Host "started in container " $containerId
    $container = (docker inspect $containerId) | ConvertFrom-Json
    $ipAddress = $container.NetworkSettings.Networks.nat.IPAddress
    
    $delaySeconds = 10
    Write-Host "testing the container in $($delaySeconds)s..."
    Start-Sleep -Seconds $delaySeconds
    $url = "http://" + $ipAddress + ":80/api/HttpTrigger?name=TEST" + (Get-Date -Format s)
    [Diagnostics.Process]::Start($url)
}





