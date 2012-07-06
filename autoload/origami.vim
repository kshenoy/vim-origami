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
            if len(l:line) > get(l:fold_info, "%", 0)
                let l:fold_info["%"] = len(l:line)
            endif
        elseif b:OrigamiIncAllLines
            let l:line = substitute(l:line, '\s*$', "", "")
            if len(l:line) > get(l:fold_info, "%", 0)
                let l:fold_info["%"] = len(l:line)
            endif
        endif
    endfor

    call filter(l:fold_info, 'b:OrigamiFoldAtCol || b:OrigamiIncAllLines || !b:OrigamiSeparateLvls ? v:key == "%" : v:key != "%"')
    echo l:fold_info
    return l:fold_info
endfunction


function! s:AssembleLine(len, len_max)
    if exists('b:OrigamiFoldAtCol') && b:OrigamiFoldAtCol > 0
        if b:OrigamiFoldAtCol > a:len
            let l:fold_it_at_col = b:OrigamiFoldAtCol
            let l:force_space = 1
        else
            echohl ERROR
            echom "Unable to place fold marker at column " . b:OrigamiFoldAtCol . " as length of line exceeds it"
            echohl NONE
            let l:fold_it_at_col = (a:len_max / &softtabstop + 1) * &softtabstop + b:OrigamiPadding
            let l:force_space = 1
        endif
    else
        let l:fold_it_at_col = (a:len_max / &softtabstop + 1) * &softtabstop + b:OrigamiPadding
    endif

    if &expandtab || l:force_space
        let l:padding = l:fold_it_at_col - a:len
        let l:pad_str = repeat(' ', l:padding)
    else
        let l:padding = (a:len_max - a:len) / &tabstop + 1 + b:OrigamiPadding
        let l:pad_str = repeat('\t', l:padding)
    endif
    return l:pad_str
endfunction


function! origami#TidyFolds(lvl)
    let l:fold_info  = s:ReconFolds()
    if a:lvl =~ '\d\+' | call filter(l:fold_info, 'v:key == a:lvl || v:key == "%"') | endif

    for k in keys(l:fold_info)
        for i in range(1, line('$'))
            let l:line = getline(i)
            if l:line =~ '{{{\(\d\+\)\?\s*$'
                let l:fold_lvl = ( matchlist(l:line, '{{{\(\d\+\)\?')[1] == "" ? 0 : matchlist(l:line, '{{{\(\d\+\)\?')[1] )
                if k == "%" || k == l:fold_lvl
                    let l:line  = substitute(l:line, '\s*{{{\(\d\+\)\?\s*$', "", "")
                    if l:fold_lvl == 0 | let l:fold_lvl = "" | endif
                    let l:line .= s:AssembleLine(len(l:line), l:fold_info[k]) . "{{{" . l:fold_lvl
                    call setline(i, l:line)
                endif
            endif
        endfor
    endfor
endfunction
