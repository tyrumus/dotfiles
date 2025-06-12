-- vim global options

vim.opt.encoding = "UTF-8"
vim.opt.syntax = "on"
vim.opt.foldcolumn = "2"
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.laststatus = 2

-- disable line wrapping
vim.opt.wrap = false

-- enable mouse support in normal and visual modes
vim.opt.mouse = "nv"

-- keep buffers open in background when the window is closed
vim.opt.hidden = true


-- live substitution
vim.opt.inccommand = "split"
-- live searching
vim.opt.incsearch = true
-- case-insensitve searching
vim.opt.ignorecase = true
-- override ignorecase if search contains capitals
vim.opt.smartcase = true


-- enable auto indent
vim.opt.autoindent = true
-- number of spaces to use for auto indent
vim.opt.shiftwidth = 4
-- use this many spaces in place of hard tabs
vim.opt.softtabstop = 4
-- number of spaces to replace a tab with
vim.opt.tabstop = 4
-- replace tabs with spaces
vim.opt.expandtab = true


-- allow folder-specific nvim config
vim.opt.exrc = true
-- limit what an .exrc file can do
vim.opt.secure = true


-- force dark background
vim.opt.background = "dark"
-- show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- highlights matching parens, braces, etc
vim.opt.showmatch = true
-- make the cursorline work properly
vim.opt.cursorline = true
vim.cmd([[:hi clear CursorLine]])
vim.cmd([[:hi CursorLine gui=underline cterm=underline]])

--[[
use absolute paths for Windows clipboard stuff because we want interop.appendWindowsPath=false in /etc/wsl.conf
since that fixes Zsh lag
]]--
local wslconfpath = "/etc/wsl.conf"

if (vim.uv or vim.loop).fs_stat(wslconfpath) then
    vim.cmd([[
    let g:clipboard = {
                \   'name': 'WslClipboard',
                \   'copy': {
                \      '+': '/mnt/c/WINDOWS/system32/clip.exe',
                \      '*': '/mnt/c/WINDOWS/system32/clip.exe',
                \    },
                \   'paste': {
                \      '+': '/mnt/c/windows/system32/windowspowershell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \      '*': '/mnt/c/windows/system32/windowspowershell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \   },
                \   'cache_enabled': 0,
                \ }
]])
end
