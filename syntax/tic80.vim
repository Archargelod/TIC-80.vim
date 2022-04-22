scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


" If the file is not a cartridge, think the whole file is a lua script.
let s:is_cartridge = getline(1) =~# '-- title:'

let lua_version = 5
let lua_subversion = 3

if s:is_cartridge
  syn include @lua syntax/lua.vim
else
  runtime! syntax/lua.vim
endif


if s:is_cartridge
  syn region tic80Lua transparent matchgroup=tic80Section start="^" end="^-- <TILES>"me=s-1 contains=@lua,tic80Func,fold
  syn region tic80Gfx transparent matchgroup=tic80Section start="^-- <TILES>$" end="^-- </TILES>$" contains=@tic80Pixel,fold
"  syn region tic80Gff transparent matchgroup=tic80Section start="^__gff__$" end="^__\l\+__$" contains=tic80Flag fold
  syn region tic80Label transparent matchgroup=tic80Section start="^-- <SCREEN>$" end="^-- </SCREEN>$" contains=@tic80Pixel fold
  syn region tic80Map transparent matchgroup=tic80Section start="^-- <MAP>$" end="^-- </MAP>$" contains=tic80Sprite fold
  syn region tic80Sfx transparent matchgroup=tic80Section start="^-- <SFX>$" end="^-- </SFX>$" contains=tic80Sequence fold
  syn region tic80Music transparent matchgroup=tic80Section start="^-- <TRACKS>$" end="^-- </TRACKS>$" contains=tic80Track fold
endif

syn cluster luaNormal contains=luaParen,luaTableBlock,luaFunctionBlock,luaIfThen,
      \luaThenEnd,luaElseifThen,luaBlock,luaLoopBlock

if s:is_cartridge
  "syn match tic80Include contained containedin=@lua "#include\>"
else
  "syn match tic80Include "#include\>"
endif

syn keyword tic80Func contained containedin=@luaNormal exit reset sync 
syn keyword tic80Func contained containedin=@luaNormal fget fset font print trace
syn keyword tic80Func contained containedin=@luaNormal BDR BOOT MENU SCN TIC 

syn keyword tic80Func contained containedin=@luaNormal peek poke peek1 poke1 peek2 poke2 peek4 poke4 memcpy memset pmem vbank
syn keyword tic80Func contained containedin=@luaNormal time tstamp
syn keyword tic80Func contained containedin=@luaNormal pix rect rectb circ circb elli ellib line ttri tri trib
syn keyword tic80Func contained containedin=@luaNormal cls map mget mset spr clip
syn keyword tic80Func contained containedin=@luaNormal sfx muxic
syn keyword tic80Func contained containedin=@luaNormal btn btnp key keyp mouse

if s:is_cartridge
  "syn sync match tic80 grouphere tic80Lua "^-->8$"
  "syn sync match tic80 grouphere tic80Lua "^__lua__$"
endif


hi def link tic80Tab luaComment
hi def link tic80Section Title
hi def link tic80Func luaFunc
hi def link tic80Include Include
hi def link tic80ShortIf luaCond
hi def link tic80ShortWhile luaCond


if s:is_cartridge && tic80#get_config('colorize_graphics', 1)
  syn match tic80Color0 contained "0"
  syn match tic80Color1 contained "1"
  syn match tic80Color2 contained "2"
  syn match tic80Color3 contained "3"
  syn match tic80Color4 contained "4"
  syn match tic80Color5 contained "5"
  syn match tic80Color6 contained "6"
  syn match tic80Color7 contained "7"
  syn match tic80Color8 contained "8"
  syn match tic80Color9 contained "9"
  syn match tic80ColorA contained "a"
  syn match tic80ColorB contained "b"
  syn match tic80ColorC contained "c"
  syn match tic80ColorD contained "d"
  syn match tic80ColorE contained "e"
  syn match tic80ColorF contained "f"
  syn cluster tic80Pixel contains=tic80Color0,tic80Color1,tic80Color2,tic80Color3,
        \tic80Color4,tic80Color5,tic80Color6,tic80Color7,
        \tic80Color8,tic80Color9,tic80ColorA,tic80ColorB,
        \tic80ColorC,tic80ColorD,tic80ColorE,tic80ColorF

  function! s:highlight_pixels() abort
    let colors = [
          \   {'gui': '#000000', '16color': 'Black',       '256color': '16'},
          \   {'gui': '#1D2B53', '16color': 'DarkBlue',    '256color': '17'},
          \   {'gui': '#7E2553', '16color': 'DarkMagenta', '256color': '89'},
          \   {'gui': '#008751', '16color': 'DarkGreen',   '256color': '29'},
          \   {'gui': '#AB5236', '16color': 'DarkRed',     '256color': '130'},
          \   {'gui': '#5F574F', '16color': 'DarkGray',    '256color': '241'},
          \   {'gui': '#C2C3C7', '16color': 'LightGray',   '256color': '251'},
          \   {'gui': '#FFF1E8', '16color': 'White',       '256color': '255'},
          \   {'gui': '#FF004D', '16color': 'Red',         '256color': '197'},
          \   {'gui': '#FFA300', '16color': 'DarkYellow',  '256color': '214'},
          \   {'gui': '#FFEC27', '16color': 'Yellow',      '256color': '226'},
          \   {'gui': '#00E436', '16color': 'Green',       '256color': '41'},
          \   {'gui': '#29ADFF', '16color': 'Blue',        '256color': '39'},
          \   {'gui': '#83769C', '16color': 'DarkCyan',    '256color': '103'},
          \   {'gui': '#FF77A8', '16color': 'Magenta',     '256color': '211'},
          \   {'gui': '#FFCCAA', '16color': 'Cyan',        '256color': '223'},
          \ ]

    for index in range(len(colors))
      if &t_Co < 256
        let cterm = colors[index].16color
      else
        let cterm = colors[index].256color
      endif
      let gui = colors[index].gui
      execute printf('hi def tic80Color%X ctermbg=%s ctermfg=%s guibg=%s guifg=%s',
            \ index, cterm, cterm, gui, gui)
    endfor
  endfunction

  call s:highlight_pixels()
endif


unlet s:is_cartridge

let b:current_syntax = 'tic80'


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
