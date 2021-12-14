#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: simple-ipfw-workstation.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 29-10-2019
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the sets the IPFW firewall with ports 22, 80 and 443 on a FreeBSD system
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

# Simple IPFW workstation firewall
sysrc firewall_enable="YES"
sysrc firewall_quiet="YES"
sysrc firewall_type="workstation"
sysrc firewall_logdeny="YES"
sysrc firewall_allowservices="any"

# To enable services like remote SSH access or setting up a web server
# uncommenting the following up will allow them when issuing this script.
sysrc firewall_myservices="22/tcp 80/tcp 443/tcp"

# Start up the firewall
service ipfw start

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-setup-a-simple-firewall-in-freebsd-using-ipfw/
