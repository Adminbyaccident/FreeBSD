#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: rkhunter-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 02-11-2019
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the rootkit analyzer security tool on a FreeBSD system
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

# Install RKHunter
pkg install -y rkhunter
touch /etc/periodic.conf
echo 'daily_rkhunter_update_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_update_flags="--update --nocolors"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_enable="YES"' >> /etc/periodic.conf
echo 'daily_rkhunter_check_flags="--checkall --nocolors --skip-keypress"' >> /etc/periodic.conf

# Configure RKHunter to send email if there's a warning
sed -ip 's/#MAIL-ON-WARNING=me@mydomain   root@mydomain/MAIL-ON-WARNING=example@gmail.com/g' /usr/local/etc/rkhunter.conf

sed -ip 's/#MAIL_CMD=mail/MAIL_CMD=mail/g' /usr/local/etc/rkhunter.conf

#Update RKHunter sources
rkhunter --update

## References:
## https://www.adminbyaccident.com/freebsd/how-to-install-rkhunter-on-freebsd/
