-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local a_status, t_actions = pcall(require, 'telescope.actions')
if (not a_status) then
  print("No actions added")
else
  require('telescope').setup {
    defaults = {
      file_ignore_patterns = {
        "^.git/*",
        "node_modules/*",
      },
      mappings = {
        i = {
          -- ['<C-u>'] = true,
          -- ['<C-d>'] = false,
        },
      },
    },
  }
end
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = false
    }
  }
})
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  -- open_on_setup = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-f>',
      node_incremental = '<c-f>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-f>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

local status_autopairs, autopairs = pcall(require, 'nvim-autopairs')
if (not status_autopairs) then
  print('No autopairs added')
else
  autopairs.setup()
end

local status_hop, hop = pcall(require, 'hop')
if (not status_hop) then
  print("Hop not added")
else
  hop.setup()
end

local status_comment, comment = pcall(require, 'Comment')
if (not status_comment) then
  comment.setup()
end


require("colorizer").setup {
  filetypes = { "*" },
  user_default_options = {
    RGB = true,          -- #RGB hex codes
    RRGGBB = true,       -- #RRGGBB hex codes
    names = true,        -- "Name" codes like Blue or blue
    RRGGBBAA = true,     -- #RRGGBBAA hex codes
    AARRGGBB = true,     -- 0xAARRGGBB hex codes
    rgb_fn = true,       -- CSS rgb() and rgba() functions
    hsl_fn = true,       -- CSS hsl() and hsla() functions
    css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = false, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
  },
  buftypes = {},
}

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.lua_snippets_path })
require("luasnip").filetype_extend("typescript", { "javascript" })

-- Auto-import simple et fonctionnel pour useState
vim.api.nvim_create_autocmd("User", {
  pattern = "LuasnipInsertNodeEnter",
  callback = function()
    -- Vérifier si on vient d'utiliser le snippet useState
    vim.defer_fn(function()
      local current_line = vim.api.nvim_get_current_line()
      if current_line:find("useState") then
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, 20, false)
        local has_import = false
        
        -- Vérifier si l'import existe déjà
        for _, line in ipairs(lines) do
          if line:find("import.*useState") or line:find("import.*React.*useState") then
            has_import = true
            break
          end
        end
        
        -- Ajouter l'import si il n'existe pas
        if not has_import then
          -- Trouver où insérer l'import (après les autres imports)
          local insert_line = 0
          for i, line in ipairs(lines) do
            if line:find("^import") then
              insert_line = i
            elseif line:match("^%s*$") == nil and not line:find("^import") then -- Remplace trim() par match
              break
            end
          end
          
          vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, {
            "import React, { useState } from 'react';"
          })
        end
      end
    end, 100) -- Délai pour laisser le snippet s'insérer
  end,
})

-- Variable globale pour suivre l'état de cmp
vim.g.cmp_toggle_status = true

-- Fonction pour activer/désactiver cmp
function _G.toggle_cmp()
  if vim.g.cmp_toggle_status then
    -- Désactiver cmp
    require('cmp').setup.buffer({ enabled = false })
    vim.g.cmp_toggle_status = false
    print("CMP désactivé")
  else
    -- Réactiver cmp
    require('cmp').setup.buffer({ enabled = true })
    vim.g.cmp_toggle_status = true
    print("CMP activé")
  end
end

-- Créer une commande utilisateur pour faciliter l'appel
vim.api.nvim_create_user_command('ToggleCmp', function()
  _G.toggle_cmp()
end, {})

-- Définir un raccourci clavier (par exemple <leader>tc pour Toggle Completion)
-- Remplacez <leader> par votre touche leader (généralement espace ou \)
vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd>lua _G.toggle_cmp()<CR>', { noremap = true, silent = true })

-- Debug : afficher les snippets chargés
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ls = require("luasnip")
    print("Snippets chargés:", vim.tbl_count(ls.get_snippets()))
  end,
})