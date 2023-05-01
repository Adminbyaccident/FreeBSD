#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: mate-desktop-intel.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 01-05-2023
# SET FOR: Test
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the Mate Desktop on FreeBSD using the Intel driver for graphics
#
# REV LIST:
# DATE: 01-05-2023
# BY: ALBERT VALBUENA
# MODIFICATION: 
#
#
# set -n # Uncomment to check your syntax, without execution.
# # NOTE: Do not forget to put the comment back in or
# # the shell script will not execute!

##########################################################
################ BEGINNING OF MAIN #######################
##########################################################

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install X11
pkg install -y xorg

# Install Mate Desktop
pkg install -y mate

# Install DRM kernel module
pkg install -y drm-kmod

# Install login manager Slim (alter this to GDM if you wish so)
pkg install -y slim

# Enable services for desktop use
sysrc dbus_enable="YES"
sysrc slim_enable="YES"
sysrc kld_list="i915kms"

# Create the xinit entry in your user's directory
touch /home/username/.xinitrc
echo "exec mate-session" >> /home/username/.xinitrc

# Final message
echo "Mate has been installed in this system. It is a good idea to reboot now".
