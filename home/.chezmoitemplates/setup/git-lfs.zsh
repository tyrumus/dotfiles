# vim: ft=zsh
function setup_git_lfs(){
    sp "Installing Git LFS"
    waitkey
    git lfs install
}
