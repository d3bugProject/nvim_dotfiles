-- config perso
require "configs.autocmds"
vim.fn.sign_define("NvimTreeDiagnosticErrorIcon", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("NvimTreeDiagnosticWarnIcon",  {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("NvimTreeDiagnosticInfoIcon",  {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("NvimTreeDiagnosticHintIcon",  {text = "", texthl = "DiagnosticSignHint"})
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"
vim.cmd([[autocmd FocusGained,BufEnter * checktime]])
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)


require("config")
