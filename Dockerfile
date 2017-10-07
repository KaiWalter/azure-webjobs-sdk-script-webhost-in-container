FROM microsoft/dotnet:2.0.0-sdk-nanoserver
LABEL Description="Azure WebJobs SDK script WebHost" Vendor="myself" Version="1.0.0"

COPY App.zip C:/App.zip

COPY Host.zip C:/Host.zip

RUN powershell -Command Expand-Archive C:\App.zip

RUN powershell -Command Expand-Archive C:\Host.zip

ENV AzureWebJobsScriptRoot='C:\App\publish'
ENV ASPNETCORE_URLS='http://*:8080/'

WORKDIR Host\\publish

EXPOSE 8080
CMD [ "dotnet","Microsoft.Azure.WebJobs.Script.WebHost.dll" ] 



