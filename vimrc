" Modeline and Notes {
"
"   This is my personal .vimrc, I don't recommend you copy it, just 
"   use the "  pieces you want(and understand!).  When you copy a 
"   .vimrc in its entirety, weird and unexpected things can happen.
"
"   Originally sourced from: 
"   Robert Melton
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
"
    " To install plugin Manager:
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    "     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    " To install plugins: vim +PlugInstall
    call plug#begin('~/.vim/plugged')

    " YouCompleteMe
    " Clang based auto complete and symbol navigation
    " Needs some compile steps. 
    " Needs some helper files.
    "Plug 'Valloric/YouCompleteMe'

	Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Vim movement plugin, allows for cool things but has a learning curve
    " turned it back off for me. Cool enough that I leave it in commented out.
    " Plug 'Lokaltog/vim-easymotion'

    " Cpride's color scheme
    Plug 'chriskempson/base16-vim'

    " Script for switching between headers and cpp/c files
    Plug 'vim-scripts/a.vim'

    " Tweak to C++ syntax highlighting
    "Plug 'octol/vim-cpp-enhanced-highlight'

    " Script for the vim part of rigging movement keys to be unified between
    " tmux and vim
    " I use this to setup one set of key bindings that can move focus between
    " vim splits and tmux splits doing sensible things.
    Plug 'christoomey/vim-tmux-navigator'

    " Integrated grep like plugin for ripgrep
    Plug 'telemenar/vim-ripgrep'

    " Pretty status prompt
    Plug 'bling/vim-airline'

    " Awesome git integration
    " Main thing I use is :Gblame
    Plug 'tpope/vim-fugitive'

    " Fuzzy find for many types of things
    " Plugin outside ~/.vim/plugged with post-update hook
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Rtags integration
    " This requires rtags installed and running:
    " https://github.com/Andersbakken/rtags
    " Requires you to compile with cmake and generate a compile_commands.json
    "Plug 'lyuts/vim-rtags'

    " This is a thing that uses ctags to find the current function and put it
    " the statusbar
    Plug 'majutsushi/tagbar'

    Plug 'fatih/vim-go', { 'tag':'v1.26', 'do': ':GoUpdateBinaries' }

    " Shows changed lines based on git status to the left.
    Plug 'airblade/vim-gitgutter'

    call plug#end()

" }

" General {
    filetype plugin indent on " load filetype plugins/indent settings
    if filereadable(expand("~/.vimrc_background"))
		source ~/.vimrc_background
    endif
	let base16colorspace=256
    colorscheme base16-pop
    highlight Comment cterm=italic
    set backspace=indent,eol,start " make backspace a more flexible
    set nobackup " make backup files
    set nowritebackup " make backup files
    set backupdir=~/.vim/backup " where to put backup files
    set clipboard+=unnamed " share windows clipboard
    set directory=~/.vim/tmp " directory to place swap files in
    set fileformats=unix,dos,mac " support all three, in this order
    set updatetime=300
	set signcolumn=number
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
    set tabstop=4 " real tabs should be 8, and they will show with 
                   " set list on
" }

" Plugin Settings {
    set wildignore+=*.o,*.obj,.git,CMakeFiles,CMakeCache.txt,contrib

    let g:cpp_class_scope_highlight = 1

    let g:plug_timeout = 600

    "let g:ycm_extra_conf_globlist = ['~/src/*','~/src-p4/*','!~/*','!/*']

    let g:aireline_theme = 'tomorrow'
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

     let g:fzf_commits_log_options = '--color=always --format="%C(auto)%h%d <%cn> %s %C(blue)%C(bold)%cr"'
     let g:fzf_layout = { 'down': '~25%' }

     " This is the default plus --no-messages -- because it was showing path
     " errors
     let g:rg_command = 'rg --no-messages --vimgrep'

     
     let g:go_code_completion_enabled = 0
     let g:go_doc_keywordprg_enabled = 0
     let g:go_bin_path = "/home/cpride/go/bin"
	 " GoPath /home/cpride/observe/code/go/src/observe/
     
" }

" Mappings {
    " fzf mappings
    noremap <leader>tt :GitFiles<CR>
    noremap <leader>tb :Buffers<CR>
    noremap <leader>tR :Tags<CR>
    noremap <leader>tr :BTags<CR>

    " space / shift-space scroll in normal mode
    noremap <S-space> <C-b>
    noremap <space> <C-f>


    " rtags mappings
    "let g:rtagsUseDefaultMappings = 0
    nmap <C-f><C-f> <plug>(coc-definition)
    nmap <C-f><C-r> <plug>(coc-references)
    nmap <C-f><C-e> <plug>(coc-references-used)
    nmap <C-f><C-d> <plug>(coc-format)
    nmap <C-f><C-n> <plug>(coc-rename)

    " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    " delays and poor user experience
    set updatetime=300
    
    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved
    set signcolumn=yes
    
    " Use tab for trigger completion with characters ahead and navigate
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    
    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    
    " Use <c-space> to trigger completion
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif
    
    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)


    " Add `:Format` command to format current buffer
    command! -nargs=0 Format :call CocActionAsync('format')

    " split controls
    noremap <C-b> :split<CR>
    noremap <C-v> :vsplit<CR>

    " Close splits/buffers
    noremap <C-g> <C-w>q

    " Escape without reaching
    inoremap jk <Esc>
    
    " Mapping for header/source switching
    noremap  :A<CR> 

    " Search for word under cursor
    nnoremap K :Rg <CR>

" }

" Custom Extension {
    function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" }

