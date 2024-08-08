-- lazy.nvim stuff
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- TODO: figure out a smarter place to put this
function navic_do_attach(client, bufnr)
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end

    vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<space>d", vim.lsp.buf.definition)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.declaration)
    vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation)
end

-- Don't need lewis6991/impatient.nvim anymore
vim.loader.enable()

local plugins = {
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
        "lsig/messenger.nvim",
        lazy = true,
        opts = {
            border = "rounded"
        },
        event = { "BufRead" }
    },
    {
        "lewis6991/spaceless.nvim",
        lazy = true,
        config = true,
        event = { "BufRead" }
    },
    {
        "dstein64/nvim-scrollview",
        lazy = true,
        config = true,
        event = { "BufRead" }
    },
    {
        "lewis6991/hover.nvim",
        lazy = true,
        opts = {
            init = function()
                require("hover.providers.lsp")
                require("hover.providers.diagnostic")
                require("hover.providers.man")
                require("hover.providers.jira")
                require("hover.providers.dictionary")
            end,
            preview_opts = {
                border = "single"
            },
            preview_window = false,
            title = true
        },
        event = { "BufRead" }
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
                on_attach = navic_do_attach,
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
            require("lspconfig").pyright.setup({
                on_attach = navic_do_attach,
            })
            require("lspconfig").svelte.setup({
                on_attach = navic_do_attach,
            })
            require("lspconfig").tailwindcss.setup({
                on_attach = navic_do_attach,
            })
            require("lspconfig").yamlls.setup({
                on_attach = navic_do_attach,
            })
            require("lspconfig").rust_analyzer.setup({
                on_attach = navic_do_attach,
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
            require("lspconfig").bashls.setup({
                on_attach = navic_do_attach,
            })
            require("lspconfig").clangd.setup({
                on_attach = navic_do_attach,
            })
        end,
        lazy = true,
        event = { "BufRead" },
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            "SmiteshP/nvim-navic"
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
                ensure_installed = {
                    "asm",
                    "bash",
                    "bitbake",
                    "c",
                    "cpp",
                    "css",
                    "dockerfile",
                    "html",
                    "java",
                    "javascript",
                    "json",
                    "kconfig",
                    "lua",
                    "make",
                    "markdown",
                    "meson",
                    "ninja",
                    "nix",
                    "python",
                    "rust",
                    "scss",
                    "sql",
                    "svelte",
                    "tcl",
                    "toml",
                    "typescript",
                    "verilog",
                    "vhdl",
                    "xml",
                    "yaml",
                },
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                },
                autotag = {
                    enable = true
                },
                sync_install = false,
                auto_install = false,
                modules = {},
                ignore_install = {},
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
        main = "ibl",
        opts = {
            viewport_buffer = {
                min = 30,
                max = 300
            },
            indent = {
                char = "▎"
            },
            exclude = {
                filetypes = {
                    "lspinfo",
                    "lazy",
                    "checkhealth",
                    "help",
                    "man",
                    "gitcommit",
                    "''",
                    "alpha",
                    "gitmessengerpopup",
                    "diagnosticpopup",
                    "json",
                    "terminal",
                }
            },
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
        "folke/trouble.nvim",
        config = true,
        cmd = "Trouble"
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-lua/plenary.nvim"
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
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = true,
        lazy = true,
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
        "earthly/earthly.vim",
        lazy = true,
        ft = "Earthfile"
    },
    {
        "rcarriga/nvim-notify",
        lazy = true,
        event = { "BufRead" },
        config = function()
            vim.notify = require("notify")
        end
    },
    {
        "utilyre/barbecue.nvim",
        lazy = true,
        opts = {
            attach_navic = false
        },
        event = { "LspAttach" },
        dependencies = {
            "SmiteshP/nvim-navic"
        },
    },
    {
        "NvChad/nvim-colorizer.lua",
        lazy = true,
        event = { "BufRead" },
        config = true
    },
    {
        "ray-x/lsp_signature.nvim",
        lazy = true,
        event = { "VeryLazy" },
        config = true
    },
    {
        "voldikss/vim-floaterm",
        lazy = true,
        cmd = {
            "FloatermNew",
            "FloatermToggle",
            "FloatermNext"
        },
    },
    {
        "nathom/filetype.nvim",
        lazy = true,
        event = { "BufRead" },
        opts = {
            overrides = {
                extensions = {
                    yuck = "yuck"
                },
                literal = {
                    Earthfile = "Earthfile"
                }
            }
        }
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
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
