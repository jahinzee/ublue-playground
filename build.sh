#!/bin/bash
set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Most of these commands are based on the build
# scripts in https://github.com/ublue-os/bluefin.

# ---
echo ":: PACKAGES"
# ---

rpm-ostree install podman distrobox

# ---
echo ":: LINUXBREW"
# ---

touch /.dockerenv
mkdir -p /var/home
mkdir -p /var/roothome

curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew

# ---
echo ":: BRANDING"
# ---

sed -i '/^PRETTY_NAME/s/Kinoite/bp_OS/' /usr/lib/os-release
sed -i "/^PRETTY_NAME/s/Fedora Linux/bp_OS/" /usr/lib/os-release
sed -i '/^NAME/s/Fedora Linux/bp_OS/' /usr/lib/os-release
sed -i '/^DEFAULT_HOSTNAME/s/fedora/bpos/' /usr/lib/os-release
sed -i '/^HOME_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^DOCUMENTATION_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^SUPPORT_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^BUG_REPORT_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release

cp /tmp/watermark.png /usr/share/plymouth/themes/spinner/watermark.png
