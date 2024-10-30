#!/bin/bash
set -oue pipefail
trap 'echo -e :: Exiting build script.\\n:: If you see this message without a \"Build completed.\" message, an error may have occured.' EXIT

# shellcheck disable=SC2034
RELEASE="$(rpm -E %fedora)"

# Some commands are based on the build
# scripts in https://github.com/ublue-os/bluefin.

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

# ---
set +x
echo ":: Packages: fish (+ set as default shell for new users)"
set -x
# ---

rpm-ostree install fish
sed -i 's/SHELL=.*/SHELL=\/usr\/bin\/fish/g' /etc/default/useradd

# ---
set +x
echo ":: Packages: KDE Utilities"
set -x
# ---

rpm-ostree install \
    yakuake

# ---
set +x
echo ":: Packages: Klassy"
set -x
# ---

KLASSY_REPO_SPEC_URL="https://download.opensuse.org/repositories/home:/paul4us/Fedora_$RELEASE/home:paul4us.repo"
KLASSY_REPO_SPEC_FILE="/etc/yum.repos.d/klassy.repo"
KLASSY_REPO_KEY_URL="https://build.opensuse.org/projects/home:paul4us/signing_keys/download?kind=gpg"

rpmkeys --import "$KLASSY_REPO_KEY_URL"
curl "$KLASSY_REPO_SPEC_URL" | tee -a "$KLASSY_REPO_SPEC_FILE"
rpm-ostree install klassy

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
set -x
# ---
