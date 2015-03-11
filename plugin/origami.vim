" vim: fdm=marker:et:ts=2:sw=2:sts=2
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists('g:loaded_Origami') || &cp
  finish
endif
let g:loaded_Origami = 1

function! s:Set(var, default)                                                                                     " {{{1
  if !exists(a:var)
    if type(a:default)
      execute 'let' a:var '=' string(a:default)
    else
      execute 'let' a:var '=' a:default
    endif
  endif
  return a:var
endfunction
call s:Set('g:OrigamiSeparateLevels',   0 )
call s:Set('g:OrigamiFoldAtCol',        0 )
call s:Set('g:OrigamiIncAllLines',      0 )
call s:Set('g:OrigamiStaggeredSpacing', 0 )
call s:Set('g:OrigamiPadding',          0 )
call s:Set('g:OrigamiMap',              {})

" Set up maps
function! s:Map(mode, key, map_lhs_default, map_rhs)                                                              " {{{1
  let l:map_lhs = get(g:OrigamiMap, a:key, a:map_lhs_default)
  if (l:map_lhs ==? '')
    return
  endif
  if (a:mode ==? 'create')
    silent! execute 'nnoremap <silent> <unique> ' . l:map_lhs . ' ' . ':<C-U>call origami#' . a:map_rhs . '<CR>'
  elseif (a:mode ==? 'remove')
    silent! execute 'nunmap ' . l:map_lhs
  endif
endfunction

let s:OrigamiMapLeader = get(g:OrigamiMap, 'Leader', 'Z')
call s:Map('create', 'Align'           , s:OrigamiMapLeader . "a", 'AlignFoldmarkers(v:count)'                      )
call s:Map('create', 'AlignAll'        , s:OrigamiMapLeader . "A", 'AlignFoldmarkers()'                             )
call s:Map('create', 'CommentedOpen'   , s:OrigamiMapLeader . "F", 'InsertFoldmarker("open" , "comment"  , v:count)')
call s:Map('create', 'UncommentedOpen' , s:OrigamiMapLeader . "f", 'InsertFoldmarker("open" , "nocomment", v:count)')
call s:Map('create', 'CommentedClose'  , s:OrigamiMapLeader . "C", 'InsertFoldmarker("close", "comment"  , v:count)')
call s:Map('create', 'UncommentedClose', s:OrigamiMapLeader . "c", 'InsertFoldmarker("close", "nocomment", v:count)')
call s:Map('create', 'Delete'          , s:OrigamiMapLeader . "D", 'DeleteFoldmarker()'                             )
