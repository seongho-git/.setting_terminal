#!/bin/bash
# for run this script on bash shell

# File: setup_copilot.sh
# Description: This script sets up a Copilot environment with plugins and configurations as specified in the init.copilot file.
# Updates: 2025_01_08
# Author: SeongHo Kim
# Email: seongho-kim@yonsei.ac.kr
# Usage:
#  Run this script in your terminal with:
#  ./setup_copilot.sh

# Check installation status of required tools
node_installed() { command -v node &>/dev/null; }
vim_installed() { command -v vim &>/dev/null; }
brew_vim_installed() { command -v /usr/local/bin/vim &>/dev/null; }
nvim_installed() { command -v nvim &>/dev/null; }

#########################################################
# Get System Information                                #
# ########################################################

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
# ########################################################
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

# Ensure that Vim is installed
if [[ $system == "Darwin" ]]; then
		if ! vim_installed; then
				if ! brew_vim_installed; then
						echo "Vim not found. Installing Vim..."
						brew install vim
				else
						echo "Vim is already installed. Version: $(/usr/local/bin/vim --version)"
				fi
		else
				echo "Vim is already installed. Version: $(vim --version)"
		fi
elif [[ $system == "Linux" ]]; then
		if ! vim_installed; then
				echo "Vim not found. Installing Vim..."
				sudo apt-get install -y vim
		else
				echo "Vim is already installed. Version: $(vim --version)"
		fi
fi

# Ensure that Neovim is installed
if ! nvim_installed; then
		echo "Neovim not found. Installing Neovim..."
		if [[ $system == "Darwin" ]]; then
				brew install neovim
		elif [[ $system == "Linux" ]]; then
				sudo apt-get install -y neovim
		fi
else
		echo "Neovim is already installed. Version: $(nvim --version)"
fi

source ~/.bashrc

# Download Copilot on neoVim
# on macOS and Linux
echo "Installing Copilot on neoVim..."
if [[ ! -f ~/.config/nvim/pack/github/start/copilot.vim ]]; then
    git clone https://github.com/github/copilot.vim \
        ~/.config/nvim/pack/github/start/copilot.vim
fi
# Install Copilot on neoVim
nvim -c "Copilot setup" -c "Copilot enable" -c "q"
# if needed, follow github authentication

# Download Copilot on Vim
# on macOS and Linux
echo "Installing Copilot on Vim..."
if [[ ! -f ~/.vim/pack/github/start/copilot.vim ]]; then
    git clone https://github.com/github/copilot.vim \
        ~/.vim/pack/github/start/copilot.vim
fi
# Install Copilot on Vim
vim -c "Copilot setup" -c "Copilot enable" -c "q"
# if needed, follow github authentication

#########################################################
# Check Installation Status                             #
# ########################################################

# Check if Copilot is installed
if [[ -d ~/.config/nvim/pack/github/start/copilot.vim ]]; then
		echo "Copilot is installed on neoVim."
else
		echo "Copilot is not installed on neoVim."
fi

if [[ -d ~/.vim/pack/github/start/copilot.vim ]]; then
		echo "Copilot is installed on Vim."
else
		echo "Copilot is not installed on Vim."
fi

# Check if Copilot is enabled
if [[ -f ~/.config/nvim/pack/github/start/copilot.vim/plugin/copilot.vim ]]; then
		echo "Copilot is enabled on neoVim."
else
		echo "Copilot is not enabled on neoVim."
fi

#########################################################
# End of Script                                         #
# ########################################################
