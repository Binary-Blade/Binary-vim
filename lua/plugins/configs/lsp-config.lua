return {

  -- LSP Configuration & Plugins
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, :help lsp-vs-treesitter
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local key_map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        key_map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        key_map('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        key_map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        key_map('<leader>gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        key_map('<leader>gT', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype [D]efinition')
        key_map('<leader>fd', require('telescope.builtin').lsp_document_symbols, '[F]ind [D]ocument Symbols')
        key_map('<leader>fw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[F]ind [W]orkspace Symbols')
        key_map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
        key_map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        key_map('K', vim.lsp.buf.hover, 'Hover Documentation')

        --    See `:help CursorHold` for information about when this is executed
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Enable the following language servers
    --  NOTE: Here to add lsp server
    --  Some languages (like typescript) have entire language plugins that can be useful: https://github.com/pmizio/typescript-tools.nvim
    local servers = {
      tsserver = {},
      volar = {},
      angularls = {},
      pyright = {},
      lua_ls = {
        -- cmd = {...},
        -- capabilities = {},
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require('mason').setup()
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          require('lspconfig')[server_name].setup {
            cmd = server.cmd,
            settings = server.settings,
            filetypes = server.filetypes,
            capabilities = capabilities,
          }
        end,
      },
    }
  end,
}
