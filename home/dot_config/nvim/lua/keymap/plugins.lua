-- Floaterm
vim.keymap.set("n", "<leader>e", "<cmd>FloatermNew<CR>")
vim.keymap.set({"n", "t"}, "<F2>", "<C-\\><C-n><cmd>FloatermToggle<CR>")
vim.keymap.set({"n", "t"}, "<F3>", "<C-\\><C-n><cmd>FloatermNext<CR>")

-- Lazy.nvim Sync
vim.keymap.set("n", "<leader>l", "<cmd>Lazy sync<CR>")

-- LSP
vim.keymap.set("n", "<leader>o", "<cmd>LspStart<CR>")
vim.keymap.set("n", "<leader>p", "<cmd>LspStop<CR>")
