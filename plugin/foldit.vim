" README:                               {{{1
" vim-foldit, version 1
" 
" Description:                          {{{2
" Plugin to align all the fold open markers  
" 
" Requirements:                         {{{2
" 
" Installation:                         {{{2
" I highly recommend using Pathogen or Vundler to do the dirty work for you. If
" for some reason, you do not want to use any of these excellent plugins, then
" unzip it to your ~/.vim directory. You know how it goes...  
" 
" So, once that's done, out of the box, the followings mappings are defined by
" default  
" 
" ````
"   zjj : Align all folds  
" ````
" 
" Customisation:                        {{{2
" The defaults not to your liking bub? Have no fear; use the following
" variables to set things just the way you want it  
"
" `g:FoldItDefaultMappings` ( Default : 1 )  
" Will use the default mappings specified below.  
" 
" `g:FoldItPadding` ( Default : 0 )  
" Specify extra padding to be added. By default alignment happens on the next
" tabstop  
"
" `g:FoldItIncAllLines` ( Default : 0 )
" Specify if all lines should be considered while aligning markers. If set to
" 1, the markers will be present outside then length of the longest line.  
"
" ````
"   <Plug>FIT_JustifyFolds : Align all folds
" ````
" 
" ToDo:                                 {{{2
" * Think of things to add here : /  
" 
" 
" Maintainer:                           {{{2
"   Kartik Shenoy  
" 
" Changelist:
"   2012-07-01:  
"     - Initial version
" 
" vim: fdm=syntax:et:ts=4:sw=4:sts=4    }}}1
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists("g:loaded_FoldIt") || &cp
    finish
endif
let g:loaded_FoldIt = "1"  " Version Number
let s:save_cpo      = &cpo
set cpo&vim

if !exists('g:FoldItDefaultMappings')
    let g:FoldItDefaultMappings = 1
endif
if !exists('g:FoldItIncAllLines')
    let g:FoldItIncAllLines = 0
endif
if !exists('g:FoldItPadding')
    let g:FoldItPadding = 0
endif

if g:FoldItDefaultMappings
    if !hasmapto( '<Plug>FIT_JustifyFolds' ) | nmap zjj <Plug>FIT_JustifyFolds| endif
endif

nnoremap <silent> <Plug>FIT_JustifyFolds :call foldit#JustifyFolds()<CR>

"===============================================================================
let &cpo = s:save_cpo
unlet s:save_cpo
