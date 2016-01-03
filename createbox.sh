#!/bin/sh
set -ex

boxname="arch64"
mname="vagrant-archlinux"

[[ -e package.box ]] && rm package.box
vagrant package --base $mname --output package.box
vagrant box add $boxname package.box
