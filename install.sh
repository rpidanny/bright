#!/usr/bin/env bash

sudo apt install ddccontrol i2c-tools
sudo groupadd --system i2c-dev
sudo cp i2c-dev.rules /etc/udev/rules.d/
sudo usermod -a -G i2c-dev $USERNAME
# sudo /bin/sh -c 'echo i2c-dev >> /etc/modules'

# TODO: Install acdcontrol and add udev rules

# TODO: install bright