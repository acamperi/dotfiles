#!/usr/bin/env bash

set -eux

# install brew
if test ! "$(command -v brew)"; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
fi

# install packages
brew bundle

# set up symlinks
dotfiles_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# set up kitty
mkdir -p ~/.config/kitty
ln -nfsv "$dotfiles_dir/kitty/kitty.conf" ~/.config/kitty/kitty.conf
ln -nfsv "$dotfiles_dir/kitty/srcery_kitty.conf" ~/.config/kitty/srcery_kitty.conf

# set up fish
fish_path="$(brew --prefix)/bin/fish"
grep -qxF "/usr/local/bin/fish" /etc/shells || echo "$fish_path" >> /etc/shells
chsh -s "$fish_path"
mkdir -p ~/.config/fish/functions
ln -nfsv "$dotfiles_dir/fish/config.fish" ~/.config/fish/config.fish
ln -nfsv "$dotfiles_dir/fish/functions/fish_user_key_bindings.fish" ~/.config/fish/functions/fish_user_key_bindings.fish
ln -nfsv "$dotfiles_dir/fish/functions/fzf_key_bindings.fish" ~/.config/fish/functions/fish_user_key_bindings.fish

# set up neovim
# ln -nfsv "$dotfiles_dir/vim/vimrc" ~/.vimrc
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim +PlugInstall +qall
mkdir -p ~/.config/nvim
ln -nfsv "$dotfiles_dir/nvim/init.lua" ~/.config/nvim/init.lua
ln -nfsv "$dotfiles_dir/nvim/lua" ~/.config/nvim/lua
# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# nvim +PlugInstall +qall
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# set up git
mkdir -p ~/.config/git
ln -nfsv "$dotfiles_dir/git/config" ~/.config/git/config
ln -nfsv "$dotfiles_dir/git/ignore" ~/.config/git/ignore

# set up tmux
mkdir -p ~/.config/tmux
ln -nfsv "$dotfiles_dir/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# install nerd font
# https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf
