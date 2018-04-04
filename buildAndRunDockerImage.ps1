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
.\runDockerImage.ps1 $imageName