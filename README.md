# lua-resty-gperftools
Lua API for [`ngx_google_perftools_profiler_module`](https://github.com/chronolaw/ngx_google_perftools_profiler_module)

Before use this tools, you must compile nginx/openresty with 
[`ngx_google_perftools_profiler_module`](https://github.com/chronolaw/ngx_google_perftools_profiler_module)

## Installation

Please use `opm`, such as :

```lua
opm get chronolaw/lua-resty-gperftools
```

## Usage

Some simple examples:

```nginx
    location /gperftools {
        content_by_lua_block {
            local gperftools = require "resty.gperftools"

            local profiler = ngx.var.arg_profiler
            local action = ngx.var.arg_action
            local name = ngx.var.arg_name

            gperftools[profiler][action](name)

            ngx.say("OK")
        }
    }
```

Then you can start/stop gperftools with `curl` like below:

```shell
    curl 'http://127.0.0.1/gperftools?profiler=cpu&action=start&name=/tmp/ngx_prof'
    curl 'http://127.0.0.1/gperftools?profiler=cpu&action=stop'
```
