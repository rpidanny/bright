# f() {
#   sudo /home/abhishek/workspace/github/acdcontrol/acdcontrol /dev/usb/hiddev$1 $2
# }; f
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
scale=0.01899
scaleeight=0.04835
percent=$(echo $brightness $scale | awk '{printf "%d\n",$1*$2}')
eightbit=$(echo $brightness $scaleeight | awk '{printf "%d\n",$1*$2}')

# TODO: detect devices rather than brute forcing
echo $percent
echo "Probing i2c devices"
for d in $(ls /dev/i2c-*); do
  echo "$percent"
  sudo ddccontrol dev:$d -r 0x10 -w $percent -f
done

echo "Looking for Apple Displays"
APPLE_DISPLAYS=$(sudo acdcontrol -s -d /dev/usb/hiddev* | tr --delete ':' | awk '{print $1} ')
for a in $APPLE_DISPLAYS; do
  sudo acdcontrol -s $a $eightbit
done