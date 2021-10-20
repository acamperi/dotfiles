#!/usr/bin/env bash

set -eux

# install brew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
brew_path=/usr/local/bin/brew

# install packages
$brew_path bundle

# set up fish
fish_path="$($brew_path --prefix)/bin/fish"
echo "$fish_path" | sudo tee -a /etc/shells
chsh -s "$fish_path"

# set up vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

# install nerd font
# https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf
