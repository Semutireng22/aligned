#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN} _____                                                                                _____ "
echo -e "( ___ )------------------------------------------------------------------------------( ___ )"
echo -e " |   |                                                                                |   | "
echo -e " |   |    #    ### ######  ######  ######  ####### ######        #     #####   #####  |   | "
echo -e " |   |   # #    #  #     # #     # #     # #     # #     #      # #   #     # #     # |   | "
echo -e " |   |  #   #   #  #     # #     # #     # #     # #     #     #   #  #       #       |   | "
echo -e " |   | #     #  #  ######  #     # ######  #     # ######     #     #  #####  #       |   | "
echo -e " |   | #######  #  #   #   #     # #   #   #     # #          #######       # #       |   | "
echo -e " |   | #     #  #  #    #  #     # #    #  #     # #          #     # #     # #     # |   | "
echo -e " |   | #     # ### #     # ######  #     # ####### #          #     #  #####   #####  |   | "
echo -e " |___|                                                                                |___| "
echo -e "(_____)------------------------------------------------------------------------------(_____)${NC}"

sleep 2  # Pause to display the banner

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Rust if not already installed
if command_exists rustc; then
    echo -e "${GREEN}Rust is already installed. Skipping Rust installation.${NC}"
else
    echo -e "${YELLOW}Installing Rust...${NC}"
    source <(wget -O - https://raw.githubusercontent.com/0xishaq/installation/main/rust.sh)
    echo -e "${GREEN}Rust installation completed.${NC}"
fi
sleep 2  # Pause for 2 seconds

# Install Foundry if not already installed
if command_exists foundryup; then
    echo -e "${GREEN}Foundry is already installed. Skipping Foundry installation.${NC}"
else
    echo -e "${YELLOW}Installing Foundry...${NC}"
    source <(wget -O - https://raw.githubusercontent.com/zunxbt/installation/main/foundry.sh)
    echo -e "${GREEN}Foundry installation completed.${NC}"
fi
sleep 2  # Pause for 2 seconds

# Install OpenSSL and pkg-config if not already installed
if dpkg -s libssl-dev pkg-config >/dev/null 2>&1; then
    echo -e "${GREEN}OpenSSL and pkg-config are already installed. Skipping installation.${NC}"
else
    echo -e "${YELLOW}Installing OpenSSL and pkg-config...${NC}"
    sudo apt update && sudo apt install -y pkg-config libssl-dev
    echo -e "${GREEN}OpenSSL and pkg-config installation completed.${NC}"
fi
sleep 2  # Pause for 2 seconds

# Interactive prompt for importing new wallet
read -p "Do you want to import a new wallet? (y/n): " import_wallet

if [[ "$import_wallet" == "y" ]]; then
    echo -e "${YELLOW}Importing new wallet...${NC}"
    [ -d ~/.aligned_keystore ] && rm -rf ~/.aligned_keystore && echo -e "${RED}Deleted existing directory ~/.aligned_keystore.${NC}"
    mkdir -p ~/.aligned_keystore
    cast wallet import ~/.aligned_keystore/keystore0 --interactive
    echo -e "${GREEN}Wallet imported successfully.${NC}"
else
    echo -e "${BLUE}Skipping wallet import.${NC}"
fi
sleep 2  # Pause for 2 seconds

# Clone the repository if not already cloned
if [ -d aligned_layer ]; then
    echo -e "${GREEN}aligned_layer repository already exists. Skipping cloning.${NC}"
else
    echo -e "${YELLOW}Cloning Aligned Layer repository...${NC}"
    git clone https://github.com/yetanotherco/aligned_layer.git
    echo -e "${GREEN}Repository cloned successfully.${NC}"
fi
sleep 2  # Pause for 2 seconds

# Navigate to zkquiz directory
cd aligned_layer/examples/zkquiz || { echo -e "${RED}Failed to navigate to zkquiz directory.${NC}"; exit 1; }

# Run the quiz
echo -e "${YELLOW}Running the quiz...${NC}"
make answer_quiz KEYSTORE_PATH=~/.aligned_keystore/keystore0
echo -e "${GREEN}Quiz completed.${NC}"
