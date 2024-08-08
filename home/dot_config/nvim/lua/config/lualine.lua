return {
    opts = {
        options = {
            theme = "gruvbox-flat",
            section_separators = { left = "", right = "" },
            component_separators = { "", "" },
            icons_enabled = true,
            refresh = {
                statusline = 250,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            }
        }
    }
}
