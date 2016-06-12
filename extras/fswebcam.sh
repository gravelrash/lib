#!/bin/bash

# clone / compile /package to a .deb
# ITS ROUGH, ITS DIRTY
CACHEDIR="/sdcard/cache"
DEST="/sdcard"
tmpdir1="tmpdir1"
TARGET="boardtarget"
REVISION="0.0.1"
ARCH="armhf"
MAINTAINER="someone"
MAINTAINERMAIL="someemail@smoewhere"

sync
# lets hear we started!
	echo "Building fswebcam" > $DEST/debug/fswebcam-build.log 2>&1
	git clone https://github.com/avafinger/fswebcam $CACHEDIR/$tmpdir1 >> $DEST/debug/fswebcam-build.log 2>&1
# Jump into the cache "/sdcard/cache/tmpdir1"
	cd $CACHEDIR/$tmpdir1
# now we configure and make it
./configure --prefix=/usr --disable-v4l1 --enable-32bit-buffer && make  >> $DEST/debug/fswebcam-compile.log 2>&1
#

# Lets do some deb packaging prep
cd $CACHEDIR/$tmpdir1
mkdir -p fswebcampak fswebcampak/DEBIAN fswebcampak/usr/bin fswebcampak/usr/share/man/man1
cat <<END > fswebcampak/DEBIAN/control
Package: fswebcam$TARGET
Version: $REVISION
Architecture: $ARCH
Maintainer: $MAINTAINER <$MAINTAINERMAIL>
Installed-Size: 1
Depends:  libgd2-xpm-dev (>= 2.0.36), libjpeg-dev, libpng-dev, libfreetype6-dev (>= 2.49), libgd-dev
Section: utils
Priority: optional
Description: fswebcam https://github.com/avafinger/fswebcam
END
#		fswebcam
cp "$CACHEDIR/$tmpdir1/fswebcam" "$CACHEDIR/$tmpdir1/fswebcampak/usr/bin/fswebcam"
cp "$CACHEDIR/$tmpdir1/fswebcam.1.gz" "$CACHEDIR/$tmpdir1/fswebcampak/usr/share/man/man1/fswebcam.1.gz"
cd "$CACHEDIR/$tmpdir1/fswebcampak"
cd ..
# package it all up
dpkg -b $CACHEDIR/$tmpdir1/fswebcampak
#
# NOW MOVE IT TO WHERE ITS NEEDED !
