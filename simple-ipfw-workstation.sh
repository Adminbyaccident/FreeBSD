#!/bin/sh

# Instructions on how to use this script 

# chmod +x SCRIPTNAME.sh

# sudo ./SCRIPTNAME.sh

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
