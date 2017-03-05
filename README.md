yj-proofreading.vim
===

A Japanese proofreading plugin for Vim.  
This plugin uses [Yahoo! Japan proofreading WebAPI](http://developer.yahoo.co.jp/webapi/jlp/kousei/v1/kousei.html).

![screenshot](https://gist.githubusercontent.com/rinx/a0bf405492e1db3506d092c2c4fa230b/raw/ab71825a080bbee8b81f82f2fd7f51d7e38c4cd7/screenshot1.png)

Dependencies
---

* [mattn/webapi-vim](https://github.com/mattn/webapi-vim)


Usage
---

This plugin requires Yahoo! Japan WebAPI key.  
You can get it from [https://e.developer.yahoo.co.jp/register](https://e.developer.yahoo.co.jp/register).
The application type is client-side one.

After you get the API-key, you should save it in your `.vimrc` like:

```vim
let g:yj_proofreading#yahoo_apikey = 'your apikey'
```

If your `.vimrc` is public, it is better to use `.vimrc_private` or something.  

`~/.vimrc_private` should be created like:

```vim
let g:vimrc_private = {
            \ 'yahoo_proofreader_apikey': 'your apikey',
            \ }
```

and then, you should write in your `.vimrc`:

```vim
let g:vimrc_private = {}
if filereadable(expand('~/.vimrc_private'))
    execute 'source' expand('~/.vimrc_private')
endif
```

`:YahooProofReader` command calls Yahoo! Japan WebAPI for the current line.  
It can be receive the range like `:9,13YahooProofReader` which means calling API for the range from the line number 9 to 13.


Functions
---

* `yjproofreading#call_yahoo_proofreader_api(apikey, line)` : it calls Yahoo! Japan proofreading API.
* `yjproofreading#yahoo_proofreader()` : it receives a range and calls API for the lines


License
---

MIT License.


