local vimmap = vim.api.nvim_set_keymap

local function map(bind, cmd, mode)
    local mode = mode or "n"
    vimmap(mode, bind, cmd, {noremap = true})
end

-- Floaterm
map("<leader>e", "<cmd>FloatermNew<CR>")
vim.keymap.set({"n", "t"}, "<F2>", "<C-\\><C-n><cmd>FloatermToggle<CR>")
vim.keymap.set({"n", "t"}, "<F3>", "<C-\\><C-n><cmd>FloatermNext<CR>")

-- fzf
map("<C-p>", "<cmd>lua require('fzf-lua').files()<CR>")

-- lazygit
map("<leader>lg", "<cmd>LazyGit<CR>")

-- todo list
map("<leader>t", "<cmd>TodoTrouble<CR>")

-- Lazy.nvim Sync
map("<leader>l", "<cmd>Lazy sync<CR>")

-- trouble
map("<leader>xQ", "<cmd>Trouble qflist toggle<CR>")
