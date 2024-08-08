vim.opt.termguicolors = true

require("keymap")

-- load plugins if installed neovim is compatible
local minVersion = vim.version.parse("0.9")
local vimVersion = vim.version()
if vim.version.ge(vimVersion, minVersion) then
    require("plug")
    require("keymap.plugins")
end

require("opt")
