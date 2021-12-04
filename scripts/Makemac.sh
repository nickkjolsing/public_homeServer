#!/bin/zsh

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing brew cask..."
brew tap homebrew/cask

echo "Installing Desktop Applications..."
brew install --cask handbrake -q
brew install --cask mullvadvpn -q
brew install --cask docker -q
brew install --cask discord -q
brew install --cask signal -q
brew install --cask visual-studio-code -q
brew install --cask spotify -q
brew install --cask alfred -q
brew install --cask firefox -q
brew install --cask appcleaner -q