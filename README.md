# lua-resty-gperftools
Lua API for [`ngx_google_perftools_profiler_module`](https://github.com/chronolaw/ngx_google_perftools_profiler_module)

Before use these tools, you must compile nginx/openresty with 
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

            -- or profiler in 10 seconds
            -- gperftools[profiler][action](name, 10)

            ngx.say("OK")
        }
    }
```

Then you can start/stop gperftools with `curl` like below:

```shell
    curl 'http://127.0.0.1/gperftools?profiler=cpu&action=start&name=/tmp/ngx_prof'
    ...     # ab/http_load/wrk and so on
    curl 'http://127.0.0.1/gperftools?profiler=cpu&action=stop'
```

## API

### ok, err = gperftools.cpu.start(name, *during*)
Start cpu profiler, infomations stores in `name`.

If `during` is given, the profiler will STOP after `during` seconds.

Notice: It will NOT add pid suffix for the name.

### gperftools.cpu.stop()
Stop cpu profiler.

### gperftools.heap.start(name, *n*, *during*)
Start heap profiler, infomations stores in `name`, dump for every `n` seconds.

If `during` is given, the profiler will STOP after `during` seconds.

Notice: It will NOT add pid suffix for the name.

### gperftools.heap.dump(s)
Dump heap profiler infomations, `s` for the reason.

### gperftools.heap.stop()
Stop heap profiler.

