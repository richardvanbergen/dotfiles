#!/bin/zsh

# Define color codes
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo -e "${RED}Warning: Homebrew is not installed. Run setup.sh.${NC}"
  exit 1
fi

SECRETS_FILE="$HOME/.secrets.env"

if [[ ! -f "$SECRETS_FILE" ]]; then
  echo -e "${YELLOW}Secrets file $SECRETS_FILE not found.${NC}"
fi

# Read each line from the secrets file
while IFS='=' read -r var_name secret_url; do
  # Skip lines that start with # (comments)
  [[ $var_name =~ ^[[:space:]]*# ]] && continue

  # Remove inline comments (everything after #)
  line="$var_name=$secret_url"
  line=${line%%#*}

  # Split the cleaned line into var_name and secret_url
  IFS='=' read -r var_name secret_url <<< "$line"

  # Trim whitespace
  var_name=$(echo "$var_name" | xargs)
  secret_url=$(echo "$secret_url" | xargs)

  # Skip empty lines
  [[ -z "$var_name" || -z "$secret_url" ]] && continue

  # Check if the variable is already set in the environment
  if [[ -z "${(P)var_name}" ]]; then
    # Resolve the secret URL and export it
    secret_value=$(op read "$secret_url" | tr -d '\n')

    # Check if the secret was retrieved successfully
    if [[ $? -eq 0 ]]; then
      export "$var_name=$secret_value"
    else
      echo -e "${YELLOW}Failed to retrieve secret for $var_name from $secret_url.${NC}"
    fi
  fi
done < "$SECRETS_FILE"

# Initialize Starship prompt for Zsh shell (if installed)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

alias ls="eza --group-directories-first --icons"
alias ll="eza --long --all --group-directories-first --icons"
alias tree="eza --tree --level=2"
alias cd="z"

export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
