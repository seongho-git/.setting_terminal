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
brew_installed() { command -v brew &>/dev/null; }
git_installed() { command -v git &>/dev/null; }
curl_installed() { command -v curl &>/dev/null; }
vim_installed() { command -v vim &>/dev/null; }
# default vim does not support python3
brew_vim_installed() { [ -f /opt/homebrew/bin/vim ]; }
vim_plug_installed() { [ -f ~/.vim/autoload/plug.vim ]; }

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

# Install Homebrew if not installed for macOS
if [[ $system == "Darwin" ]]; then
		if ! brew_installed; then
				echo "Homebrew not found. Installing Homebrew..."
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		else
				echo "Homebrew is already installed. Version: $(brew --version)"
		fi
fi

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

# Install CMake if not installed
echo "Installing build tools..."
if [[ $system == "Darwin" ]]; then
		brew install cmake
elif [[ $system == "Linux" ]]; then
		sudo apt update && sudo apt install -y build-essential g++ cmake python3-dev
fi

# Install Vim
if [[ $system == "Darwin" ]]; then
		# Install Vim if not installed
		if ! brew_vim_installed; then
				echo "Vim not found. Installing Vim..."
				brew install vim
		else
				echo "Vim is already installed. Version: $(vim --version | head -n 1)"
		fi
elif [[ $system == "Linux" ]]; then
		# Install Vim if not installed
		if ! vim_installed; then
				echo "Vim not found. Installing Vim..."
				sudo apt-get update && sudo apt-get install -y vim
		else
				echo "Vim is already installed. Version: $(vim --version | head -n 1)"
		fi
fi

# Copy .vimrc and syntax settings
echo "Copying .vimrc and syntax settings..."
# check if .vimrc and .vim directory already exists, delete it
if [ -f ~/.vimrc ]; then
		rm ~/.vimrc
fi
if [ -d ~/.vim ]; then
		rm -rf ~/.vim
fi
cp ./.setting/.vimrc ~/.vimrc
cp -r ./.vim/syntax ~/.vim/

# Install Vim-Plug
if ! vim_plug_installed; then
		echo "Installing Vim-Plug..."
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
				https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
				else
						echo "Vim-Plug is already installed."
fi

# Install plugins using Vim-Plug
echo "Installing Vim plugins..."
# Put enter key to avoid error
vim -c 'PlugInstall' -c 'qa'
# Put enter key to avoid error

# Ensure terminal supports 256 colors
export TERM=xterm-256color

# Install YouCompleteMe plugin
echo "Installing YouCompleteMe plugin..."
cd ~/.vim/plugged/YouCompleteMe || exit
python3 install.py --clangd-completer
cd ~

#########################################################
# Installation Check                                    #
#########################################################

echo -e "\n--------------------"
echo "Installation result:"
echo -e "--------------------"
if [[ $system == "Darwin" ]]; then
		echo "System: macOS"
		echo -e "Homebrew          ... \c"; if brew_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Git               ... \c"; if git_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Curl              ... \c"; if curl_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Vim               ... \c"; if brew_vim_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Vim-Plug          ... \c"; if vim_plug_installed; then echo "Yes"; else echo "No"; fi
elif [[ $system == "Linux" ]]; then
		echo "System: Linux"
		echo -e "Git               ... \c"; if git_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Curl              ... \c"; if curl_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Vim               ... \c"; if vim_installed; then echo "Yes"; else echo "No"; fi
		echo -e "Vim-Plug          ... \c"; if vim_plug_installed; then echo "Yes"; else echo "No"; fi
fi

if [[ $system == "Darwin" ]]; then
		if brew_installed && git_installed && curl_installed && brew_vim_installed && vim_plug_installed; then
				echo "Installation complete."
		else
				echo "incomplete. Please check the errors above."
		fi
elif [[ $system == "Linux" ]]; then
		if git_installed && curl_installed && vim_installed && vim_plug_installed; then
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
