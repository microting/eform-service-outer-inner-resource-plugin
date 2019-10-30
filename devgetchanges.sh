#!/bin/bash

cd ~

if [ -d "Documents/workspace/microting/eform-service-outer-inner-resource-plugin/ServiceOuterInnerResourcePlugin" ]; then
	rm -fR Documents/workspace/microting/eform-service-outer-inner-resource-plugin/ServiceOuterInnerResourcePlugin
fi

cp -av Documents/workspace/microting/eform-debian-service/Plugins/ServiceOuterInnerResourcePlugin Documents/workspace/microting/eform-service-outer-inner-resource-plugin/ServiceOuterInnerResourcePlugin
