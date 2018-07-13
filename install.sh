#!/usr/bin/env bash

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Install ddccontrol and add i2c udev rules
info "Installing ddccontrol"
sudo apt install i2c-tools ddccontrol ddccontrol-db
info "Adding i2c udev rule"
sudo groupadd --system i2c-dev
sudo cp i2c-dev.rules /etc/udev/rules.d/
sudo usermod -a -G i2c-dev $USERNAME
# sudo /bin/sh -c 'echo i2c-dev >> /etc/modules'

# Install acdcontrol and add hid udev rules
info "Installing acdcontrol"
git clone https://github.com/warvariuc/acdcontrol.git
cd acdcontrol && make
sudo cp acdcontrol /usr/bin
info "Adding hid udev rule"
sudo groupadd --system hid-dev
sudo cp hid-dev.rules /etc/udev/rules.d/
sudo usermod -a -G hid-dev $USERNAME

# TODO: install bright
info "Installing bright"
sudo mkdir -p /etc/brightSync
sudo cp bright.sh /etc/brightSync
sudo cp bright.service /etc/systemd/system/

success "Installation Complete"