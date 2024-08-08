-- Git plugins

return {
    { -- display git commit message for current line
        "lsig/messenger.nvim",
        lazy = true,
        opts = {
            border = "rounded"
        },
        keys = {
            { "<leader>gm", "<cmd>MessengerShow<CR>" }
        },
        cmd = "MessengerShow"
    },
    { -- open lazygit in nvim
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = "LazyGit",
        keys = {
            { "<leader>lg", "<cmd>LazyGit<CR>" }
        },
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    { -- git integration with buffers
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "BufRead" },
        opts = require("config.gitsigns").opts,
        dependencies = {
            "folke/trouble.nvim"
        }
    },
}
