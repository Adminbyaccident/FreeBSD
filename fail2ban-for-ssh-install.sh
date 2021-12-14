#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: fail2ban-for-ssh-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 02-11-2019
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the fail2ban to protect SSH connections on a FreeBSD system
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

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install Fail2ban
pkg install -y py38-fail2ban

# Enable the service to be started/stopped/restarted/etc
sysrc fail2ban_enable="YES"

# Configure a Jail to protect the SSH connections
touch /usr/local/etc/fail2ban/jail.d/ssh-ipfw.local

echo "[ssh-ipfw]
enabled = true
filter = sshd
action = ipfw[name=SSH, port=ssh, protocol=tcp]
logpath = /var/log/auth.log
findtime = 600
maxretry = 3
bantime = 604800" >> /usr/local/etc/fail2ban/jail.d/ssh-ipfw.local

# Start the service
service fail2ban start

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-fail2ban-on-freebsd/
