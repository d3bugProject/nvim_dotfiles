return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = { --[[ things you want to change go here]] },
  config = function()
    require("toggleterm").setup{
      size = 30,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 3,
      }
    }
  end,
  lazy = false

}
