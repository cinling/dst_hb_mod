-- use English as default language
HbI18N = require("languages/en")

--- 合并方法，如果有重复键，t2会覆盖t1的值
--- Merge method, if there are duplicate keys, t2 will overwrite the value of t1
local function merge(t1, t2)
    for k,v in pairs(t2) do
        t1[k] = v
    end
end

if locale == "zh" then -- 简体中文
    local zh = require("languages/zh")
    HbI18N = merge(HbI18N, zh)
elseif locale == "zht" then -- 繁體中文
    local zh = require("languages/zh")
    HbI18N = merge(HbI18N, zh)
end

-- 名字 name
--HbI18N.LIGHTBREAK_EDGE_SWORD = "Lightbreak Edge Sword"
--if locale == "zh" then
--    Module.LIGHTBREAK_EDGE_SWORD = "碎光之晓刀"
--elseif locale == "zht" then
--    Module.LIGHTBREAK_EDGE_SWORD = "碎光之曉刀"
--end

return HbI18N