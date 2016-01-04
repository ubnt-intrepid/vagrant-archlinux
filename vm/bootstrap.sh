#!/bin/sh
[[ -f /etc/bootstrapped ]] && exit

set -ex

echo "Update GPG Keys"
sudo pacman-key --init
sudo pacman-key --populate archlinux

echo "Install My dotfiles"
echo 'vagrant' | su - vagrant
curl -L https://raw.githubusercontent.com/ys-nuem/dotfiles/master/install.sh \
  | bash

