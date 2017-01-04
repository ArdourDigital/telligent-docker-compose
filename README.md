# Docker Compose for Telligent Community - EXPERIMENTAL

## Introduction

There are a few parts to the Telligent Community platform, setting all these up for testing can be time consuming especially if comparing different versions. Docker and Docker Compose provide a way to automate the startup of multiple linked services as seperate "containers" (essentially virtual machines).

Docker support for Windows server is still in Beta so there are some workarounds in this implementation, and it can be seen as experimental for now. It has only be designed for the use case of running a full Telligent install on a local development machine, no ports are exposed to the wider network.

__This has not been designed for production scenarios__

If you find something that can be improved or fixed please [check the GitHub issues for this project](https://github.com/ArdourDigital/telligent-docker-compose/issues) or submit a Pull Request.

## Supported Versions

The current version of the scripts have been tested on the following versions of Telligent Community. Due to differences in the distribution package tweaks may be needed for other versions but these are likely to be minimal.

- Telligent Community 9.1
- Telligent Community 9.2

## ServiceMonitor.exe

Docker requires a process to continue running to keep the container alive. For the windows service based components a process needs to run to monitor the service is healthy. The [Microsoft IIS docker image](https://github.com/microsoft/iis-docker) uses an application they have created named `ServiceMonitor.exe` a copy of that has been included to monitor the services. This is currently a standalone exe, but [Microsoft are planning on working on this as a standard approach to this problem](https://github.com/Microsoft/iis-docker/issues/1).

## Running

### Install Docker for Windows

You will need to install docker for windows to run these scripts. [Full details on this are available on the docker site](https://docs.docker.com/docker-for-windows/). You will need to be running a version with support for Windows Containers. These scripts have been tested on the latest beta version available at the time of writing _(1.13.0-rc4-beta34)_.

### Switch to Windows containers

Switch docker to use Windows containers by [following these instructions](https://docs.docker.com/docker-for-windows/#/switch-between-windows-and-linux-containers-beta-feature)

### Extract Telligent distribution and Copy docker files

Extract your Telligent distribution zip file (provided by Telligent), this should give you a folder containing a selection of subfolders (`Web`, `JobServer`, `Search`, `SqlScripts` etc.).

Clone this repository, or [download the files](https://github.com/ArdourDigital/telligent-docker-compose/archive/master.zip), and copy the files into the same folder as your Telligent files.

### Run Bootstrap script

Open powershell and navigate to the folder containing the docker files and the Telligent distribution and run:

```
.\bootstrap.ps1
```

This will update any required files, build the docker images and startup the containers.

### Updating files in the container

From powershell run

```
docker-compose build
docker-compose up -d
```

### Get the website address

From powershell run

```
docker ps
```

This will give a list of running containers, check for the name of the website container it should be something like `foldername_web_1`. Next run the following powershell command with your container name to get the IP address of your website:

```
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" foldername_web_1
```

### Stopping the containers

From powershell run

```
docker-compose stop
```

### Restarting the containers

From powershell run

```
docker-compose up -d
```

### Resetting the containers

To reset to a "fresh" state (e.g. start with a fresh database and filestorage), from powershell run. The next time you start the containers they will be fresh.

```
docker-compose down
```

## Limitations

### Have to rebuild to update files

The compose file does not currently use volumes to allow changes to the folders on your machine to be automatically included in the docker containers. There appeared to be some problems running this - [see this issue for more information](https://github.com/ArdourDigital/telligent-docker-compose/issues/1).

To work around this issue, update the files on your host machine then run the following commands to rebuild your environment:

```
docker-compose build
docker-compose up -d
```

### Static IPs used for dependencies rather than aliases

Host name aliases don't work on the current Docker for Windows beta _(1.13.0-rc4-beta34)_, so static IPs have to be used to communicate with the database, search server and socket message bus.

This means you will only be able to run one copy of Telligent at a time using docker compose. To workaround this you can change the static IPs assigned to the components in `docker-compose.yml`. Select 3 IP addresses between `172.16.0.0` and `172.31.255.255` that are not currently in use and update the `docker-compose.yml`. You will then have to update the `connectionstrings.config` and `communityserver_override.config` file used by the Website and Job Service. You should also update the Socket Message Bus IP address in `Sql.dockerfile`. 

### SQL Password

A SQL Password has been hardcoded in the `docker-compose.yml`, as this is intended for use only on local development machines. If you are extending this to a wider network you should set your own password.

The password should be updated in the `docker-compose.yml` file and in the `connectionstrings.config` file used by the Website and Job Service.

The password must meet the requirements set out in [this MSDN article](https://msdn.microsoft.com/en-us/library/ms161959.aspx).

### Telligent Password

The Telligent admin password has been hardcoded to `password`, as this is intended for use only on local development machines. If you are extending this to a wider network you should set your own password.

The password can be changed in the `Sql.dockerfile` where the community is initialized.