This repository contains a script to automate much of the build setup.

Before cloning this repository you should make sure your development machine has all the required packages installed.  This is detailed on the Yocto Project web site on this page (under the "The Build Host Packages" section):

https://www.yoctoproject.org/docs/2.6/brief-yoctoprojectqs/brief-yoctoprojectqs.html

For example, the command to do this for the Ubuntu distribution is:

$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm

Once the prerequisite packages are installed, create a working directory and clone the build setup script in this repository:

$ git clone git@github.com:sakoman/setup-reach.git

Now create a directory to store the Yocto source downloads and the build shared state. This data will persist across builds, and its use will dramatically decrease subsequent build times.

$ mkdir ~/yocto-files-thud

Now cd into the build setup directory and run the script:

$ cd setup-reach

$ ./setup.sh ~/yocto-files-thud

The script will then automatically clone all the required meta-data. When it is complete you can set up the build environment and start a build:

$ source sources/poky/oe-init-build-env
 
$ bitbake reach-image-qt5

This will take quite some time while the system downloads all the required source code, creates build tools, and then builds the boot loader, kernel, and all required packages. The build output will be in the standard spot (build/tmp/deploy/images/reach/)


Subsequent builds

If the upstream metadata changes due to the addition of a new feature or a bug fix, you will want to update your build sources.

First enter your build directory and update the setup script (just in case that has changed too):

$ cd setup-reach/

$ git pull

Now simply re-run the script:

$ ./setup.sh ~/yocto-files

The script will remove the old metadata and temporary build files, and then re-clone all required metadata.  It will not delete the downloaded source cache nor the shared-state files.  This will allow very rapid builds after the metadata update.

Then, just as before, set up the build environment and start a build:

$ source sources/poky/oe-init-build-env

$ bitbake reach-image-qt5

