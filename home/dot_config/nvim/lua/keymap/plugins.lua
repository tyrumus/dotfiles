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
map("<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>")

-- lazygit
map("<leader>lg", "<cmd>LazyGit<CR>")

-- todo list
map("<leader>t", "<cmd>TodoTrouble<CR>")

-- Lazy.nvim Sync
map("<leader>l", "<cmd>Lazy sync<CR>")

-- trouble
map("<leader>xQ", "<cmd>Trouble qflist toggle<CR>")

-- hover.nvim
vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
vim.keymap.set("n", "gK", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})
vim.keymap.set("n", "GK", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
