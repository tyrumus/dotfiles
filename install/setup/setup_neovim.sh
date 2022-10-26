function setup_neovim() {
    sp "Starting headless Neovim install"
    nvim --headless -c "autocmd User PackerComplete quitall"
}
