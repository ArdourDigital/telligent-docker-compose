FROM microsoft/windowsservercore
SHELL ["powershell"]

RUN (new-object System.Net.WebClient).Downloadfile('http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185', 'C:\jre-8u91-windows-x64.exe')
RUN (new-object System.Net.WebClient).Downloadfile('http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9-windows-x64.zip', 'C:\apache-tomcat-8.5.9-windows-x64.zip')
ADD ServiceMonitor.exe /ServiceMonitor.exe

RUN start-process -filepath C:\jre-8u91-windows-x64.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91,/L,install64.log"
RUN Expand-Archive c:\apache-tomcat-8.5.9-windows-x64.zip -DestinationPath C:\Tomcat

ENV JRE_HOME C:\\Java\\jre1.8.0_91
ENV CATALINA_HOME C:\\Tomcat\\apache-tomcat-8.5.9

RUN C:\Tomcat\apache-tomcat-8.5.9\bin\service.bat install
RUN Set-Service -Name Tomcat8 -StartupType Automatic

RUN del C:\jre-8u91-windows-x64.exe
RUN del C:\apache-tomcat-8.5.9-windows-x64.zip

ADD Search/solr C:\\Tomcat\\apache-tomcat-8.5.9\\solr
ADD Search/copy-to-tomcat_lib C:\\Tomcat\\apache-tomcat-8.5.9\\lib
ADD Search/solr.war C:\\Tomcat\\apache-tomcat-8.5.9\\webapps

EXPOSE 8080

ENTRYPOINT ["C:\\ServiceMonitor.exe", "Tomcat8"]