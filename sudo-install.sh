#!/bin/sh

# Instructions on how to use this script 

# chmod +x SCRIPTNAME.sh

# sudo ./SCRIPTNAME.sh

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install sudo
pkg install -y sudo

# Configure sudo so users in the wheel group can elevate privileges
sed -ip 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /usr/local/etc/sudoers

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/install-sudo-freebsd/
