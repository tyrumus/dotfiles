-- Auto source when there are changes in plugins.lua
-- vim.cmd([[autocmd BufWritePost plugins.lua luafile %]])

local plugins = {}
local packer = nil

local function init()
    packer = require("packer")
    packer.init({
        git = { clone_timeout = 120 }
    })
    packer.reset()
    local use = packer.use
    use({"wbthomason/packer.nvim"})
    use({"hoob3rt/lualine.nvim",
        config = require("cfg.lualine"),
        requires = {"kyazdani42/nvim-web-devicons", opt = true}
    })
    use({"eddyekofo94/gruvbox-flat.nvim",
        disable = false,
        config = function()
            vim.cmd([[colorscheme gruvbox-flat]])
        end
    })

    --require("packer").startup(function(use)
        --use({"lukas-reineke/indent-blankline.nvim"})
        --use({"kdheepak/lazygit.nvim"})
        --use({"folke/todo-comments.nvim", requires = {{"nvim-lua/plenary.nvim"}, {"folke/trouble.nvim"}}})
        --use({"goolord/alpha-nvim"})
        --use({"terrortylor/nvim-comment"})
        --use({"tpope/vim-surround"})
        --use({"folke/which-key.nvim"})
        --use({"lambdalisue/suda.vim"})
        --use({"ibhagwan/fzf-lua", requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"}})
        --use({"ahmedkhalf/project.nvim"})
        --use({"andweeb/presence.nvim"})
        --require("packer").sync()
    --end)
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then
            init()
        end
        return packer[key]
    end,
})

function plugins.bootstrap()
    local execute = vim.api.nvim_command
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.api.nvim_command("packadd packer.nvim")

        vim.cmd("autocmd User PackerComplete ++once lua require('load_config').init()")

        init()

        require("packer").sync()
    else
        vim.api.nvim_command("packadd packer.nvim")
        init()
        require("load_config").init()
    end
end

return plugins

-- require("packer").startup(function(use)
--     use({"wbthomason/packer.nvim"})
--     use({"hoob3rt/lualine.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true}})
--     use({"eddyekofo94/gruvbox-flat.nvim"})
--     use({"lukas-reineke/indent-blankline.nvim"})
--     use({"kdheepak/lazygit.nvim"})
--     use({"folke/todo-comments.nvim", requires = {{"nvim-lua/plenary.nvim"}, {"folke/trouble.nvim"}}})
--     use({"goolord/alpha-nvim"})
--     use({"terrortylor/nvim-comment"})
--     use({"tpope/vim-surround"})
--     use({"folke/which-key.nvim"})
--     use({"lambdalisue/suda.vim"})
--     use({"ibhagwan/fzf-lua", requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"}})
--     use({"ahmedkhalf/project.nvim"})
--     use({"andweeb/presence.nvim"})
--
--     if packer_bootstrap then
--         require('packer').sync()
--     end
-- end)
-- require("plugin_config")
