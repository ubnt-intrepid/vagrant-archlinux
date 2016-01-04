#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

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
sed -e '1iServer = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' -i /etc/pacman.d/mirrorlist
sed -e '1iServer = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch' -i /etc/pacman.d/mirrorlist

# copy base system and kernel images {{{
cp -ax / /mnt
cp -vaT /run/archiso/bootmnt/arch/boot/$(uname -m)/vmlinuz /mnt/boot/vmlinuz-linux
# }}}
# generate /etc/fstab from mouned conditions
genfstab -U -p /mnt > /mnt/etc/fstab

# enter target environment and run setup scripts
cp ./setup-chroot.sh /mnt
chmod +x /mnt/setup-chroot.sh
arch-chroot /mnt /setup-chroot.sh
rm /mnt/setup-chroot.sh
