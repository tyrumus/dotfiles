-- lazy.nvim stuff
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "lewis6991/impatient.nvim"
    },
    {
        "eddyekofo94/gruvbox-flat.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme gruvbox-flat")
        end
    },
    {
        "goolord/alpha-nvim",
        opts = require("dashboard").opts
    },
    {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
        opts = { default = true }
    },
    {
        "williamboman/nvim-lsp-installer",
        config = function()
            require("nvim-lsp-installer").setup({
                automatic_installation = true,
                ui = {
                    icons = {
                        server_installed = "✓",
                        server_pending = "➜",
                        server_uninstalled = "✗"
                    }
                }
            })
            require("lspconfig").pyright.setup({})
            require("lspconfig").svelte.setup({})
            require("lspconfig").tailwindcss.setup({})
            require("lspconfig").rust_analyzer.setup({
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                }
            })
        end,
        event = { "BufRead" },
        dependencies = {
            "nvim-lspconfig"
        }
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({with_sync = true})
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"bash", "toml", "yaml", "html", "css", "javascript", "json", "c", "cpp", "lua", "rust", "python", "svelte"},
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                },
                autotag = {
                    enable = true
                },
                rainbow = {
                    enable = true,
                    extended_mode = true
                }
            })
        end,
        event = { "BufRead" }
    },
    {
        "mrjones2014/nvim-ts-rainbow",
        lazy = true,
        event = { "BufRead" },
        dependencies = {
            "nvim-treesitter"
        }
    },
    {
        "windwp/nvim-ts-autotag",
        lazy = true,
        event = { "BufRead" },
        dependencies = {
            "nvim-treesitter"
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = "VeryLazy",
        opts = {
            options = {
                theme = "gruvbox-flat",
                section_separators = {left = "", right = ""},
                component_separators = {"", ""},
                icons_enabled = true,
                refresh = {
                    statusline = 250,
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch", "diff"},
                    lualine_c = {"filename"},
                    lualine_x = {"encoding", "fileformat", "filetype"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                }
            }
        },
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = true,
        event = { "BufRead" },
        opts = {
            char = "▎",
            space_char_blankline = " ",
            show_end_of_line = true,
            show_current_context = true,
            show_current_context_start = true,
            buftype_exclude = {"terminal", "nofile", "help"},
            filetype_exclude = {
                "alpha",
                "man",
                "gitmessengerpopup",
                "diagnosticpopup",
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "json",
                "terminal",
            }
        }
    },
    {
        "ibhagwan/fzf-lua",
        lazy = true,
        opts = {
            files = {
                multiprocess = true,
                git_icons = true,
                file_icons = true,
                color_icons = true,
                rg_opts = "--color=never --files --hidden --follow --ignore -g '!.git' -g '!node_modules'"
            }
        },
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = "LazyGit"
    },
    {
        "folke/todo-comments.nvim",
        lazy = true,
        cmd = "TodoTrouble",
        config = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim"
        }
    },
    {
        "terrortylor/nvim-comment",
        lazy = true,
        event = { "BufRead" },
        config = function()
            require("nvim_comment").setup()
        end
    },
    {
        "tpope/vim-surround",
        lazy = true,
        event = { "BufRead" }
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "BufRead" },
        config = true,
        dependencies = {
            "folke/trouble.nvim"
        }
    },
    {
        "sindrets/diffview.nvim",
        config = true,
        lazy = true,
        cmd = "DiffviewOpen",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons"
        }
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            cmp.setup({
                mapping = {
                    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
                    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<TAB>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    })
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                        menu = {
                            buffer = "[buf]",
                            nvim_lsp = "[LSP]",
                            path = "[path]"
                        }
                    })
                },
                sources = {
                    {name = "nvim_lsp"},
                    {name = "path"},
                    {name = "buffer", keyword_length = 5}
                },
                experimental = {
                    ghost_text = true
                }
            })
        end,
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "onsails/lspkind.nvim"
        }
    },
    {
        "fladson/vim-kitty",
        lazy = true,
        ft = "kitty"
    },
    {
        "folke/which-key.nvim",
        lazy = true,
        cmd = "WhichKey"
    },
    {
        "lambdalisue/suda.vim",
        lazy = true
    },
    {
        "elkowar/yuck.vim",
        lazy = true,
        ft = "yuck"
    },
    {
        "nathom/filetype.nvim",
        lazy = true,
        event = { "BufRead" }
    },
    {
        "ahmedkhalf/project.nvim",
        lazy = true,
        event = { "VeryLazy" },
        config = function()
            require("project_nvim").setup({
                patterns = {".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project_root"}
            })
        end
    },
    {
        "andweeb/presence.nvim",
        lazy = true,
        event = { "BufRead" },
        config = function()
            require("presence"):setup({
                neovim_image_text = "8==========>",
                buttons = {{label = "View Repository", url = "https://naddan.co/r"}}, -- :)
                blacklist = {"/var/tmp", "cshw"},
                reading_text = "Browsing files"
            })
        end
    }
}

local opts = {
}

require("lazy").setup(plugins, opts)
