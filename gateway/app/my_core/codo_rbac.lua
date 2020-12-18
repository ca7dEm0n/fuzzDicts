local ipairs = ipairs
local log = require("app.core.log")
local core_table = require("app.core.table")
local lrucache = require("app.core.lrucache")
local radixtree = require("resty.radixtree")
local _M = {}

local radix_cache
local rx_key = "rbac.rx"

do
    radix_cache = lrucache.new({ count = 2048 })
end -- end do

local function create_rx(rbac_data)
    local mapping = {}
    for _, data in ipairs(rbac_data) do
        core_table.insert(mapping,
            {
                paths = { data.key },
                metadata = data.rules,
            })
    end
    --    log.error("mapping: ", json.delay_encode(mapping))
    return radixtree.new(mapping)
end


-- 匹配权限
function _M.match(app_code,url, user_id, method)
    local rx = radix_cache:get(rx_key, false)
    local rule = rx:match(url)
    local user_id_method = core_table.concat({app_code,'|',method,'|',user_id }) -- mg|GET|1
    --    log.error("mapping: ", user_id_method, rule[user_id_method])
    if rule and rule[user_id_method] == "y" then
        return true
    end
    return false
end


-- 注册URI权限
function _M.refresh(rbac_data)
    local rx = create_rx(rbac_data)
    radix_cache:set(rx_key, rx)
end

return _M
