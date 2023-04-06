Assets = {
    Asset("IMAGE", "images/inventoryimages/hb_lightbreak_edge_sword.tex"),
    Asset("ATLAS", "images/inventoryimages/hb_lightbreak_edge_sword.xml"),
}


PrefabFiles = {
    "hb_lightbreak_edge_sword"
}


env.STRINGS = GLOBAL.STRINGS -- 预设置
STRINGS.NAMES.HB_LIGHTBREAK_EDGE_SWORD = "碎光之晓刀" -- 物体在游戏中显示的名字
STRINGS.RECIPE_DESC.HB_LIGHTBREAK_EDGE_SWORD = "耐久耗光不会消失，但会[弹刀]。可用燧石磨刀。也许也适合用来种地" -- 物体的制作栏描述

-- 配方
AddRecipe2(
        "hb_lightbreak_edge_sword",
        {Ingredient("dragon_scales", 1), Ingredient("goldnugget", 5)},
        GLOBAL.TECH.SCIENCE_TWO,
        {atlas = "images/inventoryimages/hb_lightbreak_edge_sword.xml"}
)