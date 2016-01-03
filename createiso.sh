#!/bin/sh

set -ex

cd mkarchiso/
sudo ./build.sh -v
cd ..

ln -s ./arch-installer/out/*.iso ./arch.iso
