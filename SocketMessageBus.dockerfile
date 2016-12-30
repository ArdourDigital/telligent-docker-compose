FROM microsoft/windowsservercore
SHELL ["powershell"]

ADD SocketMessageBus SocketMessageBus
ADD ServiceMonitor.exe /ServiceMonitor.exe

RUN New-Service -Name "TelligentSocketMessageBus" -DisplayName "Telligent` Socket` Message` Bus" -BinaryPathName "C:\SocketMessageBus\Telligent.SocketMessageBus.Service.exe"
RUN Start-Service -Name "TelligentSocketMessageBus"

ENTRYPOINT ["C:\\ServiceMonitor.exe", "TelligentSocketMessageBus"]

EXPOSE 9623