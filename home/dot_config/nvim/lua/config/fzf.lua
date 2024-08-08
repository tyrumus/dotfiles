return {
    opts = {
        files = {
            multiprocess = true,
            git_icons = true,
            file_icons = true,
            color_icons = true,
            rg_opts = "--color=never --files --hidden --follow --ignore -g '!.git' -g '!node_modules'"
        }
    },
    keys = {
        { "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>" },
        { "<C-b>", "<cmd>lua require('fzf-lua').buffers()<CR>" },
    }
}
