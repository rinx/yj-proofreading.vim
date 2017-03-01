let g:yj_proofreading#yahoo_apikey = get(g:, 'yj_proofreading#yahoo_apikey', '')

" Use Yahoo! Japan Proof-Read API
function! yj_proofreading#call_yahoo_proofreader_api(apikey, line)
    let res = webapi#http#get('https://jlp.yahooapis.jp/KouseiService/V1/kousei', {
                \ "appid": a:apikey,
                \ "sentence" : a:line,
                \})
    let res_body = webapi#xml#parse(res.content)
    let results = res_body.childNodes("Result")

    let arr = []
    for r in results
        call add(arr, {
                    \ "startpos": r.childNode("StartPos").value(),
                    \ "length": r.childNode("Length").value(),
                    \ "surface": r.childNode("Surface").value(),
                    \ "word": r.childNode("ShitekiWord").value(),
                    \ "info": r.childNode("ShitekiInfo").value(),
                    \})
    endfor

    return arr
endfunction

function! yj_proofreading#yahoo_proofreader()
    let line = getline('.')

    let res = yj_proofreading#call_yahoo_proofreader_api(g:yj_proofreading#yahoo_apikey, line)
    let formatted_res = res
    call map(formatted_res,
                \ "'(1,' . v:val.startpos . '): ' . v:val.surface . ' -> ' . v:val.word . ' : ' . v:val.info")

    let tmp_errorformat = &errorformat
    try
        let &errorformat = '(%l\,%c):%m'
        cexpr join(formatted_res, "\n")
        copen
    catch
        echo v:exception
        echo v:throwpoint
    finally
        let &errorformat = tmp_errorformat
    endtry
endfunction


