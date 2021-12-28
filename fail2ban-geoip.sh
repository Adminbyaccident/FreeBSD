#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: fail2ban-geoip.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 28-12-2021
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs and configures Fail2Ban to block all connections but from a specific country/countries on a FreeBSD system
#
# IMPORTANT: Create an account for MaxMind geolocation databases in order to use this script.
# The URL to create the account is: https://dev.maxmind.com/geoip/geolite2-free-geolocation-data?lang=en
# Remember to fill the values for the variables below with the ones of your MaxMind account ID and key.
#
# REV LIST:
# DATE: 28-12-2021
# BY: ALBERT VALBUENA
# MODIFICATION: 28-12-2021
#
#
# set -n # Uncomment to check your syntax, without execution.
# # NOTE: Do not forget to put the comment back in or
# # the shell script will not execute!


# Declare variables:
# MaxMind variables
AccountID=write_your_maxmind_account_id_here
LicenseKey=write_your_maxmind_key_here

# Countries to allow. Only allowed countries will reach the site, ALL others are blocked.
# Full country codes list: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
# Example: USA='US|USA'
# Uncomment and add as many lines below as you need. 
# These will be treated as variables and put in place in the contrylist = directive in the geohostsallow.conf file.
# Country_1='US|USA'
# Country_2='GB|GBR'
# Add as many countries as needed here and in the 200_mod_maxmindb.conf file directives.

##########################################################
################ BEGINNING OF MAIN #######################
##########################################################


# Uncomment if the latest packages are needed instead of the quarterly released ones.
# sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages
pkg upgrade -y

# Install the geoip database
pkg install -y geoipupdate

sed -i -e "s/YOUR_ACCOUNT_ID_HERE/$AccountID/" /usr/local/etc/GeoIP.conf
sed -i -e "s/YOUR_LICENSE_KEY_HERE/$LicenseKey/" /usr/local/etc/GeoIP.conf

# Populate the databases
/usr/local/bin/geoipupdate

# Wait 20 seconds for the geoipupdate to finish
sleep 20

# Install Fail2ban
pkg install -y py38-fail2ban

# Enable the service to be started/stopped/restarted/etc
sysrc fail2ban_enable="YES"

# Create new action.d file
touch /usr/local/etc/fail2ban/action.d/geohostsallow.conf

# Add configuration to the new action.d file
echo '
[Definition]

# Option:  actionstart
# Notes.:  command executed once at the start of Fail2Ban.
# Values:  CMD
#
actionstart =

# Option:  actionstop
# Notes.:  command executed once at the end of Fail2Ban
# Values:  CMD
#
actionstop =

# Option:  actioncheck
# Notes.:  command executed once before each actionban command
# Values:  CMD
#
actioncheck =

# Option:  actionban
# Notes.:  command executed when banning an IP. Take care that the
#          command is executed with Fail2Ban user rights.
#          Excludes ES|Spain from banning.
# Tags:    See jail.conf(5) man page
# Values:  CMD
#
actionban = IP=<ip> &&
            COUNTRY=$(geoiplookup $IP | egrep "<country_list>") && [ "$COUNTRY" ] ||
            (printf %%b "<daemon_list>: $IP\n" >> <file>)

# Option:  actionunban
# Notes.:  command executed when unbanning an IP. Take care that the
#          command is executed with Fail2Ban user rights.
# Tags:    See jail.conf(5) man page
# Values:  CMD
#
actionunban = IP=<ip> && sed -i.old /ALL:\ $IP/d <file>

[Init]

# Option:  country_list
# Notes.:  List of exempted countries separated by pipe "|"
# Values:  STR  Default:
#
country_list = 

# Option:  file
# Notes.:  hosts.deny file path.
# Values:  STR  Default:  /etc/hosts.deny
#
file = /etc/hosts.allow

# Option:  daemon_list
# Notes:   The list of services that this action will deny. See the man page
#          for hosts.deny/hosts_access. Default is all services.
# Values:  STR  Default: ALL
daemon_list = ALL
' >> /usr/local/etc/fail2ban/action.d/geohostsallow.conf

sed -i -e "s/country_list =/country_list = $Country_1 $Country_2/" /usr/local/etc/fail2ban/action.d/geohostsallow.conf

# Create a new jail (in fail2ban terminology not FreeBSD's!)
touch /usr/local/etc/fail2ban/jail.d/geoip-block.local
echo '
[geoip-block]
enabled = true
filter = sshd
banaction = geohostsallow
logpath = /var/log/auth.log
findtime = 600
maxretry = 1
bantime = 604800
' >> /usr/local/etc/fail2ban/jail.d/geoip-block.local

# Start Fail2Ban service
service fail2ban start

# Install a cron job so the geolocation database from MaxMind is regularly updated.
crontab -l > /root/cronjob.txt
echo '
# Uncomment the SHELL and PATH variables if there is no cron job already in place. 
# Use crontab -l to check if there is any cron job.
# SHELL=/bin/sh
# PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin
# Order of crontab fields
# minute    hour    mday    month   wday    command
  1         0       *      *        1,3     /usr/local/bin/geoipupdate
' >> /root/cronjob.txt
crontab /root/cronjob.txt
rm /root/cronjob.txt

echo '
Fail2Ban has been installed with geolocation based configuration'

# EOF
