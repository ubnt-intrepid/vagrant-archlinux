#!/bin/sh

set -ex

cd mkarchiso/
sudo ./build.sh -v
cd ..

rm -f ./arch.iso
ln -s ./mkarchiso/out/*.iso ./arch.iso
