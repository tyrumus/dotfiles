-- Util plugins

return {
    { -- auto close/rename HTML tags
        "windwp/nvim-ts-autotag",
        lazy = true,
        config = true,
        event = { "BufRead" },
        dependencies = {
            "nvim-treesitter"
        }
    },
    { -- superior fuzzy finder to telescope, that's not compatible with everything
        "ibhagwan/fzf-lua",
        lazy = true,
        opts = require("config.fzf").opts,
        keys = require("config.fzf").keys,
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { -- todo comment highlighting
        "folke/todo-comments.nvim",
        lazy = true,
        config = true,
        keys = {
            { "<leader>t", "<cmd>Trouble todo<CR>" }
        },
        event = { "BufRead" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim"
        }
    },
    { -- toggle comments by keymap
        "terrortylor/nvim-comment",
        lazy = true,
        event = { "BufRead" },
        main = "nvim_comment",
        config = true
    },
    { -- quickly edit surrounding delimiters
        "tpope/vim-surround",
        lazy = true,
        event = { "BufRead" }
    },
    { -- read/write files with sudo
        "lambdalisue/suda.vim",
        lazy = true
    },
    { -- floating terminal
        "voldikss/vim-floaterm",
        lazy = true,
        cmd = {
            "FloatermNew",
            "FloatermToggle",
            "FloatermNext"
        }
    },
    { -- automatically cd to project dir
        "ahmedkhalf/project.nvim",
        main = "project_nvim",
        opts = require("config.project").opts,
    },
    { -- automatically set indentation settings for a file
        "NMAC427/guess-indent.nvim",
        lazy = true,
        event = { "BufRead" },
        config = true
    },
    {
        "MagicDuck/grug-far.nvim",
        opts = {},
    },
    {
        "nvim-mini/mini.align",
        version = "*",
        opts = {},
        lazy = true,
        event = { "BufRead" }
    },
}
