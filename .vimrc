" Modeline and Notes {
"
"   This is my personal .vimrc, I don't recommend you copy it, just 
"   use the "  pieces you want(and understand!).  When you copy a 
"   .vimrc in its entirety, weird and unexpected things can happen.
"
"   If you find an obvious mistake hit me up at:
"   http://robertmelton.com/contact (many forms of communication)
" }

" Basics {
    if !has('nvim')
        set nocompatible " explicitly get out of vi-compatible mode
    endif
    set noexrc " don't use local version of .(g)vimrc, .exrc
    set background=dark " we plan to use a dark background
    set cpoptions=aABceFsmq
    "             |||||||||
    "             ||||||||+-- When joining lines, leave the cursor 
    "             |||||||      between joined lines
    "             |||||||+-- When a new match is created (showmatch) 
    "             ||||||      pause for .5
    "             ||||||+-- Set buffer options when entering the 
    "             |||||      buffer
    "             |||||+-- :write command updates current file name
    "             ||||+-- Automatically add <CR> to the last line 
    "             |||      when using :@r
    "             |||+-- Searching continues at the end of the match 
    "             ||      at the cursor position
    "             ||+-- A backslash has no special meaning in mappings
    "             |+-- :write updates alternative file name
    "             +-- :read updates alternative file name
    syntax on " syntax highlighting on
    "set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    "              | | | | |  |   |      |  |     |    |
    "              | | | | |  |   |      |  |     |    + current 
    "              | | | | |  |   |      |  |     |       column
    "              | | | | |  |   |      |  |     +-- current line
    "              | | | | |  |   |      |  +-- current % into file
    "              | | | | |  |   |      +-- current syntax in 
    "              | | | | |  |   |          square brackets
    "              | | | | |  |   +-- current fileformat
    "              | | | | |  +-- number of lines
    "              | | | | +-- preview flag in square brackets
    "              | | | +-- help flag in square brackets
    "              | | +-- readonly flag in square brackets
    "              | +-- rodified flag in square brackets
    "              +-- full path to file in the buffer

" }

" Plugin Manager {
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    "     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    call plug#begin('~/.vim/plugged')

    " YouCompleteMe
    " Clang based auto complete and symbol navigation
    " Needs some compile steps.
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' } 
    " Baseline variant of this plugin
    " Plug 'oblitum/YouCompleteMe' 
    " Variant with automaticlly completing function parameters.

    " Vim movement plugin, just recommend googling it. 
    " Plug 'Lokaltog/vim-easymotion'

    " Cpride's color scheme
    Plug 'chriskempson/base16-vim'

    " Script for switching between headers and cpp/c files
    Plug 'vim-scripts/a.vim'

    Plug 'octol/vim-cpp-enhanced-highlight'

    " Script for the vim part of rigging movement keys to be unified between
    " tmux and vim
    Plug 'christoomey/vim-tmux-navigator'

    " Integrated grep like plugin
    " Plug 'rking/ag.vim'
    Plug 'mileszs/ack.vim'

    " Pretty status prompt
    Plug 'bling/vim-airline'

    " Awesome git integration
    Plug 'tpope/vim-fugitive'

    " Fuzzy completion code navigation plugin
    "Plug 'ctrlpvim/ctrlp.vim'
    "Plug 'kien/ctrlp.vim'

    " Plugin outside ~/.vim/plugged with post-update hook
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Faster fuzzy matching for ctrlp
    " need compilation
    "Plug 'telemenar/ctrlp-cmatcher', { 'do': './install.sh' }
    
    " Rtags integration
    Plug 'lyuts/vim-rtags'

    Plug 'majutsushi/tagbar'

    Plug 'airblade/vim-gitgutter'

    call plug#end()

" }

" General {
    filetype plugin indent on " load filetype plugins/indent settings
    let base16colorspace=256  " Access colors present in 256 colorspace
    colorscheme base16-pop
    set backspace=indent,eol,start " make backspace a more flexible
    set backup " make backup files
    set backupdir=~/.vim/backup " where to put backup files
    set clipboard+=unnamed " share windows clipboard
    set directory=~/.vim/tmp " directory to place swap files in
    set fileformats=unix,dos,mac " support all three, in this order
    set hidden " you can change buffers without saving
    " (XXX: #VIM/tpope warns the line below could break things)
    set noerrorbells " don't make noise
    set whichwrap=b,s,h,l,<,>,~,[,] " everything wraps
    "             | | | | | | | | |
    "             | | | | | | | | +-- "]" Insert and Replace
    "             | | | | | | | +-- "[" Insert and Replace
    "             | | | | | | +-- "~" Normal
    "             | | | | | +-- <Right> Normal and Visual
    "             | | | | +-- <Left> Normal and Visual
    "             | | | +-- "l" Normal and Visual (not recommended)
    "             | | +-- "h" Normal and Visual (not recommended)
    "             | +-- <Space> Normal and Visual
    "             +-- <BS> Normal and Visual
    set wildmenu " turn on command line completion wild style
    " ignore these list file extensions
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,
                    \*.jpg,*.gif,*.png
    set wildmode=list:longest " turn on wild mode huge list

    set mouse=a
    if !has('nvim')
        set ttyfast
        set ttymouse=sgr
    endif
" }

" Vim UI {
    set incsearch " BUT do highlight as you type you 
                   " search phrase
    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines 
                     " betweens rows
    set nolist
    "set list " we do what to show tabs, to ensure we get them 
              " out of my files
    "set listchars=trail:- " show tabs and trailing 
    set matchtime=5 " how many tenths of a second to blink 
                     " matching brackets for
    set nostartofline " leave my cursor where it was
    set novisualbell " don't blink
    set number " turn on line numbers
    set numberwidth=5 " We are good up to 99999 lines
    set report=0 " tell us when anything is changed via :...
    set ruler " Always show current positions along the bottom
    set scrolloff=10 " Keep 10 lines (top/bottom) for scope
    set shortmess=aOstT " shortens messages to avoid 
                         " 'press a key' prompt
    set showcmd " show the command being typed
    set showmatch " show matching brackets
    set sidescrolloff=10 " Keep 5 lines at the size
" }

" Text Formatting/Layout {
    set completeopt= " don't use a pop up menu for completions
    set expandtab " no real tabs please!
    set formatoptions=rq " Automatically insert comment leader on return, 
                          " and let gq format comments
    set ignorecase " case insensitive by default
    set infercase " case inferred by default
    set nowrap " do not wrap line
    set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
    set smartcase " if there are caps, go case-sensitive
    set shiftwidth=4 " auto-indent amount when using cindent, 
                      " >>, << and stuff like that
    set softtabstop=4 " when hitting tab or backspace, how many spaces 
                       "should a tab be (see expandtab)
    set tabstop=8 " real tabs should be 8, and they will show with 
                   " set list on
" }

" Plugin Settings {
    "let b:match_ignorecase = 1 " case is stupid
    " let perl_extended_vars=1 " highlight advanced perl vars 
                              " inside strings
    set wildignore+=*.o,*.obj,.git,CMakeFiles,doc,CMakeCache.txt,contrib

    let g:cpp_class_scope_highlight = 1
    
    let g:ycm_extra_conf_globlist = ['~/src/*','~/src-p4/*','!~/*','!/*']

    let g:aireline_theme = 'tomorrow'
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif

    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
    let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }
     let g:airline#extensions#whitespace#enabled = 0
     let g:airline#extensions#tmuxline#enabled = 0 
     let g:airline#extensions#tabline#enabled = 1
     let g:airline#extensions#tabline#show_buffers = 0

     let g:ctrlp_extensions = ['tag', 'buffertag']
     let g:ctrlp_clear_cache_on_exit = 0
     let g:ctrlp_match_window = 'order:ttb'
     let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

     let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s \( -type d -name .git -prune \) -o \( -type d -name .svn -prune \) -o \( -type d -name .deps -prune \) -o \( -type d -name .libs -prune \) -o ${EXCLUDE_CONTRIB} \( -type d -path "${EXCLUDE_MINIFIED_JS}" -prune \) -o \( -type d -name logs -prune \) -o \( -type d -name CVS -prune \) -o \( -type f -name "*.[oa]" -prune \) -o \( -type f -name "*.l[oa]" -prune \) -o \( -type f -name "*.so" -prune \) -o \( -type f -name ".*.swp" -prune \) -o \( -type f -iname "*.txt" -prune \) -o \( -type f -iname "*.csv" -prune \) -o -type f']
     let g:ctrlp_lazy_update = 100

     let g:ctrlp_buftag_types = {
                 \ 'cpp' : 
                 \ '--extra=+q',
                 \ } 

     let g:ack_autofold_results = 1
     let g:ackprg = "git grep -n"

     let g:fzf_commits_log_options = '--color=always --format="%C(auto)%h%d <%cn> %s %C(blue)%C(bold)%cr"'
     let g:fzf_layout = { 'down': '~25%' }
" }

" Mappings {
    " space / shift-space scroll in normal mode
    noremap <leader>tt :GitFiles<CR>
    noremap <leader>tb :Buffers<CR>
    noremap <leader>tR :Tags<CR>
    noremap <leader>tr :BTags<CR>
    noremap <S-space> <C-b>
    noremap <space> <C-f>

    let g:rtagsUseDefaultMappings = 0
    noremap <C-f><C-f> :call rtags#JumpTo()<CR>
    noremap <C-f><C-i> :call rtags#SymbolInfo()<CR>
    noremap <C-f><C-r> :call rtags#FindRefs()<CR>

    noremap <C-b> :split<CR>
    noremap <C-v> :vsplit<CR>

    noremap <C-g> <C-w>q
    noremap <C-G> :bd<CR>

    inoremap jk <Esc>
    
    noremap  :A<CR> 

    " The Silver Searcher
    " Use ag over grep

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    "let g:ctrlp_user_command = 'ag %s -l --ignore search_mrsparkle --ignore CMakeFiles --ignore contrib --ignore "*.js" --ignore "*.py" --ignore "*.png" --ignore "*.html" --ignore "*.css" --ignore "*.xml" -G "^.*\.(cpp\|h\|c\|.in)$" --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    " let g:ctrlp_use_caching = 0

    " bind K to grep word under cursor
    nnoremap K :Ack! "\b<C-R><C-W>\b" "src/" "cfg/bundles/default/" "cfg/bundles/README/" <CR>


    " Make Arrow Keys Useful Again {
   "     map <down> <ESC>:bn<RETURN>
   "     map <left> <ESC>:NERDTreeToggle<RETURN>
   "     map <right> <ESC>:Tlist<RETURN>
   "     map <up> <ESC>:bp<RETURN>
    " }
" }

