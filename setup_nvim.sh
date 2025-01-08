#!/bin/bash
# for run this script on bash shell

# File: setup_nvim.sh
# Description: This script sets up a Neovim environment with plugins and configurations as specified in the init.vim file.
# Updates: 2025_01_08
# Author: SeongHo Kim
# Email: seongho-kim@yonsei.ac.kr
# Usage:
#   Run this script in your terminal with:
#   ./setup_nvim.sh

# Check installation status of required tools
brew_installed() { command -v brew &>/dev/null; }
git_installed() { command -v git &>/dev/null; }
curl_installed() { command -v curl &>/dev/null; }
nvim_installed() { command -v nvim &>/dev/null; }
vim_plug_installed() { [ -f ~/.vim/autoload/plug.vim ]; }

#########################################################
# Get System Information                                #
#########################################################

# Detect the system type
system="$(uname -s)"

# Get the processor type.
processor="$(uname -m)"

if [[ $processor == "arm64" || $processor == "aarch64" ]]; then
    echo "Detected Apple Silicon processor."
    sysdir="/opt/homebrew" # Apple arm64
else 
    echo "Detected Intel x86_64 processor."
    sysdir="/usr/local"    # Intel x86_64
fi

# Set system-specific variables
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

# Install Git if not installed
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

# Install Neovim if not installed
if ! nvim_installed; then
    echo "Neovim not found. Installing Neovim..."
    if [[ $system == "Darwin" ]]; then
        brew install neovim
    elif [[ $system == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y neovim
    fi
else
    echo "Neovim is already installed. Version: $(nvim --version | head -n 1)"
fi

# Install Vim-Plug
if ! vim_plug_installed; then
    echo "Installing Vim-Plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "Vim-Plug is already installed."
fi

# Copy init.vim configuration
if [[ ! -d ~/.config/nvim ]]; then
    mkdir -p ~/.config/nvim
fi
cp ./.setting/init.vim ~/.config/nvim/init.vim

# Install Neovim plugins
nvim -c 'PlugInstall' -c 'qa'

# Final message
echo "Neovim environment setup complete. Launch Neovim with 'nvim' to start using the configured setup."
