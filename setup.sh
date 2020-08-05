#!/bin/bash

set -e

SRCREV_POKY=f65b24e9ca0918a4ede70ea48ed8b7cc4620f07f
SRCREV_OE=a24acf94d48d635eca668ea34598c6e5c857e3f8
SRCREV_FREESCALE=dde79e0e441cf0dae95ba42acdb9d81a384541c4
SRCREV_FREESCALE_DISTRO=d4e77ea682fa10d0d54a723b3d3099c44fc5e95c
SRCREV_REACH=05b306342e2315442a3efc04c15cafca3b3bc95a
SRCREV_QT5=7d0b17aa229edc9e138edfe0e8477fbbe9013ba6
SRCREV_MENDER=4d0432acbd4c927a54447aab3f7f9490bf92ffe5
SRCREV_VIRTUALIZATION=343b5e236b844e9347090c358797fae80bdd22f5

if [ "X$1" = "Xhelp" ]; then
	echo ""
	echo "Usage: $0 <dlss_dir>"
	echo "   dlss_dir: directory to place downloads and sstate-cache"
	echo "             (ommit for yocto default)"
	exit 1;
fi

if [ -z "$1" ]; then
	my_dlss="default"
else
	my_dlss=$1
fi

echo "Removing previous installation"
rm -rf sources
rm -rf build

mkdir sources

echo "Cloning poky"
git clone git://git.yoctoproject.org/poky sources/poky
if [[ $SRCREV_POKY != "auto" ]]; then
	cd sources/poky
	git checkout $SRCREV_POKY
	cd ../..
fi

echo "Cloning meta-openembedded"
git clone git://git.openembedded.org/meta-openembedded sources/meta-openembedded
if [[ $SRCREV_OE != "auto" ]]; then
	cd sources/meta-openembedded
	git checkout $SRCREV_OE
	cd ../..
fi

echo "Cloning meta-freescale"
git clone git://git.yoctoproject.org/meta-freescale sources/meta-freescale
if [[ $SRCREV_FREESCALE != "auto" ]]; then
	cd sources/meta-freescale
	git checkout $SRCREV_FREESCALE
	cd ../..
fi

echo "Cloning meta-freescale-distro"
git clone https://github.com/Freescale/meta-freescale-distro.git sources/meta-freescale-distro
if [[ $SRCREV_FREESCALE_DISTRO != "auto" ]]; then
	cd sources/meta-freescale-distro
	git checkout $SRCREV_FREESCALE_DISTRO
	cd ../..
fi

echo "Cloning meta-reach"
git clone https://github.com/jmore-reachtech/meta-reach.git sources/meta-reach
if [[ $SRCREV_REACH != "auto" ]]; then
	cd sources/meta-reach
	git checkout $SRCREV_REACH
	cd ../..
fi

echo "Cloning meta-qt5"
git clone https://github.com/meta-qt5/meta-qt5.git sources/meta-qt5
if [[ $SRCREV_QT5 != "auto" ]]; then
	cd sources/meta-qt5
	git checkout $SRCREV_QT5
	cd ../..
fi

echo "Cloning meta-mender"
git clone https://github.com/mendersoftware/meta-mender.git sources/meta-mender
if [[ $SRCREV_MENDER != "auto" ]]; then
	cd sources/meta-mender
	git checkout $SRCREV_MENDER
	cd ../..
fi

echo "Cloning meta-virtualization"
git clone git://git.yoctoproject.org/meta-virtualization sources/meta-virtualization
if [[ $SRCREV_VIRTUALIZATION != "auto" ]]; then
	cd sources/meta-virtualization
	git checkout $SRCREV_VIRTUALIZATION
	cd ../..
fi

set build

pwd
TEMPLATECONF=../meta-reach/conf/sample/ source sources/poky/oe-init-build-env >> /dev/null

if [ "X$my_dlss" = "Xdefault" ]; then
	echo "Using default download and sstate directories"
else
	echo DL_DIR ?= \""$my_dlss"/downloads\" >> conf/local.conf
	echo SSTATE_DIR ?= \""$my_dlss/sstate-cache"\" >> conf/local.conf
fi
