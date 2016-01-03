#!/bin/sh

set -ex

./createiso.sh
./createvm.sh
./install-system.sh
./createbox.sh

