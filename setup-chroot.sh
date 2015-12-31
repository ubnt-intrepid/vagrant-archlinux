#!/bin/sh
set -ex

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

cat > /etc/modules-load.d/virtualbox.conf << EOF
vboxguest
vboxsf
EOF

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
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# add SSH settings
mkdir -p /home/vagrant/.ssh
curl -L "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub" \
   > /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
echo "UseDNS no" >> /etc/sshd_config

# enable network settings
device_name=`ip addr | grep "^[0-9]" | awk '{print $2}' | sed -e 's/://' | grep -v '^lo$' | head -n 1`
systemctl enable sshd.service
systemctl enable "dhcpcd@${device_name}.service"