require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'base16',
  },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
      }
    }
  }
}
