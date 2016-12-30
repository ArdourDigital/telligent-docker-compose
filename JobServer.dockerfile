FROM microsoft/windowsservercore
SHELL ["powershell"]

ADD JobServer JobServer
ADD ServiceMonitor.exe /ServiceMonitor.exe

RUN New-Service -Name "TelligentCommunityJobService" -DisplayName "Telligent` Community` Job` Service" -BinaryPathName "C:\JobServer\Telligent.Jobs.Server.exe"
RUN Start-Service -Name "TelligentCommunityJobService"

ENTRYPOINT ["C:\\ServiceMonitor.exe", "TelligentCommunityJobService"]