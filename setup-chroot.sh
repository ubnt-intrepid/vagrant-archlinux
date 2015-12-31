#!/bin/sh
set -ex

# set hostname
echo vagrant-archlinux > /etc/hostname

# set locale settings
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sed -i.bak -e 's/#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen
rm /etc/locale.gen.bak
locale-gen

# make user & set passwd
useradd -m -G wheel -s /bin/bash vagrant
echo -e 'vagrant\nvagrant\n' | passwd
echo -e 'vagrant\nvagrant\n' | passwd vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# disable predictable network interface names
ln -sf /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# enable network settings
systemctl enable sshd.service
systemctl enable dhcpcd@eth0.service


# install bootloader
bootctl --path=/boot install
cat > /boot/loader/loader.conf << EOF
default arch
timeout 0
editor  0
EOF

cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda3 rw
EOF