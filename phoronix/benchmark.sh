#!/bin/bash

# Revision: 4/3/2026
# Description: Benchmarking script to streamline use of phoronix testing suite.

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"
LOGPATH="/tmp/benchmark.log"

echo -e "${BLUE}${BOLD}Script is running, logs can be found in $LOGPATH ${RESET}"

# Runs stress-ng multi-core with unattended answers
echo -e "${BOLD}Running multi-core CPU test...${RESET}"
phoronix-test-suite batch-benchmark stress-ng <<EOF > $LOGPATH
1
EOF

# Runs stress-ng single-core with unattended answers
echo -e "${BOLD}Running single-core CPU test...${RESET}"
for ((i=0; i<$(nproc); i++)); do
    echo "Testing core $i..."
    taskset -c $i phoronix-test-suite batch-benchmark stress-ng << EOF | awk '/Test 1 of 1/,0' >> $LOGPATH
1
EOF
done

# Runs mbw with unattended answers
echo -e "${BOLD}Running RAM test...${RESET}"
phoronix-test-suite batch-benchmark mbw <<EOF >> $LOGPATH
1
4
EOF

# Displays drives on the device and prompts user for the drive desired.
lsblk -d -e 7
while true; do
    read -p "Please specify the drive you want analyzed (sda, nvme0n1, etc.):" drive
    if [ -b "/dev/$drive" ]; then
        break
    else
        echo -e "${RED}${BOLD}Invalid drive${RESET}"
    fi
done
echo -e "${BOLD}Checking SMART values...${RESET}"
sudo smartctl -a /dev/$drive >> $LOGPATH
driveuse=$(grep "Percentage Used" $LOGPATH)
echo -e "$driveuse" # Displays life of the drive

# Checks battery history, displays amount of charging cycles.
echo -e "${BOLD}Checking battery health...${RESET}"
battery=$(upower -e | grep battery)
upower -i $battery >> $LOGPATH
cycle=$(grep charge-cycle $LOGPATH)
echo -e "$cycle"


echo -e "${GREEN}${BOLD}Done! Further information can be found in the log file.${RESET}"