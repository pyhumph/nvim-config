-- ~/.config/nvim/lua/plugins/nvim-cmp.lua
return {
  'hrsh7th/nvim-cmp', -- Completion engine
  dependencies = {
    'hrsh7th/cmp-buffer', -- Buffer completions
    'hrsh7th/cmp-path', -- Path completions
    'hrsh7th/cmp-nvim-lsp', -- LSP completions
    'hrsh7th/cmp-vsnip', -- Snippet completions
    'hrsh7th/vim-vsnip', -- Snippet engine
  },
  config = function()
    local cmp = require('cmp')  -- Requiring cmp

    -- Setup nvim-cmp
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- Use vsnip to expand snippets
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
        ['<C-e>'] = cmp.mapping.abort(), -- Abort completion
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- Use LSP for completion
        { name = 'vsnip' }, -- Use vsnip for snippets
      }, {
        { name = 'buffer' }, -- Use buffer content for completion
        { name = 'path' }, -- Use path completion
      }),
    })
  end,
}
