#!/bin/bash
echo ""
echo ""
echo "             +~+~+~+~+~+~+~+~+~~+~+~+~~+~+~+~~+~+~+~+~+~+~+~ "
echo " "
echo "                <--Made only for SONOMA NPT Devices-->"
echo "           ************************************************* "
echo "                   RNTrust (mohamedazarudeen.it@gmail.com)    "
echo "                < ~~~SYSLOG FORWARDER SETUP TOOL ~~~>   "
echo ""
echo "             +~+~+~+~++~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~ "
echo ""

#!/bin/bash
syslog_ip=""

function getip {
    while true; do
        echo ""
        echo "-------------------------"
        echo "Enter syslog receiver IP:"
        echo "-------------------------"
        echo ""
        read syslog_ip

        if [[ $syslog_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            IFS='.' read -ra octets <<< "$syslog_ip"
            valid=1
            for octet in "${octets[@]}"; do
                if [[ "$octet" -gt 255 ]]; then
                    valid=0
                    break
                fi
            done

            if [ $valid -eq 1 ]; then
                break
            else
                echo "Invalid IP address"
            fi
        else
            echo "Invalid IP address"
        fi
    done
}

function getprotocol {
    while true; do
        echo ""
        echo "-------------------------"
        echo "Enter protocol (udp/tcp): "
        echo "-------------------------"
        echo ""
        read protocol
        # Edit syslog configuration file to forward all logs to syslog server
        if [ $protocol == "udp" ]; then
            sed -i "s/^#*\s*.*@.*/\t*.*@$syslog_ip/" /etc/syslog.conf
            break
        elif [ $protocol == "tcp" ]; then
            sed -i "s/^#*\s*.*@.*/\t*.*@@$syslog_ip/" /etc/syslog.conf
            break
        else
            echo ""
            echo ""
            echo "Invalid Option, Try Again"
            echo ""
            echo ""
        fi
    done
}

function persistant {
echo ""
echo "-----------------------------------"
echo "Do you want to make it persistant? yes/no"
echo "-----------------------------------"
echo ""
read option

if [ $option == "no" ]; then

echo "****************************************************************"
echo "All logs are now being forwarded to syslog receiver Temporarily"
echo "After the restart the settings will revert back"
echo "****************************************************************"
/etc/rc.d/rc.syslog restart
echo "Service Restart done"

elif [ $option == "yes" ]; then
echo "***************************************************************"
echo "All logs are now being forwarded to syslog receiver permanantly"
echo "***************************************************************"
cp /etc/syslog.conf /boot/etc/syslog.conf
/etc/rc.d/rc.syslog restart
echo "Service Restart done"

else
echo "**************************"
echo "Invalid option, Try Again"
echo "**************************"
persistant
fi
}


getip
getprotocol
persistant
