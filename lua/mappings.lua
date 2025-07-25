-- Initialize
require "nvchad.mappings"
local keymap = vim.keymap


-----------------------------------------------------------
-- BASIC SETTINGS
-----------------------------------------------------------
-- General keymaps
keymap.set('n', '<leader>r', ':luafile %<CR>', { desc = 'reload neovim config' })
keymap.set('n', "e", ":wa<CR>", { desc = "save all buffer" })
keymap.set("n", "Q", ":wqa<CR>", { desc = "save all buffer and close neovim" })
keymap.set("n", "<C-a>", "gg<S-v>G") -- select all

-- Completion toggles
keymap.set('n', '<leader>cp', ':lua require("cmp").setup.buffer { enabled = false }<CR>',
  { desc = "disable all completion" })
keymap.set('n', '<leader>cs', ':lua require("cmp").setup.buffer { enabled = true }<CR>',
  { desc = "enable all completion" })
keymap.set('v', '<C-c>', '"+y')
keymap.set('n', '<C-v>', '"+p')

-----------------------------------------------------------
-- WINDOW MANAGEMENT
-----------------------------------------------------------
-- Tabs management
keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'create new tab' })
keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'close tab' })
keymap.set('n', '<leader>l', ':tabnext<CR>', { desc = 'move to next tab' })

-- Split management
keymap.set('n', '<leader>hs', ':split<CR>', { noremap = true, silent = true, desc = 'split horizontal' })
keymap.set('n', '<leader>vs', ':vsplit<CR>', { noremap = true, silent = true, desc = 'split vertical' })

-- Window navigation
keymap.set('n', 'fh', '<C-w>h', { desc = 'focus left' })
keymap.set('n', 'fl', '<C-w>l', { desc = 'focus right' })
keymap.set('n', 'fj', '<C-w>j', { desc = 'focus down' })
keymap.set('n', 'fk', '<C-w>k', { desc = 'focus up' })

-- Buffer management
keymap.set('n', '<leader>t', ':ToggleTerm direction=float<CR>', { silent = true })
keymap.set("n", "x", ":bd<CR>", { desc = 'close buffer' })
keymap.set("n", "xx", ":bufdo bd<CR>", { desc = 'close all buffers' })
keymap.set("n", "X", ":close<CR>", { desc = 'close window' })

-----------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------
-- Copilot
keymap.set("i", "<S-Tab>", "copilot#Next()", { expr = true, silent = true, noremap = true })
keymap.set("n", "<leader>m", ":CopilotChat<CR>", { desc = "open copilot chat" })
keymap.set("n", "<leader>ze", ":CopilotChatExplain <CR>", { desc = "open copilot chat explain" })
keymap.set("v", "<leader>zr", ":CopilotChatReview <CR>", { desc = "open copilot chat review" })
keymap.set("v", "<leader>zf", ":CopilotChatFix <CR>", { desc = "open copilot chat fix" })
keymap.set("v", "<leader>zo", ":CopilotChatOptimize", { desc = "open copilot chat optimize" })
keymap.set("v", "<leader>zd", ":CopilotChatDocs <CR>", { desc = "open copilot chat debug" })
keymap.set("n", "<leader>zs", ":CopilotChatCommit <CR>", { desc = "open copilot chat show" })
keymap.set("v", "<leader>zq", ":CopilotChatQuit <CR>", { desc = "open copilot chat quit" })

-- Telescope
keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = 'searching file' })
keymap.set('n', '<leader>g', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = 'search in current buffer' })
keymap.set('n', '<leader>gg', require('telescope.builtin').live_grep, { desc = 'searching word by grep' })

-- Hop
keymap.set("n", "m", ":HopAnywhere<cr>", { desc = "go to any charactere in page", silent = true })
keymap.set("n", "mm", ":HopPattern<cr>",
  { desc = "go directly to another character into the buffer", silent = true })
keymap.set("n", "mmm", ":HopWord<cr>", { desc = "go directly to another word in the buffer", silent = true })

-----------------------------------------------------------
-- CODING
-----------------------------------------------------------
-- Moving lines
keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Formatage amélioré avec Conform
keymap.set({'n', 'v'}, "ff", function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    range = vim.fn.mode() == 'v' and {
      start = vim.fn.getpos("'<"),
      ['end'] = vim.fn.getpos("'>"),
    } or nil,
  })
end, { desc = "Format document/selection" })

-- Formatage LSP en fallback
keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "LSP format" })

-- Toggle format-on-save
keymap.set('n', '<leader>tf', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  if vim.g.disable_autoformat then
    print("Format-on-save disabled")
  else
    print("Format-on-save enabled")
  end
end, { desc = "Toggle format-on-save" })

-- Comments
keymap.set('n', 'gc', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
  { desc = "turn the line into comment" })
keymap.set('v', 'gc', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
  { desc = 'turn the block into comment' })
-- nvim cmp toggle 
keymap.set('n', '<F2>', ':ToggleCmp<CR>',
  { desc = "toggle nvim cmp" })
-----------------------------------------------------------
-- NVIM-TREE
-----------------------------------------------------------
-- Toggle tree
keymap.set('n', 'W', '<cmd>:NvimTreeToggle<CR>', { desc = "open nvim-tree" })

-- Tree configuration function
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Tree Navigation
  keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  keymap.set('n', '<tab>', api.node.open.preview, opts('Open Preview'))
  keymap.set('n', 'fh', '<C-w>h', { desc = 'focus left' })
  keymap.set('n', 'fl', '<C-w>l', { desc = 'focus right' })
  keymap.set('n', 'fj', '<C-w>j', { desc = 'focus down' })
  keymap.set('n', 'fk', '<C-w>k', { desc = 'focus up' })


  -- File operations
  keymap.set('n', 'a', api.fs.create, opts('Create'))
  keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  keymap.set('n', 'd', api.fs.trash, opts('Delete'))

  -- Tree features
  -- keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
  keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
  keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

-----------------------------------------------------------
-- TREE OPTIONS
-----------------------------------------------------------
local options = {
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "right",
    width = 40,
  },
  filters = {
    custom = { ".DS_Store" },
  },
  git = {
    enable = false,
    ignore = false,
  },
  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  diagnostics = {
    enable = false,
    show_on_dirs = true,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "none",
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        modified = true,
      },
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

-- Setup NvimTree
vim.g.nvimtree_side = options.view.side
require('nvim-tree').setup(options)
