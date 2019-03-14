data:extend({
    {
        type = "item-group",
        name = "space-traveler",
        order = "gab",
        inventory_order = "gaa",
        icon = "__space-traveler__/graphics/food_dish_blank.png",
        icon_size = 64,
      },
      {
        type = "item-subgroup",
        name = "portal",
        group = "space-traveler",
        order = "a",
      },
      {
      type = "item",
      name = "portal1",
      group = "space-traveler",
      subgroup = "portal",
      icon = "__space-traveler__/graphics/icons/food_chikuwa.png",
      icon_size = 32,
      flags = {"goes-to-main-inventory"},
      stack_size = 10,
    }
})