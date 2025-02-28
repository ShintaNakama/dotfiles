return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local fzf = require("fzf-lua")

      -- ファイル検索
      vim.keymap.set("n", "<Leader>ff", function()
        fzf.files()
      end, { silent = true, desc = "Search files with fzf" })

      -- ripgrep を使った検索（ファイル名を対象外に修正）
      vim.keymap.set("n", "<Leader>fg", function()
        fzf.grep({
          search = "",
          cmd = "rg --column --line-number --no-heading --hidden --smart-case --ignore-case", -- ファイル名を検索対象外に
          fzf_opts = {
            ["--delimiter"] = ":",
            ["--nth"] = "3..", -- 検索結果の行の内容のみを表示
          },
          previewer = "builtin", -- プレビューを有効化
          actions = {
            ["default"] = fzf.actions.file_edit_or_qf, -- Enter で該当行へジャンプ
            ["alt-q"] = fzf.actions.file_sel_to_qf, -- Alt+Q で検索結果をクイックフィックスリストに追加
          },
        })
      end, { silent = true, desc = "Search text in files with fzf and ripgrep" })

      -- FZF-Lua のデフォルト設定
      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          preview = {
            layout = "vertical",
            vertical = "up:40%",
          },
        },
        fzf_opts = {
          ["--info"] = "inline",
          ["--layout"] = "reverse",
        },
      })
    end,
  },
}

