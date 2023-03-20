local class = require "com.class"

---@class Network
---@overload fun():Network
local Network = class:derive("Network")

local json = require("com.json")
local http = require("socket.http")
local ltn12 = require("ltn12")



--[[
    DEV NOTES:

    Keep in mind that HTTPS requests may be harder to create unless you are working
    with LOVE 12.0. Feel free to add workarounds when dealing with 11.3 (the current
    version). And please don't use 11.4, that thing is unstable.

    There are no fields for now, feel free to add/change stuff here as more networking
    functionalities are added.

    PS: Methods of this class may require use of `coroutine`.
    As far as I can remember this blocks the main process (the game).
]]



--- Initializes the Network class.
---
--- This class is used for potential online functionality such as score submission,
--- version updates and advanced Discord integration.
function Network:new()
end



---Sends a `GET` request to a specified URL.
---The returned table may only have "code" as it's field if the connection refused.
---@param url string
---@return { res: number, code: number|"connection refused", head: table, status: string, body: any }
function Network:get(url)
    local body = {}
    local res, code, head, status = http.request({
        url = url,
        sink = ltn12.sink.table(body)
    })
    return {
        res = res,
        code = code,
        head = head,
        status = status,
        body = body[1] or nil
    }
end



---Sends a `POST` request with a serialized JSON as it's request body to a specified URL.
---The returned table may only have "code" as it's field if the connection refused.
---@param url string
---@param tbl table
---@return { res: number, code: number|"connection refused", head: table, status: number, body: any }
function Network:postSerialized(url, tbl)
    local requestBody = json.encode(tbl)
    local responseBody = {}
    local res, code, head, status = http.request({
        method = "POST",
        url = url,
        headers = {
            ["content-type"] = "application/json",
            ["content-length"] = tostring(#requestBody)
        },
        source = ltn12.source.string(requestBody),
        sink = ltn12.sink.table(responseBody)
    })
    ---@diagnostic disable: cast-local-type
    responseBody = table.concat(responseBody)
    return {
        res = res,
        code = code,
        head = head,
        status = status,
        body = responseBody or nil
    }
end



return Network