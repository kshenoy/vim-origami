" vim: fdm=syntax:et:ts=4:sw=4:sts=4
"===========================================================================

function! s:ReconFolds()
    let l:fold_info = {}
    for i in range(1, line('$'))
        let l:line = getline(i)
        if l:line =~ '{{{\d\?\s*$'
            let l:fold_lvl = matchlist(l:line, '{{{\(\d\+\)\?')[1]
            if empty(l:fold_lvl) | let l:fold_lvl = 0 | endif
            let l:line = substitute(l:line, '\s*{{{\(\d\+\)\?\s*$', "", "")
            if len(l:line) > get(l:fold_info, l:fold_lvl, 0)
                let l:fold_info[l:fold_lvl] = len(l:line)
            endif
        elseif g:FoldItIncAllLines
            let l:line = substitute(l:line, '\s*$', "", "")
            if len(l:line) > get(l:fold_info, "%", 0)
                let l:fold_info["%"] = len(l:line)
            endif
        endif
    endfor

    return l:fold_info
endfunction


function! folder#JustifyFolds()
    let l:fold_info = s:ReconFolds()
    let l:len_max = max(l:fold_info)

    for i in range(1, line('$'))
        let l:line = getline(i)
        if l:line =~ '{{{\d\?\s*$'
            let l:fold_lvl = matchlist(l:line, '{{{\(\d\+\)\?')[1]
            if empty(l:fold_lvl) | let l:fold_lvl = 0 | endif
            let l:line  = substitute(l:line, '\s*{{{\(\d\+\)\?\s*$', "", "")
            let l:pad   = (l:len_max/&tabstop + 1) * &tabstop - len(l:line) + g:FoldItPadding
            if l:fold_lvl == 0 | let l:fold_lvl = "" | endif
            let l:line .= repeat(' ', l:pad) . "{{{" . l:fold_lvl
            call setline(i, l:line)
        endif
    endfor
endfunction
