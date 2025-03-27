return {
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            virt_test_pos = "right_align",
            delay = 2000
        },
    },
    keys = {
        { "<C-g>b", "<cmd>Gitsigns blame<CR>" }
    }
}
