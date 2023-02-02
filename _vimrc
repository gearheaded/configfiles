" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

"""""""""""""""""""""""""""""
"
"   General Stuff
"   Visual Mode/Searching
"   Themes/Fonts
"   Highlighting
"   Tab/Buffer Keymaps
"   Custom Keymaps
"   Folding
"   Plugins
"
"""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" General Stuff {{{
"""""""""""""""""""""""""""""

set number          " show line numbers
set hidden          " allow hidden buffers
set history=1000    " save commands and such that are used
set smarttab        " insert 'tabstop' number of spaces when the 'tab' key is pressed
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set shiftround      " when shifting lines, round the indentation to the nearest multiple of 'shiftwidth'
set shiftwidth=2    " when indenting with > then use 2 spaces
set autoindent      " new lines inherit indentation of previous lines
set expandtab       " insert spaces when pressing tab
set smartindent     " react to style/syntax of current code
set ruler           " show current position
set noerrorbells    " no audio bells
set novisualbell    " no flashing crap
"set termguicolors  " doesn't jive with my theme so it's off for now

set wrap linebreak nolist         " wrap lines but don't wrap in the middle of words
set backspace=eol,start,indent    " let backspae do it's thing
set whichwrap+=<,>,h,l            " allow arrow keys to wrap around

set wildmenu                      " set tab completion menu for selecting files
set wildmode=longest:list,full

" Mouse behavior (the Windows way)
behave mswin

filetype indent on
filetype plugin on

set encoding=utf-8

" set leader key
nnoremap <SPACE> <Nop>
let mapleader = "\<SPACE>"

" auto-reload vim upon saving vimrc
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYVIMRC | endif | redraw
  augroup END
endif " has autocmd

" check the final line of a file for a modeline
set modelines=1

" auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" set where to backup files
set undodir=~/bak/vim/undo
set backupdir=~/bak/vim/backup
set directory=~/bak/vim/swap
set undofile

" show status line & format
set laststatus=1
" set statusline=%f<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%Y/%m/%d-%H:%M\")}%=\ CWD:\%r%{getcwd()}%h\ \ Line:%l\ \ %P

" put some space around the cursor when scrolling
set scrolloff=10

" remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set viminfo='20,\"500   

" make y and p copy and paste to the global clipboard
set clipboard+=unnamed

" }}}
""""""""""""""""""""""""""""
" Visual Mode/Searching {{{
""""""""""""""""""""""""""""

" ignore case when searching
set ignorecase      " ignore case when searching
set smartcase       " if caps are used then search with caps
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set magic           " magic on for regular expressions

" highlight matching [{()}] & tenths of seconds to blink
set showmatch
set mat=2

" redraw only when we need to
set lazyredraw

" }}}
""""""""""""""""""""""""""""
" Themes/Fonts {{{
""""""""""""""""""""""""""""

syntax on
" syntax enable
set background=dark

set guioptions+=d " only works in GTK+ GUI. damnit.

" set all split to happen below (mostly for terminal)
set splitbelow

set encoding=utf8
if has('gui_running')
  " this is GUI vim
  colorscheme material-theme
  "set guifont=Consolas_NF:h8:b
  set guifont=Ubuntu_Mono_derivative_Powerlin:h8:b
  set lines=50 columns=135
else
  " this is console vim
  colorscheme desert
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif

" }}}
""""""""""""""""""""""""""""
" Highlighting {{{
""""""""""""""""""""""""""""

" highlight current line in the current window
augroup CursorLine
  au!
  autocmd! ColorScheme * hi clear CursorLine
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  hi CursorLine term=bold cterm=bold ctermbg=12 ctermfg=15 
  hi CursorLineNR term=bold cterm=bold ctermbg=NONE ctermfg=1
  hi Cursor term=bold cterm=bold ctermbg=0 ctermfg=15
  hi LineNr term=bold cterm=bold ctermbg=NONE ctermfg=15
  au WinLeave * setlocal nocursorline
augroup END

" highlighting for fenced code blocks in markdown files
au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['bash', 'css', 'c++=cpp', 'erb=eruby', 'java', 'javascript', 'js=javascript', 'json', 'perl', 'php', 'python', 'ruby', 'sass', 'scss', 'sql', 'xml', 'html']

" }}}
""""""""""""""""""""""""""""
" Tab/Buffer Keymaps {{{
""""""""""""""""""""""""""""

" Smart way to move between windows:
" this will move to the window in the direction shown, or create a new
" split if there is not one there already
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

" Close the current buffer
noremap <leader>bd :bd<cr>:tabclose<cr>gT

" Close all the buffers
noremap <leader>ba :bufdo bd<cr>
" Next/previous buffers
"noremap <S-l> :bnext<cr>
"noremap <S-h> :bprevious<cr>
" Next/previous buffers, but sync NERDTree to the buffered file
nnoremap <silent> <S-l> :bnext<CR>:call SyncTree()<CR> 
nnoremap <silent> <S-h> :bprev<CR>:call SyncTree()<CR> 

" Useful mappings for managing tabs
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove
noremap <C-Tab> :tabnew<cr>
noremap <S-Tab> :tabprevious<cr>
noremap <Tab> :tabnext<cr>

" show all buffers in tabs, or to close all tabs (toggle: it alternately executes :tab ball and :tabo)
let notabs = 0
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>

" Let '<lead>tl' (NOTE: TL, NOT T1) toggle between this and the last accessed tab
let g:lasttab = 1
noremap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
noremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
noremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files 
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" }}}
""""""""""""""""""""""""""""
" Custom Keymaps {{{
""""""""""""""""""""""""""""

" edit vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
" reload vimrc if edited outside of vim - though it should be done automatically with function in "General Stuff"
nnoremap <leader>vr :source $MYVIMRC<CR>

" fast saving
nmap <leader>w :w!<cr>

" ignore word wrapping when moving lines
"noremap j gj
"noremap k gk
" ignore word wrapping when moving lines unless I have a count, in which case it bahaves normally
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <Down> gj
noremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" clear the last search
noremap <silent> <leader>/ :let @/ = ""<CR>

" move a line of text using ALT+[jk]
noremap <M-j> mz:m+<cr>`z
noremap <M-k> mz:m-2<cr>`z

" repeat the last macro used
nnoremap Q @@

" toggle and untoggle spell checking
noremap <leader>sp :setlocal spell!<cr>

" scroll the viewport faster
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Search and replace
" Press * to search for the term under the cursor or a visual selection, or
" use / to search and then press the keys below to replace all instances of it 
" in the current file
" rc will ask for confirmation
nnoremap <leader>r :%s///g<Left><Left>
nnoremap <leader>rc :%s///gc<Left><Left><Left>

" same as above except will replace within a visually selected field
xnoremap <leader>r :s///g<Left><Left>
xnoremap <leader>rc :s///gc<Left><Left><Left>

" type s*, then a replacement term, then esc. Then press . to repeat the 
" replacement again. Useful for replacing a few instances of a term 
" that's default behavior??? can't figure this one out. original description:
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
"nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
"xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" sort visually selected lines
vnoremap <leader>s :sort<cr>

" in insert mode, pressing Ctrl-O switches to normal mode for one command, then switches back to insert mode when the command is finished - these keymaps make a few things easier
inoremap <M-o> <C-O>o
inoremap <M-O> <C-O>O
inoremap <M-I> <C-O>^
inoremap <M-A> <C-O>$

" }}}
""""""""""""""""""""""""""""
" Folding {{{
""""""""""""""""""""""""""""

set foldcolumn=1    " extra column
set nofoldenable    " set folds to be open when you open a file
set foldnestmax=10

" set <LEADER>z to open/close folds, as well as set manually selected sections to fold
" this will interrupt insert mode to fold/unfold, but also causes lag
" since SPACE is set as the leader key
" inoremap <leader>z <C-O>za
nnoremap <leader>z za
vnoremap <leader>z zf

" have vim define folds by indent level, but allow creation of folds manually
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" make vim remember manual folds and reload them when opening a file
" see here: https://vim.fandom.com/wiki/Make_views_automatic
"augroup AutoSaveFolds
"  autocmd!
"  autocmd BufWinLeave *.* mkview
"  autocmd BufWinEnter *.* silent loadview
"augroup END

" }}}
""""""""""""""""""""""""""""
" Plugins {{{
""""""""""""""""""""""""""""

" Vim-Plug
" Use :PlugInstall to install new plugins
" Use :PlugUpdate to update installed plugins - you can then press D to review the changes, or use :PlugDiff later on
" Updated plugins may have new bugs and no longer work correctly. With :PlugDiff command you can review the changes from the last :PlugUpdate and roll each plugin back to the previous state before the update by pressing X on each paragraph
" To remove plugins:
" 1. Delete or comment out Plug commands for the plugins you want to remove.
" 2. Reload vimrc (:source ~/.vimrc) or restart Vim
" 3. Run :PlugClean. It will detect and remove undeclared plugins.

" load plugins with vim-plug - but first check if vim-plug is installed - if only this worked on windows, but no 'glob' command unfortunately
"if empty(glob('~/vimfiles/autoload/plug.vim'))
"  silent !curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"  autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" download plugins to this directory
call plug#begin('~/vimfiles/plugged')

" declare list of plugins
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/rjayatilleka/vim-insert-char'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/Yggdroot/LeaderF'
Plug 'https://github.com/godlygeek/tabular'
Plug 'https://github.com/vimwiki/vimwiki'

" lazy load
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" list ends here. Plugins become visible to vim after this call
call plug#end()


" Leaderf
" if exclamation point is used then leaderf will remain in normal mode, without inpupt mode will be used. Switch between modes with TAB key
let g:Lf_PreviewInPopup = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
" keymaps
let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
" search files
let g:Lf_ShortcutF = "<C-P>"
" search buffers
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" search most recently opened files
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
" search tags of current buffer
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
" search lines within current buffer 
noremap <C-F> :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
" search word under cursor literally only in current buffer
noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>
" search word under cursor literally in all listed buffers
noremap <leader>fc :<C-U><C-R>=printf("Leaderf! rg -F --all-buffers -e %s ", expand("<cword>"))<CR>
" search word under cursor in all files, treated as regex
noremap <leader>fa :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally in all files, don't quit after accepting an entry
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen -e %s ", leaderf#Rg#visual())<CR>
" repeat last search
noremap go :<C-U>Leaderf! rg --recall<CR>
" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

" Airline
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Enable NERDTree
autocmd vimenter * NERDTree
" Map NERDTree to ctrl+n
"nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<cr><c-w>l:call SyncTree()<cr><c-w>h

" Close NERDTree when it's the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Synchonize NERDTree with currently opened file
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

" UTL
" TODO

" Vim-insert-char
" insert a single character, with ability to insert X number. Repeatable with .
let g:insert_char_no_default_mapping = 1
nmap _ <Plug>InsertChar

" VimWiki
let g:vimwiki_list = [{'path': 'C:/Users/Peter/blah/wiki/vimwiki', 
                      \ 'path_html': 'C:/Users/Peter/blah/wiki/html/',
                      \ 'syntax': 'markdown', 
                      \ 'ext': '.md', 
                      \ 'css_file': 'C:/Users/Peter/blah/wiki/html/style.css',
                      \ 'links_space_char': '_',
                      \ 'list_margin': 0, 
                      \ 'auto_toc': 1, 
                      \ 'auto_tags': 1,
                      \ 'auto_generate_links': 1}]
" \ 'custom_wiki2html': 'C:/Users/Peter/blah/wiki/misaka_md2html.py',
" 'auto_export': 1, 

" The first option numbers headers like such:
" 1 Header1
" 1.1 Header2
" 1.2 Header2
" 1.2.1 Header3
" 2 Header1
" etc
"let g:vimwiki_html_header_numbering = 1
" This second option can be set to '.' or ')' to make headers like:
" 1. Header1
" 1.1. Header2
" 1.2. Header2
" 1.2.1. Header3
" or
" 1) Header1
" 1.1) Header2
" 1.2) Header2
" etc
"let g:vimwiki_html_header_numbering_sym = '.'
let g:vimwiki_global_ext = 0
let g:vimwiki_markdown_link_ext = 1
:hi VimwikiHeader1 guifg=#FFAF5F
:hi VimwikiHeader2 guifg=#7B9F57
:hi VimwikiHeader3 guifg=#D7AFFF
:hi VimwikiHeader4 guifg=#DE3358
:hi VimwikiHeader5 guifg=#DE33C7
:hi VimwikiHeader6 guifg=#4F63F7

" }}}
""""""""""""""""""""""""""""

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


" vim:foldmethod=marker:foldlevel=0
