#!/bin/sh
set -ex

mname=vagrant-archlinux

# run virtual machine
VBoxManage startvm $mname --type headless
sleep 2m

# copy install scripts
scp -P 2222 -oStrictHostKeyChecking=no setup.sh setup-chroot.sh root@localhost:/root
ssh -p 2222 -oStrictHostKeyChecking=no root@localhost './setup.sh 2>&1 | tee install.log'
scp -P 2222 -oStrictHostKeyChecking=no root@localhost:/root/install.log ./install.log

VBoxManage modifyvm $mname --firmware bios
