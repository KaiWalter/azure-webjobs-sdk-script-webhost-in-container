param(
    $imageName = 'functions-container',
    $containerRegistry = '{acr-name}.azurecr.io',
    $adminUserName = '{acr-name}',
    $adminUserPassword = '{acr-password}',
    $tagName = (get-date -Format o).SubString(0,19).Replace(":","").Replace("-","")
)

# Login at the repository
docker login "$containerRegistry" -u "$adminUserName" -p "$adminUserPassword"

$containerName = $containerRegistry + "/" + $imageName + ":" + $tagName

Write-Host "tagging and pushing $containerName"

# Add the name
docker tag "$imageName" "$containerName"

# Push the image to the repository
docker push "$containerName"
