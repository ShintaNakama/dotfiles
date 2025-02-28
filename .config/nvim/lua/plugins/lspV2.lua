return {
  -- LSP 関連のプラグイン
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },

  -- LSP サーバー管理
  { "williamboman/mason.nvim", config = true, event = "VeryLazy" },
  { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },

  -- LSP の補完
  { "hrsh7th/nvim-cmp", event = "VeryLazy" },
  { "hrsh7th/cmp-nvim-lsp", event = "VeryLazy" },
  { "L3MON4D3/LuaSnip", event = "VeryLazy" },

  -- 追加の LSP サポート
  { "jose-elias-alvarez/null-ls.nvim", event = "VeryLazy" },
  { "nvim-telescope/telescope.nvim", event = "VeryLazy" },
  { "smjonas/inc-rename.nvim", config = function() require("inc_rename").setup() end, event = "VeryLazy" },

  -- LSP のセットアップ
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- Mason のセットアップ
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "typos_lsp" }, -- 自動インストール
      })

      -- LSP を簡単に設定
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
      })

      -- LSP の補完設定
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- `LuaSnip` をスニペットとして利用
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      })

      -- LSP キーマッピング
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- LSP 定義ジャンプ
      keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })

      -- LSP Hover
      keymap("n", "<Leader>h", vim.lsp.buf.hover, { desc = "Show hover documentation" })

      -- LSP References を Telescope で表示
      keymap("n", "<Leader>r", function()
        require("telescope.builtin").lsp_references()
      end, { desc = "Show LSP References with Telescope" })

      -- LSP Type Definitions を Telescope で表示
      keymap("n", "<Leader>d", function()
        require("telescope.builtin").lsp_type_definitions()
      end, { desc = "Show Type Definitions with Telescope" })

      -- LSP Rename
      keymap("n", "<Leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename Symbol with Inline UI" })

      -- LSP Implementations を Telescope で表示
      keymap("n", "<Leader>i", function()
        require("telescope.builtin").lsp_implementations()
      end, { desc = "Show Implementations with Telescope" })

      -- LSP Diagnostics（エラーの移動）
      keymap("n", "<Leader>ne", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to next LSP error" })

      keymap("n", "<Leader>pe", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to previous LSP error" })
    end,
  },
}
