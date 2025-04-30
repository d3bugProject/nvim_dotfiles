local autocmd = vim.api.nvim_create_autocmd

-- Créer automatiquement jsconfig.json s'il n'existe pas
autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    local jsconfig = vim.fn.getcwd() .. "/jsconfig.json"
    if vim.fn.filereadable(jsconfig) == 0 then
      local config = {
        compilerOptions = {},
        exclude = { "dist" }
      }
      local json = vim.fn.json_encode(config)
      vim.fn.writefile({json}, jsconfig)
    end
  end,
})
