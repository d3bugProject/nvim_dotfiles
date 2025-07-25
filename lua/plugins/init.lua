return {
  "xiyaowong/transparent.nvim",
  "nvimtools/none-ls.nvim",
  "aca/emmet-ls",
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- Activer avant la sauvegarde
    cmd = { "ConformInfo" },
    keys = {
      {
        "ff",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = function()
      return require "configs.conform"
    end,
    init = function()
      -- Si tu veux format-on-save pour certains filetypes seulement
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Formatters
        "prettier",
        "stylua", 
        "black",
        "shfmt",
        
        -- Linters
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
  {
  "HiPhish/rainbow-delimiters.nvim", -- Remplace par ceci
  config = function()
    require("rainbow-delimiters.setup").setup()
  end,
},
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  

}
