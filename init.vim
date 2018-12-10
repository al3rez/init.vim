" Enable syntax highlighting
syntax on


" Use true colors (24 bit/GUI colors)
set termguicolors


" Auto-reload when file changes
set autoread


" Escape using jk in all modes (insert, visual, terminal)
inoremap jk <esc>
xnoremap jk <esc>
tnoremap jk <c-\><c-n>


" Do smart auto-indenting when starting a new line
set smartindent


" Display a parenthesized file type after file name in status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


" Display tab line
set showtabline=2


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


" Delete the buffer without losing/closing the window split
" SEE: https://github.com/neovim/neovim/issues/2434
nnoremap <leader>d :setl bufhidden=delete\|bnext<cr>


" Switch between buffers
" SEE: https://vi.stackexchange.com/a/2187
nnoremap <leader>b :ls<cr>:b<space>


" Search through files
" SEE: https://github.com/cloudhead/neovim-fuzzy
nnoremap <leader>p :FuzzyOpen<cr>


" Define plugins
" SEE: https://github.com/junegunn/vim-plug
call plug#begin('~/.local/share/nvim/plugged')
" ===================================================================

" Add fzy integration (to search through files)
" SEE: https://github.com/cloudhead/neovim-fuzzy
" FAQ: You have to install fzy (`brew install fzy`)
" FAQ: You have to install rg or ag (`brew install ripgrep/ag`)
Plug 'cloudhead/neovim-fuzzy', { 'on': 'FuzzyOpen' }


" Add JavaScript and JSX support
" SEE: https://github.com/pangloss/vim-javascript
" SEE: https://github.com/mxw/vim-jsx
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }


" Add Elixir support
" SEE: https://github.com/vim-ruby/vim-ruby
Plug 'elixir-editors/vim-elixir', { 'for': ['elixir', 'eelixir'] }

" Improve Ruby support
" SEE: https://github.com/vim-ruby/vim-ruby
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }


" Landscape color-scheme
" SEE: https://github.com/itchyny/landscape.vim
Plug 'itchyny/landscape.vim'


" Make tab line look better
" SEE: https://github.com/mkitt/tabline.vim
Plug 'mkitt/tabline.vim'

" ===================================================================
call plug#end()


" Set color-scheme
colorscheme landscape


" Define file type specific settings
augroup rubyGroup
	" NOTE: Add abbreviations for `<%%>` and `<%=%>` when working with
	" `*.erb` files you can just type `<%` for `<% %>` and `<%=` for `<%=
	" %>` which is much faster than typing manually.
	autocmd FileType eruby iabbrev <%    <%%><left><left>
	autocmd FileType eruby iabbrev <=    <%=%><left><left>
augroup end


" Make vertical split separator less than a full column wide
" SEE: https://vi.stackexchange.com/a/2942
hi VertSplit guibg=bg guifg=fg
