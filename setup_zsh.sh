# File: setup_zsh.sh
# Description: This script automates the installation and configuration of zsh, oh-my-zsh and powerlevel10k on Ubuntu (Devian). It also sets up plugins and custom configurations for zsh.

# Updates: 2024_12_04 
# Author: SeongHo Kim
# Email: klue980@gmail.com 
# Usage: 
#	Run this script in your terminal with: 
#	./setup_zsh.sh

# !/bin/bash

# install zsh and set default shell
sudo apt update
sudo apt install -y zsh curl git
sudo chsh -s $(which zsh)

# install oh-my-zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh plugins
## zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

## zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# install zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
#rm -f ~/.p10k.zsh
#cp ./.p10k.zsh ~/.p10k.zsh
echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
#sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc


# tmux conf setting
# sudo apt-get install -y tmux
# cp ~/.init-setting/.tmux.conf ~/.tmux.conf
# tmux source-file ~/.tmux.conf

# Install tmux tpm if it is not installed
# if [[ ! -d ~/.tmux/plugins/tpm ]]; then
#   echo "Installing tmux tpm..."
#   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi

zsh -c "source ~/.zshrc"
zsh
