local function config()
    require("telescope").setup({
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    })
    require("telescope").load_extension("ui-select")
end

return {
    config = config
}
