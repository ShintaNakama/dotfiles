local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 行の端に行く
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)
keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- qqで強制終了
keymap("n", "qq", ":<C-u>q!<Return>", opts)

-- コンマの後に自動的にスペースを挿入
keymap("i", ",", ",<Space>", opts)

-- tab作成
keymap("n", "tc", ":tablast <bar> tabnew<Return>", opts)
-- tab閉じる
keymap("n", "tx", ":tabclose<Return>", opts)
-- next tab
keymap("n", "tn", ":tabnext<Return>", opts)
-- prev tab
keymap("n", "tp", ":tabprev<Return>", opts)

-- increment
keymap("n", "<C-a>", "+", opts)
-- decrement
keymap("n", "<C-x>", "-", opts)

-- 0番レジスタを使いやすくした
keymap("v", "<C-p>", '"0p', opts)

