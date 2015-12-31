#!/bin/sh
set -ex

mname=vagrant-archlinux
mpath="$HOME/VirtualBox VMs/$mname/${mname}.vbox"
hddpath="$HOME/VirtualBox VMs/$mname/${mname}.vmdk"
dvdpath="$PWD/archlinux-2015.12.01-dual.iso"

VBoxManage createvm --name $mname --register

VBoxManage modifyvm $mname \
  --ostype ArchLinux_64 \
  --firmware efi \
  --memory 768 \
  --acpi   on \
  --ioapic on \
  --cpus   1  \
  --hwvirtex on \
  --nestedpaging on \
  --largepages   on \
  --clipboard    bidirectional \
  --nic1         nat \
  --nictype1     82540EM \
  --natpf1 rule1,tcp,,2222,,22 \
  --cableconnected1 on \
  --boot1 none \
  --boot2 disk \
  --boot3 dvd \
  --boot4 net \
  --usb     off \
  --usbehci off

VBoxManage createhd \
  --size 32768 \
  --variant Standard \
  --format  vmdk \
  --filename "$hddpath"

VBoxManage storagectl $mname \
  --name SATA \
  --add sata \
  --portcount 5 \
  --bootable on

VBoxManage storageattach $mname \
  --storagectl SATA \
  --port 1 \
  --type hdd \
  --medium "$hddpath"

VBoxManage storageattach $mname \
  --storagectl SATA \
  --port 2 \
  --type dvddrive \
  --medium "$dvdpath"