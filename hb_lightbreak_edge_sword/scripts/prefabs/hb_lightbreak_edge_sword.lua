local assets =
{
    Asset("ANIM", "anim/hb_lightbreak_edge_sword.zip"),
    Asset("ANIM", "anim/swap_hb_lightbreak_edge_sword.zip"),
    Asset("ATLAS", "images/inventoryimages/hb_lightbreak_edge_sword.xml"),
}

local function onequip(inst, owner)
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

local function onunequip(inst, owner)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

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

    ---------------------- 主客机分界代码 -------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hb_lightbreak_edge_sword.xml" -- 物品来图片

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/hb_lightbreak_edge_sword", fn, assets)