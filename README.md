# .dotfiles

preview what Stow will do:

stow -nv nvim

Restow after changing files

stow -R nvim

Remove the symlinks

stow -D nvim

cd ~/dotfiles
stow --target="$HOME" nvim

Set the target directory explicitly

cd ~/dotfiles
stow --target="$HOME" nvim
