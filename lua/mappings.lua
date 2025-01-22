require "nvchad.mappings"
local keymap = vim.keymap
---------------- tabs
--panes controle
keymap.set("n", "x", ":bd<CR>", { desc = 'close buffer' })
keymap.set("n", "xx", ":bufdo bd<CR>", { desc = 'close all buffers' })
keymap.set("n", "X", ":close<CR>", { desc = 'close all buffers' })

--save
-- keymap.set('n', "e", ":w<CR>", { desc = "save current buffer" })
keymap.set('n', "e", ":wa<CR>", { desc = "save all buffer" })
keymap.set("n", "Q", ":wqa<CR>", { desc = "save all buffer and close neovim" })
--searching files and word using grep
keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = 'searching file' })
keymap.set('n', '<leader>g', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'search in current buffer' })
keymap.set('n', '<leader>gg', require('telescope.builtin').live_grep, { desc = 'searching word by grep' })
-- keymap.set('n', 'sr', require('telescope.builtin').oldfiles, { desc = 'find recently opened files' })
-- keymap.set('n', 'sb', require('telescope.builtin').buffers, { desc = 'find opened buffer' })
--------------- telescope
keymap.set('n', 't', '<cmd>:NvimTreeOpen<CR>', { desc = "open nvim-tree" })
keymap.set('n', 'E', '<cmd>:NvimTreeClose<CR>', { desc = "close nvim-tree" })
---------------- coding
--desable autocompletion
keymap.set('n', '<leader>cp', ':lua require("cmp").setup.buffer { enabled = false }<CR>', {
  desc =
  "desable all completion"
})
keymap.set('n', '<leader>cs', ':lua require("cmp").setup.buffer { enabled = true }<CR>',
  { desc = "enable all completion" })
--formating
keymap.set('n', "f", "<cmd>lua vim.lsp.buf.format{async=true}<CR>", { desc = "format document" })
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set('n', '<leader>k', ':m .-2<CR>', { noremap = true })
keymap.set('n', '<leader>j', ':m .+1<CR>', { noremap = true })
--turn comment
keymap.set('n', 'gc', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
  { desc = "turn the line into comment" })
keymap.set('v', 'gc', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
  { desc = 'turn the block into comment' })
---------------- hop
vim.api.nvim_set_keymap("n", "m", ":HopAnywhere<cr>",
  { desc = "go directly to another character into the buffer", silent = true })
vim.api.nvim_set_keymap("n", "mm", ":HopWord<cr>", { desc = "go directly to another word in the buffer", silent = true })
---------------- nvim-tree
-- See `:help telescope.builtin`
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
  keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
  keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  -- keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  -- keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  keymap.set('n', '<tab>', api.node.open.preview, opts('Open Preview'))
  keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
  -- keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  keymap.set('n', 'a', api.fs.create, opts('Create'))
  keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
  keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
  keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
  keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
  keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  keymap.set('n', 'D', api.fs.trash, opts('Trash'))
  keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
  keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
  keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
  keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
  keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
  keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
  keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
  keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
  keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
  keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
  keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  keymap.set('n', 'q', api.tree.close, opts('Close'))
  keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  -- keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  keymap.set('n', 'S', api.tree.search_node, opts('Search'))
  keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
  keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
  keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH
  keymap.set('n', 'O', '', { buffer = bufnr })
  keymap.del('n', 'O', { buffer = bufnr })
  keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  keymap.set('n', 'D', '', { buffer = bufnr })
  keymap.del('n', 'D', { buffer = bufnr })
  keymap.set('n', 'E', '', { buffer = bufnr })
  keymap.del('n', 'E', { buffer = bufnr })
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
  keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
end
local options = {
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  -- transparent_panel = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = {
    custom = { ".DS_Store" },
  },
  view = {
    adaptive_size = false,
    side = "right",
    width = 40,
    -- hide_root_folder = true,
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
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
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
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

vim.g.nvimtree_side = options.view.side

require('nvim-tree').setup(options)

-- keymap.set('n', "<leader>tt", "<cmd>TroubleToggle<cr>")
-- keymap.set('n', "<leader>tw",
--   "<cmd>TroubleToggle workspace_diagnostics<cr><cmd>TroubleToggle workspace_diagnostics<cr>")
-- keymap.set('n', "<leader>td",
--   "<cmd>TroubleToggle workspace_diagnostics<cr><cmd>TroubleToggle document_diagnostics<cr>")
