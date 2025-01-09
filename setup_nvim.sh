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
node_installed() { command -v node &>/dev/null; }
gh_installed() { command -v gh &>/dev/null; }
nvim_installed() { command -v nvim &>/dev/null; }
vim_plug_installed() { [ -f ~/.local/share/nvim/site/autoload/plug.vim ]; }

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

# Check the system type
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

# Install Node.js if not installed
if ! node_installed; then
        echo "Node.js not found. Installing Node.js..."
        if [[ $system == "Darwin" ]]; then
                brew install node
        elif [[ $system == "Linux" ]]; then
            # Download and install nvm:
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
            # Verify nvm installation:
            # Export nvm to the current shell session:
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

            # Append nvm initialization to ~/.zshrc for future sessions:
            echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
            echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
            echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

            # Download and install Node.js:
            nvm install --lts
            # Verify the Node.js version:
            node -v # Should print "v23.6.0".
            nvm current # Should print "v23.6.0".
        fi
else
        echo "Node.js is already installed. Version: $(node --version)"
fi

# Install GitHub CLI if not installed
if ! gh_installed; then
        echo "GitHub CLI not found. Installing GitHub CLI..."
        if [[ $system == "Darwin" ]]; then
                echo "Detected Apple Silicon processor."
                echo "Login to GitHub CLI and retry the installation."
                exit 1
        elif [[ $system == "Linux" ]]; then
                sudo apt-get update
                sudo apt-get install gh
                gh auth login
        fi
else
        echo "GitHub CLI is already installed. Version: $(gh --version)"

# Install Neovim Python dependencies
if [[ $system == "Darwin" ]]; then
		echo "Installing Neovim Python dependencies..."
        python3 -m venv ~/.venvs/nvim
        source ~/.venvs/nvim/bin/activate
        pip3 install --upgrade pynvim
        pip3 list
        deactivate
elif [[ $system == "Linux" ]]; then
		echo "Installing Neovim Python dependencies..."
		sudo apt-get update && sudo apt-get install -y python3 python3-pip python3-venv
        python3 -m venv ~/.venvs/nvim
        source ~/.venvs/nvim/bin/activate
        pip3 install --upgrade pynvim
        pip3 list
        deactivate
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
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
