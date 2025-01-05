# File: setup_zsh.sh
# Description: This script sets up a Zsh environment on macOS or Linux. It ensures necessary tools like Homebrew, Git, and Zsh are installed, copies configuration files, installs Oh My Zsh, and sets up plugins like Zsh-Autosuggestions and Zsh-Syntax-Highlighting.
# Updates: 2024_12_30
# Author: SeongHo Kim
# Email: klue980@gmail.com 
# Usage: 
#	Run this script in your terminal with: 
#	./zsh_mac.sh

# !/bin/bash

# Check installation status of required tools
brew_installed() { command -v brew &>/dev/null; }
git_installed() { command -v git &>/dev/null; }
curl_installed() { command -v curl &>/dev/null; }
zsh_installed() { command -v zsh &>/dev/null; }

#########################################################
# Get System Information                                #
#########################################################

# Detect the system type
system="$(uname -s)"

# Get the processor type.
processor="$(uname -m)"

if [[ $processor == "arm64" ]];
    then sysdir="/opt/homebrew" # Apple arm64
    else sysdir="/usr/local"    # Intel x86_64
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

# Install Zsh if not installed
if ! zsh_installed; then
    echo "Zsh not found. Installing Zsh..."
    if [[ $system == "Darwin" ]]; then
        brew install zsh
    elif [[ $system == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y zsh
    fi
else
    echo "Zsh is already installed. Version: $(zsh --version)"
fi

# (Optional) Set zsh as the default shell
# chsh -s $(which zsh) $USER
# if not working, sudo passwd $USER
# temporal
# export SHELL=$(which zsh)

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
Y | RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
## Zsh-Autosuggestions
if [[ $system == "Darwin" ]]; then
    if ! brew list zsh-autosuggestions &>/dev/null; then
        echo "Installing macOS Zsh-Autosuggestions..."
        brew install zsh-autosuggestions
    else
        echo "Zsh-Autosuggestions is already installed."
    fi
elif [[ $system == "Linux" ]]; then
    if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
        echo "Installing Linux Zsh-Autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    else
        echo "Zsh-Autosuggestions is already installed."
    fi
fi

## Zsh-Syntax-Highlighting
if [[ $system == "Darwin" ]]; then
    if ! brew list zsh-syntax-highlighting &>/dev/null; then
        echo "Installing macOS Zsh-Syntax-Highlighting..."
        brew install zsh-syntax-highlighting
    else
        echo "Zsh-Syntax-Highlighting is already installed."
    fi
elif [[ $system == "Linux" ]]; then
    if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
        echo "Installing Linux Zsh-Syntax-Highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    else
        echo "Zsh-Syntax-Highlighting is already installed."
    fi
fi

# Install Powerlevel10k theme
if [[ $system == "Darwin" ]]; then
    if ! brew list powerlevel10k &>/dev/null; then
        echo "Installing Powerlevel10k..."
        brew install powerlevel10k
    else
        echo "Powerlevel10k is already installed."
    fi
elif [[ $system == "Linux" ]]; then
    if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
        echo "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    else
        echo "Powerlevel10k is already installed."
    fi
fi

# Configure Powerlevel10k
rm -f ~/.p10k.zsh
cp ./.setting/.p10k.zsh ~/.p10k.zsh
# echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
# sed -i "s/^ZSH_THEME=.*/ZSH_THEME='powerlevel10k\/powerlevel10k'/" ~/.zshrc
# echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc


# tmux conf setting
# sudo apt-get install -y tmux
# cp ~/.init-setting/.tmux.conf ~/.tmux.conf
# tmux source-file ~/.tmux.conf

# Install tmux tpm if it is not installed
# if [[ ! -d ~/.tmux/plugins/tpm ]]; then
#   echo "Installing tmux tpm..."
#   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi

# Copy .zshrc configuration
rm -f ~/.zshrc
cp ./.setting/.zshrc ~/.zshrc


# Apply Zsh configuration
zsh -c "source ~/.zshrc"
zsh
