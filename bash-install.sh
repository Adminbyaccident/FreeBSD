#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: bash-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 02-11-2019
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 12/13
#
# PURPOSE: This script installs the bash shell on a FreeBSD system for a specific user
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

# Change the default pkg repository from quarterly to latest
sed -ip 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

# Update packages (it will first download the pkg repo from latest)
# secondly it will upgrade any installed packages.
pkg upgrade -y

# Install the bash shell and bash completion
pkg install -y bash bash-completion

# Configure bash
touch .bash_profile

echo '[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \' >> /usr/home/username/.bash_profile
echo 'source /usr/local/share/bash-completion/bash_completion.sh' >> /usr/home/username/.bash_profile

# Add some aliases so bash isn't totally dumb
echo "alias ll='ls -lah'" >> /usr/home/username/.bash_profile
echo "alias la='ls -A'" >> /usr/home/username/.bash_profile
echo "alias l='ls -CF'" >> /usr/home/username/.bash_profile

echo "
export CLICOLOR=\"YES\"
export LSCOLORS=\"Cxfxcxdxgxegedabagacad\"
" >> /usr/home/username/.bash_profile

# Change the shell for a specific user
chsh -s /usr/local/bin/bash username

## References:
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-the-bash-shell-on-freebsd/
