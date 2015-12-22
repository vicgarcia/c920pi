Scripts and configurations for building a HLS streaming web cam server with
a Raspberry Pi 2 and a Logitech C920 webcam.

I'm using a Rasberry Pi 2 and Logitech C920 webcam.  This setup as it is is
specific to this device and camera combination.

I start of by writing the Raspberian image to a micro SD card to use.

I'm doing this on a Windows desktop with a tool called Win32DiskImager.

I found it helpful to use my television as a monitor and plug in an HDMI cable
into the Raspberry Pi.  I also have a USB wireless keyboard that I used.

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
        wpa-ssid "ssid for wifi network here"
        wpa-psk "password for wifi network here"

The configure.sh script provided in the repository can be used from here
to complete the installation of the software necessary for the rest of the
streaming webcam stack.

The easiest way to run this script is the old curl | bash

    curl https://raw.githubusercontent.com/vicgarcia/c920pi/master/configure.sh | sh

This script will :
* perform apt update/upgrade
* install vim, tmux, curl and curl
* install all of the necessary build tools
* download source, compile, and install x264 and ffmpeg
* install v4l (video 4 linux) drivers and utilities with apt
* download and compile the repository's c920.c camera utility
* download and install the repository's capture.sh capture script
* create the filesystem path w/ permissions for hls video files
* install nginx and configure to serve the hls video stream
* install supervisor and configure to run the capture script
* setup firewall and dynamic dns update utility

After running this script, there will be some manual configuration required
to get everything to run the streaming server. Make sure to run these as root.

XXX check into installing firewall

The firewall will have to be enabled

    ufw enable

Then configure the No-IP client (optionally)

    cd /usr/src/noip-2.1.9-1
    make && make install



Vic Garcia | http://vicg4rcia.com
