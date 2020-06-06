setlocal tw=80
setlocal colorcolumn=80

"let b:syntastic_checkers = findfile('.eslintrc.json', '.;') != '' || findfile('.eslintrc', '.;') != '' ? ['eslint'] : ['jshint']
"let b:syntastic_eslint_exec = './node_modules/.bin/eslint'

let b:ale_linters = findfile('.eslintrc.json', '.;') != '' || findfile('.eslintrc', '.;') != '' ? ['eslint'] : []

"set ts=2
"set sw=2
