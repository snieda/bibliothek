call plug#begin('~/.vim/plugged')

" layout and coloring
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'

" utils
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'

Plug '/opt/fzf' | Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'majutsushi/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-vinegar'
" Plug 'wincent/command-t' " Needs Ruby compilation
Plug 'fisadev/vim-ctrlp-cmdpalette'
"Plug 'vim-scripts/unmswin.vim'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'

" install 'BurntSushi/ripgrep' "multifile search command line tool
Plug 'wincent/ferret'

" workspace / project
" Plug 'thaerkh/vim-workspace'
" Plug 'bagrat/vim-workspace'
Plug 'powerman/vim-plugin-autosess'
Plug 'zefei/vim-wintabs'
Plug 'zefei/vim-wintabs-powerline'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Plug 'junegunn/vim-github-dashboard' "Needs Ruby compilation 

" develop
Plug 'Shougo/deoplete.nvim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --java-completer' }
Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
"Plug 'natebosch/vim-lsc'

"debugging
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'idanarye/vim-vebugger'
Plug 'Dica-Developer/vim-jdb'

" java
" add javacomplete2 only, if YCM and deoplete are not working
Plug 'artur-shaik/vim-javacomplete2'
Plug 'bam9523/vim-decompile'

" python
"Plug 'nvie/vim-flake8'
Plug 'SkyLeach/pudb.vim'
Plug 'tell-k/vim-autopep8'

" CoffeeScript
Plug 'kchmck/vim-coffee-script'
Plug 'mtscout6/vim-cjsx'

" TypeScript
Plug 'leafgarland/typescript-vim'

" Othes
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'genoma/vim-less'

" Docker
Plug 'docker/docker', {'rtp': '/contrib/syntax/vim/'}

" Plug 'pangloss/vim-javascript'

" Jsx
Plug 'mxw/vim-jsx'

" Show the available 256 colors in vim.
Plug 'guns/xterm-color-table.vim'

" Autocompletion
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" Load on nothing
Plug 'nacitar/terminalkeys.vim', { 'on': [] }

" If in tmux
if $TMUX =~ "tmux" 
    " Load terminalkeys
    call plug#load('terminalkeys.vim')
endif

call plug#end()

" add all the plugins
" if filereadable(expand("~/.vim/plugins.vim"))
"    source ~/.vim/plugins.vim
" endif

let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']

" Groovy ----------------------------------------------------------------------
" Reference: http://www.vim.org/scripts/script.php?script_id=945
" source ~/.vim/syntax/groovy.vim
" Recognize groovy
au BufNewFile,BufRead *.groovy  setf groovy
au BufNewFile,BufRead Jenkinsfile*  setf groovy

" General configuration -------------------------------------------------------
set number
set ruler
set cursorcolumn 
hi CursorColumn ctermbg=8

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" Sets the number of columns for a TAB.
set softtabstop=4
" On pressing tab, insert 4 spaces
set expandtab

" Specific identations
augroup identationGroup
    " Prevent duplicates on multiple .vimrc load
    autocmd!
    " Python
    autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    " PHP
    autocmd Filetype php setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    " Groovy
    autocmd Filetype groovy setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    " JavaScript
    " autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype javascript setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd Filetype typescript setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype coffee setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " Jade / HTML
    autocmd Filetype jade setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype pug setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " Yaml
    autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " CSS / LESS / SASS / Stylus
    autocmd Filetype less setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " autocmd Filetype sass setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype sass setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd Filetype scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype styl setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd Filetype css setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " Dockerfile
    autocmd Filetype dockerfile setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Autocompletion
set wildmenu
set wildmode=list:longest

" Seach
set hlsearch
set incsearch

set paste
set ttyfast

set autoindent
set showcmd

" Fugitive (Diff for resolve conflicts) ---------------------------------------
set diffopt+=vertical

" Folding ---------------------------------------------------------------------
"
" Note : za --> toggle fold
"        zd --> remove fold
"        zo --> open fold
"        zc --> close fold
"
" with foldmethod=manual may be more confortable than this
"        va}zf --> close the current block

" Fold by grouping indented text
set foldmethod=indent

" Sets the maximum nesting of folds
set foldnestmax=10

" Avoid folding when the file is being open
set nofoldenable

" Folds with a higher level will be closed
set foldlevel=2

" NERDTree Configuration ------------------------------------------------------
map <F3> :NERDTreeToggle<CR>

" TagBar Configuration --------------------------------------------------------

" autofocus on Tagbar open
let g:tagbar_autofocus = 1

" toggle Tagbar display
map <F4> :TagbarToggle<CR>

" Set default width
let g:tagbar_width = 30

" Load the CoffeeScript type support
let g:tagbar_type_coffee = {
    \ 'ctagstype' : 'coffee',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 'm:methods',
        \ 'f:functions',
        \ 'v:variables',
        \ 'f:fields',
    \ ]
\ }

" Load the JavaScript type support
let g:tagbar_type_javascript = {
    \ 'ctagstype' : 'js',
    \ 'kinds'     : [
        \ 'o:objects',
        \ 'u:functions',
        \ 'v:variables',
        \ 'c:controllers',
        \ 'd:directives',
        \ 's:services',
        \ 'f:factories',
        \ 'm:modules',
        \ 'c:controllers',
    \ ]
\ }

" Load the Java type support
let g:tagbar_type_java = {
    \ 'ctagstype' : 'java',
    \ 'kinds'     : [
        \ 'o:objects',
        \ 'u:functions',
        \ 'v:variables',
        \ 'c:controllers',
        \ 'd:directives',
        \ 's:services',
        \ 'f:factories',
        \ 'm:modules',
        \ 'c:controllers',
    \ ]
\ }

" FZF Configuration -----------------------------------------------------------
nnoremap <F2> :FZF<CR>
nnoremap ,e :call fzf#vim#gitfiles('', fzf#vim#with_preview('right'))<CR>

" CtrlP Configuration ---------------------------------------------------------
" let g:ctrlp_map = '<F2>'
" map ,e <F2>

" to search in the current open buffers
nnoremap ,b :CtrlPBuffer<CR>
" to search listing all tags
nnoremap ,t :CtrlPBufTag<CR>
" to search through the current file's lines
nnoremap ,l :CtrlPLine<CR>
" to search listing all Most-Recently-Used file.
nnoremap ,r :CtrlPMRUFiles<CR>

" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction

" CtrlP with default text
nnoremap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nnoremap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nnoremap ,d ,wg
nnoremap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nnoremap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>

" Don't change working directory
let g:ctrlp_working_path_mode = 0

" Ignore this files/dirs
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/](\.git|\.hg|\.svn|target|bin)$',
            \ 'file': '\.pyc$\|\.pyo$',
            \ }

" Update the search once the user ends typing.
let g:ctrlp_lazy_update = 2

" The Silver Searcher
if executable('ag')
    " Use ag in CtrlP for listing files, lightning fast.
    let ignores = '--ignore ".git/" --ignore ".hg/" --ignore ".svn/" --ignore "target" -- ignore "bin"'  " dirs
    let ignores .= ' --ignore "*.pyc" --ignore "*.pyo"'                " files
    let g:ctrlp_user_command = 'ag %s -l --skip-vcs-ignores --nocolor -g "" ' . ignores

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0

    nnoremap <leader>ag :Ag 
endif

" Powerline Configuration -----------------------------------------------------
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup
" set laststatus=2

" Ale Configuration -----------------------------------------------------------
let g:ale_statusline_format = ['x %d', '⚠ %d', '⬥ ok']
let g:ale_open_list=1
let g:ale_set_loclist=1
let g:ale_set_quickfix=1

" Airline configuration -------------------------------------------------------

" Make airline to appear on all the tabs
set laststatus=2

" Use 256 colors
set t_Co=256

"call airline#parts#define_function('ALE', 'ALEGetStatusLine')
"call airline#parts#define_condition('ALE', 'exists("*ALEGetStatusLine")')
"let g:airline_section_error = airline#section#create_right(['ALE'])
" let g:airline_theme='durant'
" let g:airline_theme='powerlineish'
" let g:airline_theme='simple'
" let g:airline_theme='term'
"let g:airline_theme='jellybeans'

"let g:airline_powerline_fonts = 1

" powerline symbols
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''


" Syntastic Configuration -----------------------------------------------------

" TODO: Refactor this to a separate module
" https://github.com/vim-syntastic/syntastic/issues/974
function! JavascriptEslintConfig(curpath)
  let parent=1
  let local_path=a:curpath
  let local_jscs=local_path . '.eslintrc.json'

  while parent <= 255
    let parent = parent + 1
    if filereadable(local_jscs)
      return '--config ' . local_jscs
    endif
    let local_path = local_path . '../'
    let local_jscs = local_path . '.eslintrc.json'
  endwhile

  unlet parent local_jscs

  return ''
endfunction

let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_checkers = ['jsl']
" let g:syntastic_javascript_checkers = ['jscs']
" let g:syntastic_javascript_jscs_args = '--preset=airbnb'
let g:syntastic_javascript_jscs_args = JavascriptEslintConfig(getcwd() . "/")
let g:syntastic_enable_signs=1                                                  
let g:syntastic_coffee_coffeelint_args = "--csv --file config.json"

" Adapt it to use the proper python version, according to the environment.
let g:syntastic_python_python_exec = '/usr/bin/env python'

highlight SyntasticErrorLine guibg=#2f0000

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1

" Allows to toggle the error's window visibility
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction

" Bind toggleErrors to <F2> 
"noremap <silent> <C-e> : call ToggleErrors()<CR>
" noremap <C-e> : call ToggleErrors()<CR>

" YouCompleteMe Configuration -------------------------------------------------
" ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:ycm_goto_buffer_command = 'new-or-existing-tab'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1

" Fix for working with virtualenvs: https://github.com/Valloric/YouCompleteMe#i-get-importerror-exceptions-that-mention-pyinit_ycm_core-or-initycm_core 
" let g:ycm_server_python_interpreter = 'env python'
let g:ycm_python_binary_path = 'python'

" bind
nnoremap <leader>jd :YcmComplete GoTo<CR>

" TypeScript configuration ----------------------------------------------------
" Disable custom indenter
let g:typescript_indent_disable = 1

" THEMING ---------------------------------------------------------------------
color ron
set colorcolumn=120
set cursorline

" Searching colors
highlight Search cterm=NONE ctermfg=LightGrey ctermbg=Blue

" Fix background on Guake
highlight Normal ctermbg=NONE

" BINDINGS --------------------------------------------------------------------

" Eliminates delay issues
set timeoutlen=1000 ttimeoutlen=50

noremap <A-PageUp> :tabmove -1<CR>
noremap <A-PageDown> :tabmove +1<CR>

" Toggle tabs display
noremap <C-k> :setlocal list!<CR>

" Toggle english spelling check
noremap <C-m> :setlocal spell! spelllang=en_us<CR>

" Show invisible characters
noremap <C-k> :setlocal list!<CR>

" Set the mapleader
let mapleader = "¡"

" Edit my .vimrc file"
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source my .vimrc file (This reloads the configuration)
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" Selects all in the current buffer
nnoremap <leader>av ggvGg_

" Select the current
nnoremap <leader>v ^vg_

" Navigate between errors
nmap <silent> <S-h> <Plug>(ale_previous_wrap)
nmap <silent> <C-h> <Plug>(ale_next_wrap)

" Toggle errors visibility
noremap <silent> <C-e> :ALEToggle<CR>

" Move lines
nnoremap <leader>f :m .+1<CR>==
nnoremap <leader>F :m .-2<CR>==
inoremap <leader>f <Esc>:m .+1<CR>==gi
inoremap <leader>F <Esc>:m .-2<CR>==gi
vnoremap <leader>f :m '>+1<CR>gv=gv
vnoremap <leader>F :m '<-2<CR>gv=gv

" Quickfix
nnoremap <leader>n :cnext<CR>
nnoremap <leader>N :cprevious<CR>
nnoremap <leader>g :cfirst<CR>
nnoremap <leader>G :clast<CR>
let g:workspace_autosave_always = 1

noremap <Tab> :WSNext<CR>
noremap <S-Tab> :WSPrev<CR>
noremap <Leader><Tab> :WSClose<CR>
noremap <Leader><S-Tab> :WSClose!<CR>
noremap <C-t> :WSTabNew<CR>

cabbrev bonly WSBufOnly

:set autoread

" session related.
cnoremap <C-O> source ~/.vim-session
cnoremap <C-S> mksession! ~/.vim-session
nnoremap <silent> <C-S><C-S> :mksession! ~/.vim-session <CR>
let g:vebugger_leader='<Leader>d'

" /vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

let g:decomp_jar = '$TOOLS/cfr_0_115.jar'
let python_highlight_all=1
syntax on
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
let g:autopep8_max_line_length=120
let g:autopep8_indent_size=2
let g:autopep8_disable_show_diff=1
let g:autopep8_on_save = 1

" use windows shortcuts
set nocompatible
source $VIMRUNTIME/mswin.vim
behave mswin

noremap <S-P> :CtrlPCmdPalette
noremap <C-M> :only
let g:ycm_error_symbol = '**'
let g:ycm_add_preview_to_completeopt = 1
set encoding=utf-8
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
