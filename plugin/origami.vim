" vim: fdm=marker:et:ts=4:sw=4:sts=4
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists('g:loaded_Origami') || &cp
  finish
endif
let g:loaded_Origami = 1

if !exists('g:OrigamiDefaultMappings')  | let g:OrigamiDefaultMappings  = 1 | endif
if !exists('g:OrigamiSeparateLevels')   | let g:OrigamiSeparateLevels   = 0 | endif
if !exists('g:OrigamiFoldAtCol')        | let g:OrigamiFoldAtCol        = 0 | endif
if !exists('g:OrigamiIncAllLines')      | let g:OrigamiIncAllLines      = 0 | endif
if !exists('g:OrigamiStaggeredSpacing') | let g:OrigamiStaggeredSpacing = 0 | endif
if !exists('g:OrigamiPadding')          | let g:OrigamiPadding          = 0 | endif

" Set up Plugs
nnoremap <silent> <Plug>OrigamiAlignFoldmarkers           :call origami#AlignFoldmarkers()<CR>
nnoremap <silent> <Plug>OrigamiUncommentedFoldmarkerOpen  :call origami#InsertFoldmarker( 'open',  'nocomment' )<CR>
nnoremap <silent> <Plug>OrigamiUncommentedFoldmarkerClose :call origami#InsertFoldmarker( 'close', 'nocomment' )<CR>
nnoremap <silent> <Plug>OrigamiCommentedFoldmarkerOpen    :call origami#InsertFoldmarker( 'open',  'comment'   )<CR>
nnoremap <silent> <Plug>OrigamiCommentedFoldmarkerClose   :call origami#InsertFoldmarker( 'close', 'comment'   )<CR>
nnoremap <silent> <Plug>OrigamiDeleteFoldmarker           :call origami#DeleteFoldmarker()<CR>

if !exists('g:OrigamiShortcut')                           | let g:OrigamiShortcut                          = {}  | endif
if !has_key( g:OrigamiShortcut, 'Align'            )      | let g:OrigamiShortcut['Align']                 = "a" | endif
if !has_key( g:OrigamiShortcut, 'CommentedOpen'    )      | let g:OrigamiShortcut['CommentedOpen']         = "O" | endif
if !has_key( g:OrigamiShortcut, 'CommentedClose'   )      | let g:OrigamiShortcut['CommentedClose']        = "C" | endif
if !has_key( g:OrigamiShortcut, 'UncommentedOpen'  )      | let g:OrigamiShortcut['UncommentedOpen']       = "o" | endif
if !has_key( g:OrigamiShortcut, 'UncommentedClose' )      | let g:OrigamiShortcut['UncommentedClose']      = "c" | endif
if !exists('g:OrigamiShortcutLevel')                      | let g:OrigamiShortcutLevel                     = {}  | endif
if !has_key( g:OrigamiShortcutLevel, 'CommentedOpen'    ) | let g:OrigamiShortcutLevel['CommentedOpen']    = ""  | endif
if !has_key( g:OrigamiShortcutLevel, 'CommentedClose'   ) | let g:OrigamiShortcutLevel['CommentedClose']   = ""  | endif
if !has_key( g:OrigamiShortcutLevel, 'UncommentedOpen'  ) | let g:OrigamiShortcutLevel['UncommentedOpen']  = ""  | endif
if !has_key( g:OrigamiShortcutLevel, 'UncommentedClose' ) | let g:OrigamiShortcutLevel['UncommentedClose'] = ""  | endif

" Set up default maps
if g:OrigamiDefaultMappings
  if !hasmapto( '<Plug>OrigamiAlignFoldmarkers' )
    nmap <silent> <unique> <leader>za <Plug>OrigamiAlignFoldmarkers
  endif
  if !hasmapto( '<Plug>OrigamiUncommentedFoldmarkerOpen' )
    nmap <silent> <unique> <leader>zo <Plug>OrigamiUncommentedFoldmarkerOpen
  endif
  if !hasmapto( '<Plug>OrigamiUncommentedFoldmarkerClose' )
    nmap <silent> <unique> <leader>zc <Plug>OrigamiUncommentedFoldmarkerClose
  endif
  if !hasmapto( '<Plug>OrigamiCommentedFoldmarkerOpen' )
    nmap <silent> <unique> <leader>zO <Plug>OrigamiCommentedFoldmarkerOpen
  endif
  if !hasmapto( '<Plug>OrigamiCommentedFoldmarkerClose' )
    nmap <silent> <unique> <leader>zC <Plug>OrigamiCommentedFoldmarkerClose
  endif
  if !hasmapto( '<Plug>OrigamiDeleteFoldmarker' )
    nmap <silent> <unique> <leader>ze <Plug>OrigamiDeleteFoldmarker
  endif
endif
