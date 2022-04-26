-- Auto source when there are changes in plugins.lua
vim.cmd([[autocmd BufWritePost plugins.lua luafile %]])

local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    -- packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    packer_bootstrap = fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute("packadd packer.nvim")
end

require("packer").startup(function(use)
    use({"wbthomason/packer.nvim"})
    use({"hoob3rt/lualine.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true}})
    use({"eddyekofo94/gruvbox-flat.nvim"})
    use({"lukas-reineke/indent-blankline.nvim"})
    use({"kdheepak/lazygit.nvim"})
    use({"folke/todo-comments.nvim", requires = {{"nvim-lua/plenary.nvim"}, {"folke/trouble.nvim"}}})
    use({"goolord/alpha-nvim"})
    use({"terrortylor/nvim-comment"})
    use({"tpope/vim-surround"})
    use({"folke/which-key.nvim"})
    use({"lambdalisue/suda.vim"})
    use({"ibhagwan/fzf-lua", requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"}})
    use({"ahmedkhalf/project.nvim"})
    use({"andweeb/presence.nvim"})

    if packer_bootstrap then
        require('packer').sync()
    end
end)
require("plugin_config")
