$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin"
$msbuild = Join-Path $msbuildPath msbuild.exe

$publishPath = ".\FunctionApp1\FunctionApp1\bin\Release\net461\Publish"
$publishFiles = Join-Path $publishPath "*"

$target = ".\App.zip"


if (Test-Path $publishPath) {
    Remove-Item .\FunctionApp1\FunctionApp1\bin\Release\PublishOutput -Recurse -Force -ErrorAction SilentlyContinue
}


nuget restore FunctionApp1\FunctionApp1.sln

. $msbuild FunctionApp1\FunctionApp1.sln /p:Configuration=Release

. $msbuild FunctionApp1\FunctionApp1\FunctionApp1.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:DeployTarget=Package


if (Test-Path $target) {
    Remove-Item $target -ErrorAction SilentlyContinue
}

Compress-Archive $publishFiles $target