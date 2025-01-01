#!/bin/zsh

# Define color codes
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo -e "${YELLOW}Homebrew is not installed. Installing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update && brew upgrade
fi

brew install jesseduffield/lazygit/lazygit

# Define an array of programs to ensure are installed
PROGRAMS=("1password-cli" "eza" "nvm" "starship" "stow" "lazygit" "zoxide" "dotnet-sdk" "docker" "gh" "ripgrep" "fd")

# Loop through the programs array
for program in "${PROGRAMS[@]}"; do
  if ! command -v "$program" &>/dev/null; then
    if ! brew list "$program" &>/dev/null && ! brew list --cask "$program" &>/dev/null; then
      if brew info --cask "$program" &>/dev/null; then
        brew install --cask "$program"
      else
        brew install "$program"
      fi
    fi
  fi
done

#!/bin/bash

# Prompt the user
read "response?Do you want to enable Touch ID for sudo? (y/n): "

# Check if the user input is 'y' or 'Y'
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    # Check if the file exists
    if [ -f /etc/pam.d/sudo_local ]; then
        echo "Overwriting /etc/pam.d/sudo_local..."
        echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo_local > /dev/null
        echo "Touch ID for sudo has been enabled."
    else
        echo "/etc/pam.d/sudo_local does not exist. Creating it..."
        echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo_local > /dev/null
        echo "Touch ID for sudo has been enabled."
    fi
fi
