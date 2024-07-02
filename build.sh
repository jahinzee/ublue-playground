#!/bin/bash
set -ouex pipefail
trap 'echo -e :: Exiting build script.\\n:: If you see this message without a \"Build completed.\" message, an error may have occured.' EXIT

RELEASE="$(rpm -E %fedora)"

# Some commands are based on the build
# scripts in https://github.com/ublue-os/bluefin.

echo '    _              ___  ____     '
echo '   | |__  _ __    / _ \/ ___|    '
echo '   | '_ \| '_ \  | | | \___ \    '
echo '   | |_) | |_) | | |_| |___) |   '
echo '   |_.__/| .__/___\___/|____/    '
echo '         |_| |_____|             '
echo '                                 '
echo " ~ jahinzee's uBlue Playground ~ "
echo ""

# ---
echo ":: Adding branding"
# ---

sed -i "/^PRETTY_NAME/s/Kinoite/Testing build – not for general consumption!/" /usr/lib/os-release
sed -i "/^PRETTY_NAME/s/Fedora Linux/bp_OS/" /usr/lib/os-release
sed -i '/^NAME/s/Fedora Linux/bp_OS/' /usr/lib/os-release
sed -i '/^DEFAULT_HOSTNAME/s/fedora/bpos/' /usr/lib/os-release
sed -i '/^HOME_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^DOCUMENTATION_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^SUPPORT_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release
sed -i '/^BUG_REPORT_URL/s/https:\/\/kinoite.fedoraproject.org/https:\/\/github.com\/jahinzee\/ublue-playground/' /usr/lib/os-release

cp /tmp/watermark.png /usr/share/plymouth/themes/spinner/watermark.png

# ---
echo ":: Installing packages: Distrobox"
# ---

rpm-ostree install \
    podman \
    distrobox

# ---
echo ":: Installing packages: Drivers/Broadcom"
# ---

# TODO: add a Broadcom target build
rpm-ostree install \
    broadcom-wl

# ---
echo ":: Installing packages: Virtualisation"
# ---

rpm-ostree install \
    virt-install \
    libvirt-daemon-config-network \
    libvirt-daemon-kvm \
    qemu-kvm \
    virt-manager \
    virt-viewer
systemctl enable libvirtd

# ---
echo ":: Installing Linuxbrew"
# ---

touch /.dockerenv
mkdir -p /var/home
mkdir -p /var/roothome

curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install || true
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew

# ---
echo ":: Build complete."
# ---