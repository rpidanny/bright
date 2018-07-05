#!/bin/bash
scale=0.01899
scaleeight=0.04835

# detect i2c displays supporting VESA
if [ -z ${GENERIC_MONITORS} ] ;
then
  echo "Looking for i2c Displays"
  GENERIC_MONITORS=$(ddccontrol -p -c | grep "Reading EDID and initializing DDC/CI at bus" | tr --delete '...' | awk '{print $8}')
  export GENERIC_MONITORS
fi

# detect HID displays
if [ -z ${HID_DISPLAYS} ] ;
then
  echo "Looking for HID Displays"
  HID_DISPLAYS=$(sudo acdcontrol -s -d /dev/usb/hiddev* | tr --delete ':' | awk '{print $1} ')
fi

# listen for brigntness change
while inotifywait -q -e modify /sys/class/backlight/intel_backlight/brightness; do
  brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
  percent=$(echo $brightness $scale | awk '{printf "%d\n",$1*$2}')
  eightbit=$(echo $brightness $scaleeight | awk '{printf "%d\n",$1*$2}')

  for a in $HID_DISPLAYS; do
    sudo acdcontrol -s $a $eightbit
  done
  for d in ${GENERIC_MONITORS}; do
    ddccontrol ${d} -f -r 0x10 -w $percent
  done
done