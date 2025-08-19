-- LSP plugins

return {
    { -- code outline window
        "stevearc/aerial.nvim",
        lazy = true,
        opts = require("config.aerial").opts,
        keys = require("config.aerial").keys,
        event = { "BufRead" }
    },
    { -- LSP package manager
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        opts = require("config.mason").opts
    },
    { -- quickstart configs for Neovim LSP
        "neovim/nvim-lspconfig",
        lazy = true,
        config = require("config.lspconfig").config,
        event = { "BufRead" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "SmiteshP/nvim-navic"
        }
    },
    { -- bridges mason.nvim with nvim-lspconfig
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig"
        }
    },
    { -- epic syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        build = require("config.treesitter").build,
        config = require("config.treesitter").config,
        event = { "BufRead" }
    },
    { -- autocompletion engine
        "hrsh7th/nvim-cmp",
        lazy = true,
        config = require("config.cmp").config,
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim"
        }
    },
    { -- snippet engine
        "L3MON4D3/LuaSnip",
        lazy = true,
        config = true
    },
    { -- function signature hints while typing
        "ray-x/lsp_signature.nvim",
        lazy = true,
        event = { "BufRead" },
        config = true
    },
}
