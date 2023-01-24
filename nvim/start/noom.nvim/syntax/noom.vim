syn keyword nmKeyword let const return if else for break continue in match

syn region nmString start=+'+ skip=+\\'+ end=+'+
syn region nmString start=+"+ skip=+\\"+ end=+"+

syn match nmNumber "\<\d\+\>"
syn match nmNumber "\<\d*.\d\+\>"

syn match nmLabel ":\w\+:"
syn match nmBuiltin "@\w\+\>"

syn match nmBracket "\((\|)\|{\|}\|\[\|\]\)"
syn match nmBracket "\(\.(\|\.{\)"
syn match nmComma ","
syn match nmSemic ";"

syn match nmComment "//.*$"

hi def link nmKeyword Keyword
hi def link nmString String
hi def link nmNumber Number
hi def link nmNumber Number
hi def link nmLabel Label
hi def link nmBuiltin Special
hi def link nmComma Delimiter
hi def link nmSemic Delimiter
hi def link nmBracket Delimiter
hi def link nmComment Comment
