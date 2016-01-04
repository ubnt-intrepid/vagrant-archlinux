#!/bin/sh

mname="vagrant-archlinux"
mpath="$HOME/VirtualBox VMs/$mname/${mname}.vbox"
hddpath="$HOME/VirtualBox VMs/$mname/${mname}.vmdk"
dvdpath="$PWD/arch.iso"

SCP="scp -P 2222 -oStrictHostKeyChecking=no"
SSH="ssh -p 2222 -oStrictHostKeyChecking=no"

set -ex

# [Step1] create installer image {{{
# make installer image {{{
pushd mkarchiso/ >/dev/null
sudo ./build.sh -v
popd >/dev/null #}}}

# link to generated ISO {{{
rm -f $dvdpath 
ln -s ./mkarchiso/out/*.iso $dvdpath  #}}}
# }}}

# [Step2] make virtual machine {{{
# create a target virtual machine {{{
VBoxManage createvm --name $mname --register
VBoxManage modifyvm $mname \
  --ostype          ArchLinux_64 \
  --firmware        efi \
  --memory          768 \
  --acpi            on \
  --ioapic          on \
  --cpus            1  \
  --hwvirtex        on \
  --nestedpaging    on \
  --largepages      on \
  --clipboard       bidirectional \
  --nic1            nat \
  --nictype1        82540EM \
  --natpf1          rule1,tcp,,2222,,22 \
  --cableconnected1 on \
  --boot1           none \
  --boot2           disk \
  --boot3           dvd \
  --boot4           net \
  --usb             off \
  --usbehci         off #}}}

# create HDD {{{
VBoxManage createhd --size 32768 \
  --variant Standard --format vmdk --filename "$hddpath" # }}}

# attach storages to virtual machine {{{
VBoxManage storagectl $mname \
  --name SATA --add sata --portcount 5 --bootable on

VBoxManage storageattach $mname \
  --storagectl SATA --port 1 --type dvddrive --medium "$dvdpath"

VBoxManage storageattach $mname \
  --storagectl SATA --port 2 --type hdd --medium "$hddpath" #}}}

# }}}

# [Step3] install Archlinux {{{
# start virtual machine {{{
VBoxManage startvm $mname --type headless #}}}

sleep 90s

# copy and run install scripts {{{
$SCP ./script/* root@localhost:/root
$SSH root@localhost './setup.sh 2>&1 | tee install.log'
$SCP root@localhost:/root/install.log ./install.log
$SSH root@localhost 'poweroff' && echo #}}}

sleep 30s
# }}}

# [Step4] create vagrant box {{{
# modify VM {{{
VBoxManage modifyvm $mname --firmware bios
VBoxManage modifyvm $mname --natpf1 delete rule1
VBoxManage storageattach $mname \
  --storagectl SATA --port 1 --type dvddrive --medium none #}}}

rm -f package.box
vagrant package --base $mname --output package.box
# }}}
