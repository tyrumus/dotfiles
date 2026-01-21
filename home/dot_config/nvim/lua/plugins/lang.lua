-- Language-specific plugins

return {
    { -- kitty terminal
        "fladson/vim-kitty",
        lazy = true,
        ft = "kitty",
    },
    { -- LaTeX
        "lervag/vimtex",
        lazy = false
    }
}
