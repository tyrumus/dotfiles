-- LSPs using generic default config
local default_lsps = {
    "bashls",
    "clangd",
    "emmylua_ls",
    "pyrefly",
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

    vim.lsp.inlay_hint.enable(true)

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

    vim.lsp.config("emmylua_ls", {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
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
