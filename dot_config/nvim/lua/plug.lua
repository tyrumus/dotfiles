pcall(vim.cmd, "packadd packer.nvim")

local present, packer = pcall(require, "packer")
local firstRun = false

if not present then
    -- Packer is not installed
    local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    vim.fn.delete(packer_path, "rf")
    vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path})
    vim.cmd("packadd packer.nvim")
    present, packer = pcall(require, "packer")
    if not present then
        error("Couldn't install packer")
        return false
    end
    firstRun = true
end

packer.init({
    git = {
        clone_timeout = 120
    }
})

-- auto source this file on write
vim.cmd([[autocmd BufWritePost plug.lua luafile %]])

local plugs = {
    {
        "wbthomason/packer.nvim"
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("dashboard").opts)
        end
    },
    {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({
                default = true
            })
        end
    },
    {
        "hoob3rt/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = {left = "", right = ""},
                    component_separators = {"", ""},
                    icons_enabled = true
                }
            })
        end,
        requires = {"kyazdani42/nvim-web-devicons", opt = true}
    },
    {
        "eddyekofo94/gruvbox-flat.nvim",
        config = function()
            vim.cmd("colorscheme gruvbox-flat")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                space_char_blankline = " ",
                show_end_of_line = true,
                buftype_exclude = {"terminal", "nofile", "help"},
                filetype_exclude = {"alpha"}
            })
        end
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").setup({
                files = {
                    multiprocess = true,
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                    rg_opts = "--color=never --files --hidden --follow --ignore -g '!.git' -g '!node_modules'"
                }
            })
        end,
        requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"}
    },
    {
        "kdheepak/lazygit.nvim"
    },
    {
        "folke/todo-comments.nvim",
        config = function()
            require("todo-comments").setup()
        end,
        requires = {{"nvim-lua/plenary.nvim"}, {"folke/trouble.nvim"}}
    },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup()
        end
    },
    {
        "tpope/vim-surround"
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup()
        end
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
                    }),
                    ["<CR>"]  = cmp.mapping.confirm({
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
        requires = {{"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"onsails/lspkind.nvim"}}
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
        end,
        after = "nvim-lspconfig"
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"bash", "toml", "yaml", "html", "css", "javascript", "json", "c", "cpp", "lua", "rust", "python", "svelte"},
                highlight = {
                    enable = true
                }
            })
        end,
        after = "nvim-lsp-installer"
    },
    {
        "fladson/vim-kitty"
    },
    {
        "folke/which-key.nvim"
    },
    {
        "lambdalisue/suda.vim"
    },
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                patterns = {".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".project_root"}
            })
        end
    },
    {
        "andweeb/presence.nvim",
        config = function()
            require("presence"):setup({
                neovim_image_text = "8==========>"
            })
        end
    }
}

return packer.startup(function(use)
    for _, v in pairs(plugs) do
        use(v)
    end
    if firstRun then
        packer.sync()
    end
end)
