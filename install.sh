#!/usr/bin/env bash

set -eux

# install brew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

# install packages
brew bundle

# set up symlinks
dotfiles_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# set up kitty
mkdir -p ~/.config/kitty
ln -nfsv "$dotfiles_dir/kitty/kitty.conf" ~/.config/kitty/kitty.conf

# set up fish
fish_path="$(brew --prefix)/bin/fish"
echo "$fish_path" | sudo tee -a /etc/shells
chsh -s "$fish_path"
mkdir -p ~/.config/fish/functions
ln -nfsv "$dotfiles_dir/fish/config.fish" ~/.config/fish/config.fish
ln -nfsv "$dotfiles_dir/fish/functions/fish_user_key_bindings.fish" ~/.config/fish/functions/fish_user_key_bindings.fish
ln -nfsv "$dotfiles_dir/fish/functions/fzf_key_bindings.fish" ~/.config/fish/functions/fish_user_key_bindings.fish

# set up vim
ln -nfsv "$dotfiles_dir/vim/vimrc" ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

# set up git
mkdir -p ~/.config/git
ln -nfsv "$dotfiles_dir/git/config" ~/.config/git/config
ln -nfsv "$dotfiles_dir/git/ignore" ~/.config/git/ignore

# set up tmux
mkdir -p ~/.config/tmux
ln -nfsv "$dotfiles_dir/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# install nerd font
# https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf
