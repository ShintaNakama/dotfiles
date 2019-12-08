set shell=/bin/bash
set encoding=utf8
scriptencoding utf8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set t_Co=256
" スワップファイルの作成先を変更
set noswapfile
" ビープ音を消す
set belloff=all
"カーソルライン
set cursorline
"行番号
set number
"検索結果をハイライトする
set hlsearch
"検索時大文字小文字を区別しない
set ignorecase
"検索時、大文字を入力した場合大文字小文字を区別する
set smartcase
"文字を入力するたびに、その時点でパターンマッチしたテキストをハイライト
set incsearch

" Undo履歴の保存
if has('persistent_undo')
 let undo_path = expand('~/.vim/undo')
 exe 'set undodir=' . undo_path
 set undofile
endif

"ファイルタイププラグイン
filetype plugin indent on
"展開するスペースの個数
set tabstop=2
"タブをスペースに展開
set expandtab
" インデントを考慮して改行
set smartindent
"インデントのスペースの数
set shiftwidth=2

"常にクリップボードレジスタを使用する
set clipboard+=unnamed
"タブの表示"
set showtabline=2
"ステータスライン表示する
set laststatus=2
"短形選択"
set virtualedit=block
"コマンドライン補間
set wildmenu
" 挿入モードでバックスペースで削除できるようにする
set backspace=indent,eol,start

" キーバインド------------------------------------------------------------------

" xで削除した時はヤンクしない
vnoremap x "_x
nnoremap x "_x

" 1 で行頭に移動
nnoremap 1 ^
" 2で行末に移動
nnoremap 2 $

" 括弧の補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" クオーテーションの補完
inoremap ' ''<LEFT>
inoremap " ""<LEFT>


" plugin manager ---------------------------------------------
if &compatible
  set nocompatible
endif
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vimがインストールされていない場合はインストール
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" プラグインのdein.tomlとdein_lazy.tomlに記述
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:lazy_toml = s:rc_dir . '/dein_lazy.toml'

  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " end settings
  call dein#end()
  call dein#save_state()
endif

" インストールされていないプラグインがある場合はインストール
if dein#check_install()
  call dein#install()
endif

" dein.tomlやdein_lazy.tomlから削除したプラグインを削除する
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
  autocmd BufWritePre *.go "LspDocumentFormatSync<CR>"
endif

if executable('go-langserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'go-langserver',
    \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
    \ 'whitelist': ['go'],
    \ })
  autocmd BufWritePre *.go "LspDocumentFormatSync<CR>"
endif

" ------------------------------------------------------------

" カラースキーム
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

"シンタックス
syntax on
