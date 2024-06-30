ssp() {
    echo -en "\033[1m"
    echo -en "\033[32m"
    echo -n "==> "
    echo -en "\033[39m"
    echo -en "CHEZMOI: ${1}"
    echo -e "\033[0m"
}

sp() {
    echo -en "\033[1m"
    echo -en "\033[34m"
    echo -n "  -> "
    echo -en "\033[39m"
    echo -en "$1"
    echo -e "\033[0m"
}
