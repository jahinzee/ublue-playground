#!/bin/bash
set -ouex pipefail

# script based off brew.sh from ublue-os/bluefin
# https://github.com/ublue-os/bluefin/blob/main/build_files/base/brew.sh (author: m2Giles)

touch /.dockerenv
mkdir -p /var/home
mkdir -p /var/roothome

curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew