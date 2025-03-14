return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      -- i want to add <Tab> for  completion
      -- and <C-c>  for stopping the chat
      --
      keymap = {
        complete = "<Tab>",
        accept = "<C-CR>",
        cancel = "<C-c>", -- Key to cancel the chat
        stop = "<leader>l",   -- Key to stop the generation

      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
