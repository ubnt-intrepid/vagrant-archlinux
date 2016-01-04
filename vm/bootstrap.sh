#!/bin/sh
[[ -f /etc/bootstrapped ]] && exit

set -ex

echo "Update GPG Keys"
pacman-key --init
pacman-key --populate archlinux

echo "Install additional dependencies"
pacman -S zsh vim
su - vagrant
curl -L https://raw.githubusercontent.com/ys-nuem/dotfiles/master/install.sh \
  | bash

