return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '|',
    },
    scope = {
      enabled = true, -- Enables scope highlighting
      show_start = true, -- Underline the start of the scope
      show_end = false, -- Don't underline the end of the scope
      injected_languages = true, -- Check scopes for injected treesitter languages
      highlight = { 'Function', 'Label' }, -- Highlight groups for scope
      priority = 1024, -- Virtual text priority
    },
    exclude = {
      filetypes = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
      },
    },
  },
}
