" Pathogen Plugin Manager
silent! execute pathogen#infect()

" mouse activation
set mouse=a
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end
" turn on line numbers
set nu
" universal clipboard
set cb=unnamedplus

" Set the bottom statusline to display useful information
set laststatus=2
set statusline=%#function#%f%=%m%r\ (%l,%c)\ %l/%L\ %y\ --%P--

" color
filetype plugin on
syntax enable
colorscheme elflord
" allow formatting of line numbers
set cursorline
" clear stupid full line underline
hi! clear cursorline
hi! CursorLine    ctermbg=None
" highlight line numbers
hi! LineNr        ctermfg=DarkGray
hi! CursorLineNr  ctermfg=White       cterm=bold
" special syntax highlighting
hi! Comment       ctermfg=DarkMagenta cterm=None
hi! Constant      ctermfg=Blue        cterm=None
hi! Type          ctermfg=Yellow      cterm=None
hi! Statement     ctermfg=DarkCyan    cterm=None
hi! Function      ctermfg=Gray        cterm=None
hi! Special       ctermfg=DarkYellow  cterm=None
hi! Conditional   ctermfg=Gray        cterm=None
hi! PreProc       ctermfg=Green       cterm=None
hi! MatchParen    ctermfg=Magenta     cterm=Bold    ctermbg=None
hi! Todo          ctermfg=Black       cterm=Bold    ctermbg=DarkMagenta
hi! Search        ctermfg=Black       cterm=Bold    ctermbg=Magenta


hi! def link Operator Statement
hi! def link Repeat   Conditional
hi! def link Booean   Type

hi! DiffAdd       ctermbg=DarkGreen   cterm=bold
hi! DiffDelete    ctermbg=DarkRed     cterm=bold    ctermfg=Gray
hi! DiffChange    ctermbg=DarkBlue    cterm=bold
hi! DiffText      ctermbg=Blue        cterm=bold

hi! def link cucumberGiven       Function
hi! def link cucumberWhen        Statement
hi! def link cucumberDelimeter   Function
  

" highlight {},[],()'s (note: only kinda works...)
" autocmd Bufread,BufNewFile * syn match StartStopSymbols /[{}()[]]/ | hi def link StartStopSymbols Conditional

" cursor switching
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" tab spacing and auto-indent
filetype indent on
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

" smartcase searching
" set smartcase
" set ignorecase

" set split to the right
set splitright

" minor typo correction
command! W w
command! Q q
command! WQ wq
command! SV source ~/.vimrc

" set search with clicks
:nnoremap <2-LeftMouse> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
:inoremap <2-LeftMouse> <esc>:let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" Set search with ,
:nnoremap , :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" easy comments
inoremap /**/     /*<Space><Space>*/<Esc>hhi
inoremap CASE:    case :<Esc>obreak;<Esc>k<End>i
"inoremap TDR      # TODO: Remove me
inoremap TDR      // TODO: Remove me

inoremap PRED       \033[31m\033[0m<Esc>hhhhhhi
inoremap PGREEN     \033[32m\033[0m<Esc>hhhhhhi
inoremap PYELLOW    \033[33m\033[0m<Esc>hhhhhhi
inoremap PBLUE      \033[34m\033[0m<Esc>hhhhhhi
inoremap PPURP      \033[35m\033[0m<Esc>hhhhhhi
inoremap PCYAN      \033[36m\033[0m<Esc>hhhhhhi

"
" c++ logger statements
"

"inoremap LGTMP  printf("\033[33m >>> \033[0m"); // TODO: Remove me<Esc>hhhhhhhhhhhhhhhhhhhhhhhhhhhhi
inoremap LGTMP  FATAL_MSG("\n >>>>>>\n >>>>>> \n >>>>>>"); // TODO: Remove me<Esc>hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhi

"
" python logger statements
"

"inoremap LGTMP  LOGGER.critical(f"\033[35m\033[0m") # TODO: Remove me<Esc>hhhhhhhhhhhhhhhhhhhhhhhhhhi
"inoremap LGDB   LOGGER.debug(f"")<Esc>hi
"inoremap LGIN   LOGGER.info(f"")<Esc>hi
"inoremap LGWA   LOGGER.warning(f"")<Esc>hi
"inoremap LGER   LOGGER.error(f"")<Esc>hi
"inoremap LGCR   LOGGER.critical(f"")<Esc>hi
"inoremap LGFDP  self.logger.critical_u("\033[33m >>> \033[0m".format()) # TODO Remove me<Esc>hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhi

"
" jinja2 templating
"

"inoremap {{   {{  }}<Esc>hhi
"inoremap {%   {%  %}<Esc>hhi
"inoremap {IF  {% if  %}<Esc>o{% endif %}<Esc>ko<Esc>k<End>hhi
"inoremap {FOR {% for  in  %}<Esc>o{% endfor %}<Esc>ko<Esc>k<End>hhhhhhi
"inoremap {SET {% set  %}<Esc>o{% endset %}<Esc>ko<Esc>k<End>hhi

"
" C++ things
"

inoremap CPPP   std::cout << "" << std::endl;<Esc>hhhhhhhhhhhhhhi

"
" GITBlame
"
command! GITBlame normal!:let @a=expand('%')<CR>:vne<CR>:set bt=nofile<CR>:set filetype=GITBlame<CR>:%!git blame --date short -wM <C-R>a<CR>:<C-R>b<CR>

"
" Simple functions
"
command! L set nosplitright
command! R set splitright

"
" Tagging help
"
" tag searching in a new vsplit with ctrl+space+]
nnoremap <C-@>] <C-W>v<C-]>
" set tags to recurse upwards
set tags=./tags;,tags;


"
" Diff mappings
"
if &diff
  nnoremap nd ]c
  nnoremap pd [c
  nnoremap ad do
  nnoremap rd :diffupdate<CR>
  :normal gg]c
endif


"
" Left Split
"
command! -nargs=1 -complete=file LS call SplitLeft(<f-args>)
function! SplitLeft(filepath)
  set nosplitright
  execute "vsplit" a:filepath
  set splitright
endfunction

"
" QuitLeft and QuitRight commands
" Quit curent window and all windows to the left or right
"
command! QR call QuitRight()
command! QL call QuitLeft()
function! QuitRight()
  if _isFarthestLeft() == 1
    :qa
  endif
  if _isFarthestRight() == 1
    :q
    return 0
  endif
  set splitright
  " exit, move right, check, repet
  while 1
    " quit
    try
      :q
    catch
    endtry

    " Move right
    wincmd l

    " check
    if _isFarthestRight() == 1
      " if this is now the fathst right, w are done
      try
        :q
      catch
      endtry
      return 0
    endif
  endwhile
endfunction

function! QuitLeft()
  if _isFarthestRight() == 1
    :qa
  endif
  if _isFarthestLeft() == 1
    :q
    return 0
  endif
  set splitright
  " check, quit, repeat
  while 1
    " record current window
    let check = _isFarthestLeft()
    " quit
    try
      :q
    catch
      wincmd h
    endtry

    " if it was the last window to quit, return
    if check == 1
      return
    endif
  endwhile
endfunction

" HELPER FUUNCTIONS

function! _isFarthestRight()
  let current = winnr()
  wincmd l
  if winnr() == current
    return 1
  endif
  wincmd h
  return 0
endfunction

function! _isFarthestLeft()
  let current = winnr()
  wincmd h
  if winnr() == current
    return 1
  endif
  wincmd l
  return 0
endfunction


" Navigate xml tags with a+t and o
"
" Remember folds (make fold with zf)
"augroup remember_folds
"  autocmd!
"  autocmd BufWinLeave * mkview
"  autocmd BufWinEnter * silent! loadview
"augroup END

