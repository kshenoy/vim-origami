" vim: fdm=marker:et:ts=4:sw=2:sts=2
"===========================================================================


function! s:ReconFolds() "                                     {{{1
  " Description:
  "   Parses the file and constructs a hash. The keys of the hash are all the foldlevels present in the file
  "   The values represent the length of the longest line of that particular foldlevel.
  "   If OrigamiSeparateLevels and OrigamiStaggeredSpacing are NOT set, the Hash contains a single key '%' whose
  "   value is equal to the length of the longest line having a fold marker
  "
  let l:fold_info = {}

  " Loop over all the lines in the file and check if the line has a foldmarker
  " If it does, get the foldlevel remove the foldmarker and save the length of the line
  for i in range(1, line('$'))
    let l:line = getline(i)

    if l:line =~ s:fmr[0].'\d\?\s*'.escape(g:comment_str[1], '*').'\s*$'
      let l:fold_lvl = matchlist(l:line, s:fmr[0].'\(\d\+\)\?')[1]
      if empty(l:fold_lvl) | let l:fold_lvl = 0 | endif

      let l:line = substitute(l:line, '\s*'.s:fmr[0].'\(\d\+\)\?\s*'.escape(g:comment_str[1], '*').'\s*$', "", "")
      let l:fold_info[l:fold_lvl] = max([ len(l:line), get( l:fold_info, l:fold_lvl, s:OrigamiFoldAtCol )])
      let l:fold_info["%"] = max([ len(l:line), get( l:fold_info, "%", s:OrigamiFoldAtCol )])

    elseif s:OrigamiIncAllLines
      let l:line = substitute(l:line, '\s*$', "", "")
      call map( keys( l:fold_info ), 'max([ len(l:line), v:val ])' )
    endif
  endfor

  " If SeparateLvls or StaggeredSpacing is set, preserve only individual line info and remove the '%' key
  call filter(l:fold_info, 's:OrigamiSeparateLevels || s:OrigamiStaggeredSpacing ? v:key != "%" : v:key == "%"')
  if empty( l:fold_info ) | return {} | endif

  " Loop over l:fold_info and adjust the values of lengths
  if s:OrigamiStaggeredSpacing
    let l:lvl = min( keys( l:fold_info ) )
    let l:len = l:fold_info[l:lvl]

    for i in sort( keys( l:fold_info ) )
      if l:fold_info[i] < l:len + (i - l:lvl) * s:OrigamiStaggeredSpacing
        let l:fold_info[i] = l:len + (i - l:lvl) * s:OrigamiStaggeredSpacing
      elseif l:fold_info[i] > l:len + (i - l:lvl) * s:OrigamiStaggeredSpacing
        for j in sort( filter( keys( l:fold_info ), 'v:val < i' ))
          let l:fold_info[j] = l:fold_info[i] + (j - i) * s:OrigamiStaggeredSpacing
        endfor
      endif
    endfor
  endif

  " Add OrigamiPadding to all the levels
  if !s:OrigamiFoldAtCol && s:OrigamiPadding
    call map( l:fold_info, 'v:val + s:OrigamiPadding' )
  endif

  return l:fold_info
endfunction



function! s:PaddedFmrString( len, len_max ) "                  {{{1
  " Description:
  "   Creates a new foldmarker string. The function takes two arguments - length of the line at which foldmarker is to
  "   be placed and the max. length of the lines. It uses these to pad the foldmarker string with spaces/tabs depending
  "   upon the expandtab setting.
  " Arguments:
  "   len     ( number ) : Length of the line to be padded
  "   len_max ( number ) : Max length of the line to be matched with
  "
  if &expandtab
    let l:padding = a:len_max - a:len
    let l:pad_str = repeat(' ', l:padding)
  else
    let l:padding = (a:len_max - a:len) / &tabstop
    let l:pad_str = repeat('\t', l:padding)
  endif

  return l:pad_str
endfunction



function! origami#AlignFoldmarkers(...) "                      {{{1
  " Description:
  "   Aligns the fold markers. If input is given, aligns foldmarkers of that particular level else accepts input from
  "   user and aligns the specified foldlevel
  " Arguments:
  "   foldlevel (optional) Foldlevel to align
  " Priority:
  "   SeparateLvls > FoldAtCol > IncAllLines
  "   Padding is applicable to all the above three while StaggeredSpacing only for the last two

  " Get all global/buffer variables and store them in script specific variables to avoid reading them in every function
  let s:OrigamiSeparateLevels   = ( exists('b:OrigamiSeparateLevels') ? b:OrigamiSeparateLevels : g:OrigamiSeparateLevels )
  let s:OrigamiFoldAtCol        = !s:OrigamiSeparateLevels *
                                    \ ( exists('b:OrigamiFoldAtCol') ? b:OrigamiFoldAtCol : g:OrigamiFoldAtCol )
  let s:OrigamiIncAllLines      = !s:OrigamiSeparateLevels * !s:OrigamiFoldAtCol *
                                    \ ( exists('b:OrigamiIncAllLines') ? b:OrigamiIncAllLines : g:OrigamiIncAllLines )
  let s:OrigamiStaggeredSpacing = !s:OrigamiSeparateLevels *
                                    \ ( exists('b:OrigamiStaggeredSpacing') ? b:OrigamiStaggeredSpacing : g:OrigamiStaggeredSpacing )
  let s:OrigamiPadding          = ( exists('b:OrigamiPadding') ? b:OrigamiPadding : g:OrigamiPadding )

  let s:OrigamiStaggeredSpacing = ( &expandtab ? s:OrigamiStaggeredSpacing : s:OrigamiStaggeredSpacing * &tabstop )
  let s:OrigamiPadding          = ( &expandtab ? s:OrigamiPadding : s:OrigamiPadding * &tabstop )
  let s:fmr                     = split( &foldmarker, ',' )
  let g:comment_str             = split( &commentstring, '%s' )
  if len( g:comment_str ) == 1 | call add( g:comment_str, "" ) | endif

  " Get the fold level to align
  if a:0
    let l:lvl = a:1
  else
    let l:char = getchar()
    let l:lvl  = nr2char( l:char )
  endif

  if ( l:lvl !~? '\d' && !( has_key( g:OrigamiMap, 'Align' ) && l:lvl ==# g:OrigamiMap['Align'] ))
    "execute "normal " . g:OrigamiMap['Leader'] . g:OrigamiMap['Align'] . l:char
    return
  else
    " Construct a hash of { foldlevel => length of longest line }
    let l:fold_info = s:ReconFolds()
    if has_key( g:OrigamiMap, 'Align' ) && l:lvl ==? g:OrigamiMap['Align']
      let l:lvl = "%"
    else
      " Input is a number; we need to align a particular foldlevel so we filter out the rest
      call filter(l:fold_info, 'v:key == l:lvl || v:key == "%"')
    endif
  endif

  " For all lines in file ...
  for i in range(1, line('$'))
    let l:line = getline(i)

    " ... check if a foldmarker is present at the end and if it does ...
    if l:line =~ s:fmr[0].'\(\d\+\)\?\s*'.escape( g:comment_str[1], '*' ).'\s*$'

      " ... get the foldlevel ...
      let l:fold_str = matchlist( l:line, s:fmr[0].'\(\d\+\)\?' )[1]
      if s:OrigamiSeparateLevels || s:OrigamiStaggeredSpacing
        let l:fold_lvl = ( l:fold_str == "" ? 0 : l:fold_str )
        if l:lvl =~ '\d' && l:lvl !=# l:fold_lvl
          return
        endif
      else
        let l:fold_lvl = "%"
      endif

      " ... remove the original marker and pad the line and add a new marker to align it with the rest
      let l:line  = substitute(l:line, '\s*'.s:fmr[0].'\(\d\+\)\?\s*'.escape( g:comment_str[1], '*' ).'\s*$', "", "")
      let l:line .= s:PaddedFmrString( len(l:line), l:fold_info[l:fold_lvl] ).s:fmr[0].l:fold_str.g:comment_str[1]
      call setline(i, l:line)
    endif
  endfor
endfunction



function! origami#InsertFoldmarker( mode, comment_mode, ... ) "{{{1
  " Description:
  "   Inserts opening and closing foldmarkers. When comment_mode = "comment", inserts commented foldmarkers else
  "   inserts just the foldmarkers itself
  " Arguments:
  "   mode         (string) : "open" / "close"
  "   comment_mode (string) : "comment" / "nocomment"
  "   foldlevel    (number) : OPTIONAL. The level of foldmarker to insert. If this is not specified, input is accepted
  "                           from the user. This can be used to insert markers for foldlevels greater than 9

  " Store variables in script specific variables to avoid reading them in every function
  let g:comment_str = split( &commentstring, '%s' )
  if len( g:comment_str ) == 1 | call add( g:comment_str, "" ) | endif

  " Get the fold level to insert
  if a:0
    let l:lvl = a:1
  else
    let l:char = getchar()
    let l:lvl  = nr2char( l:char )
  endif

  " When input is a Num, do what comment_mode says
  if l:lvl =~# '\d'
    let l:comment_str = ( a:comment_mode ==? "comment" ? g:comment_str : [ "", "" ] )
    let l:lvl = ( l:lvl =~# '0' ? "" : l:lvl )

  " When input is Shift + Num, do the opposite of what comment_mode says
  elseif l:lvl =~# '[)!@#$%^&*(]'
    let l:comment_str = ( a:comment_mode ==? "comment" ? [ "", "" ] : g:comment_str )
    let l:lvl = ( l:lvl ==# ')' ? "" : stridx( ")!@#$%^&*(", l:lvl ))

  " Maps to insert opening and closing {{{,}}} marker without a comment
  elseif ( a:mode ==? "open"  && has_key( g:OrigamiMap, 'UncommentedOpen' )  && l:lvl ==# g:OrigamiMap['UncommentedOpen']
      \ || a:mode ==? "close" && has_key( g:OrigamiMap, 'UncommentedClose' ) && l:lvl ==# g:OrigamiMap['UncommentedClose'] )
      \ && a:comment_mode ==? "nocomment"
    let l:comment_str = [ "", "", "" ]
    let l:lvl = ( a:mode ==? "open" ? g:OrigamiMapLevel['UncommentedOpen'] : g:OrigamiMapLevel['UncommentedClose'] )

  " Maps to insert opening and closing {{{,}}} marker with a comment
  elseif ( a:mode ==? "open"  && has_key( g:OrigamiMap, 'CommentedOpen' )  && l:lvl ==# g:OrigamiMap['CommentedOpen']
      \ || a:mode ==? "close" && has_key( g:OrigamiMap, 'CommentedClose' ) && l:lvl ==# g:OrigamiMap['CommentedClose'] )
      \ && a:comment_mode ==? "comment"
    let l:comment_str = g:comment_str
    let l:lvl = ( a:mode ==? "open" ? g:OrigamiMapLevel['CommentedOpen'] : g:OrigamiMapLevel['CommentedClose'] )

  " Unusable sequence
  else
    " TODO Maybe execute the sequence
    return
  endif

  let s:fmr  = split( &foldmarker, ',' )
  let l:line = getline('.')
  let l:mode = !( a:mode ==? "open" )

  let l:line = substitute( l:line, '\s*$', l:comment_str[0] . s:fmr[l:mode] . l:lvl . l:comment_str[1], "" )
  call setline( '.', l:line )

  call origami#AlignFoldmarkers( l:lvl )
endfunction


function! origami#DeleteFoldmarker() "                         {{{1
  " Description: Remove a foldmarker from the current line

  let s:fmr  = split( &foldmarker, ',' )
  let l:line = getline('.')
  let l:line = substitute( l:line, s:fmr[0].'\d*', "", "" )
  let l:line = substitute( l:line, s:fmr[1].'\d*', "", "" )
  call setline( '.', l:line )
endfunction
