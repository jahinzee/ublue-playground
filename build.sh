#!/bin/bash
set -oue pipefail
trap 'echo -e :: Exiting build script.\\n:: If you see this message without a \"Build completed.\" message, an error may have occured.' EXIT

# shellcheck disable=SC2034
RELEASE="$(rpm -E %fedora)"

# Some commands are based on the build
# scripts in https://github.com/ublue-os/bluefin.
echo '            ,,                                          '
echo '            db                    mm                    '
echo '                                  MM                    '
# shellcheck disable=SC2016
echo '`7MMpdMAo.`7MM  ,p6"bo   ,pW"Wq.mmMMmm .gP"Ya   .gP"Ya  '
echo "  MM   \`Wb  MM 6M'  OO  6W'   \`Wb MM  ,M'   Yb ,M'   Yb "
echo '  MM    M8  MM 8M       8M     M8 MM  8M"""""" 8M"""""" '
echo '  MM   ,AP  MM YM.    , YA.   ,A9 MM  YM.    , YM.    , '
echo "  MMbmmd' .JMML.YMbmd'   \`Ybmd9'  \`Mbmo\`Mbmmd'  \`Mbmmd' "
echo '  MM                                                    '
echo '.JMML.                                                  '
echo ""

# ---
set +x
echo ":: Branding"
set -x
# ---

rpm-ostree override remove fedora-logos --install generic-logos
sed -i '/^PRETTY_NAME/s/Kinoite/Picotee/' /usr/lib/os-release

# ---
set +x
echo ":: Packages: Distrobox"
set -x
# ---

rpm-ostree install \
    podman \
    distrobox

# ---
set +x
echo ":: Packages: Virtualisation"
set -x
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
set +x
echo ":: Packages: pipx"
set -x
# ---

rpm-ostree install pipx

# ---
set +x
echo ":: Packages: Codium"
set -x
# ---

CODIUM_REPO_KEY=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
CODIUM_REPO_SPEC="[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h"
CODIUM_REPO_SPEC_FILE="/etc/yum.repos.d/vscodium.repo"

rpmkeys --import "$CODIUM_REPO_KEY"
echo -e "$CODIUM_REPO_SPEC" | tee -a "$CODIUM_REPO_SPEC_FILE"
rpm-ostree install codium

# ---
set +x
echo ":: Packages: System Utilities"
set -x
# ---

rpm-ostree install \
    bat \
    eza \
    fastfetch \
    trash-cli \
    fzf \
    wl-clipboard \
    zoxide \
    git

# # ---
# echo ":: Addons: Linuxbrew"
# # ---

# touch /.dockerenv
# mkdir -p /var/home
# mkdir -p /var/roothome

# curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
# chmod +x /tmp/brew-install
# /tmp/brew-install || true
# tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew

# ---
set +x
echo ":: Build complete."
# ---
