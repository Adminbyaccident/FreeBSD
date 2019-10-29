#!/bin/sh

# Install Git to pull the firewall configuration file
pkg install -y git

# Get the firewall's configuration file
fetch https://github.com/Adminbyaccident/FreeBSD/blob/master/workstation-ipfw.conf

# Place the configuration file and change it's name to a convenient one.
mv /usr/home/albert/workstation-ipfw.conf /etc/ipfw.rules

# Placing the minimum ipfw settings into /etc/rc.conf 
sysrc firewall_enable="YES"
sysrc firewall_script="/etc/ipfw.rules"
sysrc firewall_logging="YES"

# Starting up the firewall
service ipfw start

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-configure-the-ipfw-firewall-on-freebsd/
