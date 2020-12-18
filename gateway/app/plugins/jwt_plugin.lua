local jwt = require "app.my_core.resty.jwt"
local user_info = ngx.shared.user_info
local resp = require("app.core.response")
local ck = require("resty.cookie")
-- local json = require("app.core.json")
local string = string
local ngx = ngx
local pairs = pairs
local config = require("app.config")
local jwt_auth_dict = config.get_jwt_auth()

local _M = {
    name = "mjwt",
    priority = 300,
    desc = "jwt auth",
    optional = true,
    version = "v1.0"
}


local token_secret = jwt_auth_dict.token_secret
local jwt_key = jwt_auth_dict.key


local function decode_auth_token_verify(auth_token)
    local load_token = jwt:verify(token_secret, auth_token)
    return load_token
end


function _M.do_in_access()
    local cookie = ck:new()

    -- 绕过WS
    local method = ngx.req.get_method()
    local uri = ngx.var.uri

    local all_cookie = cookie:get_all()
    if not all_cookie and method == "GET" then
        local ws_code = string.sub(uri, 2, 3)
        if ws_code == "ws" then
            return
        end
        return resp.exit(ngx.HTTP_UNAUTHORIZED)
    end


    local auth_key = cookie:get(jwt_key)

    if auth_key == nil then
        local arg = ngx.req.get_uri_args()
        if arg ~= nil then
            for k, v in pairs(arg) do
                if k == 'auth_key' then
                    auth_key = v
                end
            end
        else
            return resp.exit(ngx.HTTP_UNAUTHORIZED)
        end
    end

    if auth_key == nil then
        return resp.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- 解密auth_key
    local load_token = decode_auth_token_verify(auth_key)

    -- 鉴定token是否正常
    if load_token.verified == false then
        return resp.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- 获得用户id
    user_info['user_id'] = load_token.payload.data.user_id
    user_info['is_superuser'] = load_token.payload.data.is_superuser
    user_info['username'] = load_token.payload.data.username
    user_info['nickname'] = load_token.payload.data.nickname

    return
end

return _M
