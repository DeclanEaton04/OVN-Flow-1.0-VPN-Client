# OVN-Flow-1.0.0-Bash-Based-OpenVPN-Client-with-Multi-Config-Support
Bash CLI Interface | Lightweight OpenVPN Client with Dual-Layer Connection Verification, Multi-Configuration &amp; Profile Support. 

Requirements:
* Ensure you have the OpenVPN Package installed on your device.
* This Script can only be run with sudo. Please enter this when prompted. 
Description:

OVN-Flow is a Lightweight OpenVPN Client designed for user friendly VPN management when using OpenVPN Configurations. Providing a clean, easy to use interface  



Features:

Multi-Configuration Support - OVN-Flow will discover & Display any added configurations. Allowing for you to easily Switch Between VPN Configs directly from the interface

Configuration Profiles - When a VPN Configruation is set. The Script will save this configuration after the script has ended. This active profile will be used when the script is opened again.  

Dual-Layer Connectivity Verification - Every Connection will undergo a 2 stage verification process to ensure the VPN has successfully connected and Internet Connectivity remains.

Manual Internet Connectivity Check - Test your internet connectivity. Can be used with or without an active VPN connection. 

Error Handling - If any connection issues arise while using this Client. All Logs are stored directly in the ./vpnconfig/logs directory for simple troubleshooting.

Installation Instructions:

To use this Client. Simply move the script provided to usr/local/bash. Rename the file from onvf.sh to ovnf

This script can now be run by typing ovnf into your terminal. You will see the sudo password prompt. This is required to use this script due to the OpenVPN dependency requiring root privileges. 

To initialize this client. Please run the script before attempting to add configs. The script will automatically create the relevant directories for you to add your .ovpn configs.

Instructions for use:

Now you have initialized the script. You are now ready to add your .ovpn configs. The VPN Configuration directory can be found in /home/USER/vpnconfigs/. Move any configs you would like to use into this directory.

Once you have moved the required configs to this directory. Run the script using the ovnf command. A main menu screen will appear with 6 options

1 - Connect To VPN - Connects to your chosen VPN Profile and verifies Connection
2 - Disconnect VPN - Checks for active connection and disconnects from VPN Profile
3 - Exit Panel - Exit to Terminal
4 - CLEAN Panel - Clears panel
5 - Configuration Menu - Select VPN Profiles
6 - Verify Internet Connection - Test Internet Connectivity

Before attempting a connection, ensure you select your .ovpn config using Configuration Menu.
