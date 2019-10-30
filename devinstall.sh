#!/bin/bash

cd ~

if [ -d "Documents/workspace/microting/eform-debian-service/Plugins/ServiceOuterInnerResourcePlugin" ]; then
	rm -fR Documents/workspace/microting/eform-debian-service/Plugins/ServiceOuterInnerResourcePlugin
fi

cp -av Documents/workspace/microting/eform-service-outer-inner-resource-plugin/ServiceOuterInnerResourcePlugin Documents/workspace/microting/eform-debian-service/Plugins/ServiceOuterInnerResourcePlugin
