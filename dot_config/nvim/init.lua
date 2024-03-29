vim.opt.termguicolors = true

require("keymap")

-- load plugins if installed neovim is compatible
local minVersion = vim.version.parse("0.9")
local vimVersion = vim.version()
if vim.version.gt(vimVersion, minVersion) then
    require("plug")
    require("keymap.plugins")
end

-- nvim options
vim.opt.encoding = "UTF-8"
vim.opt.wrap = false
vim.opt.inccommand = "split"
vim.opt.syntax = "on"
vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.exrc = true
vim.opt.foldcolumn = "2"
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.incsearch = true
vim.opt.mouse = "nv"
vim.opt.expandtab = true
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 2
vim.opt.showmatch = true
vim.opt.hidden = true

-- make the cursorline work properly
vim.opt.cursorline = true
vim.cmd([[:hi clear CursorLine]])
vim.cmd([[:hi CursorLine gui=underline cterm=underline]])
