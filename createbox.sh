#!/bin/sh
set -ex

boxname="arch64"
mname="vagrant-archlinux"

rm -f package.box
vagrant package --base $mname --output package.box
vagrant box add $boxname package.box
