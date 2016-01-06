#!/bin/sh
set -e

[[ -f /etc/bootstrapped ]] && exit

echo "import package databases"
pacman -Syy

echo "Install additional dependencies"
yes | pacman -S zsh vim python2 git
