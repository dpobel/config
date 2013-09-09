
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <buffer> <C-d> :call pdv#DocumentWithSnip()<CR>
noremap <F5>  :!~/.vim/shell/ctags.sh % > /dev/null 2>&1 &<CR>
inoremap <F5>  <ESC>:!~/.vim/shell/ctags.sh % > /dev/null 2>&1 &<CR>i

setlocal tw=80
setlocal colorcolumn=80

