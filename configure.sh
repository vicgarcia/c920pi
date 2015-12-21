#!/bin/bash

# see README.md for configuration necessary prior to running this script

# update / upgrade via apt-get
apt-get -qq -y update
apt-get -qq -y upgrade

# install shell tools
apt-get -qq -y install vim-nox tmux git nmap zip unzip

# install build tools
apt-get -qq -y install build-essential cmake pkg-config

# install ffmpeg w/ h264 and hls support from source

# compile & install x264 (used w/ ffmpeg)
cd /usr/src
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make
make install

# compile & install ffmpeg (compiled for hls support)
cd /usr/src
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
make
make install

# http://www.jeffreythompson.org/blog/2014/11/13/installing-ffmpeg-for-raspberry-pi/

# install v4l drivers
apt-get install v4l-utils

# compile & install c920 camera utility
mkdir -p /usr/src/c920
cd /usr/src/c920
curl -o c920.c https://raw.githubusercontent.com/vicgarcia/c920pi/master/c920.c
gcc c920.c -o /usr/local/bin/c920

# http://nerdlogger.com/2013/11/09/streaming-1080p-video-using-raspberry-pi-or-beaglebone-black/

# download capture script
curl -o /home/pi/capture.sh https://raw.githubusercontent.com/vicgarcia/c920pi/master/capture.sh
chmod +x /home/pi/capture.sh

# create path for video hls files
mkdir -p /c920pi
chown -R pi:pi /c920pi

# install nginx
apt-get -qq -y install nginx

# configure basic nginx server
cat > /etc/nginx/sitex-available/default << DELIM
server {
    root /c920pi;
    location / { }
}
DELIM

# install supervisor
apt-get -qq -y install supervisor

# config file for supervisor to manage capture.sh
cat > /etc/supervisor/conf.d/c920pi.conf << DELIM
[program:c920pi]
command=/home/pi/capture.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/c920pi.log
stdout_logfile=/var/log/c920pi.log
DELIM

# https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-supervisor-on-ubuntu-and-debian-vps

# setup firewall
ufw allow 80/tcp
ufw allow 22/tcp

# the firewall will have to be enabled and the raspberry pi restart
# manually run 'sudo ufw enable' and 'sudo shutdown -r now'

# install dynamic dns update (for noip service)
cd /usr/src
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar xzf noip-duc-linux.tar.gz
rm -rf noip-duc-linux.tar.gz

# XXX do this after install / add to readme
#cd no-ip-2.1.9
# make
# make install

# make && make install will run the config script
# run this manually after running this setup script

# http://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/


