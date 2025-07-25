-- LSP Configuration pour Neovim
-- Fichier: lspconfig.lua
-- Description: Configuration des serveurs de langage pour un développement efficace avec autocomplétion

----------------------------------
-- Initialisation et Dépendances
----------------------------------

-- Charger les configurations par défaut de NvChad
require("nvchad.configs.lspconfig").defaults()

-- Importer les bibliothèques nécessaires
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

----------------------------------
-- Configuration des Serveurs LSP
----------------------------------

-- Liste des serveurs de base à configurer avec les paramètres par défaut
local base_servers = { "html", "cssls", "emmet_ls", "lua_ls" }

-- Configuration spécifique pour TypeScript/JavaScript
lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  -- Configuration avancée pour une meilleure indexation des projets
  init_options = {
    -- Augmenter la mémoire disponible pour l'indexation des grands projets
    maxTsServerMemory = 4096,
    -- Améliorer les suggestions d'auto-complétion
    preferences = {
      -- Inclure automatiquement les exportations des modules
      includeCompletionsForModuleExports = true,
      -- Inclure les informations d'importation
      includeCompletionsWithInsertText = true,
      -- Format d'import par défaut
      importModuleSpecifierPreference = "relative",
    },
    -- Activer les suggestions des bibliothèques non importées
    suggestFromUnimportedLibraries = true,
    -- Configuration implicite pour les projets sans fichier de configuration
    implicitProjectConfiguration = {
      -- Traiter tous les fichiers JS comme un projet même sans jsconfig.json
      checkJs = true,
      target = "ES2020",
      module = "ESNext",
      allowSyntheticDefaultImports = true,
      moduleResolution = "node",
      jsx = "react-jsx"
    }
  },
  -- Types de fichiers à analyser
  filetypes = { 
    "javascript", "javascriptreact", "javascript.jsx", 
    "typescript", "typescriptreact", "typescript.tsx" 
  },
  -- Configuration des inlay hints (indices visuels)
  settings = {
    -- Configuration pour TypeScript
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    -- Configuration pour JavaScript
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

-- Configuration pour CSS
require('lspconfig').cssls.setup({
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { "vscode-css-languageserver" },
  filetypes = { "css", "scss", "less", "postcss" },
})

-- Configuration pour Tailwind CSS
require('lspconfig').tailwindcss.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
}

-- Configuration pour Emmet (expansion HTML/CSS)
lspconfig.emmet_ls.setup({
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', "vue" }
})

-- Configuration pour ESLint
require('lspconfig').eslint.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
}

-- Configuration pour Lua
require('lspconfig').lua_ls.setup {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
}

-- Application des configurations par défaut aux serveurs de base
for _, lsp in ipairs(base_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

----------------------------------
-- Configuration nvim-cmp
----------------------------------

-- Configuration de l'auto-complétion
local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Configuration de base de LuaSnip
luasnip.config.setup {}

-- Configuration de nvim-cmp
cmp.setup {
  -- Configuration des snippets
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  -- Configuration des mappings clavier
  mapping = {
    -- Tab intelligent : LuaSnip en priorité, puis Copilot
    ['<Tab>'] = cmp.mapping(function(fallback)
      -- 1. Si LuaSnip est actif et peut sauter, on l'utilise
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      -- 2. Sinon, si cmp est visible, sélectionner le prochain item
      elseif cmp.visible() then
        cmp.select_next_item()
      -- 3. Enfin, essayer Copilot
      else
        local copilot_keys = vim.fn['copilot#Accept']("")
        if copilot_keys ~= "" then
          vim.api.nvim_feedkeys(copilot_keys, "i", true)
        else
          fallback()
        end
      end
    end, { 'i', 's' }),

    -- Shift+Tab pour aller en arrière dans les snippets
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      -- 1. Si LuaSnip peut sauter en arrière
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      -- 2. Sinon, si cmp est visible, sélectionner l'item précédent
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- Navigation dans les suggestions avec les flèches
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    
    -- Navigation dans la documentation
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    
    -- Ouvrir/fermer la complétion
    ['<C-b>'] = cmp.mapping.complete {},
    
    -- Confirmer la sélection
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  
  -- Sources d'auto-complétion par ordre de priorité
  sources = {
    { name = "luasnip", priority = 1000 },
    {
      name = "nvim_lsp",
      entry_filter = function(entry, ctx)
        return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
      end,
    },
    { name = "path" },
  },
}

