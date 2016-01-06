#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

set -ex

# archiso由来の設定を削除 {{{
# journaldの設定を復旧
sed -i 's/Storage=volatile/#Storage=auto/' /etc/systemd/journald.conf
# 特殊なudevルールの削除
rm -f /etc/udev/rules.d/81-dhcpcd.rules
# archisoによって作成されたサービスの無効化と削除
systemctl disable pacman-init.service choose-mirror.service
rm -rf /etc/systemd/system/{choose-mirror.service,pacman-init.service,etc-pacman.d-gnupg.mount,getty@tty1.service.d}
rm -f /etc/systemd/scripts/choose-mirror
# ライブ環境の特殊なスクリプトを削除
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /root/{.automated_script.sh,.zlogin}
rm -f /etc/mkinitcpio-archiso.conf
rm -rf /etc/initcpio

yes | pacman -Rs intel-ucode memtest86+ \
  mkinitcpio-nfs-utils nbd zsh syslinux prebootloader \
  arch-install-scripts gptfdisk
# }}}

# set hostname
echo archlinux > /etc/hostname

# set locale settings
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sed -i.bak -e 's/#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen
rm /etc/locale.gen.bak
locale-gen

# settings of account
useradd -m -G wheel -s /bin/bash vagrant
echo -e 'vagrant\nvagrant\n' | passwd
echo -e 'vagrant\nvagrant\n' | passwd vagrant
mkdir -p /etc/sudoers.d
cat > /etc/sudoers.d/vagrant << EOF
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

# install bootloader
mkinitcpio -p linux
grub-install --target=i386-pc --recheck /dev/sda
sed -i 's/\(GRUB_TIMEOUT\)=\(.*\)/\1=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# clear caches
rm -rf /var/cache/pacman/pkg/*

# pacman-keyの初期化
haveged -w 1024   # make entropy
pacman-key --init
pacman-key --populate archlinux

# compress image
dd if=/dev/zero of=empty bs=1M && echo
rm -f empty
