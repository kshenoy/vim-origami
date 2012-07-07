" vim: fdm=syntax:et:ts=4:sw=4:sts=4
"===========================================================================

function! s:ReconFolds()
    let l:OrigamiFoldAtCol        = ( exists('b:OrigamiFoldAtCol')        ? b:OrigamiFoldAtCol        : g:OrigamiFoldAtCol        )
    let l:OrigamiIncAllLines      = ( exists('b:OrigamiIncAllLines')      ? b:OrigamiIncAllLines      : g:OrigamiIncAllLines      )
    let l:OrigamiSeparateLvls     = ( exists('b:OrigamiSeparateLvls')     ? b:OrigamiSeparateLvls     : g:OrigamiSeparateLvls     )
    let l:OrigamiStaggeredSpacing = ( exists('b:OrigamiStaggeredSpacing') ? b:OrigamiStaggeredSpacing : g:OrigamiStaggeredSpacing )

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
        elseif l:OrigamiIncAllLines
            let l:line = substitute(l:line, '\s*$', "", "")
            if len(l:line) > get(l:fold_info, "%", 0)
                let l:fold_info["%"] = len(l:line)
            endif
        endif
    endfor

    call filter(l:fold_info, 'l:OrigamiSeparateLvls || l:OrigamiStaggeredSpacing ? v:key != "%" : v:key == "%"')
    if l:OrigamiStaggeredSpacing
        let l:lvl = min(keys(l:fold_info))
        let l:pad = l:fold_info[l:lvl]

        for i in sort(keys(l:fold_info))
            if l:fold_info[i] < l:pad + (i - l:lvl) * l:OrigamiStaggeredSpacing
                let l:fold_info[i] = l:pad + (i - l:lvl) * l:OrigamiStaggeredSpacing

            elseif l:fold_info[i] > l:pad + (i - l:lvl) * l:OrigamiStaggeredSpacing
                let l:lvl = i
                let l:pad = l:fold_info[i]
                for j in sort(keys(l:fold_info))
                    if j >= l:lvl | break | endif
                    let l:fold_info[j] = l:pad + (j - l:lvl) * l:OrigamiStaggeredSpacing
                endfor
            endif
        endfor
    endif

    return l:fold_info
endfunction


function! s:AssembleLine(len, len_max)
    let l:OrigamiFoldAtCol        = ( exists('b:OrigamiFoldAtCol')        ? b:OrigamiFoldAtCol        : g:OrigamiFoldAtCol        )
    let l:OrigamiPadding          = ( exists('b:OrigamiPadding')          ? b:OrigamiPadding          : g:OrigamiPadding          )
    let l:OrigamiStaggeredSpacing = ( exists('b:OrigamiStaggeredSpacing') ? b:OrigamiStaggeredSpacing : g:OrigamiStaggeredSpacing )

    if l:OrigamiFoldAtCol > 0
        if l:OrigamiFoldAtCol > a:len
            let l:fold_pos = l:OrigamiFoldAtCol
            let l:force_space = 1
        else
            echohl ERROR
            echom "Unable to place fold marker at column " . l:OrigamiFoldAtCol . " as length of line exceeds it"
            echohl NONE
            let l:force_space = 1
        endif
    endif

    if l:OrigamiStaggeredSpacing > 0
        let l:fold_pos = a:len_max + l:OrigamiPadding
    else
        let l:fold_pos = (a:len_max / &softtabstop + 1) * &softtabstop + l:OrigamiPadding
    endif

    if &expandtab || l:force_space
        let l:padding = l:fold_pos - a:len
        let l:pad_str = repeat(' ', l:padding)
    else
        let l:padding = (a:len_max - a:len) / &tabstop + 1 + l:OrigamiPadding
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
