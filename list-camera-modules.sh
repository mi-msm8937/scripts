#!/bin/bash

case "${1}" in
	"M")
		DIR_CAMCFG="etc/camera"
		LIST_CAMCFG="$DIR_CAMCFG/msm8937_camera.xml"
		;;
	"N")
		DIR_CAMCFG="etc/camera"
		LIST_CAMCFG="$(grep -lr CameraConfigurationRoot $DIR_CAMCFG|grep -v 'csidtg_camera.xml')"
		;;
	"O")
		DIR_CAMCFG="vendor/etc/camera"
		LIST_CAMCFG="$(grep -lr CameraConfigurationRoot $DIR_CAMCFG|grep -v 'csidtg_camera.xml')"
		;;
	""|*)
		echo "Please specify an android version: M N O"
		exit 1;
		;;
esac

DIR_CAMLIB="vendor/lib"

for camcfg in $(echo $LIST_CAMCFG); do
	ls $camcfg
	# Actuator
	for ActuatorName in `grep -oP "(?<=<ActuatorName>)[^<]+" $camcfg`; do
		ls $DIR_CAMLIB/libactuator_${ActuatorName}.so
	done
	# Chromatix
	for ChromatixName in `grep -oP "(?<=<ChromatixName>)[^<]+" $camcfg`; do
		ls $DIR_CAMCFG/${ChromatixName}.xml
		for chromatix in `cat $DIR_CAMCFG/${ChromatixName}.xml|grep -oP "(?<=>)[^<]+"`; do
			ls $DIR_CAMLIB/libchromatix_${chromatix}.so
		done
	done
	# Chromatix India
	grep ChromatixName_india $camcfg>/dev/null
	if [ $? -eq 0 ]; then
		for ChromatixName_india in `grep -oP "(?<=<ChromatixName_india>)[^<]+" $camcfg`; do
			ls $DIR_CAMCFG/${ChromatixName_india}.xml
			for chromatix_india in `cat $DIR_CAMCFG/${ChromatixName_india}.xml|grep -oP "(?<=>)[^<]+"`; do
				ls $DIR_CAMLIB/libchromatix_${chromatix_india}.so
			done
		done
	fi
	# Eeprom
	for EepromName in `grep -oP "(?<=<EepromName>)[^<]+" $camcfg`; do
		ls $DIR_CAMLIB/libmmcamera_${EepromName}_eeprom.so
	done
	# Sensor
	for SensorName in `grep -oP "(?<=<SensorName>)[^<]+" $camcfg`; do
		ls $DIR_CAMLIB/libmmcamera_${SensorName}.so
	done
done|sort|uniq
