FROM microsoft/aspnet:4.6.2
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD https://github.com/Azure/azure-webjobs-sdk-script/releases/download/v1.0.11296/Functions.Private.1.0.11296.zip C:\\WebHost.zip

RUN Expand-Archive C:\WebHost.zip ; Remove-Item WebHost.zip

RUN Import-Module WebAdministration; \
    Set-ItemProperty 'IIS:\Sites\Default Web Site\' -name physicalPath -value 'C:\WebHost\SiteExtensions\Functions'; \
    Set-ItemProperty 'IIS:\Sites\Default Web Site\' -name serverAutoStart -value 'true'; \
    Set-ItemProperty 'IIS:\AppPools\DefaultAppPool\' -name autoStart -value 'true'

COPY App.zip App.zip

RUN Expand-Archive App.zip ; \
    Remove-Item App.zip

SHELL ["cmd", "/S", "/C"]
ENV AzureWebJobsScriptRoot='C:\App'

EXPOSE 80

WORKDIR App

