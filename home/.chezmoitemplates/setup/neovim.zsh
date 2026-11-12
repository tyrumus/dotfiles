# vim: ft=zsh
function setup_neovim(){
    # The Neovim configuration bootstraps tree-sitter-cli and its Node.js
    # provider using this toolchain (see dot_config/nvim/lua/plug.lua).
    sp "Installing Node.js stable toolchain for Neovim"
    waitkey
    # n-install restores the N_PREFIX line after installing the toolchain.
    sed -i "/export N_PREFIX/d" "$HOME/.zshrc"
    curl -kL "https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install" | N_PREFIX="$HOME/.local/share/n" bash -s -- -y

    ssp "Installing Neovim plugins"
    waitkey
    nvim --headless "+Lazy! sync" +qa
}
