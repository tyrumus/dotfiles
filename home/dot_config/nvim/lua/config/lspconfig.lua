-- LSPs using generic default config
local default_lsps = {
    "bashls",
    "clangd",
    "lua_ls",
    "ruff",
    "rust_analyzer",
    "svelte",
    "tailwindcss",
    "yamlls",
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

local function lsp_setup()
    -- global settings
    vim.lsp.config("*", {
        on_attach = navic_do_attach,
    })

    -- LSP-specific settings
    vim.lsp.config("lua_ls", {
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

    vim.lsp.config("rust_analyzer", {
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
    config = lsp_setup,
    default_servers = default_lsps
}
