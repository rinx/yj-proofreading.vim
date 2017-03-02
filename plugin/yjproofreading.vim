" yj-proofreading.vim
" Version: 0.0.1
" Author: Rintaro Okamura
" License: MIT

if exists('g:loaded_yj_proofreading')
  finish
endif
let g:loaded_yj_proofreading = 1

let s:save_cpo = &cpo
set cpo&vim

command! -range YahooProofReader <line1>,<line2>call yjproofreading#yahoo_proofreader()

let &cpo = s:save_cpo
unlet s:save_cpo

