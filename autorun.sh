#!/bin/sh
# vim: ft=sh ts=2 sw=2 et :

set -ex

repo_root="https://raw.githubusercontent.com/ys-nuem/vagrant-archlinux/master"

curl -L "${repo_root}/setup.sh"        > setup.sh
curl -L "${repo_root}/setup-chroot.sh" > setup-chroot.sh
chmod +x setup.sh
./setup.sh
