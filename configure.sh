#!/bin/bash

# update / upgrade via apt-get
apt-get update && apt-get -qq -y upgrade

# install build tools
apt-get -qq -y install build-essential cmake pkg-config

# install curl, vim
apt-get -qq -y install curl vim-nox

# http://www.jeffreythompson.org/blog/2014/11/13/installing-ffmpeg-for-raspberry-pi/

# compile & install x264
cd /usr/src
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make
make install

# compile & install ffmpeg
cd /usr/src
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
make
make install

# http://nerdlogger.com/2013/11/09/streaming-1080p-video-using-raspberry-pi-or-beaglebone-black/

# install v4l drivers
apt-get install v4l-utils

# compile & install c920 capture utility
cd /usr/src
mkdir c920
cd c920
# XXX curl
gcc c920.c -o /usr/local/bin/c920



# XXX
# configure static ip in /etc/network/interfaces for wifi adapter
# http://www.modmypi.com/blog/tutorial-how-to-give-your-raspberry-pi-a-static-ip-address

# install nginx
apt-get -qq -y install nginx

# XXX
# configure basic nginx server setup

# https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-supervisor-on-ubuntu-and-debian-vps

# install supervisor
apt-get -qq -y install supervisor

# XXX
# install config file for supervisor to manage capture.sh
