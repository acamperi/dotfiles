# install brew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

# install fish
brew install fish
fish_path="$(brew --prefix)/bin/fish"
echo "$fish_path" | sudo tee -a /etc/shells
chsh -s "$fish_path"

# install cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install common packages
cargo install exa
brew install jq
cargo install ripgrep
brew install tmux
brew install htop

# install vim
brew install vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# TODO: install color schemes

