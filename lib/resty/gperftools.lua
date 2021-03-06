-- Copyright (C) 2018 by chrono

local ffi = require "ffi"
local ffi_cdef = ffi.cdef
local ffi_C = ffi.C

-- local gperf_tools_module = "ngx_google_perftools_profiler_module"
-- if not string.find(ngx.config.nginx_configure(),
--                    gperf_tools_module, 1, true) then
--     error("needs ".. gperf_tools_module)
-- end

ffi_cdef[[
typedef unsigned char u_char;

void ngx_lua_ffi_cpu_profiler_start(const u_char* profile);
void ngx_lua_ffi_cpu_profiler_stop();

void ngx_lua_ffi_heap_profiler_start(const u_char* profile, int interval);
void ngx_lua_ffi_heap_profiler_dump(const u_char* reason);
void ngx_lua_ffi_heap_profiler_stop();
]]

local proto = {
    _VERSION = '0.0.2',
    cpu = {},
    heap = {},
    }

-- cpu profiler

proto.cpu.start = function(name, during)
    if type(name) ~= "string" then
        return nil, "profiler needs a name"
    end

    if #name == 0 then
        return nil, "profiler name can not be empty"
    end

    local profile = name .. '\0'
    ffi_C.ngx_lua_ffi_cpu_profiler_start(profile)

    local during = tonumber(during)

    if not during then
        return true
    end

    return ngx.timer.at(during, function(premuture)
                        ffi_C.ngx_lua_ffi_cpu_profiler_stop()
                    end)
end

proto.cpu.stop = function()
    ffi_C.ngx_lua_ffi_cpu_profiler_stop()
    return true
end

-- heap profiler

proto.heap.start = function(name, n, during)
    if type(name) ~= "string" then
        return nil, "profiler needs a name"
    end

    if #name == 0 then
        return nil, "profiler name can not be empty"
    end

    local profile = name .. '\0'
    ffi_C.ngx_lua_ffi_heap_profiler_start(profile, tonumber(n) or 0)

    local during = tonumber(during)

    if not during then
        return true
    end

    return ngx.timer.at(during, function(premuture)
                        ffi_C.ngx_lua_ffi_heap_profiler_stop()
                    end)
end

proto.heap.dump = function(s)
    if type(s) ~= "string" then
        return nil, "needs a reason"
    end

    if #s == 0 then
        return nil, "reason can not be empty"
    end

    local reason = s .. '\0'
    ffi_C.ngx_lua_ffi_heap_profiler_dump(reason)

    return true
end

proto.heap.stop = function()
    ffi_C.ngx_lua_ffi_heap_profiler_stop()
    return true
end

return proto
