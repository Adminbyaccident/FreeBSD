#!/bin/sh
# Instructions on how to use this script:
# chmod +x SCRIPTNAME.sh
# sudo ./SCRIPTNAME.sh
#
# SCRIPT: firewall-check-and-install.sh
# AUTHOR: ALBERT VALBUENA
# DATE: 30-08-2024
# SET FOR: Production
# (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: FreeBSD 11/12/13/14
#
# PURPOSE: Verifies if firewall types IPFW, PF or IPFilter are installed. Automates installation of either PF or IPFW for SSH and web services.
#
# REV LIST:
# DATE:
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

# Funtion to check if the IPFW firewall is enabled
check_ipfw_firewall() {
        if grep 'firewall_enable' /etc/rc.conf; then
                echo "It seems an IPFW firewall is set on this system."
                ipfw_configured=true
        else
                ipfw_configured=false
        fi
}

# Funtion to check if the PF firewall is enabled
check_pf_firewall() {
        if grep 'pf_enable' /etc/rc.conf; then
                echo "It seems a PF firewall is set on this system."
                pf_configured=true
        else
                pf_configured=false
        fi
}

# Funtion to check if the IPFilter firewall is enabled
check_ipfilter_firewall() {
        if grep 'ipfilter_enable' /etc/rc.conf; then
                echo "It seems a PF firewall is set on this system."
                ipfilter_configured=true
        else
                ipfilter_configured=false
        fi
}

select_firewall() {
    if [ "$ipfw_configured" = false ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = false ]; then
        echo "It seems there is NO firewall configured on this system."
        echo "Would you like to automatically configure a firewall now?"
        echo "1) YES"
        echo "2) NO"
        read -p "Enter the corresponding number: " wants_firewall
                        if [ "$wants_firewall" -eq 2 ]; then
                            break						
						elif [ "$wants_firewall" -eq 1 ]; then
                                echo "This script can configure one of two basic firewall options for web server protection:"
                                echo "1) IPFW"
                                echo "2) PF"
                                read -p "Enter the corresponding number: " firewall_type_selection
                        
                        else
                                echo "Invalid selection for firewall configuration"
                        fi
    elif [ "$ipfw_configured" = true ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = false ]; then
        echo "It seems an IPFW firewall is configured. Make sure web service ports are reachable."
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = true ] && [ "$ipfilter_configured" = false ]; then
        echo "It seems a PF firewall is configured. Make sure web service ports are reachable."
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = true ]; then
        echo "It seems an IPFilter firewall is configured. Make sure web service ports are reachable."
        break
    else
        echo "Failed to discover a firewall install. Make sure you have one configured for web server use."
    fi
}

install_firewall() {
    if [ "$ipfw_configured" = true ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = false ]; then
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = true ] && [ "$ipfilter_configured" = false ]; then
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = true ]; then
        break
	elif [ "$wants_firewall" -eq 2 ]; then
		break		
	elif [ "$wants_firewall" -eq 1 ] && [ "$firewall_type_selection" -eq 1 ]; then
			sysrc firewall_enable="YES"
			sysrc firewall_quiet="YES"
			sysrc firewall_type="workstation"
			sysrc firewall_logdeny="YES"
			sysrc firewall_allowservices="any"
			sysrc firewall_myservices="22/tcp 80/tcp 443/tcp"
			echo "An IPFW firewall configuration has been set up."
			echo "Open ports are: 22, 80, 443, all over TCP."
			echo "Do you want to enable the firewall now?"
			echo "1) YES"
			echo "2) NO, I will start the service later"
			read -p "Enter the corresponding number: " ipfw_enable
					if [ "$ipfw_enable" -eq 1 ]; then
							service ipfw start
					elif [ "$ipfw_enable" -eq 2 ]; then
							echo "The firewall won't be started."
					else
							echo "Invalid selection for firewall start-up."
					fi
	elif [ "$wants_firewall" -eq 1 ] && [ "$firewall_type_selection" -eq 2 ]; then
			net_if=$(ifconfig | grep -o '^[^:]*' | head -1)
			echo "
################ Start of PF rules file #####################

# Define network interface
net_if = \"$net_if\"

# Define services to allow
services_tcp = \"{ ssh, http, https }\"

# Allow all traffic on the loopback interface
set skip on lo0

# Default block all traffic
block all

# Anti-spoofing protection
antispoof log quick for \$net_if

# Allow inbound SSH, HTTP, and HTTPS
pass in on \$net_if proto tcp from any to any port \$services_tcp keep state

# Allow outbound SSH, HTTP, and HTTPS
pass out on \$net_if proto tcp to any port \$services_tcp keep state

# Allow DNS queries (optional, if needed)
pass out on \$net_if proto udp to any port domain keep state
pass in on \$net_if proto udp from any to any port domain keep state

################ End of PF rules file #####################
                " >> /etc/pf.conf
                sysrc pf_enable="YES"
                echo "A PF firewall configuration has been set up."
                echo "After this script is almost finished you will be asked to start up the PF firewall or not."
        elif [ "$wants_firewall" -eq 2 ]; then
                break

        else
                echo "Invalid firewall selection"
        fi
}

enable_pf_firewall() {

    if [ "$ipfw_configured" = true ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = false ]; then
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = true ] && [ "$ipfilter_configured" = false ]; then
        break
    elif [ "$ipfw_configured" = false ] && [ "$pf_configured" = false ] && [ "$ipfilter_configured" = true ]; then
        break
	elif [ "$wants_firewall" -eq 2 ]; then
		break
	elif [ "$pf_configured" = false ] && [ "$firewall_type_selection" -eq 2 ]; then
		echo "Since the PF firewall was selected, it needs service activation."
		echo "Be aware SSH connections will be momentarily interrupted, logging users out."
		echo "Choose to start the PF firewall now or do it manually later"
		echo "1) YES, start the PF firewall right now"
		echo "2) NO, do NOT start the PF firewall now, I will enable it later by issuing the command \"service pf start\"."
		read -p "Enter the corresponding number: " pf_start
			if [ "$pf_start" -eq 1 ]; then
					service pf start
			elif [ "$pf_start" -eq 2 ]; then
					echo "PF won't be started as selected. Mind to do it manually when appropiate."
			else
					echo "Invalid pf service start selection."
			fi
	else
		break
	fi

}

check_ipfw_firewall
check_pf_firewall
check_ipfilter_firewall
select_firewall
install_firewall
enable_pf_firewall
