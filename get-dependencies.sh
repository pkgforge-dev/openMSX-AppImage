#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glew      \
    libtheora \
    sdl2_ttf  \
    tcl

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package openmsx

# If the application needs to be manually built that has to be done down here
echo "Building stable version of openMSX..."
echo "---------------------------------------------------------------"
REPO="https://github.com/openMSX/openMSX"
TAG="$(curl -s https://api.github.com/repos/openMSX/openMSX/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
VERSION="${TAG#RELEASE_}"
VERSION="${VERSION//_/.}"
git clone "$REPO" ./openMSX
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./openMSX
git checkout "$TAG"
sed -i 's@SYMLINK_FOR_BINARY:=true@SYMLINK_FOR_BINARY:=false@' build/custom.mk
sed -i 's@INSTALL_BASE:=/opt/openMSX@INSTALL_BASE:=/usr/share/openmsx@' build/custom.mk
echo 'INSTALL_DOC_DIR:=/usr/share/doc/openmsx' >> build/custom.mk
echo 'INSTALL_SHARE_DIR:=/usr/share/openmsx' >> build/custom.mk
echo 'INSTALL_BINARY_DIR:=/usr/bin' >> build/custom.mk

# Compiling
./configure
make -j$(nproc)
make install
