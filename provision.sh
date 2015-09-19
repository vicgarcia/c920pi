#!/bin/bash

# update via apt-get
apt-get update
apt-get upgrade

# install common tools and dependencies
apt-get -qq -y install vim-nox curl build-essential cmake pkg-config

# configure static ip in /etc/network/interfaces for wifi adapter
# http://www.modmypi.com/blog/tutorial-how-to-give-your-raspberry-pi-a-static-ip-address


# install python3 environment
# http://www.keithsterling.com/?p=112
apt-get -qq -y install python3 python-setuptools python3-pip python3-dev

# suggested used ...
# alias python='python3.2'
# alias pip='pip-3.2'


# compile and install nginx w/ hls module
# http://pkula.blogspot.com/2013/06/live-video-stream-from-raspberry-pi.html

# various nginx dependencies
apt-get -qq -y install libpcre3-dev libpcre++-dev zlib1g-dev libcurl4-openssl-dev libssl-dev

# install nginx and remove, installs dependencies and config scripts
apt-get -qq -y install nginx
apt-get -y remove nginx
apt-get clean

# change to directory for system source
cd /usr/src

# get nginx and nginx-rtmp module source
wget http://nginx.org/download/nginx-1.4.1.tar.gz && tar xzf nginx-1.4.1.tar.gz && rm nginx-1.4.1.tar.gz
git clone git://github.com/arut/nginx-rtmp-module.git

# make directory for web root
mkdir -p /var/www

# compile and install nginx w/ rtmp module
cd nginx-1.4.1
./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_ssl_module --without-http_proxy_module --add-module=/usr/src/nginx-rtmp-module
make
make install
cd


# compile and install opencv 3 for python 3
# http://www.pyimagesearch.com/2015/07/27/installing-opencv-3-0-for-both-python-2-7-and-python-3-on-your-raspberry-pi-2/

# install image libraries
apt-get -qq -y install libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev

# install video i/o libraries
apt-get -qq -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev

# install gtk libraries, used by open cv for ui
apt-get -qq -y install libgtk2.0-dev

# install optimization libraries
apt-get -qq -y install libatlas-base-dev gfortran

# change to directory for system source
cd /usr/src

# install numpy
pip-3.2 install numpy

# get open cv source
git clone https://github.com/Itseez/opencv.git
cd opencv
git checkout 3.0.0
cd ..
git clone https://github.com/Itseez/opencv_contrib.git
cd opencv_contrib
git checkout 3.0.0
cd ..

# setup build for open cv
cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules -D BUILD_EXAMPLES=ON ..
make -j4
# left off here
make install
ldconfig

# test this via python shell
# ~$ python3.2
# >>> import cv2
# >>> cv2.__version___
# '3.0.0'


# install ffmpeg and x264 codec
# http://www.jeffreythompson.org/blog/2014/11/13/installing-ffmpeg-for-raspberry-pi/

# install x264
cd /usr/src
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make
make install

# install ffmpeg
cd /usr/src
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
make
make install


