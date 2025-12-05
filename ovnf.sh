#!/bin/bash

# ------------------ Verification ------------------
mkdir ~"/vpnconfig" 2> /dev/null/ #Verifies presence of VPN Config Directory. Makes directory if not available  
mkdir ~"vpnconfig/logs" >2 /dev/null/ #Verifies presence of log file. Makes directory if not
#Main Menu Banner & Options
userdir=$(echo ~)
configpath="$userdir/vpnconfig"
avconfigs=$(ls $configpath | grep ".ovpn") #Parses and displays OpenVPN configuration files in the vpnconfig path

# ------------------ End ------------------


# ------------------ Connection Processes ------------------

connect(){
 	vpncheck	  
 	if [[ "$vpnid" -lt 2 && "$tun0con" -eq 0 ]]; then # Checks for Active Process id using PGREP & checks for active Tun0 Interface
 		echo "-----"
 		sudo openvpn "$selectprofile" | echo "" &
 		empline
 		echo "OpenVPN Loading. Please allow up to 10 seconds"
 		empline
 		loadscreentimer
 		empline
		vpncheck
 		#Nested IF Statement for Status Check 
		if [[ "$tun0con" -eq 1 ]]; then
			banner
			echo "-----------------------------------------"
 			echo "|    OPENVPN Connection Successful!     |"
			echo "-----------------------------------------"
			external_connection_vfy
			shorttimer	
 		if [[ "$extinttest" -eq 1 ]]; then # Uses a Boolean based If statement to check if network packet was receieved. 
 			echo $conn_successful
 			else
 				banner
 				echo "Connection Failed. Attempting Alternative Connection."
 				shorttimer
 				if [[ "$extintestbkp" -eq 1 ]]; then
 					echo $conn_successful
 				else
 					banner
 					echo $conn_failed
 				fi
 						
 			
 		fi
 		#If condition is not met,returns to main menu and displays message
 	else
 		banner
 		echo "$tun0con"
 		echo "Connection not confirmed. Terminating Failed OpenVPN processes"
 		shorttimer
 		end_connection
 	fi
 	else
 	echo "OpenVPN Connection Already Established"
 	fi
}
Disconnect(){
vpncheck
if [[ "$vpnid" -gt 1 && "$tun0con" -eq 1 ]]; then
 	echo "Disconnecting From VPN. Please Wait."
	end_connection
 	shorttimer			
 	banner
 	echo ""
	echo "--------------------------------"	 
 	echo " VPN Disconnected Successfully"
 	echo "--------------------------------"
 	vpnid="0"
 			
 	else
 		banner
 		echo "No Active OpenVPN connection available"
 	fi
}

verify(){
 	vpncheck
 	external_connection_vfy
 	shorttimer
 	if [[ "$extinttest" -eq 1 ]]; then
 		banner
		echo "Server Responded. Internet Connection Confirmed!"
	else
		banner
		echo $conn_failed
	fi
}

end_connection() {
sudo pkill openvpn
}

vpncheck() {
 vpnid=$(pgrep "openvpn") 
 tun0con=`ifconfig | grep -c "tun0"`
 sleep 0.5
 }
 
external_connection_vfy() {
conn_failed="No Connection Detected. Please Check your internet connection." 
conn_successful="Server Responded. Internet Connection Confirmed!"
echo "Testing External Internet Connection"
#Tests External network using Cloudflare services
errorlog="$configpath/logs/ConnLog-$(date "+%Y-%m-%d %H:%M:%S").log"  
extinttest=$(ping -c 1 1.1.1.1 2>"$errorlog" | grep -c "1 received") #Pings CloudFlare Services to verify external connectivity
extintestbkp=$(ping -c 1 8.8.8.8 2>"$errorlog" | grep -c "1 received") #Pings Google Services as Backup for Cloudflare
if [ ! -s "$errorlog" ]; then
	rm "$errorlog" 
else
	echo ""
fi
}
# ------------------ End ------------------



# ------------------ User Interface ------------------

# Define colors & Formatting
GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;31m'
WHITE='\033[1;37m'
ORANGE='\x1b[1;38;5;208m'
NC='\033[0m' # No Color

empline() {
echo ""
}

empdbl() {
echo ""
echo ""
}

banner() {
clear
echo -e "${ORANGE}    _____     ___   _ ${NC}     ${WHITE} _____ _               ${NC}   ____ _ _            _   "
echo -e "${ORANGE}   / _ \ \   / / \ | |${NC}_____${WHITE}|  ___| | _____      __${NC}  / ___| (_) ___ _ __ | |_ "
echo -e "${ORANGE}  | | | \ \ / /|  \| |${NC}_____${WHITE}| |_  | |/ _ \ \ /\ / /${NC} | |   | | |/ _ \ '_ \| __|"
echo -e "${ORANGE}  | |_| |\ V / | |\  |${NC}     ${WHITE}|  _| | | (_) \ V  V / ${NC} | |___| | |  __/ | | | |_ "
echo -e "${ORANGE}   \___/  \_/  |_| \_|${NC}     ${WHITE}|_|   |_|\___/ \_/\_/  ${NC}  \____|_|_|\___|_| |_|\__|"
empdbl
sudo echo "Open-Source OpenVPN Client Project Developed by Declan Eaton "
empline
echo -e "Version ${WHITE}1.0.1${NC}" 
empdbl
echo "Welcome! $(whoami)"
empline
}

menu() {
empline
echo -e "Current Profile: ${WHITE}$(cat "$configpath/activeprofile.txt")${NC}" #Displays txt file containing chosen profile name
empline
echo -e "1 -${GREEN} Connect${NC}"
empline
echo -e "2 -${RED} Disconnect${NC}"
empline
echo -e "3 -${GREEN} Verify Connection${NC}"
empline
echo -e "4 -${WHITE} Configuration Menu${NC}"
empline
echo -e "5 -${BLUE} Exit${NC}"
empline
 }
 
 mainmenu() {
 #Loop to return to main menu after action 
 while true; do
 	selectprofile=$(sudo cat "$configpath/selectedprofile.txt") # Reads the "selectedprofile" text file to hand over to the openvpn connection command 
 	menu
	read -p "Pick  An Option: " conf
	
	#Connect To VPN
	 if [[ $conf == 1 ]]; then
	connect
	 # Disconnect From VPN
	 elif [[ "$conf" == 2 ]]; then 	
	 	Disconnect
	 #Exit OpenVPN Panel	
	 elif [[ "$conf" == 3 ]]; then
		 verify
	 #Clear Panel
	 elif [[ "$conf" == 4 ]]; then
	 	configmenu
	 #Exit OVN-Flow
	 elif [[ "$conf" == 5 ]]; then
	 	clear
	 	echo "Exit"
	 	exit
	 else
	 	banner
	 	echo "Invalid Option, try again "
	 	mainmenu
	 fi
 done
}

configmenu() { #Configuration Menu
while true; do
banner
echo -e "${WHITE}Welcome to the configuration menu! ${NC}"
empline
echo "To go to Main Menu. Please type EXIT"
empline
echo -e "${WHITE}Configs Available:${NC}"
empline
echo -e "${WHITE}$avconfigs${NC}"
empline
read -p "Please Choose a Config File: (include .ovpn) " activeprof

profvfy=`ls "$configpath" | grep -c -x "$activeprof"`
if [[ "$profvfy" -eq 1 ]]; then
	echo $activeprof > "$configpath/activeprofile.txt" #Saves Active profile name to txt. Used in main menu
	echo "$configpath/$activeprof"  > "$configpath/selectedprofile.txt"
	banner
	mainmenu
elif [[ "$activeprof" == "exit" ]]; then
	banner
	mainmenu
else
	echo "Config not found, please try again. "
fi

done
}

# ------------------ End ------------------



# ------------------ User Experience ------------------
loadscreentimer() { #Uses for loop statements to display a loading bar. Use for longer processes involving network connections
echo -n "Loading  "
for i in {1..15}
do
	echo -n "...."
	sleep 0.45
done	
empline
 }
shorttimer() { # Uses For Loop statements to display a loading bar. Used in Quicker Processes
echo -n "Loading  "
for i in {1..17}
do
	echo -n "...."
	sleep 0.10
done	
empline
 } 
# ------------------ End ------------------

# ------------------ Called Functions ------------------ 
banner
mainmenu
# ------------------ End ------------------
