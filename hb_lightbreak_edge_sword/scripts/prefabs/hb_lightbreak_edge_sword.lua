--- 碎光之晓刀
-- 基础攻击力 55（面板属性）
-- 耐久度 100
-- 特点 持有时可以发出微弱的光芒，并且可以发出热量，冬天时可提供一定的热量
-- 每攻击10次，将会触发一次范围性爆炸伤害（不会着火），伤害值是300

--- 斩味
-- 颜色   伤害  耐久度     伤害倍率
-- 紫    76    >=90      1.39
-- 白    72    70-89     1.32
-- 蓝    68    50-69     1.25
-- 绿    61    40-49     1.125
-- 黄    55    20-39     1
-- 橙    41    0-19      0.75
-- 红    27    =0        0.5

--- 参考文件：
-- spear.lua 长矛
-- axe.lua 斧头

local assets =
{
    Asset("ANIM", "anim/hb_lightbreak_edge_sword.zip"),
    Asset("ANIM", "anim/swap_hb_lightbreak_edge_sword.zip"),
    Asset("ATLAS", "images/inventoryimages/hb_lightbreak_edge_sword.xml"),
}

-- 最大耐久度
local HB_LIGHTBREAK_EDGE_USES_MAX = 400
-- 初始化耐久度
local HB_LIGHTBREAK_EDGE_USES_INIT = 240

-- 斩味
local HB_SHARPNESS = {
    PURPLE = {damage = 76, chop = 20},
    WHITE = {damage = 72, chop = 15},
    BLUE = {damage = 68, chop = 10},
    GREEN = {damage = 61, chop = 5},
    YELLOW = {damage = 55, chop = 2},
    ORANGE = {damage = 41, chop = 1},
    RED = {damage = 27, chop = 1},
}

--- 斩味class
HbSharpness = {
    damage = 0,
    chop = 0
}

--- 新建一个斩味对象
-- percent 耐久度百分比
function HbSharpness:new(
        percent -- 耐久度百分比
)
    if percent >= 0.9 then
        return HB_SHARPNESS.PURPLE
    elseif percent >= 0.7 then
        return HB_SHARPNESS.WHITE
    elseif percent >= 0.5 then
        return HB_SHARPNESS.BLUE
    elseif percent >= 0.4 then
        return HB_SHARPNESS.GREEN
    elseif percent >= 0.2 then
        return HB_SHARPNESS.YELLOW
    elseif percent > 0 then
        return HB_SHARPNESS.ORANGE
    else
        return HB_SHARPNESS.RED
    end
end


--- 根据耐久度（斩味）重置属性
local function ResetPropByUses(inst)
    local sharpness = HbSharpness:new(inst.components.finiteuses:GetPercent())

    inst.components.weapon:SetDamage(sharpness.damage) -- 设置伤害
    inst.components.tool:SetAction(ACTIONS.CHOP, sharpness.chop) -- 设置砍树威力
end

--- 耐久度百分比变化
local function OnPercentUsedChange(inst, data)
    ResetPropByUses(inst)
end

local function OnEquip(inst, owner)
    --local skin_build = inst:GetSkinBuild()
    --if skin_build ~= nil then
    --    owner:PushEvent("equipskinneditem", inst:GetSkinName())
    --    owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_spear", inst.GUID, "swap_spear")
    --else
    --    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    --end
    --owner.AnimState:Show("ARM_carry")
    --owner.AnimState:Hide("ARM_normal")


    owner.AnimState:OverrideSymbol("swap_object", "swap_hb_lightbreak_edge_sword", "swap_hb_lightbreak_edge_sword") -- 以下三句都是设置动画表现的，不会对游戏实际内容产生影响，你可以试试去掉的效果
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.DynamicShadow:SetSize(1.7, 1) -- 设置阴影大小，你可以仔细观察装备荷叶伞时，人物脚下的阴影变化
end

local function OnUnequip(inst, owner)
    --owner.AnimState:Hide("ARM_carry")
    --owner.AnimState:Show("ARM_normal")
    --local skin_build = inst:GetSkinBuild()
    --if skin_build ~= nil then
    --    owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    --end

    owner.AnimState:Hide("ARM_carry") -- 和上面的装备回调类似，可以试试去掉的结果
    owner.AnimState:Show("ARM_normal")
    owner.DynamicShadow:SetSize(1.3, 0.6)
end

-- 耐久度用完后
local function OnFinishedUses(inst)
    ResetPropByUses(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight() -- 光源（仅地面）

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hb_lightbreak_edge_sword")
    inst.AnimState:SetBuild("hb_lightbreak_edge_sword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    -- 光源处理（丢到地面时发光）
    inst.Light:Enable(true)
    inst.Light:SetRadius(1) -- 光源半径
    inst.Light:SetIntensity(0.9) -- 光源亮度 [0,1]
    inst.Light:SetFalloff(0.8) -- 光源衰减强度 [0.1]
    inst.Light:SetColour(1, 0.611, 0) -- r,g,b 光源颜色 [0,1]

    ---------------------- 主客机分界代码 -------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    -- 武器
    inst:AddComponent("weapon")
    -- 伤害由斩味相关进行设置，这里不进行设置。详情可参考:ResetPropByUses

    -- 工具
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP) -- 允许砍（威力和斩味相关，因此不设置，仅声明）
    inst.components.tool:SetAction(ACTIONS.DIG) -- 允许 挖（铲）
    inst.components.tool:SetAction(ACTIONS.HAMMER, 0.5) -- 允许 锤。威力0.5
    inst.components.tool:SetAction(ACTIONS.MINE, 0.5) -- 允许 挖矿。威力0.5

    -- 园艺锄 组件
    inst:AddComponent("farmtiller")

    -- 耐久度 组件
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(HB_LIGHTBREAK_EDGE_USES_MAX)
    inst.components.finiteuses:SetUses(HB_LIGHTBREAK_EDGE_USES_INIT)
    inst.components.finiteuses:SetOnFinished(OnFinishedUses)
    inst.components.finiteuses:SetConsumption(ACTIONS.ATTACK, 1) -- 攻击 耐久度消耗
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 1) -- 砍 耐久度消耗
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 2) -- 挖（铲） 耐久度消耗
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 5) -- 锤 耐久度消耗
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 10) -- 采矿 耐久度消耗
    inst.components.finiteuses:SetConsumption(ACTIONS.TILL, 1) -- 锄 耐久度消耗

    -- 燃料组件
    --inst:AddComponent("fueled")
    --inst.components.fueled.fueltype = FUELTYPE.BURNABLE

    -- 可查看 组件
    inst:AddComponent("inspectable")

    -- 物品图标
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hb_lightbreak_edge_sword.xml" -- 物品来图片

    -- 可装备 组件
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    --MakeHauntableLaunch(inst) -- 不确定有什么作用
    ResetPropByUses(inst)

    -- 监听事件
    inst:ListenForEvent("percentusedchange", OnPercentUsedChange) -- 耐久度变更

    return inst
end

return Prefab("common/inventory/hb_lightbreak_edge_sword", fn, assets)