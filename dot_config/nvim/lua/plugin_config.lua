-- plugin init
require("alpha").setup(require("alpha.themes.dashboard").opts)
require("presence"):setup({
    neovim_image_text = "8==========>"
})
require("lualine").setup({
    options = {
        theme = "gruvbox-flat",
        section_separators = {left = "", right = ""},
        component_separators = {"", ""},
        icons_enabled = true
    }
})
vim.cmd[[colorscheme gruvbox-flat]]
require("indent_blankline").setup({
    buftype_exclude = {"terminal"},
    filetype_exclude = {"dashboard"}
})
require("trouble").setup()
require("todo-comments").setup()
require("project_nvim").setup({
    patterns = {".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project_root"}
})
require("nvim-web-devicons").setup({
    default = true
})
require("nvim_comment").setup()
