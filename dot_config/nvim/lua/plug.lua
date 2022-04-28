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

-- some automated shiz
vim.cmd([[autocmd BufWritePost plug.lua luafile %]])

local plugs = {
    {
        "wbthomason/packer.nvim"
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").opts)
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
                buftype_exclude = {"terminal"},
                filetype_exclude = {"dashboard"}
            })
        end
    },
    {
        "ibhagwan/fzf-lua",
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
        -- vim.cmd("autocmd User PackerComplete ++once PackerSync")
    end
end)
