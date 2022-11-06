#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: iocage-auto-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 04-05-2020
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the iocage jail management platform on a FreeBSD system
#
# REV LIST:
# DATE: 14-12-2021
# BY: ALBERT VALBUENA
# MODIFICATION: 14-12-2021
#
#
# set -n # Uncomment to check your syntax, without execution.
# # NOTE: Do not forget to put the comment back in or
# # the shell script will not execute!

##########################################################
################ BEGINNING OF MAIN #######################
##########################################################

# This is an install script to automate installation of iocage on FreeBSD.
# Iocage is a tool for managin FreeBSD Jails (think about Docker for containers on Linux)
# Modify it at your convenience.

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install Iocage (it's written in Python)
pkg install -y py39-iocage

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
