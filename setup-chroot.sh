#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

set -ex

# install bootloader
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# set hostname
echo archlinux > /etc/hostname

# set locale settings
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sed -i.bak -e 's/#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen
rm /etc/locale.gen.bak
locale-gen

# make user & set passwd
useradd -m -G wheel -s /bin/zsh vagrant
echo -e 'vagrant\nvagrant\n' | passwd
echo -e 'vagrant\nvagrant\n' | passwd vagrant
cat << EOF > /etc/sudoers.d/vagrant
vagrant ALL=(ALL) NOPASSWD: ALL
Defaults env_keep += "SSH_AUTH_SOCK"
EOF
chmod 0440 /etc/sudoers.d/vagrant

# shared folder settings
modprobe -a vboxguest vboxsf
cat > /etc/modules-load.d/virtualbox.conf << EOF
vboxguest
vboxsf
EOF
groupadd vboxsf
gpasswd -a vagrant vboxsf
systemctl enable vboxservice

# add SSH settings
mkdir -p /home/vagrant/.ssh
curl -L "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub" \
   > /home/vagrant/.ssh/authorized_keys
chmod 755 /home/vagrant/.ssh
echo "UseDNS no" >> /etc/sshd_config

# enable network settings
device_name=$(ip addr | grep "^[0-9]" | awk '{print $2}' | sed -e 's/://' | grep -v '^lo$' | head -n 1)
systemctl enable sshd.service
systemctl enable "dhcpcd@${device_name}.service"

# clear caches
yes | pacman -Scc
dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
