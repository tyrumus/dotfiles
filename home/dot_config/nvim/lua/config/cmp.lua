local function snippet_config(args)
    require("luasnip").lsp_expand(args.body)
end

local function config()
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    cmp.setup({
        mapping = {
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<TAB>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            })
        },
        snippet = {
            expand = snippet_config
        },
        formatting = {
            format = lspkind.cmp_format({
                with_text = true,
                menu = {
                    buffer = "[buf]",
                    nvim_lsp = "[LSP]",
                    path = "[path]"
                }
            })
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "buffer",  keyword_length = 5 }
        },
        experimental = {
            ghost_text = true
        }
    })
end

return {
    config = config
}
