#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: clamav-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 19-10-2022
# SET FOR: Test
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the Clamav antivirus security tool on a FreeBSD system
#
# REV LIST:
# DATE: 19-10-2022
# BY: ALBERT VALBUENA
# MODIFICATION: 19-10-2022
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

# Install Clamav
pkg install -y clamav

# Configure the Clamav (to be run) and Freshclam (for updates) daemons
sysrc clamav_clamd_enable="YES"
sysrc clamav_freshclam_enable="YES"

# Fire up the services
clamav-clamd start
clamav-freshclam start

# Download/Update signatures
freshclam

# Restart clamd service since it will probably won't be notified about the update from freshclam.
service clamav-clamd restart
freshclam

# Final message
echo 'The Clamav antivirus has been installed on this system. Mind this set up is an on demand scan.'

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-the-clamav-antivirus-in-freebsd/
