local vimmap = vim.api.nvim_set_keymap

local function map(bind, cmd, mode)
    local mode = mode or "n"
    vimmap("n", bind, cmd, {noremap = true})
end

-- Floaterm
map("<leader>e", "<cmd>FloatermNew git t<CR>")

-- telescope
--map("<C-p>", "<cmd>Telescope find_files<CR>")

-- fzf
map("<C-p>", "<cmd>lua require('fzf-lua').files()<CR>")
-- do not ignore files that match .gitignore
map("<C-P>", [[<cmd>lua require('fzf-lua').files({rg_opts = "--color=never --files --hidden --follow --no-ignore -g '!.git' -g '!node_modules'"})<CR>]])

-- lazygit
map("<leader>lg", "<cmd>LazyGit<CR>")

-- todo list
map("<leader>t", "<cmd>TodoTrouble<CR>")

-- Lazy.nvim Sync
map("<leader>l", "<cmd>Lazy sync<CR>")
