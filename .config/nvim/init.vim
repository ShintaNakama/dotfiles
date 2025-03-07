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

set synmaxcol=500

set history=200
cnoremap <C-p> <up>
cnoremap <C-n> <down>

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

"undofile
set undofile
set undodir=~/.local/state/nvim/undo

" キーバインド------------------------------------------------------------------
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

"アスタリスクsearchで次の候補に移動しない(移動した後戻しているだけ
nmap * *N

"強制終了
nnoremap qq :q!<CR>

"" + => increment
nnoremap + <C-a>

"" - => decrement
nnoremap - <C-x>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"" vimshell
nnoremap <Leader>sh :above split \| terminal<CR>
"NeoVimではデフォルトでターミナルモードが有効になっているので<C-]>でノーマルモードに戻す
tnoremap <C-[> <C-\><C-n>

" plugin manager ---------------------------------------------
" Lua のプラグイン設定を読み込む
lua require("plugins")
lua require("local")

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

colorscheme rigel
hi Search ctermbg=8
"シンタックス
syntax on

" URLをブラウザで開く
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
nnoremap <Leader>o :<C-u>execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')<CR>

" Go の指定された式から左辺を完成
autocmd FileType go nnoremap <silent> ge :<C-u>silent call go#expr#complete()<CR>

