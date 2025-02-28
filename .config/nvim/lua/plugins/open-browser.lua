-- 開いたファイルをブラウザで開く(GitHubで管理されている場合はそのページを開く)
return {
  {
    "tyru/open-browser.vim",
    event = "VeryLazy",
  },
  {
    "tyru/open-browser-github.vim",
    event = "VeryLazy",
    dependencies = {
      { "tyru/open-browser.vim" },
    },
  },
}
