scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


function! tic80#get_config(key, ...) abort
  let default = a:0 > 0 ? a:1 : 0
  if !has_key(g:, 'tic80_config')
    return default
  endif
  return get(g:tic80_config, a:key, default)
endfunction


function! tic80#run(mods, options) abort
  let cmdline = '"' . tic80#get_config('tic80_path', 'tic80') . '" ' . expand('%:p:S')
  if has('win32')
    " PICO-8 on Windows does not output logs if run directly.
    let cmdline = $ComSpec . ' /C "' . cmdline . '"'
  endif

  if has('nvim')
    execute a:mods 'split' join(filter(a:options, 'v:val =~ "^+"')) 'term://' . fnameescape(cmdline)
  else
    execute a:mods 'terminal' join(filter(a:options, 'v:val =~ "^++"')) cmdline
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo


" vim: et sw=2 sts=-1
