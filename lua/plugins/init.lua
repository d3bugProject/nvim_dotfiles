return {
  -- --codeium
  -- {
  --   "Exafunction/codeium.vim",
  --   lazy = false,
  --   config = function()
  --     vim.keymap.set("i", "<tab>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-;>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-,>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-x>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true })
  --   end,
  -- },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Basic configuration
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      -- Use <C-j> for accepting suggestions
      vim.api.nvim_set_keymap("i", "<tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

      -- Additional key mappings if needed
      -- vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Next()', { silent = true, expr = true })
      -- vim.api.nvim_set_keymap("i", "<C-[>", 'copilot#Previous()', { silent = true, expr = true })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    lazy = false, -- Force load the plugin
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = true, -- Enable debug for troubleshooting
      })
      -- Keybindings
      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>")
      vim.keymap.set("v", "<leader>cc", ":CopilotChatVisual<CR>")
    end,
  }, 
  "xiyaowong/transparent.nvim",

  "nvimtools/none-ls.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "aca/emmet-ls",
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    optional = true,
    opts = {
      formatters_by_ft = {
        ["typescript"] = { "eslint_d" },
        ["javascript"] = { "eslint_d" },
      },
      require "configs.conform",
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint_d",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip' },
    keys = {
      { "<tab>", mode = { "i" }, false },
    },
  },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      view = {
        side = "right",
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require("nvim-navic").setup()
    end
  },
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
  },
  { 'NvChad/nvim-colorizer.lua' },
  { 'mrjones2014/nvim-ts-rainbow' },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

}
