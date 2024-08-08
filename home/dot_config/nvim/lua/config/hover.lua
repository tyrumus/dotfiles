local function providers()
    require("hover.providers.lsp")
    require("hover.providers.diagnostic")
    require("hover.providers.man")
    require("hover.providers.jira")
    require("hover.providers.dictionary")
end

return {
    opts = {
        init = providers,
        preview_opts = {
            border = "single"
        },
        preview_window = false,
        title = true
    },
    keys = {
        { "K",  "<cmd>lua require('hover').hover()<CR>" },
        { "KK", "<cmd>lua require('hover').hover_select()<CR>" },
        { "gK", "<cmd>lua require('hover').hover_switch('next')<CR>" },
        { "GK", "<cmd>lua require('hover').hover_switch('previous')<CR>" }
    }
}
