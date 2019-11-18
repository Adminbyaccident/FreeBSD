#!/bin/sh

# Set server time correctly
cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install GNU sed to introduce specific lines 
# since FreeBSD's sed is a pain for that specific

pkg install -y gsed

# Set the locale globally
gsed -i '50i\:charset=UTF-8:\\' /etc/login.conf
gsed -i '51i\:lang=xx_XX.UTF-8:' /etc/login.conf

cap_mkdb /etc/login.conf

# Enable NTP (Network Time Protocol) to synchronize time
# and do it also at boot time
sysrc ntpd_enable="YES"
sysrc ntpd_sync_on_start="YES"

# Start time synchronization
service ntpd start

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/time-and-date-in-freebsd/
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-set-the-locale-in-freebsd/
