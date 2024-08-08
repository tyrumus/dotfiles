-- UI plugins

return {
    { -- gruvbox colorscheme, also used for kitty theme
        "eddyekofo94/gruvbox-flat.nvim",
        priority = 900,
        config = function()
            vim.cmd("colorscheme gruvbox-flat")
        end
    },
    { -- greeter
        "goolord/alpha-nvim",
        opts = require("config.dashboard").opts
    },
    { -- map icons to nerd fonts
        "kyazdani42/nvim-web-devicons",
        lazy = true,
        opts = { default = true }
    },
    { -- scrollbar
        "dstein64/nvim-scrollview",
        lazy = true,
        config = true,
        opts = require("config.scrollview").opts,
        event = { "BufRead" }
    },
    { -- hover plugin framework; provides visual help and context
        "lewis6991/hover.nvim",
        lazy = true,
        opts = require("config.hover").opts,
        keys = require("config.hover").keys,
        event = { "BufRead" }
    },
    { -- provides rainbow-colored delimiters to make it easier to see which pairs belong together
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        event = { "BufRead" }
    },
    { -- very epic statusline
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = "VeryLazy",
        opts = require("config.lualine").opts,
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        }
    },
    { -- show indentations guides
        "lukas-reineke/indent-blankline.nvim",
        priority = 1000,
        main = "ibl",
        lazy = true,
        opts = require("config.indent").opts,
        event = { "BufRead" }
    },
    { -- pretty list for diagnostics, quickfixes, etc
        "folke/trouble.nvim",
        lazy = true,
        config = true,
        keys = {
            { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>" }
        },
        cmd = "Trouble"
    },
    { -- generic UI selector for telescope.nvim
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = true,
        config = true
    },
    { -- fuzzy finder over lists
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        lazy = true,
        cmd = "Telescope",
        config = require("config.telescope").config,
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-lua/plenary.nvim"
        }
    },
    { -- tabpage interface for cycling thru git diffs
        "sindrets/diffview.nvim",
        config = true,
        lazy = true,
        cmd = "DiffviewOpen",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons"
        }
    },
    { -- show available keymaps while typing
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = require("config.whichkey").init,
        config = true,
        lazy = true
    },
    { -- pretty notification manager
        "rcarriga/nvim-notify",
        lazy = true,
        event = { "BufRead" },
        config = require("config.notify").config
    },
    { -- show colors (hex, rgb(), rgba(), etc) in the terminal
        "NvChad/nvim-colorizer.lua",
        lazy = true,
        event = { "BufRead" },
        config = true
    },
    { -- top winbar to show LSP context
        "utilyre/barbecue.nvim",
        lazy = true,
        opts = {
            attach_navic = false
        },
        event = { "LspAttach" },
        dependencies = {
            "SmiteshP/nvim-navic"
        }
    },
}
