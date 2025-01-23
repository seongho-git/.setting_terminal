#!/bin/bash
# for run this script on bash shell

# File: setup_vim.sh
# Description: This script sets up a Neovim environment on macOS or Linux. It ensures necessary tools like Homebrew, Git, and Vim are installed, copies configuration files, installs Vim-Plug, and sets up plugins like YouCompleteMe.
# Updates: 2025_01_08
# Author: SeongHo Kim
# Email: klue980@gmail.com
# Usage:
#   Run this script in your terminal with:
#   ./setup_vim.sh

# Check installation status of required tools
git_installed() { command -v git &>/dev/null; }
curl_installed() { command -v curl &>/dev/null; }
vim_installed() { command -v vim &>/dev/null; }

#########################################################
# Get System Information                                #
#########################################################

# Detect the system type
system="$(uname -s)"

# Get the processor type.
processor="$(uname -m)"

# Set system-specific variables
if [[ $processor == "arm64" || $processor == "aarch64" ]]; then
		echo "Detected Apple Silicon processor."
		sysdir="/opt/homebrew" # Apple arm64
else
		echo "Detected Intel x86_64 processor."
		sysdir="/usr/local"    # Intel x86_64
fi

if [[ $system == "Darwin" ]]; then
		echo "Detected macOS system."
elif [[ $system == "Linux" ]]; then
		echo "Detected Linux system."
else
		echo "Unsupported system detected. Exiting."
		exit 1
fi

#########################################################
# Main Script                                           #
#########################################################

# Install Git
if ! git_installed; then
		echo "Git not found. Installing Git..."
		if [[ $system == "Darwin" ]]; then
				brew install git
		elif [[ $system == "Linux" ]]; then
				sudo apt-get update && sudo apt-get install -y git
		fi
else
		echo "Git is already installed. Version: $(git --version)"
fi

# Install Curl if not installed
if ! curl_installed; then
		echo "Curl not found. Installing Curl..."
		if [[ $system == "Darwin" ]]; then
				brew install curl
		elif [[ $system == "Linux" ]]; then
				sudo apt-get update && sudo apt-get install -y curl
		fi
else
		echo "Curl is already installed. Version: $(curl --version | head -n 1)"
fi

# Install vim with src
sudo apt remove --purge vim vim-runtime vim-tiny vim-common vim-gui-common
sudo apt update
sudo apt install -y make
git clone https://github.com/vim/vim.git
cd vim
git pull
cd src
make distclean  # if you build Vim before
./configure --with-features=huge \
		--enable-multibyte \
		--enable-python3interp=yes \
		--with-python3-config-dir=$(python3-config --configdir) \
		--enable-cscope \
		--prefix=/usr/local
		# for python3 binding
		make
		sudo make install
		cd
		sudo ln -sf /usr/local/bin/vim /usr/bin/vi # if needed
		vim --version
		vi --version

#########################################################
# Installation Check                                    #
#########################################################

echo -e "\n--------------------"
echo "Installation result:"
echo -e "--------------------"
if [[ $system == "Darwin" ]]; then
		echo "System: macOS"
		echo -e "Git               ... \c"; if git_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Curl              ... \c"; if curl_installed; then echo "Yes"; else echo "No"; fi
elif [[ $system == "Linux" ]]; then
		echo "System: Linux"
		echo -e "Git               ... \c"; if git_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Curl              ... \c"; if curl_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Vim               ... \c"; if vim_installed; then echo "Yes"; else echo "No"; fi
fi

if [[ $system == "Darwin" ]]; then
		if git_installed && curl_installed && vim_installed then
				echo "Installation complete."
		else
				echo "incomplete. Please check the errors above."
		fi
elif [[ $system == "Linux" ]]; then
		if git_installed && curl_installed && vim_installed; then
				echo "Installation complete."
		else
				echo "incomplete. Please check the errors above."
		fi
else
		echo "incomplete. Please check the errors above."
fi

#########################################################
# End of Script                                         #
#########################################################
