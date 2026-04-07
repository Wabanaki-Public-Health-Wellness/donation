#!/bin/bash

sudo apt update
sudo apt install -y smartmontools php-cli php-xml
cd phoronix-test-suite # Phoronix needs to be run in the directory it's in
sudo ./install-sh

phoronix-test-suite batch-setup <<EOF
n
n
EOF

phoronix-test-suite install stress-ng
phoronix-test-suite install mbw