" vim: fdm=marker:et:ts=2:sw=2:sts=2
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists('g:loaded_Origami') || &cp
  finish
endif
let g:loaded_Origami = 1

if !exists('g:OrigamiSeparateLevels')   | let g:OrigamiSeparateLevels   = 0 | endif
if !exists('g:OrigamiFoldAtCol')        | let g:OrigamiFoldAtCol        = 0 | endif
if !exists('g:OrigamiIncAllLines')      | let g:OrigamiIncAllLines      = 0 | endif
if !exists('g:OrigamiStaggeredSpacing') | let g:OrigamiStaggeredSpacing = 0 | endif
if !exists('g:OrigamiPadding')          | let g:OrigamiPadding          = 0 | endif

if !exists ('g:OrigamiMap'                    ) | let g:OrigamiMap                     = {}          | endif
if !has_key( g:OrigamiMap, 'Leader'           ) | let g:OrigamiMap['Leader']           = "<Leader>z" | endif
if !has_key( g:OrigamiMap, 'Align'            ) | let g:OrigamiMap['Align']            = "a"         | endif
if !has_key( g:OrigamiMap, 'CommentedOpen'    ) | let g:OrigamiMap['CommentedOpen']    = "O"         | endif
if !has_key( g:OrigamiMap, 'CommentedClose'   ) | let g:OrigamiMap['CommentedClose']   = "C"         | endif
if !has_key( g:OrigamiMap, 'UncommentedOpen'  ) | let g:OrigamiMap['UncommentedOpen']  = "o"         | endif
if !has_key( g:OrigamiMap, 'UncommentedClose' ) | let g:OrigamiMap['UncommentedClose'] = "c"         | endif
if !has_key( g:OrigamiMap, 'Delete'           ) | let g:OrigamiMap['Delete'            = "d"         | endif

if !exists ('g:OrigamiMapLevel'                    ) | let g:OrigamiMapLevel                     = {} | endif
if !has_key( g:OrigamiMapLevel, 'CommentedOpen'    ) | let g:OrigamiMapLevel['CommentedOpen']    = "" | endif
if !has_key( g:OrigamiMapLevel, 'CommentedClose'   ) | let g:OrigamiMapLevel['CommentedClose']   = "" | endif
if !has_key( g:OrigamiMapLevel, 'UncommentedOpen'  ) | let g:OrigamiMapLevel['UncommentedOpen']  = "" | endif
if !has_key( g:OrigamiMapLevel, 'UncommentedClose' ) | let g:OrigamiMapLevel['UncommentedClose'] = "" | endif

" Set up maps
if g:OrigamiMap['Align'] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['Align']
        \ . ' :call origami#AlignFoldmarkers()<CR>'
endif
if g:OrigamiMap['UncommentedOpen'] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['UncommentedOpen']
        \ . ' :call origami#InsertFoldmarker( "open",  "nocomment" )<CR>'
endif
if g:OrigamiMap[''] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['UncommentedClose']
        \ . ' :call origami#InsertFoldmarker( "close", "nocomment" )<CR>'
endif
if g:OrigamiMap[''] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['CommentedOpen']
        \ . ' :call origami#InsertFoldmarker( "open",  "comment"   )<CR>'
endif
if g:OrigamiMap[''] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['CommentedClose']
        \ . ' :call origami#InsertFoldmarker( "close", "comment"   )<CR>'
endif
if g:OrigamiMap[''] != ""
  execute 'nnoremap <silent> <unique> ' . g:OrigamiMap['Leader'] . g:OrigamiMap['DeleteFoldmarker']
        \ . ' :call origami#DeleteFoldmarker()<CR>'
endif
