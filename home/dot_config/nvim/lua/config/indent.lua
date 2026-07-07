local opts = {
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

local function config()
    local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan"
    }

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- indent blankline upstream
        -- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        -- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        -- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

        -- rainbow delimiters defaults
        -- vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#cc241d" })
        -- vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#d79921" })
        -- vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#458588" })
        -- vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#d65d0e" })
        -- vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#689d6a" })
        -- vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#b16286" })
        -- vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#a89984" })

        -- gruvbox
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ea6962" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#d8a657" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#7daea3" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#e78a4e" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#a9b665" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d3869b" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#89b482" })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    opts.scope = { highlight = highlight }

    require("ibl").setup(opts)

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return {
    config = config,
}
