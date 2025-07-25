local options = {
  formatters_by_ft = {
    -- Web technologies
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    markdown = { "prettier" },
    
    -- Lua
    lua = { "stylua" },
    
    -- Python
    python = { "black" },
    
    -- Shell
    bash = { "shfmt" },
    zsh = { "shfmt" },
  },

  -- Formatage automatique à la sauvegarde
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true, -- Utiliser LSP si le formatter n'est pas disponible
  },
  
  -- Formatage manuel plus rapide
  format_after_save = {
    lsp_fallback = true,
  },
}

return options