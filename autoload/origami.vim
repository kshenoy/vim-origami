" vim: fdm=marker:et:ts=4:sw=2:sts=2
"===========================================================================

function! s:Get(var, ...)                                                                                         " {{{1
  " Description:
  "   Returns the buffer-local variable, global variable or the default value
  return get(b:, a:var, get(g:, a:var))
endfunction


function! s:Init()                                                                                                " {{{1
  " Description:
  "   Get all global/buffer variables and store them in script specific variables to avoid reading them in every function
  let s:comment_string  = split(s:Get('OrigamiCommentString', &commentstring), '%s', 1)
  if (len(s:comment_string) < 2)
    call add(s:comment_string, '')
  endif

  let s:fmr               = split(&foldmarker, ',')
  let s:fold_at_col       = 0
  let s:inc_all_lines     = 0
  let s:staggered_spacing = 0
  let s:separate_levels   = s:Get('OrigamiSeparateLevels')
  let s:padding           = s:Get('OrigamiPadding')

  let s:fmr_regex_pre_level  = '\s*\(' . escape(s:comment_string[0], '*') . '\)\?\s*' . s:fmr[0]
  let s:fmr_regex_post_level = '\s*\(' . escape(s:comment_string[1], '*') . '\)\?\s*$'
  let s:fmr_regex            = s:fmr_regex_pre_level . '\(\d*\)' . s:fmr_regex_post_level

  if !s:separate_levels
    let s:fold_at_col = s:Get('OrigamiFoldAtCol')
    " If FoldAtCol is specified relative to textwidth, get the absolute value
    if (s:fold_at_col =~ '^[+-]')
      let s:fold_at_col = &textwidth + eval(s:fold_at_col)
    endif
    if s:fold_at_col
      let s:fold_at_col -= (len(s:comment_string[0]) + 2)
    else
      let s:inc_all_lines = s:Get('OrigamiIncAllLines')
    endif
    let s:staggered_spacing = s:Get('OrigamiStaggeredSpacing') * (&expandtab ? 1 : &tabstop)
  endif
endfunction


function! origami#Debug()                                                                                         " {{{1
  call s:Init()
  echo "OrigamiCommentString    : " . "[" . join(s:comment_string, ', ') . "]"
  echo "OrigamiSeparateLevels   : " . s:separate_levels
  echo "OrigamiFoldAtCol        : " . s:fold_at_col
  echo "OrigamiIncAllLines      : " . s:inc_all_lines
  echo "OrigamiStaggeredSpacing : " . s:staggered_spacing
  echo "OrigamiPadding          : " . s:padding
  echo "Foldmarkers             : " . "[" . join(s:fmr, ', ') . "]"
endfunction


function! s:ReconFolds()                                                                                          " {{{1
  " Description:
  "   Parses the file and constructs the following hash
  "     FoldInfo = {
  "       level = {
  "         'len': 0,
  "         'lnums': [],
  "         'commented': 0
  "       }
  "     }
  let l:fold_info = {}

  " Loop over all the lines in the file and check if the line has a foldmarker
  " If it does, get the foldlevel remove the foldmarker and save the length of the line
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)

    " ... check if a foldmarker is present at the end and if it does ...
    let l:match = matchlist(l:line, s:fmr_regex)
      " l:match[1] - Comment string start
      " l:match[2] - Foldlevel
      " l:match[3] - Comment string end

    " ... remove the foldmarker
    let l:line = substitute(l:line, s:fmr_regex, '', "")

    if !empty(l:match)
      let l:foldlevel = (l:match[2] == '' ? 0 : l:match[2])
      if (!has_key(l:fold_info, l:foldlevel))
        let l:fold_info[l:foldlevel] = {'commented': 0, 'len': s:fold_at_col, 'lnums': []}
      endif
      let l:fold_info[l:foldlevel].len = max([len(l:line) + s:padding, l:fold_info[l:foldlevel].len])
      let l:fold_info[l:foldlevel].commented = l:fold_info[l:foldlevel].commented || (l:match[1] != '')
      call add(l:fold_info[l:foldlevel].lnums, l:lnum)
    elseif s:inc_all_lines
      for l:foldlevel in keys(l:fold_info)
        let l:fold_info[l:foldlevel].len = max([len(l:line) + s:padding, l:fold_info[l:foldlevel].len])
      endfor
    endif
  endfor

  " Loop over l:fold_info and adjust the values of len
  if !s:fold_at_col
    " If neither of SeparateLvls or StaggeredSpacing are set, set the length of all foldlevels to the longest of them
    if (  !s:staggered_spacing
     \ && !s:separate_levels
     \ )
      let l:len_max = 0
      let l:commented = 0
      for l:foldlevel in keys(l:fold_info)
        let l:len_max = max([l:len_max, l:fold_info[l:foldlevel].len])
        let l:commented = (l:commented || l:fold_info[l:foldlevel].commented)
      endfor
      for l:foldlevel in keys(l:fold_info)
        let l:fold_info[l:foldlevel].len = l:len_max
        let l:fold_info[l:foldlevel].commented = l:commented
      endfor
    endif
  endif

  " echo l:fold_info
  return l:fold_info
endfunction



function! s:PaddedFmrString(len, len_max)                                                                         " {{{1
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



function! origami#AlignFoldmarkers(...)                                                                           " {{{1
  " Description:
  "   Aligns the fold markers. If input is given, aligns foldmarkers of that particular level else accepts input from
  "   user and aligns the specified foldlevel
  " Arguments:
  "   foldlevel (optional) Foldlevel to align
  " Priority:
  "   SeparateLvls > FoldAtCol > IncAllLines
  "   Padding is applicable to all the above three while StaggeredSpacing only for the last two
  call s:Init()
  let l:fold_info = s:ReconFolds()

  if a:0
    " We need to align a particular foldlevel so we filter out the rest
    call filter(l:fold_info, 'v:key == a:1')
  endif

  " The lines having foldmarkers are known in l:fold_info[l:foldlevel].lnums
  for l:foldlevel in keys(l:fold_info)
    for l:lnum in l:fold_info[l:foldlevel].lnums
      let l:line = getline(l:lnum)

      let l:foldlevel_str = (l:foldlevel == 0 ? "" : l:foldlevel)
      " ... check if a foldmarker is present at the end and if it does ...
      let l:match = matchlist(l:line, s:fmr_regex_pre_level . l:foldlevel_str . s:fmr_regex_post_level)
      " l:match[1] - Open comment
      " l:match[2] - Close comment

      if (  (l:match[1] == "")
       \ && l:fold_info[l:foldlevel].commented
       \ )
        let l:match[1] = repeat(" ", len(s:comment_string[0]))
      endif

      if l:match[2] != "" | let l:match[2] = " " . l:match[2] | endif

      let l:stagger_pad = repeat(' ', (l:foldlevel - min(keys(l:fold_info))) * s:staggered_spacing)

      " ... remove the original marker and pad the line and add a new marker to align it with the rest
      let l:line = substitute(l:line, s:fmr_regex_pre_level . l:foldlevel_str . s:fmr_regex_post_level, '', "")

      let l:line .= s:PaddedFmrString(len(l:line), l:fold_info[l:foldlevel].len) . l:match[1] . l:stagger_pad
                    \ . s:fmr[0] . l:foldlevel_str . l:match[2]

      call setline(l:lnum, l:line)
    endfor
  endfor
endfunction



function! origami#InsertFoldmarker(mode, comment_mode, lvl)                                                       " {{{1
  " Description:
  "   Inserts opening and closing foldmarkers. When comment_mode = "comment", inserts commented foldmarkers else
  "   inserts just the foldmarkers itself
  " Arguments:
  "   mode         : "open" / "close"
  "   comment_mode : "comment" / "nocomment"
  "   foldlevel    : OPTIONAL. The level of foldmarker to insert. If this is not specified, an unnumbered marker is used
  call s:Init()

  " When input is a Num, do what comment_mode says
  let l:comment_string = (a:comment_mode ==? "comment" ? s:comment_string : ["", ""])
  let l:lvl = (a:lvl =~# '0' ? "" : a:lvl)

  let s:fmr  = split(&foldmarker, ',')
  let l:line = getline('.')
  let l:mode = (a:mode ==? "close")

  let l:line = substitute(l:line, '\s*$', l:comment_string[0] . s:fmr[l:mode] . l:lvl . l:comment_string[1], "")
  call setline('.', l:line)

  call origami#AlignFoldmarkers(l:lvl)
endfunction


function! origami#DeleteFoldmarker()                                                                              " {{{1
  " Description: Remove a foldmarker from the current line
  call s:Init()

  let l:line = getline('.')
  let l:line = substitute(l:line, s:fmr_regex, '', "")
  call setline('.', l:line)
endfunction
