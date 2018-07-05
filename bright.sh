#!/bin/bash

scale=0.01899
scaleeight=0.04835

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo_green () {
  echo -e "${GREEN}$1${NC}"
}

# detect i2c displays supporting VESA
if [ -z ${GENERIC_DISPLAYS} ] ;
then
  echo_green "Looking for i2c Displays"
  GENERIC_DISPLAYS=$(ddccontrol -p 2> /dev/null | grep "Reading EDID and initializing DDC/CI at bus" | tr --delete '...' | awk '{print $8}')
  echo $GENERIC_DISPLAYS
  echo ""
fi

# detect HID displays
if [ -z ${HID_DISPLAYS} ] ;
then
  echo_green "Looking for HID Displays"
  HID_DISPLAYS=$(acdcontrol -s -d /dev/usb/hiddev* | tr --delete ':' | awk '{print $1} ')
  echo $HID_DISPLAYS
  echo ""
fi

# listen for brigntness change
echo_green "Listening for brightness change..."
while inotifywait -q -e modify /sys/class/backlight/intel_backlight/brightness -o /dev/null; do
  brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
  percent=$(echo $brightness $scale | awk '{printf "%d\n",$1*$2}')
  eightbit=$(echo $brightness $scaleeight | awk '{printf "%d\n",$1*$2}')

  for a in $HID_DISPLAYS; do
    acdcontrol -s $a $eightbit
  done
  # TODO: Filter out devices already included in hid
  # for d in ${GENERIC_DISPLAYS}; do
  #   ddccontrol ${d} -f -r 0x10 -w $percent
  # done
done