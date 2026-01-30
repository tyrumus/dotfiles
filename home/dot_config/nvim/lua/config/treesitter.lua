local function ts_build()
    require("nvim-treesitter.install").update({ with_sync = true })
end

local function ts_setup()
    require("nvim-treesitter").setup({
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
            "markdown_inline",
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
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        },
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        },
        sync_install = false,
        auto_install = false,
        modules = {},
        ignore_install = {},
    })
end

return {
    build = ts_build,
    config = ts_setup
}
