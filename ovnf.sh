#!/bin/bash
# Define colors & Formatting
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'
NC='\033[0m' # No Color
WHITE='\033[1;37m'

empline() {
echo ""
}
#Verification
pcuser=`whoami` #Assigns current username to variable
mkdir "/home/$pcuser/vpnconfig" 2> /dev/null/ #Verifies presence of VPN Config Directory. Makes directory if not available  
mkdir "/home/$pcuser/vpnconfig/logs" >2 /dev/null/ #Verifies presence of log file. Makes directory if not
#Main Menu Banner & Options
configpath="/home/$pcuser/vpnconfig/"



configmenu() { #Configuration Menu to change VPN Config Profile
while true; do
banner
echo -e "${WHITE}Welcome to the configuration menu! ${NC}"
echo "To go to Main Menu. Please type EXIT"
empline
echo -e "${WHITE}Configs Available:${NC}"
echo ""

avconfigs=$(ls $configpath | grep ".ovpn") #Parses and displays OpenVPN configuration files in the vpnconfig path

echo -e "${WHITE}$avconfigs${NC}"
empline
read -p "Please Choose a Config File: (include .ovpn) " activeprof
profvfy=`ls "$configpath" | grep -c -x "$activeprof"`

if [[ "$profvfy" -eq 1 ]]; then
	echo "$configpath/$activeprof"  > "$configpath/selectedprofile.txt"
	echo "You have selected $activeprof"
	mainmenu
elif [[ "$activeprof" == "exit" ]]; then
	mainmenu
else
	echo "Config not found, please try again. "
fi

done
}

banner() {
clear
figlet "OVN-Flow VPN Panel:" -c
sudo echo "Version 1.0.0 | Created by Declan Eaton Nov 2025"
empline
echo "Welcome! $pcuser"
empline
}


menu() {
echo "Current Profile: $selectprofile"
empline
echo -e "1)${GREEN} Connect To VPN${NC}"
empline
echo -e "2)${RED} Disconnect VPN${NC}"
empline
echo -e "3)${BLUE} EXIT Panel${NC}"
empline
echo -e "4)${WHITE} CLEAN Panel${NC}"
empline
echo -e "5)${WHITE} Configuration Menu${NC}"
empline
echo -e "6)${GREEN} Verify Internet Connection${NC}"
empline
 }
 
loadscreentimer() { #Uses for loop statements to display a loading bar. Use for longer processes involving network connections
echo -n "Loading"
echo ""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
do
	echo -n "...."
	sleep 0.6
done	
echo -n ""
echo ""
 }
shorttimer() { # Uses For Loop statements to display a loading bar. Used in Quicker Processes
echo -n "Loading"
echo ""
for i in 1 2 3 4 5 6 7 8 9 10
do
	echo -n "........"
	sleep 0.25
done	
echo -n ""
echo ""
 } 
 
 vpncheck() {
 vpnid=$(pgrep "openvpn") 
 tun0con=`ifconfig | grep -c "tun0"`
 sleep 0.5
 }
 
external_connection_vfy() {
echo "Testing External Internet Connection"
#Tests External network using Cloudflare services
errorlog="$configpath/logs/ConnLog-$(date "+%Y-%m-%d %H:%M:%S").log"  
extinttest=$(ping -c 1 1.1.1.1 2>"$errorlog" | grep -c "1 received")
if [ ! -s "$errorlog" ]; then
	rm "$errorlog" 
else
	echo ""
fi
shorttimer 
}
 
 banner
  mainmenu() {
 #Loop to return to main menu after action 
 while true; do
 	selectprofile=$(sudo cat "$configpath/selectedprofile.txt") # Reads the "selectedprofile" text file to hand over to the openvpn connection command 
 	menu
	read -p "Pick  An Option: " conf
	echo "You Entered: $conf"
#Connect To VPN
 if [[ $conf == 1 ]]; then
 	vpncheck	  
 	if [[ "$vpnid" -lt 2 && "$tun0con" -eq 0 ]]; then
 		echo "-----"
 		sudo openvpn "$selectprofile" | echo "" &
 		echo "OpenVPN Loading. Please allow up to 10 seconds"
 		loadscreentimer
 		echo ""
		vpncheck
 		#Nested IF Statement for Status Check 
		if [[ "$tun0con" -eq 1 ]]; then
			banner
			echo "-----------------------------------------"
 			echo "    OPENVPN Connection Successful!"
			echo "-----------------------------------------"
			external_connection_vfy	
 		if [[ "$extinttest" -eq 1 ]]; then # Uses a Boolean based If statement to check if network packet was receieved. 
 			echo "Server Responded. Internet Connection Confirmed!"
 			else
 			echo "Connection Failed! Please try again."
 			sudo pkill openvpn
 		fi
 		#If condition is not met,returns to main menu and displays message
 	else
 		banner
 		echo "$tun0con"
 		echo "Connection not confirmed. Terminating Failed OpenVPN processes"
 		shorttimer
 		sudo pkill openvpn
 	fi
 	else
 	echo "OpenVPN Connection Already Established"
 	fi
 # Disconnect From VPN
 	elif [[ "$conf" == 2 ]]; then 	
 	vpncheck
		if [[ "$vpnid" -gt 1 && "$tun0con" -eq 1 ]]; then
 			echo "Disconnecting From VPN. Please Wait."
			sudo pkill openvpn
 			shorttimer			
 			banner
 			echo ""
 			echo "--------------------------------"	 
 			echo " VPN Disconnected Successfully"
 			echo "--------------------------------"
 			vpnid="0"
 			echo "$vpnid"
 			
 	else
 		banner
 		echo "No Active OpenVPN connection available"
 	fi
 #Exit OpenVPN Panel	
 elif [[ "$conf" == 3 ]]; then
 	clear
 	echo "Exit"
 	exit
 #Clear Panel
 elif [[ "$conf" == 4 ]]; then
 	banner
 	echo "Panel Cleared"
 #Opens Config menu
 elif [[ "$conf" == 5 ]]; then
 	configmenu
 elif [[ "$conf" == 6 ]]; then
 	vpncheck
 	external_connection_vfy
 	echo "$extinttest "
 	if [[ "$extinttest" -eq 1 ]]; then
 		banner
		echo "Server Responded. Internet Connection Confirmed!"
	else
		banner
		echo "No Connection Detected. Please Check your internet connection." 
	fi
  else
 	echo "Invalid Option, try again: "
 fi	
 done
}
mainmenu
