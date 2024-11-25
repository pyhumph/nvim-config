return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason for managing LSP servers, linters, and formatters
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- UI improvements for LSP status
    { 'j-hui/fidget.nvim', opts = {} },

    -- CMP integration for LSP capabilities
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Attach function for configuring keymaps and autocommands when LSP starts
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- LSP-related keybindings
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Toggle inlay hints
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint(event.buf, not vim.lsp.inlay_hint.is_enabled(event.buf))
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Additional capabilities for nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- LSP servers configuration
    local servers = {
      ["typescript-language-server"] = {}, -- Correct TypeScript LSP
      ruff = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      cssls = {},
      tailwindcss = {},
      dockerls = {},
      sqlls = {},
      terraformls = {},
      jsonls = {},
      yamlls = {},
      
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT', -- Use LuaJIT for Neovim
                path = vim.split(package.path, ';'), -- Correct Lua runtime path
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- Avoid warnings about third-party libraries
              },
              diagnostics = {
                globals = { 'vim' }, -- Recognize Neovim globals
                disable = { 'missing-fields' }, -- Disable specific warnings
              },
            },
          },
        },
    }

    -- Mason setup for automatic tool installation
    require('mason').setup()
    require('mason-tool-installer').setup {
      ensure_installed = {
        "typescript-language-server",
        "html",
        "cssls",
        "tailwindcss",
        "dockerls",
        "sqlls",
        "terraformls",
        "jsonls",
        "yamlls",
        "lua_ls",
        "ruff",
        "pylsp",
      },
    }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local opts = servers[server_name] or {}
          opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
          require('lspconfig')[server_name].setup(opts)
        end,
      },
    }
  end,
}

