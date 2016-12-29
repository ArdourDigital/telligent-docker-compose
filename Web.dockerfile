FROM microsoft/aspnet:4.6.2
SHELL ["powershell"]

ADD Web Web  
RUN Remove-WebSite -Name 'Default Web Site'  
RUN New-Website -Name 'Website' -Port 80 -PhysicalPath 'c:\Web' -ApplicationPool '.NET v4.5'

EXPOSE 80  