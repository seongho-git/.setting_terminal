# .setting_terminal
This repository provides two primary scripts to set up development environments on macOS or Linux:

1. **Zsh Setup Script** — `setup_zsh.sh`  
2. **Vim Setup Script** — `setup_vim.sh`
3. **NeoVim Setup Script** — `setup_nvim.sh`

Each script installs necessary dependencies, configures popular plugins, and copies respective configuration files to your home directory.

## Features

- **Zsh Installation**: Installs zsh using the system's package manager.
- **Oh My Zsh Setup**: Installs Oh My Zsh, a framework for managing zsh configurations.
- **Syntax Highlighting**: Adds zsh-syntax-highlighting for improved command readability.
- **Autosuggestions**: Integrates zsh-autosuggestions to suggest commands as you type.
- **Powerlevel10k Theme**: Sets up the Powerlevel10k theme for an enhanced prompt appearance.
- **Alias Configuration**: Defines custom aliases for common commands to streamline workflows.

## Installation

To set up your environment using this script, follow these steps:

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/seongho-git/.setting_terminal.git
   ```

2. **Navigate to the Directory**:

   ```bash
   cd .setting_terminal
   ```

3. **Run the Setup Script**:

   ```bash
   # Run all setup scripts in sequence
   ./setup_all.sh
   source ~/.zshrc
   ```

   ```bash
   ./setup_zsh.sh
   ```
   
   ```bash
   # To change the default shell in environments like Multipass
   chsh -s $(which zsh) $USER
   # If the above command fails, add the following line to your .bashrc file:
   echo "exec zsh" >> ~/.bashrc
   ```
   
   ```bash
   ./setup_vim.sh
   ```
   ```bash
   ./setup_nvim.sh
   ```

   ```bash
   ./setup_copilot.sh
   source ~/.bashrc
   # During the installation, you will need to enter the Copilot token using a web browser
   # Ensure you have access to a device with a web browser
   # visit https://github.com/login/device
   ```

   ```bash
   ./setup_all.sh
   ```

   *Note* Ensure the script has execute permissions. If not, modify the permissions with:

   ```bash
   chmod +x setup_zsh.sh
   ```

## Updates

The script is periodically updated to incorporate the latest tools and configurations. Recent enhancements include:

- Integration of the Powerlevel10k theme for a modern and informative prompt.
- Addition of zsh-autosuggestions to boost command-line efficiency.
- Refinement of alias definitions for improved command shortcuts.

## Author

This repository is maintained by Seongho Kim.

- **Updates**: December 4th, 2024
- **Email**: [seongho-kim@yonsei.ac.kr](mailto:seongho@yonsei.ac.kr)
- **GitHub**: [@seongho-git](https://github.com/seongho-git)

For questions or feedback, feel free to reach out via email or through GitHub.
For more information, visit my [Tistory blog](https://klue.tistory.com/78).



