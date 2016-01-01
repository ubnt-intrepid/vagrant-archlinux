#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

packages=(
  base base-devel grub
  virtualbox-guest-modules
  openssh
  git zsh python vim-python3
)

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
echo 'Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' \
   > /etc/pacman.d/mirrorlist

# install base system
pacstrap /mnt ${packages[@]}
genfstab -U -p /mnt > /mnt/etc/fstab

# enter target environment and run setup scripts
cp ./setup-chroot.sh /mnt
chmod +x /mnt/setup-chroot.sh
arch-chroot /mnt /setup-chroot.sh
rm /mnt/setup-chroot.sh

