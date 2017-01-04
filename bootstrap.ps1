Copy-Item .\Configs\connectionStrings.config .\Web\connectionStrings.config
Copy-Item .\Configs\connectionStrings.config .\JobServer\connectionStrings.config
Copy-Item .\Configs\communityserver_override.config .\Web\communityserver_override.config
Copy-Item .\Configs\communityserver_override.config .\JobServer\communityserver_override.config
Rename-Item ".\Search\copy to tomcat_lib" copy-to-tomcat_lib
docker-compose build
docker-compose up -d