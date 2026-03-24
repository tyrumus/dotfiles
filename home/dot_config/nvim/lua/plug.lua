-- generic bootstrap function
function bootstrap_dl(name, path, cmd)
    if not (vim.uv or vim.loop).fs_stat(path) then
        local out = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to download " .. name .. ":\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
end

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
bootstrap_dl("lazy.nvim", lazypath, {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
})

vim.opt.rtp:prepend(lazypath)

-- bootstrap tree-sitter-cli
-- Arch Linux has left this package out of date for almost 4 months, and now it's breaking my config
local tspath = vim.env.HOME .. "/.local/share/n/lib/node_modules/tree-sitter-cli"
bootstrap_dl("tree-sitter-cli", tspath, {
    "npm",
    "install",
    "-g",
    "tree-sitter-cli"
})

-- Don't need lewis6991/impatient.nvim anymore
vim.loader.enable()

-- combine all of the plugin specs
require("lazy").setup({
    spec = {
        {
            import = "plugins"
        }
    },
    rocks = {
        enabled = false,
    },
    checker = {
        enabled = false
    }
})
