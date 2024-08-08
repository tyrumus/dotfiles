local function attach(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", {buffer = bufnr})
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", {buffer = bufnr})
end

return {
    opts = {
        on_attach = attach,
    },
    keys = {
        { "<leader>a", "<cmd>AerialToggle<CR>" }
    }
}
