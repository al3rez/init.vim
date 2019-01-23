" Auto-reload when file changes
set autoread


" Escape using jk in all modes (insert, visual, terminal)
inoremap jk <esc>
xnoremap jk <esc>
tnoremap jk <c-\><c-n>
cnoremap jk <esc>


" Do smart auto-indenting when starting a new line
set smartindent


" Display a parenthesized file type after file name in status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


" Display tab line
set showtabline=2

" Display line numbers
set number


" Use comma as <leader>
" NOTE: Which will be used in mapping combinations. For example; `<leader>p`
" translates to `,p` which could be mapped to a function call, command or etc.
let mapleader=","


" Expand %% to current file directory
" NOTE: This makes creating non-existent directories easier. For example; when
" you :e /project/dir1/file and `dir1` doesn't exist you can simply create the
" directory with `:!mkdir %%` instead of typing the full path.
cnoremap %% <C-R>=expand('%:h').'/'<cr>


" Edit files under current file directory
map <leader>e :edit %%


" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
nnoremap <leader>n :call RenameFile()<cr>


" Use ripgrep as grep program
" NOTE: Makes greppig 💉 (bloody) fast
" FAQ: You have to install ripgrep (`brew install ripgrep`)
set grepprg=rg\ --vimgrep\ --color=never\ --no-heading


" NOTE: Opens a buffer containing the search results in linked form,
" suppresses grep full screen output and prevents jumping to the first match
" automatically
" SEE: https://neovim.io/doc/user/quickfix.html#grep
command! -nargs=+ Rg execute 'silent grep! <args>' | copen


" Search the word under the cursor
nnoremap K :Rg "\b<c-r><c-w>\b"<cr>


" Bind \ (backward slash) to grep shortcut to make searching faster
nnoremap \ :Rg<SPACE>


" Delete the buffer without losing/closing the window split
" SEE: https://github.com/neovim/neovim/issues/2434
nnoremap <leader>d :setl bufhidden=delete\|bnext<cr>


" Switch between buffers
" SEE: https://vi.stackexchange.com/a/2187
nnoremap <leader>b :PickerBuffer<cr>


" Search through files
" SEE: https://github.com/cloudhead/neovim-fuzzy
function! FzyCommand()
	if (getbufinfo({'buflisted':1})[0].name == '') == 1
		call picker#Edit()
	else
		call picker#Tabedit()
	endif
endfunction

nnoremap <leader>p :call FzyCommand()<cr>


" Define plugins
" SEE: https://github.com/junegunn/vim-plug
call plug#begin('~/.local/share/nvim/plugged')
" ===================================================================
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-unimpaired'
Plug 'haya14busa/is.vim'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'srstevenson/vim-picker'
" ===================================================================
call plug#end()


" Set color-scheme
set background=dark
colorscheme solarized


" Define file type specific settings
augroup rubyGroup
	" NOTE: Add abbreviations for `<%%>` and `<%=%>` when working with
	" `*.erb` files you can just type `<%` for `<% %>` and `<%=` for `<%=
	" %>` which is much faster than typing manually.
	autocmd FileType eruby iabbrev <%    <%%><left><left>
	autocmd FileType eruby iabbrev <=    <%=%><left><left>

	" RSpec mappings
	autocmd FileType ruby map <leader>R :!./bin/rspec %<CR>
	autocmd FileType ruby map <leader>r :!./bin/rspec %:<C-r>=line('.')<CR><CR>
augroup end

augroup jsGroup
	" NOTE: Add abbreviations for `<%%>` and `<%=%>` when working with
	" `*.erb` files you can just type `<%` for `<% %>` and `<%=` for `<%=
	" %>` which is much faster than typing manually.
	autocmd FileType javascript.jsx set ts=2 sts=2 sw=2 et
	autocmd FileType javascript set ts=2 sts=2 sw=2 et
augroup end

augroup jsGroup
	autocmd FileType javascript set ts=4 sts=4 sw=4 et
augroup end


" Make vertical split separator less than a full column wide
" SEE: https://vi.stackexchange.com/a/2942
hi VertSplit gui=NONE guibg=bg guifg=fg cterm=none


" Remove unfocused tab line underline
hi TabLineFill ctermfg=bg ctermbg=fg cterm=none
hi TabLineSel ctermfg=fg ctermbg=bg cterm=none
hi TabLine ctermfg=bg ctermbg=fg cterm=none


" Use mouse
set mouse=a


" No backup file
set noswapfile
set nobackup


" Overwrite vim-unimpaired [t and ]t to switch bwteen tabs
nnoremap [t :tabp<CR>
nnoremap ]t :tabn<CR>


" Write to file within 100 ms
set updatetime=100


" Close quickfix window with <leader>q
nnoremap <leader>q :ccl<cr>


" Use git-ls-files to make vim-picker faster
let g:picker_find_executable = 'git'
let g:picker_find_flags = 'ls-files --cached --exclude-standard --others'
