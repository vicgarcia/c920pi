#!/bin/bash

# see README.md for configuration necessary prior to running this script

# update / upgrade via apt-get
apt-get -qq -y update
apt-get -qq -y upgrade

# install build tools
apt-get -qq -y install git build-essential cmake pkg-config

# install common linux cli tools
apt-get -qq -y install vim-nox tmux curl zip unzip

# install ack-grep, setup to run as 'ack'
apt-get -qq -y install ack-grep
dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

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

# download repository to /opt path
git clone https://github.com/vicgarcia/c920pi.git /opt/c920pi

# make the capture script executable by pi user
chmod +x /opt/c920pi/capture.sh
chown pi:pi /opt/c920pi/capture.sh

# compile c920 camera utility
gcc /opt/c920pi/c920.c -o /usr/local/bin/c920

# create path for video hls files
mkdir -p /c920pi
chown -R pi:pi /c920pi

# http://nerdlogger.com/2013/11/09/streaming-1080p-video-using-raspberry-pi-or-beaglebone-black/

# install nginx
apt-get -qq -y install nginx

# install apache httpd password tool
apt-get -qq -y install apache2-utils

# empty httpd password file
touch /etc/nginx/password

# https://www.digitalocean.com/community/tutorials/how-to-set-up-http-authentication-with-nginx-on-ubuntu-12-10

# create path for ssl certificates
mkdir /etc/nginx/ssl

# create a self signed certificate, completed manuall after install (see README)
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key

# https://devcenter.heroku.com/articles/ssl-certificate-self

# configure basic nginx server
cat > /etc/nginx/sites-available/default << DELIM
server {
    listen 443 ssl;

    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    root /c920pi;

    location / {
        auth_basic "Access Control";
        auth_basic_user_file /etc/nginx/password;
    }
}
DELIM

# install supervisor
apt-get -qq -y install supervisor

# config file for supervisor to manage capture.sh
cat > /etc/supervisor/conf.d/c920pi.conf << DELIM
[program:c920pi]
user=pi
command=/opt/c920pi/capture.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/c920pi.log
stdout_logfile=/var/log/c920pi.log
DELIM

# https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-supervisor-on-ubuntu-and-debian-vps

# install dynamic dns update (for noip service)
cd /usr/src
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar xzf noip-duc-linux.tar.gz
rm -rf noip-duc-linux.tar.gz

# http://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/

