#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: bastille-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 29-04-2023
# SET FOR: Beta
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the Bastille Jail Management software on FreeBSD 12 and 13
#
# REV LIST:
# DATE: 29-04-2023
# BY: ALBERT VALBUENA
# MODIFICATION: 
#
#
# set -n # Uncomment to check your syntax, without execution.
# # NOTE: Do not forget to put the comment back in or
# # the shell script will not execute!

##########################################################
################ BEGINNING OF MAIN #######################
##########################################################

# Initial message
echo 'Bastille Jail Management is about to be installed on this system alongside the PF firewall'
sleep 7s
echo 'Mind the default zpool name to be enabled is zroot and the ext_if network interface to vtnet0'
sleep 7s
echo 'If your system is using a different name for the ZFS pool, cancel this operation, and adjust the script to your needs'
sleep 10s
echo 'Adjust the pf syntax in this script to your correct external interface, the ext_if default value is vtnet0'
sleep 10s
echo 'If you do not place the right ZFS pool name on, ZFS will not be used by Bastille. You have been warned'
sleep 10s
echo 'If you wish so, you have 15 seconds to cancel this operation by pressing Ctrl + Esc. Otherwise please wait for the install to happen'
sleep 15s

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install Bastille
pkg install -y bastille

# Enable Bastille as a service at boot time
sysrc bastille_enable="YES"

# Enable Bastille options at boot time
sysrc bastille_zfs_enable="YES"
sysrc bastille_zfs_zpool="zroot"

# Configure Bastille main configuration file
sed -i -e 's/bastille_zfs_enable=""/bastille_zfs_enable="YES"/g' /usr/local/etc/bastille/bastille.conf
sed -i -e 's/bastille_zfs_zpool=""/bastille_zfs_zpool="zroot"/g' /usr/local/etc/bastille/bastille.conf

# Configure Networking as in the official documentation example
sysrc cloned_interfaces="lo1"
sysrc ifconfig_lo1_name="bastille0"
service netif cloneup

#Configuring PF firewall to enable traffic on the clond interface
# For more reference: https://bastillebsd.org/getting-started/
echo '
ext_if="vtnet0"

set block-policy return
scrub in on $ext_if all fragment reassemble
set skip on lo

table <jails> persist
nat on $ext_if from <jails> to any -> ($ext_if:0)
rdr-anchor "rdr/*"

block in all
pass out quick keep state
antispoof for $ext_if inet
pass in inet proto tcp from any to any port ssh flags S/SA keep state
' >> /etc/pf.conf 

# Enabling the PF firewall
sysrc pf_enable="YES"
service pf start

# Boostrap a default Jail image
bastille bootstrap 13.2-RELEASE update

# Final message
echo 'Bastille and PF have been installed on this system'
echo 'This script is based on what is described in the official starting guide: https://bastillebsd.org/getting-started/'

# References:
# https://bastillebsd.org/getting-started/
