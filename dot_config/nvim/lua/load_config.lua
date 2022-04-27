-- I'm not sure why this is done this way.
-- https://github.com/jchilders/dotfiles/blob/main/nvim/lua/load_config.lua

local M = {}
M.__index = M

M.init = function()
    -- Things that should happen after packer is initialized,
    -- but for whatever reason can't be put into packer's config attribute go here
end

return M
