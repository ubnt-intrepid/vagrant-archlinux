#!/bin/sh
set -ex

[[ -f /etc/bootstrapped ]] && exit

echo "import package databases"
pacman -Syy

echo "Install additional dependencies"
pacman -S zsh vim python2 git
su - vagrant
curl -L https://raw.githubusercontent.com/ys-nuem/dotfiles/master/install.sh \
  | bash
