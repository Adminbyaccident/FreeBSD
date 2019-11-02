#!/bin/sh

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install Fail2ban
pkg install -y py36-fail2ban

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
