#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q openmsx | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/openmsx/icons/openMSX-logo-256.png
export DESKTOP=/usr/share/applications/openmsx.desktop
export STARTUPWMCLASS=openmsx
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/openmsx /usr/share/openmsx

# Turn AppDir into AppImage
quick-sharun --make-appimage
