#!/bin/bash

# Author: Dylan Haughton
# Revision: 4/3/2026
# Description: Benchmarking script to streamline use of phoronix testing suite.

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

echo -e "${BLUE}${BOLD}Script is running, logs can be found in /tmp/benchmark.log ${RESET}"
#
echo -e "${BOLD}Running multi-core CPU test...${RESET}"
phoronix-test-suite batch-benchmark stress-ng <<EOF > /tmp/benchmark.log
1
EOF
# May grep the average value and display it
#echo -e "${BOLD}Running multi-core CPU test...${RESET}"
#phoronix-test-suite benchmark stress-ng >> /tmp/benchmark.log

#
echo -e "${BOLD}Running RAM test...${RESET}"
phoronix-test-suite batch-benchmark mbw <<EOF >> /tmp/benchmark.log
1
4
EOF
# May grep the average value and display it

#
echo -e "${BOLD}Displaying battery health...${RESET}"
upower -i /org/freedesktop/UPower/devices/battery_BAT0
# grep the cycle count 

#
lsblk -d -e 7
read -p "${BOLD}Please specify the drive you want analyzed:${RESET}" drive

echo -e "${BOLD}Displaying SMART values...${RESET}"
sudo smartctl -a /dev/$drive
# grep the percentage used, if under 50% green, if 50%-90% yellow, 90%-100% red

echo -e "${GREEN}${$BOLD}Done!${RESET}"



# Potential commands
# ------------------
# executive-summary