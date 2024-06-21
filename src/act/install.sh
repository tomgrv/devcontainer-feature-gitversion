#!/bin/sh
set -e

echo "Activating feature 'act'"

### Install Act
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash -s -- -b /usr/local/bin
