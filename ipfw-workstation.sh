#!/bin/sh

# Simple IPFW workstation firewall
sysrc firewall_enable="YES"
sysrc firewall_quiet="YES"
sysrc firewall_type="workstation"
sysrc firewall_logdeny="YES"
sysrc firewall_allowservices="any"

# To enable services like remote SSH access or setting up a web server
# uncommenting the following up will allow them when issuing this script.
# sysrc firewall_myservices="22/tcp 80/tcp 443/tcp"

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-setup-a-simple-firewall-in-freebsd-using-ipfw/
