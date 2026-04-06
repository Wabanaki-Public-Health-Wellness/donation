#!/bin/bash

# Author: Dylan Haughton
# Revision: 4/3/2026
# Description: Benchmarking script to streamline use of phoronix testing suite.

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"
LOGPATH="/tmp/benchmark.log"

echo -e "${BLUE}${BOLD}Script is running, logs can be found in $LOGPATH ${RESET}"
#
echo -e "${BOLD}Running multi-core CPU test...${RESET}"
phoronix-test-suite batch-benchmark stress-ng <<EOF > $LOGPATH
1
EOF

#
echo -e "${BOLD}Running RAM test...${RESET}"
phoronix-test-suite batch-benchmark mbw <<EOF >> $LOGPATH
1
4
EOF

#
lsblk -d -e 7
read -p "Please specify the drive you want analyzed:" drive
echo -e "${BOLD}Checking SMART values...${RESET}"
sudo smartctl -a /dev/$drive >> $LOGPATH
driveuse=$(grep "Percentage Used" $LOGPATH)
echo -e "$driveuse$"

#
echo -e "${BOLD}Checking battery health...${RESET}"
battery=$(upower -e | grep battery)
upower -i $battery >> $LOGPATH
cycle=$(grep charge-cycle $LOGPATH)
echo -e "$cycle"


echo -e "${GREEN}${BOLD}Done!${RESET}"



# Potential commands
# ------------------
# executive-summary