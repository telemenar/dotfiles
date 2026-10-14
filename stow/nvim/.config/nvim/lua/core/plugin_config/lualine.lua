require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tinted',
  },
  sections = {
    lualine_a = { 'mode',
      {
        'filename',
        path = 1,
        shortening_target = 80,
      }
    }
  }
}
