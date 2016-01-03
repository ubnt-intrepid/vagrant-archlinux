#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

#packages=(
#  base base-devel grub
#  virtualbox-guest-utils-nox
#  openssh
#  git zsh python vim-python3
#)

set -ex

# Create partitions
sgdisk \
  -n 1::+1m --typecode 1:ef02 \
  -n 2 \
  /dev/sda
mkfs.ext4 /dev/sda2

# mount partitions
mount /dev/sda2 /mnt

# change mirrorlist
mv /etc/pacman.d/mirrorlist{,.bak}
echo 'Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch'    >> /etc/pacman.d/mirrorlist
echo 'Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist.bak >> /etc/pacman.d/mirrorlist

# install base system
#pacstrap /mnt ${packages[@]}
# pacstrapを使わずライブ環境からファイルをコピーする
time cp -ax / /mnt
# カーネルイメージをコピーする
cp -vaT /run/archiso/bootmnt/arch/boot/$(uname -m)/vmlinuz /mnt/boot/vmlinuz-linux

genfstab -U -p /mnt > /mnt/etc/fstab

# enter target environment and run setup scripts
cp ./setup-chroot.sh /mnt
chmod +x /mnt/setup-chroot.sh
arch-chroot /mnt /setup-chroot.sh
rm /mnt/setup-chroot.sh
