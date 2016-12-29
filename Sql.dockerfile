FROM microsoft/mssql-server-windows-express
SHELL ["powershell"]

COPY SqlScripts SqlScripts

RUN sqlcmd -Q 'CREATE DATABASE Telligent'
RUN sqlcmd -d Telligent -i C:\SqlScripts\Install.sql
RUN sqlcmd -d Telligent -Q 'EXECUTE [dbo].[cs_system_CreateCommunity] @SiteUrl = N''http://yoursite.com'', @ApplicationName = N''telligent_evolution'', @AdminEmail = N''notset@localhost.com'', @AdminUserName = N''admin'', @AdminPassword = N''password'', @PasswordFormat = 0, @CreateSamples = 0'
