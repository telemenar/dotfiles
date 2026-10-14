local palette = vim.tbl_extend("force", { variant = "dark" }, require("colors.base24-pop-bright"))

require("tinted-nvim").setup({
    default_scheme = "base24-pop-bright",
    schemes = {
        ["base24-pop-bright"] = palette,
    },
})
