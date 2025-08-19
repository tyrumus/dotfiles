return {
    opts = {
        view = {
            merge_tool = {
                layout = "diff3_mixed",
                disable_diagnostics = true,
                winbar_info = true,
            },
        },
    },
    keys = {
        { "<C-g>d", "<cmd>DiffviewOpen<CR>" },
    }
}
