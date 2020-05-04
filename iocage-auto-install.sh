#!/bin/sh

# This is an install script to automate installation of iocage on FreeBSD.
# Iocage is a tool for managin FreeBSD Jails (think about Docker for containers on Linux)
# Modify it at your convenience.

# Instructions on how to use this script 

# chmod +x SCRIPTNAME.sh

# sudo ./SCRIPTNAME.sh

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install Iocage (it's written in Python)
pkg install -y py37-iocage

# Mount the file descriptor file system (mandatory)
mount -t fdescfs null /dev/fd

# Make the fdescfs permanently mounted after reboots
echo "fdescfs /dev/fd fdescfs rw 0 0" >> /etc/fstab

# Activate iocage on the pool (check the pool's name first with zpool list)
iocage activate zroot

# Fetch the latest release (or choose your preferred one)
iocage fetch --release latest

# Install message
echo "IOCAGE has been installed on this system"


# References:
# https://www.adminbyaccident.com/freebsd/how-to-freebsd/abandon-linux-how-to-install-iocage-to-manage-freebsd-jails/

# EOF
