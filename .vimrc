set shell=/bin/zsh
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
" ヴィジュアルモードで選択、ヤンクしてctr-vで貼り付け"
set clipboard+=unnamed

set helplang=ja

" <leader>を"\"から変更
let mapleader = "\<Space>"

" 操作設定
" jjをESCキー
inoremap <silent> jj <esc>
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

" For LSP settings
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  nmap <buffer> <Leader>d <plug>(lsp-type-definition)
  nmap <buffer> <Leader>r <plug>(lsp-references)
  nmap <buffer> <Leader>i <plug>(lsp-implementation)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
" let g:asyncomplete_auto_popup = 1
" let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
let g:lsp_preview_float = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

let g:lsp_settings = {}
let g:lsp_settings['gopls'] = {
  \  'workspace_config': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \  'initialization_options': {
  \    'usePlaceholders': v:true,
  \    'analyses': {
  \      'fillstruct': v:true,
  \    },
  \  },
  \}

" For snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

set completeopt=menuone
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

" -----------------------------------------------------------
au FileType plantuml command! OpenUml : !start chrome %
