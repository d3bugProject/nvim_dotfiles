local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Fonction pour gérer les imports automatiques
local function auto_import(import_line)
  return function()
    if not import_line then return "" end
    
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    
    -- Vérifier si l'import existe déjà
    for _, line in ipairs(lines) do
      if line:find(import_line, 1, true) then
        return "" -- Import déjà présent
      end
    end
    
    -- Ajouter l'import en haut du fichier
    vim.schedule(function()
      local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local insert_pos = 0
      
      -- Trouver la position après les imports existants
      for i, line in ipairs(current_lines) do
        if line:match("^import") then
          insert_pos = i
        elseif line:trim() == "" and insert_pos > 0 then
          insert_pos = i
          break
        elseif not line:match("^%s*$") and not line:match("^import") and insert_pos > 0 then
          break
        end
      end
      
      vim.api.nvim_buf_set_lines(buf, insert_pos, insert_pos, false, {import_line})
    end)
    
    return ""
  end
end

-- Fonction pour charger les snippets avec support import
local function load_vscode_snippets_with_import(path)
  local snippets_file = io.open(path, "r")
  if not snippets_file then return end
  
  local content = snippets_file:read("*all")
  snippets_file:close()
  
  local ok, snippets_data = pcall(vim.json.decode, content)
  if not ok then return end
  
  for name, snippet_data in pairs(snippets_data) do
    if type(snippet_data) == "table" and snippet_data.prefix and snippet_data.body then
      local nodes = {}
      
      -- Si il y a un import, l'ajouter en premier
      if snippet_data.import then
        table.insert(nodes, f(auto_import(snippet_data.import), {}))
      end
      
      -- Ajouter le corps du snippet
      for _, line in ipairs(snippet_data.body) do
        -- Convertir la syntaxe VSCode vers LuaSnip
        local converted_line = line
        -- Conversion basique des placeholders
        converted_line = converted_line:gsub("%${(%d+):([^}]*)}", function(num, default)
          return "${" .. num .. ":" .. default .. "}"
        end)
        converted_line = converted_line:gsub("%$(%d+)", "${%1}")
        
        table.insert(nodes, t({converted_line}))
        if line ~= snippet_data.body[#snippet_data.body] then
          table.insert(nodes, t({"", ""}))
        end
      end
      
      -- Créer le snippet
      ls.add_snippets("all", {
        s(snippet_data.prefix, nodes)
      })
      
      -- Ajouter aussi pour les filetypes spécifiques
      if snippet_data.prefix:find("use") or snippet_data.prefix:find("react") then
        ls.add_snippets("javascriptreact", {
          s(snippet_data.prefix, nodes)
        })
        ls.add_snippets("typescriptreact", {
          s(snippet_data.prefix, nodes)
        })
      end
    end
  end
end

-- Charger tes snippets personnalisés
load_vscode_snippets_with_import(vim.fn.stdpath("config") .. "/lua/snippets/perso.json")

return {}