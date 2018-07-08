#!/usr/bin/env bash

# Install ddccontrol and add i2c udev rules
sudo apt install i2c-tools ddccontrol ddccontrol-db
sudo groupadd --system i2c-dev
sudo cp i2c-dev.rules /etc/udev/rules.d/
sudo usermod -a -G i2c-dev $USERNAME
# sudo /bin/sh -c 'echo i2c-dev >> /etc/modules'

# Install acdcontrol and add hid udev rules
git clone https://github.com/warvariuc/acdcontrol.git
cd acdcontrol && make
sudo cp acdcontrol /usr/bin
sudo groupadd --system hid-dev
sudo cp hid-dev.rules /etc/udev/rules.d/
sudo usermod -a -G hid-dev $USERNAME

# TODO: install bright
sudo mkdir -p /etc/brightSync
sudo cp bright.sh /etc/brightSync
sudo cp bright.service /etc/systemd/system/