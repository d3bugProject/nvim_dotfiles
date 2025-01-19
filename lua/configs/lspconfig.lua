-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
require 'lspconfig'.tailwindcss.setup {}
require 'lspconfig'.lua_ls.setup {}
require('lspconfig').cssls.setup({
  cmd = { "vscode-css-languageserver" },            -- Adjust if the executable has a different name
  filetypes = { "css", "scss", "less", "postcss" }, -- Adjust filetypes as needed
  -- ... other options ...
})
lspconfig.emmet_ls.setup({
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', "vue" }
})
require 'lspconfig'.eslint.setup {}
-- EXAMPLE
local servers = { "html", "cssls", "ts_ls", "emmet_ls", "lua_ls" }
local nvlsp = require "nvchad.configs.lspconfig"
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['~'] = cmp.mapping.close {},
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  -- sources = { { name = "path" }, { name = "nvim_lsp" }, { name = "luasnip" } }
  sources = { { name = "luasnip" }, {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
    end,
  }, { name = "path" } }

}
