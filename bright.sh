#!/bin/bash

SCALEP=0.01899 # scale for 0 - 100
SCALEE=0.04835 # scale for 0 - 255

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo_green () {
  echo -e "${GREEN}$1${NC}"
}

# detect HID displays
echo_green "Looking for HID Displays"
HID_DISPLAYS=$(acdcontrol -s -d /dev/usb/hiddev* | tr --delete ':' | awk '{print $1} ')
echo $HID_DISPLAYS
echo ""

# Current implementation: only look for i2c displays if hid displays not found
# TODO: scan independent to hid display and filter out devices already included in hid
# detect i2c displays supporting VESA
if [ -z ${HID_DISPLAYS} ] ;
then
  echo_green "Looking for i2c Displays"
  I2C_DISPLAYS=$(ddccontrol -p 2> /dev/null | grep "Reading EDID and initializing DDC/CI at bus" | tr --delete '...' | awk '{print $8}')
  echo $I2C_DISPLAYS
  echo ""
fi

# listen for brigntness change
echo_green "Listening for brightness change..."
while inotifywait -q -e modify /sys/class/backlight/intel_backlight/brightness -o /dev/null; do
  brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
  percent=$(echo $brightness $SCALEP | awk '{printf "%d\n",$1*$2}')
  eightbit=$(echo $brightness $SCALEE | awk '{printf "%d\n",$1*$2}')

  for a in $HID_DISPLAYS; do
    acdcontrol -s $a $eightbit
  done
  for d in ${I2C_DISPLAYS}; do
    ddccontrol ${d} -f -r 0x10 -w $percent &> /dev/null
  done
done