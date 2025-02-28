-- Test関連
return {
  {
    {
      "vim-test/vim-test",
      event = "VeryLazy",
    },
    {
      "vim-test/vim-test",
      config = function()
        vim.g["test#go#runner"] = "gotest"
        vim.g["test#go#gotest#executable"] = "gotest -race -v -cover"
      end,
    },
    -- neotest は使ってみようとしたが、うまく動かなかったのでコメントアウト
    -- { "nvim-neotest/neotest" },
    -- { "nvim-neotest/neotest-go" },
    -- dependencies = {
    --   "nvim-neotest/nvim-nio",
    --   "nvim-lua/plenary.nvim",
    --   "antoinemadec/FixCursorHold.nvim",
    --   "nvim-treesitter/nvim-treesitter"
    -- },
    -- cofing = function()
    --   require('neotest').setup({
    --     adapters = {
    --       require('neotest-go')({
    --         recursive_run = true,
    --       })
    --     },
    --   })
    -- end,
  },
}
