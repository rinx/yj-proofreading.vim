" Load vital modules
let s:V = vital#of('yjproofreading')
let s:HTTP = s:V.import('Web.HTTP')
let s:XML = s:V.import('Web.XML')

let g:yj_proofreading#yahoo_apikey = get(g:, 'yj_proofreading#yahoo_apikey', '')

" Use Yahoo! Japan Proof-Read API
function! yjproofreading#call_yahoo_proofreader_api(apikey, line)
    let res = s:HTTP.get('https://jlp.yahooapis.jp/KouseiService/V1/kousei', {
                \ "appid": a:apikey,
                \ "sentence" : a:line,
                \})
    let res_body = s:XML.parse(res.content)
    let results = res_body.childNodes("Result")

    let arr = []
    for r in results
        call add(arr, {
                    \ "line": 1,
                    \ "startpos": str2nr(r.childNode("StartPos").value(), 10) + 1,
                    \ "length": str2nr(r.childNode("Length").value(), 10),
                    \ "surface": r.childNode("Surface").value(),
                    \ "word": r.childNode("ShitekiWord").value(),
                    \ "info": r.childNode("ShitekiInfo").value(),
                    \})
    endfor

    return arr
endfunction

function! yjproofreading#yahoo_proofreader() range
    let lines = getline(a:firstline, a:lastline)
    let strcounts = map(copy(lines), 'yjproofreading#len_multibyte(v:val)')

    let res = yjproofreading#call_yahoo_proofreader_api(g:yj_proofreading#yahoo_apikey, join(lines, ""))
    let formatted_res = res

    if !empty(expand('%'))
        let prefix_filename = expand('%')
        let prefix_erf = '%f'
    else
        let prefix_filename = ''
        let prefix_erf = ''
    endif
    let tmp_errorformat = &errorformat
    try
        let arr = []
        let nowline = 0
        let coldiff = 0
        for v in formatted_res
            while v.startpos > strcounts[nowline] + coldiff
                let coldiff = coldiff + strcounts[nowline]
                let nowline = nowline + 1
            endwhile
            let ln = printf("%d", v.line + nowline + a:firstline - 1)
            let sp = printf("%d", v.startpos - coldiff)
            if !empty(v.word)
                let msg = v.surface . ' -> ' . v.word . ' : ' . v.info
            else
                let msg = v.surface . ' : ' . v.info
            end
            call add(arr, prefix_filename . '(' . ln . ',' . sp . '): ' . msg)
        endfor
        let &errorformat = prefix_erf . '(%l\,%c):%m'
        cexpr join(arr, "\n")
        copen
    catch
        echo v:exception
        echo v:throwpoint
    finally
        let &errorformat = tmp_errorformat
    endtry
endfunction

function! yjproofreading#len_multibyte(str)
    return len(substitute(a:str, '.', 'x', 'g'))
endfunction

