# FreeBSD
FreeBSD useful scripts

- This is a list of some useful scripts for FreeBSD systems.
- Almost every script has a reference article at the bottom, so anyone can read about how and why.

## The firewall-check-and-install.sh script
The firewall-check-and-install.sh script automatically verifies any available firewall installation on FreeBSD. It checks if IPFW, PF or IPFilter are configured on the system. 
If any of these are found the script doesn't alter or modify any configuration or service.
However, if there is no firewall on the system allows the user to either install a firewall or not and lets the user either install IPFW or PF for SSH and web services.

## The bash-install.sh script

The bash-install.sh script installs the bash shell on FreeBSD. 
Add the adequate username at the end to change the default sheel for the user 

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-the-bash-shell-on-freebsd/

## The fail2ban-for-ssh-install.sh script

This script installs fail2ban in order to protect the system for unwanted SSH connections.
The number of maximum failed attempts is 3.
The banning time is 604800 seconds, or 7 days.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-fail2ban-on-freebsd/

## The iocage-auto-install.sh script

This script installs iocage, a tool to manage FreeBSD Jails.
Think of iocage as of Docker to manage Linux containers but on FreeBSD and managing Jails.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/abandon-linux-how-to-install-iocage-to-manage-freebsd-jails/

## The pkg-latest.sh script

This one sets the configuration of available packages to get the latest ones instead of quarterly.
Using this script the latest compiled binaries are obtained.

## The rkhunter-install.sh script

Every system needs some security and rootkits are dangerous pieces of software.
The script installs rkhunter and it sets to auto update.

https://www.adminbyaccident.com/freebsd/how-to-install-rkhunter-on-freebsd/

## The set-date-locale-time.sh script

Locale comes unconfigured and date needs to be synchronized with an NTP server.
This script does both automatically.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/time-and-date-in-freebsd/
https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-set-the-locale-in-freebsd/

## The simple-ipfw-workstation.sh script

This sets the IPFW firewall as a workstation set of rules. This works smooth.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-setup-a-simple-firewall-in-freebsd-using-ipfw/

## The sudo-install.sh script

Need sudo? Here you can set it in auto.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/install-sudo-freebsd/

## The webserver-ipfw.conf file

This is a clunky configuration for a IPFW firewall ruleset with a web server in mind. 
Not well tested. May not work as expected. Test it first before using this.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-configure-the-ipfw-firewall-on-freebsd/

## The workstation-ipfw.conf file

This is a clunky configuration for a IPFW firewall ruleset with a workstation use case in mind. 
Not well tested. May not work as expected. Test it first before using this.

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-configure-the-ipfw-firewall-on-freebsd/

## The workstation-pf.conf file

This is a clunky configuration for a PF firewall ruleset with a workstation use case in mind. 
Not well tested. Unfinished work. Test it first before using this and make the necessary changes!

https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-configure-the-pf-firewall-on-freebsd/
