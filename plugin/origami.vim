" vim: fdm=marker:et:ts=2:sw=2:sts=2
"===========================================================================

" Exit when app has already been loaded (or "compatible" mode set)
if exists('g:loaded_Origami') || &cp
  finish
endif
let g:loaded_Origami = 1

let g:OrigamiSeparateLevels       = get(g:, 'OrigamiSeparateLevels',   0)
let g:OrigamiFoldAtCol            = get(g:, 'OrigamiFoldAtCol',        0)
let g:OrigamiIncAllLines          = get(g:, 'OrigamiIncAllLines',      0)
let g:OrigamiStaggeredSpacing     = get(g:, 'OrigamiStaggeredSpacing', 0)
let g:OrigamiPadding              = get(g:, 'OrigamiPadding',          0)
let g:OrigamiMap                  = get(g:, 'OrigamiMap',              {})

" Set up maps                                                                                                     " {{{1
function! s:Map(key, map_lhs_default, map_rhs)
  let l:map_lhs = get(g:OrigamiMap, a:key, a:map_lhs_default)
  if (l:map_lhs ==? '')
    return
  endif
  silent! execute 'nnoremap <silent> <unique> ' . l:map_lhs . ' ' . ':<C-U>call origami#' . a:map_rhs . '<CR>'
endfunction

let s:OrigamiMapLeader = get(g:OrigamiMap, 'Leader', 'Z')
if (s:OrigamiMapLeader == "")
  echoe "Origami: OrigamiMapLeader shouldn't be left blank"
endif

call s:Map('Align',            s:OrigamiMapLeader . 'a', 'AlignFoldmarkers(v:count)')
call s:Map('AlignAll',         s:OrigamiMapLeader . 'A', 'AlignFoldmarkers()')
call s:Map('CommentedOpen',    s:OrigamiMapLeader . 'F', 'InsertFoldmarker("open" , "comment"  , v:count)')
call s:Map('UncommentedOpen',  s:OrigamiMapLeader . 'f', 'InsertFoldmarker("open" , "nocomment", v:count)')
call s:Map('CommentedClose',   s:OrigamiMapLeader . 'C', 'InsertFoldmarker("close", "comment"  , v:count)')
call s:Map('UncommentedClose', s:OrigamiMapLeader . 'c', 'InsertFoldmarker("close", "nocomment", v:count)')
call s:Map('Delete',           s:OrigamiMapLeader . 'D', 'DeleteFoldmarker()')
