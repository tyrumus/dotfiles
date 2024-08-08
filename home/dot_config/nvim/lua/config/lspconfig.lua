-- LSPs using generic default config
local default_lsps = {
    "pyright",
    "svelte",
    "tailwindcss",
    "yamlls",
    "bashls",
    "clangd"
}

local function navic_do_attach(client, bufnr)
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end

    vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<space>d", vim.lsp.buf.definition)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.declaration)
    vim.keymap.set("n", "<space>i", vim.lsp.buf.implementation)
end

local function default_setup(lsp_name)
    require("lspconfig")[lsp_name].setup({
        on_attach = navic_do_attach,
    })
end

local function lsp_setup()
    for _,v in pairs(default_lsps) do
        default_setup(v)
    end

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
end

return {
    config = lsp_setup
}
