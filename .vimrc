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
set nocursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
highlight CursorLine gui=underline guifg=NONE guibg=NONE
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
set nrformats=

set synmaxcol=320

set history=200
cnoremap <C-p> <up>
cnoremap <C-n> <down>

" Undo履歴の保存
if has('persistent_undo')
 let undo_path = expand('~/.vim/undo')
 exe 'set undodir=' . undo_path
 set undofile
endif

"ファイルタイププラグイン
filetype plugin indent on
runtime macros/matchit.vim
set modifiable
set write
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

"set ttimeoutlen=1
set timeout timeoutlen=3000 ttimeoutlen=100

" キーバインド------------------------------------------------------------------
" jjをESCキー
"inoremap <silent> jj <esc>

" Ctrl-p でレジスタ0を貼り付け"
vnoremap <silent> <C-p> "0p

" xで削除した時はヤンクしない
vnoremap x "_x
nnoremap x "_x

" Shift + hで行頭文字に移動
noremap <S-h> ^
" Shift + lで行末に移動
noremap <S-l> $

" 括弧の補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" クオーテーションの補完
"inoremap ' ''<LEFT>
"inoremap " ""<LEFT>


"強制終了
nnoremap qq :q!<CR>

"" + => increment
nnoremap + <C-a>

"" - => decrement
nnoremap - <C-x>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"" vimshell
nnoremap <Leader>sh :terminal<CR>

"" fzf
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fg :<C-u>silent call <SID>find_rip_grep()<CR>
function! s:find_rip_grep() abort
    call fzf#vim#grep(
                \   'rg --ignore-file ~/.ignore --column --line-number --no-heading --hidden --smart-case .+',
                \   1,
                \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'),
                \   0,
                \ )
endfunction

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
  \    "experimentalWorkspaceModule": v:true,
  \  },
  \}
let g:lsp_settings['golangci-lint-langserver'] = {
  \ 'initialization_options': {'command': ['golangci-lint', 'run', '--enable-all', '--disable', 'lll', '--out-format', 'json']},
  \ 'whitelist': ['go'],
  \}

" For snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

set completeopt=menuone,noinsert
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"
" ------------------------------------------------------------
au FileType plantuml command! OpenUml : !start chrome %

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

" ステータスラインに日付表示
function! g:Date()
  let weeks = [ "(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)" ]
  let wday = strftime("%w")
  return strftime('%Y/%m/%d').weeks[wday].strftime(' %H:%M')
endfunction

"let g:rigel_lightline = 1
let g:lightline = {
  \ 'active': {
  \   'right': [
  \     ['lineinfo'],
  \     ['percent'],
  \     ['charcode','fileencoding','date'],
  \   ],
  \ },
  \ 'component_function': {
  \   'date': 'Date',
  \ },
  \ 'component_expand': {
  \ },
  \ 'component_type': {
  \ },
  \}

" for vim-test
let test#strategy = "basic"
let test#go#runner = 'gotest'
let test#go#gotest#executable = 'gotest -race -v -cover'
" tのあとにCTRL+dでテストをデバッガ経由で実行する
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>

" 構造体にinterfaceを自動実装する(対象のGo module内に移動して、構造体名にカーソルを当てる) :IMP
autocmd BufNewFile,BufRead *go command! IMP call s:go_fzf_implement_interface()

function! s:go_fzf_implement_interface() abort
    let source = 'go_list_interfaces'

    call fzf#run({
                \   'source': source,
                \   'sink':   function('s:go_implement_interface'),
                \   'down':   '40%'
                \ })
endfunction

function! s:go_implement_interface(interface) abort
    call s:go_execute_impl(a:interface, v:false)
endfunction

function! s:go_receiver() abort
  let line = line(".")
  let col  = col(".")
  let word = expand("<cword>")
  let res = word[0].' *'.word
  return res
endfunction

function! s:go_execute_impl(interface, is_std_pkg) abort
    let pos = getpos('.')
    let recv = s:go_receiver()

    " Make sure we put the generated code *after* the struct.
    if getline('.') =~# 'struct '
        normal! $%
    endif

    if !a:is_std_pkg
        let pkg = system('go mod edit -json | jq -r .Module.Path | tr -d "\n"')
        if a:interface =~# '^\.'
            let interface = printf('%s%s', pkg, a:interface)
        else
            let interface = printf('%s/%s', pkg, a:interface)
        endif
    else
        let interface = a:interface
    end
    try
        echo recv
        echo interface
        let dirname = fnameescape(expand('%:p:h'))
        let [result, err] = go#util#Exec(['impl', '-dir', dirname, recv, interface])
        let result = substitute(result, "\n*$", '', '')
        if err
            call go#util#EchoError(result)
            return
        endif

        if result is# ''
            return
        end

        put =''
        silent put =result
    finally
        call setpos('.', pos)
    endtry
endfunction

" translate
let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_popup_window = 1
let g:translate_winsize = 10

" カーソル下の単語をGoogleで検索する <leader>gs
function! s:search_by_google()
    let line = line(".")
    let col  = col(".")
    let searchWord = expand("<cword>")
    if searchWord  != ''
        execute 'read !open https://www.google.co.jp/search\?q\=' . searchWord
        execute 'call cursor(' . line . ',' . col . ')'
    endif
endfunction
command! SearchByGoogle call s:search_by_google()
nnoremap <silent> <leader>gs :SearchByGoogle<CR>

"
autocmd FileType go nnoremap <silent> ge :<C-u>silent call go#expr#complete()<CR>

" ファイルツリーの表示形式、1にするとls -laのような表示になります
let g:netrw_liststyle=0
" ヘッダを非表示にする
let g:netrw_banner=0
" サイズを(K,M,G)で表示する
let g:netrw_sizestyle="H"
" 日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
" プレビューウィンドウを垂直分割で表示する
let g:netrw_preview=1
" 左右分割を右側に開く
let g:netrw_altv = 1

let g:startify_session_persistence = 1
" Once vim-javascript is installed you enable flow highlighting
let g:javascript_plugin_flow = 1

"" カラースキーム
"if (empty($TMUX))
"  if (has("nvim"))
"    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"  endif
"  if (has("termguicolors"))
"    set termguicolors
"
"    "let g:tokyonight_style = 'storm' " available: night, storm
"    "let g:tokyonight_transparent_background = 0
"    "let g:tokyonight_enable_italic = 1
"
"    "colorscheme molokai
"    colorscheme rigel
"  endif
"endif
"

colorscheme peachpuff
"シンタックス
syntax on

" URLをブラウザで開く
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
nnoremap <Leader>o :<C-u>execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')<CR>

if filereadable(expand('~/dotfiles/.vimrc.local'))
  source ~/.vimrc.local
endif
