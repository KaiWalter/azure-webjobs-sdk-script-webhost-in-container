
dotnet build .\HttpTriggerCore.sln

dotnet publish .\HttpTriggerCore.sln

Remove-Item .\App.zip -ErrorAction SilentlyContinue

Compress-Archive .\HttpTriggerCore\bin\Debug\netstandard2.0\publish .\App.zip