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
        priority = 900,
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
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").lua_ls.setup({
                update_in_insert = true,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT"
                        },
                        diagnostics = {
                            globals = { "vim" },
                            unusedLocalExclude = { "_*" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            })
            require("lspconfig").pyright.setup({})
            require("lspconfig").svelte.setup({})
            require("lspconfig").tailwindcss.setup({})
            require("lspconfig").rust_analyzer.setup({
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
        lazy = true,
        event = { "BufRead" },
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim"
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        config = true,
        dependencies = {
            "mason.nvim"
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "bash", "toml", "yaml", "html", "scss", "css", "javascript", "typescript", "json", "c", "cpp", "lua",
                    "rust", "python", "svelte" },
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                },
                autotag = {
                    enable = true
                }
            })
        end,
        event = { "BufRead" }
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        event = { "BufRead" }
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
                section_separators = { left = "", right = "" },
                component_separators = { "", "" },
                icons_enabled = true,
                refresh = {
                    statusline = 250,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" }
                }
            }
        },
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        priority = 1000,
        opts = {
            viewport_buffer = 300,
            char = "▎",
            context_char = "▎",
            space_char_blankline = " ",
            show_end_of_line = true,
            show_current_context = true,
            show_current_context_start = true,
            buftype_exclude = { "terminal", "nofile", "help" },
            context_patterns = {
                "arrow_function",
                "class",
                "^func",
                "method",
                "^if",
                "while",
                "for",
                "with",
                "try",
                "except",
                "match",
                "arguments",
                "argument_list",
                "object",
                "dictionary",
                "element",
                "table",
                "tuple",
                "do_block",
            },
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
                snippet = {
                    expand = function(args) require("luasnip").lsp_expand(args.body) end,
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
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer",  keyword_length = 5 }
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
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim"
        }
    },
    {
        "L3MON4D3/LuaSnip",
        config = true,
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
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project_root" }
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
                buttons = { { label = "View Repository", url = "https://naddan.co/r" } }, -- :)
                blacklist = { "/var/tmp", "cshw" },
                reading_text = "Browsing files"
            })
        end
    }
}

local opts = {
}

require("lazy").setup(plugins, opts)
