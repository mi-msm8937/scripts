#!/bin/bash -e

if [ "$#" -eq 0 ] || [ ! -f "$1" ] || [ ! -f "$2" ]; then
    echo "Parameters: <libmmcamera2_sensor_modules.so> <camera_config.xml>"
    exit 1
fi

BLOB="$1"
XML="$2"

STRINGS="$(strings $BLOB)"

if false; then
# Actuator
for ActuatorName in `grep -oP "(?<=<ActuatorName>)[^<]+" $XML`; do
    echo "$STRINGS" | grep -E "^$ActuatorName" > /dev/null || echo "Actuator $ActuatorName does not exist."
done
# Chromatix
for ChromatixName in `grep -oP "(?<=<ChromatixName>)[^<]+" $XML`; do
    echo "$STRINGS" | grep -E "^$ChromatixName" > /dev/null || echo "Chromatix $ChromatixName does not exist."
done
# Chromatix India
if grep ChromatixName_india $XML > /dev/null; then
    for ChromatixName_india in `grep -oP "(?<=<ChromatixName_india>)[^<]+" $XML`; do
        echo "$STRINGS" | grep -E "^$ChromatixName_india" > /dev/null || echo "Chromatix India $ChromatixName_india does not exist."
    done
fi
# Sensor
for SensorName in `grep -oP "(?<=<SensorName>)[^<]+" $XML`; do
    echo "$STRINGS" | grep -E "^$SensorName" > /dev/null || echo "Sensor $SensorName does not exist."
done
fi

# Eeprom
for EepromName in `grep -oP "(?<=<EepromName>)[^<]+" $XML`; do
    echo "$STRINGS" | grep -E "^${EepromName}_eeprom" > /dev/null || echo "Eeprom $EepromName does not exist."
done

exit 0