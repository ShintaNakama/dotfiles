-- lazy.nvim のセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  defaults = {
    event = "VeryLazy",
  },
  { import = "plugins.fzf" },
  "itchyny/lightline.vim",
  "simeji/winresizer",
  "skanehira/translate.vim",
  "bronson/vim-trailing-whitespace",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "vim-jp/vimdoc-ja",
  { import = "plugins.open-browser" },
  "Rigellute/rigel",
  "vim-denops/denops.vim",
  "nvim-lua/plenary.nvim",
  { import = "plugins.copilotchat" },
  { import = "plugins.sqls" },
  { import = "plugins.lspV2" },
  { import = "plugins.tests" },
  { import = "plugins.goimports" },
  { import = "plugins.copilot" },
})
