#!/bin/bash

set -e

SRCREV_POKY=6d2e12e79211b31cdf5ea824fb9a8be54ba9a9eb
SRCREV_OE=3bdbf72e3a4bf18a4a2c7afbde4f7ab773aeded9
SRCREV_FREESCALE=2142f7ded1b3115ccc21f7575fd83e2376247193
SRCREV_FREESCALE_DISTRO=d4e77ea682fa10d0d54a723b3d3099c44fc5e95c
SRCREV_REACH=1c1801aaa38b94da53d6b23e13ca6a57453f4172
SRCREV_QT5=171871280307126c94faeeb90fb635a26495459d
SRCREV_MENDER=0df2ee7b9108f22d249bae644cd1fee06dc19b5c
SRCREV_VIRTUALIZATION=e1f24ea8e77f8a3c3266264dd71417c8f9661f89

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
