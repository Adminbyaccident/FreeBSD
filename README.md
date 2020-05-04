# FreeBSD
FreeBSD useful scripts

- This is a list of some useful scripts for FreeBSD systems.
- Almost every script has a reference article at the bottom, so anyone can read about how and why.

## The bash-install.sh script

The bash-install.sh script installs the bash shell on FreeBSD. 
Add the adequate username at the end to change the default sheel for the user 

## The fail2ban-for-ssh-install.sh script

This script installs fail2ban in order to protect the system for unwanted SSH connections.
The number of maximum failed attempts is 3.
The banning time is 604800 seconds, or 7 days.

## The iocage-auto-install.sh script

This script installs iocage, a tool to manage FreeBSD Jails.
Think of iocage as of Docker to manage Linux containers but on FreeBSD and managing Jails.

## The pkg-latest.sh script

This one sets the configuration of available packages to get the latest ones instead of quarterly.
Using this script the latest compiled binaries are obtained.

## The rkhunter-install.sh script

Every system needs some security and rootkits are dangerous pieces of software.
The script installs rkhunter and it sets to auto update.

## The set-date-locale-time.sh script

Locale comes unconfigured and date needs to be synchronized with an NTP server.
This script does it automatically.

## The simple-ipfw-workstation.sh script

This sets the IPFW firewall as a workstation set of rules. This works smooth.

## The sudo-install.sh script

Need sudo? Here you can set it in auto.

## The webserver-ipfw.conf file

This is a clunky configuration for a IPFW firewall ruleset with a web server in mind. 
Not well tested. May not work as expected. Test it first before using this.

## The workstation-ipfw.conf file

This is a clunky configuration for a IPFW firewall ruleset with a workstation use case in mind. 
Not well tested. May not work as expected. Test it first before using this.

## The workstation-pf.conf file

This is a clunky configuration for a PF firewall ruleset with a workstation use case in mind. 
Not well tested. Unfinished work. Test it first before using this and make the necessary changes!
