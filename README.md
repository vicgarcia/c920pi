Scripts and configurations for building a HLS streaming web cam server with
a Raspberry Pi 2 and a Logitech C920 webcam. The configuration/scripts included
are specific to this device and camera combination.

I start of by writing the Raspberian image to a micro SD card to use. I'm doing
this on a Windows desktop with a tool called Win32DiskImager. I also found it
helpful to use my TV and a wireless USB keyboard to perform the initial install.

On the first boot, you will need to run throught the Raspberian config utility.
During this configuration, I opt to expand the filesystem, enable the SSH server,
and configure the device for a US keyboard. When prompted, I typically will opt
not to reboot, instead doing so after configuring the wifi networking.

Next, we will need to get the wireless (or wired) networking configured.  If
you're using a wired connection with a DHCP assigned address this should work
out of the box.  I'm opting not only to use wireless networking, but also to
configure a static IP for routing/port forwarding for public access.

My configuration in /etc/network/interfaces looks like this :

    auto lo
    iface lo inet loopback

    auto eth0
    allow-hotplug eth0
    iface eth0 inet manual

    auto wlan0
    allow-hotplug wlan0
    iface wlan0 inet static
        address 10.10.10.80
        netmask 255.255.255.0
        gateway 10.10.10.1
        dns-nameservers 8.8.8.8 8.8.4.4
        wpa-ssid "ssid for wifi network here"
        wpa-psk "password for wifi network here"

The install.sh script provided in the repository is used from here to
complete the installation of the software necessary for the rest of the
streaming webcam stack.

The easiest way to run this script is the old curl | bash

    curl https://raw.githubusercontent.com/vicgarcia/c920pi/master/install.sh | sh

This script will :
* perform apt update/upgrade
* install all of the necessary build tools
* download source, compile, and install x264 and ffmpeg
* install v4l (video 4 linux) drivers and utilities with apt
* download and compile this repository's c920.c camera utility
* download and install this repository's capture.sh capture script
* create the filesystem path w/ permissions for hls video files
* install nginx and configure to serve the hls video stream
* install supervisor and configure to run the capture script
* setup dynamic dns update utility for No-IP (noip.com)


After the script is run, you will need to set up a user for http authentication.

    $ sudo htpasswd -c /etc/nginx/password <username>

And finish configuration of your self-signed SSL certificate. Be sure to use the proper FQDN.

    $ sudo su
    $ cd /etc/nginx/ssl
    $ openssl req -new -key server.key -out server.csr
    $ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

I'd recommend also setting up your firewall with UFW.

    $ sudo su
    $ ufw allow https
    $ ufw allow ssh
    $ ufw enable

If you would like to use the provided NoIP dynamic dns updater, you will need
to compile and configure it.  This can be done like so.

    $ sudo su
    $ cd /usr/src/noip-2.1.9-1
    $ make && make install
    $ exit

After performing this installation, reboot the raspberry pi.  When the device
reboots, the camera capture will be running and serving live video.

You should be able to access this video in a browser at :

    https://<ip or hostname of raspberry pi>/video.m3u8


Vic Garcia | http://vicg4rcia.com
