set background=dark
let g:colors_name="molo"

lua package.loaded['lush_theme.molo'] = nil
lua require('lush')(require('lush_theme.molo'))
