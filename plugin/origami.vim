" README:           {{{1
" vim-origami, version 1
" 
" Description:      {{{2
" Plugin to satisfy all your folding needs
"  * Justify all the open-fold markers
"  * Create new open-fold marker and justify it automatically
" 
" Requirements:     {{{2
" 
" Installation:     {{{2
" I highly recommend using Pathogen or Vundler to do the dirty work for you. If
" for some reason, you do not want to use any of these excellent plugins, then
" unzip it to your ~/.vim directory. You know how it goes...  
" 
" So, once that's done, out of the box, the followings mappings are defined by
" default  
" 
" ````
"   ztt : Align all folds  
"   zxt : When 'x' is a number from 1-9, align folds of that particular fold-level
"         When 'x' is 0, align all unnumbered folds
"   zxf : Create a new justified open-fold marker of fold-level 'x'
"         When 'x' is 0, create new unnumbered open-fold marker
"   zxF : Same as above, but also comments the marker. Requires NERDCommenter
" ````
" 
" Customisation:    {{{2
" The defaults not to your liking bub? Have no fear; use the following
" variables to set things just the way you want it  
" 
" `g:OrigamiDefaultMappings` ( Default : 1 )  
" Will use the default mappings specified below.  
" 
" `g:OrigamiPadding` ( Default : 0 )  
" Specify extra padding to be added. By default alignment happens on the next tabstop.  
" This behaves differently depending on whether `expandtab` is set or not. If yes, this specifies the number of spaces to insert and if not,  
" it specifies the number of tabs to be inserted.
" 
" `g:OrigamiIncAllLines` ( Default : 0 )  
" Specify if all lines should be considered while aligning markers or only those having the marker.  
" If set to 1, the markers will be present outside the length of the longest line irrespective of if it has a fold-open marker or not.
" 
" `g:OrigamiSeparateLvls` ( Default : 0 )  
" Align different fold-levels independently
" 
" `g:OrigamiFoldAtCol` ( Default : 0 )  
" Force the markers to align at the specified column. If set to 0, will
" auto-detect alignment position.
" 
" 
" ToDo:             {{{2
" * Think of things to add here : /
" 
"
" Maintainer:       {{{2
"   Kartik Shenoy  
" 
" Changelist:
"   2012-07-02:  
"     - Made the marker insertion method dependent upon tab settings
"     - Added options to align different fold-levels independently
"     - Added support to insert marker at a fixed column
"     - Added support to insert fold-open markers
"
"   2012-07-01:  
"     - Initial version
" 
" }}}1
" vim: fdm=marker:et:ts=4:sw=4:sts=4
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists("g:loaded_Origami") || &cp
    finish
endif
let g:loaded_Origami = "1"  " Version Number
let s:save_cpo      = &cpo
set cpo&vim

if !exists('g:OrigamiDefaultMappings')
    let g:OrigamiDefaultMappings = 1
endif
if !exists('g:OrigamiIncAllLines')
    let g:OrigamiIncAllLines = 0
endif
if !exists('g:OrigamiPadding')
    let g:OrigamiPadding = 0
endif
if !exists('g:OrigamiSeparateLvls')
    let g:OrigamiSeparateLvls = 0
endif
if exists('g:OrigamiFoldAtCol') && g:OrigamiFoldAtCol > 0
    let g:OrigamiSeparateLvls = 0
    let g:OrigamiPadding    = 0
endif

nnoremap <silent> ztt :call origami#TidyFolds("%")<CR>
for i in range(1, 9)
    silent exec 'nnoremap <silent> z' . i . 't :call origami#TidyFolds(' . i . ')<CR>'
    silent exec 'nmap <silent> z' . i . 'f   A{{{' . i . '<ESC>z' . i . 't'
    silent exec 'nmap <silent> z' . i . 'F ,cA{{{' . i . '<ESC>z' . i . 't'
endfor
nnoremap <silent> z0t :call origami#TidyFolds(0)<CR>
nmap <silent> z0f   A{{{<ESC>z0t
nmap <silent> z0F ,cA{{{<ESC>z0t


"===============================================================================
let &cpo = s:save_cpo
unlet s:save_cpo
