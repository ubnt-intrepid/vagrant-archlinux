#!/bin/sh
set -ex

# Create partitions
#  /dev/sda    : GPT
#  - /dev/sda1 : 256m,    FAT32(EFI)
#  - /dev/sda2 : 1024m,   swap
#  - /dev/sda3 : remains, ext4
sgdisk -o /dev/sda
sgdisk            \
  --new      1::+256m  \
  --typecode 1:ef00    \
  --new      2::+1024m \
  --new      3:::      \
  /dev/sda
sgdisk -p /dev/sda
mkfs.vfat -F32 /dev/sda1
mkswap         /dev/sda2
mkfs.ext4      /dev/sda3

# mount partitions
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2

# change mirrorlist
echo 'Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' \
   > /etc/pacman.d/mirrorlist

# run base system.
pacstrap /mnt base sudo openssh
genfstab -U -p /mnt > /mnt/etc/fstab

# run chroot scripts.
cp ./setup-chroot.sh /mnt
chmod +x /mnt/setup-chroot.sh
arch-chroot /mnt /setup-chroot.sh
rm /mnt/setup-chroot.sh

echo "Done installation."