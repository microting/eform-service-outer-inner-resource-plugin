#!/bin/bash

if [ ! -d "/var/www/microting/eform-service-outer-inner-resource-plugin" ]; then
  cd /var/www/microting
  su ubuntu -c \
  "git clone https://github.com/microting/eform-service-outer-inner-resource-plugin.git -b stable"
fi

cd /var/www/microting/eform-service-OuterInnerResource-plugin
su ubuntu -c \
"dotnet restore ServiceOuterInnerResourcePlugin.sln"

echo "################## START GITVERSION ##################"
export GITVERSION=`git describe --abbrev=0 --tags | cut -d "v" -f 2`
echo $GITVERSION
echo "################## END GITVERSION ##################"
su ubuntu -c \
"dotnet publish ServiceOuterInnerResourcePlugin.sln -o out /p:Version=$GITVERSION --runtime linux-x64 --configuration Release"

su ubuntu -c \
"mkdir -p /var/www/microting/eform-debian-service/MicrotingService/MicrotingService/out/Plugins/"

su ubuntu -c \
"cp -av /var/www/microting/eform-service-outer-inner-resource-plugin/ServiceOuterInnerResourcePlugin/out /var/www/microting/eform-debian-service/MicrotingService/out/Plugins/ServiceOuterInnerResourcePlugin"
./rabbitmqadmin declare queue name=eform-service-outer-inner-resource-plugin durable=true
