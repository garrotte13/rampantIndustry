-- Copyright (C) 2022  veden

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local power = {}

local recipeUtils = require("utils/RecipeUtils")
local itemUtils = require("utils/ItemUtils")
local powerUtils = require("utils/PowerUtils")
local technologyUtils = require("utils/TechnologyUtils")
local scaleUtils = require("utils/ScaleUtils")

local addEffectToTech = technologyUtils.addEffectToTech
local makeRecipe = recipeUtils.makeRecipe
local makeOilBurner = powerUtils.makeOilBurner
local addFuelToItem = itemUtils.addFuelToItem
local scalePicture = scaleUtils.scalePicture

function power.enable()

    if settings.startup["rampant-industry--enableFuelEmissions"].value then
        addFuelToItem({
                eType = "item",
                eName = "uranium-fuel-cell",
                accelerationMutlipler = 1.5,
                topSpeedMultipler = 1.10,
                fuelEmissionsMultipler = 1.5
        })

        addFuelToItem({
                eType = "item",
                eName = "solid-fuel",
                fuelEmissionsMultipler = 0.75
        })

        addFuelToItem({
                eType = "item",
                eName = "wood",
                fuelEmissionsMultipler = 1.5
        })

        addFuelToItem({
                eType = "item",
                eName = "rocket-fuel",
                fuelEmissionsMultipler = 2
        })

        addFuelToItem({
                eType = "item",
                eName = "coal",
                fuelEmissionsMultipler = 3
        })

        addFuelToItem({
                eType = "item",
                eName = "nuclear-fuel",
                fuelEmissionsMultipler = 2.5
        })
    end

    if settings.startup["rampant-industry-enableOilBurner"].value then
        local oilBurner = makeOilBurner({
                name = "basic",
                icon = "__RampantIndustry__/graphics/icons/oil-burner.png",
                burnFluid = true,
                scaleFluidUsage = true,
                fluidPerTick = 1,
                effectivity = 1,
                maxTemp = 25,
                emissions = 35,
                scale = 1,
                tint = { r = 0.7, g = 0.4, b = 0.3, a = 1 }
        })

        makeRecipe({
                name = oilBurner,
                icon = "__RampantIndustry__/graphics/icons/oil-burner.png",
                enabled = false,
                category = "crafting",
                ingredients = {
                    {"chemical-plant", 2},
                    {"steel-furnace", 2},
                    {"electronic-circuit", 40},
                    {"copper-plate", 30}
                },
                time = 35,
                result = oilBurner
        })

        addEffectToTech("rampant-industry-technology-oil-burner",
                        {
                            type = "unlock-recipe",
                            recipe = oilBurner
        })

        addFuelToItem({
                eType = "fluid",
                eName = "light-oil",
                fuelValue = "0.95MJ",
                fuelEmissionsMultipler = 1.5
        })

        addFuelToItem({
                eType = "fluid",
                eName = "crude-oil",

                fuelValue = "0.45MJ",
                fuelEmissionsMultipler = 4
        })

        addFuelToItem({
                eType = "fluid",
                eName = "heavy-oil",
                fuelValue = "0.57MJ",
                fuelEmissionsMultipler = 3
        })

        addFuelToItem({
                eType = "fluid",
                eName = "petroleum-gas",
                fuelValue = "1.1MJ",
                fuelEmissionsMultipler = 2
        })

    end

    if settings.startup["rampant-industry-enableAdvancedSolarPanel"].value then
        data:extend({
                {
                    type = "corpse",
                    name = "advanced-solar-panel-remnants-rampant-industry",
                    icon = "__base__/graphics/icons/solar-panel.png",
                    icon_size = 32,
                    flags = {"placeable-neutral", "not-on-map"},
                    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
                    tile_width = 3,
                    tile_height = 3,
                    selectable_in_game = false,
                    subgroup = "remnants",
                    order="d[remnants]-a[generic]-a[small]",
                    time_before_removed = 60 * 60 * 15, -- 15 minutes
                    final_render_layer = "remnants",
                    remove_on_tile_placement = false,
                    animation = make_rotated_animation_variations_from_sheet (2,
                                                                              {
                                                                                  filename = "__base__/graphics/entity/solar-panel/remnants/solar-panel-remnants.png",
                                                                                  line_length = 1,
                                                                                  width = 146,
                                                                                  height = 142,
                                                                                  frame_count = 1,
                                                                                  variation_count = 1,
                                                                                  axially_symmetrical = false,
                                                                                  direction_count = 1,
                                                                                  shift = util.by_pixel(4, 0),
                                                                                  scale = 4,
                                                                                  hr_version =
                                                                                      {
                                                                                          filename = "__base__/graphics/entity/solar-panel/remnants/hr-solar-panel-remnants.png",
                                                                                          line_length = 1,
                                                                                          width = 290,
                                                                                          height = 282,
                                                                                          frame_count = 1,
                                                                                          variation_count = 1,
                                                                                          axially_symmetrical = false,
                                                                                          direction_count = 1,
                                                                                          shift = util.by_pixel(3.5, 0),
                                                                                          scale = 2,
                                                                                      },
                    })
                }
        })

        local solarPanel = table.deepcopy(data.raw["solar-panel"]["solar-panel"])
        solarPanel.name = "advanced-solar-panel-rampant-industry"
        solarPanel.minable.result = "advanced-solar-panel-rampant-industry"
        solarPanel.collision_box[1][1] = solarPanel.collision_box[1][1] * 4
        solarPanel.collision_box[1][2] = solarPanel.collision_box[1][2] * 4
        solarPanel.collision_box[2][1] = solarPanel.collision_box[2][1] * 4
        solarPanel.collision_box[2][2] = solarPanel.collision_box[2][2] * 4

        solarPanel.selection_box[1][1] = solarPanel.selection_box[1][1] * 4
        solarPanel.selection_box[1][2] = solarPanel.selection_box[1][2] * 4
        solarPanel.selection_box[2][1] = solarPanel.selection_box[2][1] * 4
        solarPanel.selection_box[2][2] = solarPanel.selection_box[2][2] * 4
        solarPanel.corpse = "advanced-solar-panel-remnants-rampant-industry"

        solarPanel.max_health = 1000

        solarPanel.production = "1.44MW"

        solarPanel.next_upgrade = nil

        scalePicture(2, solarPanel.picture)
        -- scalePicture(2, solarPanel.overlay, true)

        solarPanel.picture.layers[2].shift = {1,0}
        solarPanel.picture.layers[2].hr_version.shift = {1,0}
        solarPanel.overlay = {
            layers =
                {
                    {
                        filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow-overlay.png",
                        priority = "high",
                        width = 108,
                        height = 90,
                        shift = util.by_pixel(50, 6),
                        scale = 4,
                        hr_version =
                            {
                                filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow-overlay.png",
                                priority = "high",
                                width = 214,
                                height = 180,
                                shift = util.by_pixel(50, 6),
                                scale = 2
                            }
                    }
                }
        }

        local recipe = table.deepcopy(data.raw["recipe"]["solar-panel"])
        recipe.name = "advanced-solar-panel-rampant-industry"
        recipe.ingredients = {
            {"steel-plate", 20},
            {"electronic-circuit", 30},
            {"solar-panel", 16}
        }
        recipe.energy_required = 25
        recipe.result = "advanced-solar-panel-rampant-industry"

        local item = table.deepcopy(data.raw["item"]["solar-panel"])
        item.name = "advanced-solar-panel-rampant-industry"
        item.icons = {{icon = item.icon, tint={0.8,0.8,1,1}}}
        item.icon = nil
        item.place_result = "advanced-solar-panel-rampant-industry"
        item.order = "d[solar-panel]-a[zsolar-panel]"

        local solarTech = table.deepcopy(data.raw["technology"]["solar-energy"])

        solarTech.name = "rampant-industry-technology-solar-energy-2"
        solarTech.effects = {
            {
                type = "unlock-recipe",
                recipe = "advanced-solar-panel-rampant-industry"
            }
        }
        solarTech.prerequisites = { "solar-energy", "electric-energy-distribution-2", "space-science-pack" }
        solarTech.unit =
            {
                count = 6000,
                ingredients =
                    {
                        {"automation-science-pack", 1},
                        {"logistic-science-pack", 1},
                        {"chemical-science-pack", 1},
                        {"utility-science-pack", 1},
                        {"space-science-pack", 1}
                    },
                time = 60
            }

        data:extend({
                solarPanel,
                recipe,
                item,
                solarTech
        })
    end

    if settings.startup["rampant-industry-enableAdvancedAccumulator"].value then
        data:extend({
                {
                    type = "corpse",
                    name = "advanced-accumulator-remnants-rampant-industry",
                    icon = "__base__/graphics/icons/accumulator.png",
                    icon_size = 32,
                    flags = {"placeable-neutral", "not-on-map"},
                    selection_box = {{-1, -1}, {1, 1}},
                    tile_width = 2,
                    tile_height = 2,
                    selectable_in_game = false,
                    subgroup = "remnants",
                    order="d[remnants]-a[generic]-a[small]",
                    time_before_removed = 60 * 60 * 15, -- 15 minutes
                    final_render_layer = "remnants",
                    remove_on_tile_placement = false,
                    animation = make_rotated_animation_variations_from_sheet (1,
                                                                              {
                                                                                  filename = "__base__/graphics/entity/accumulator/remnants/accumulator-remnants.png",
                                                                                  line_length = 1,
                                                                                  width = 86,
                                                                                  height = 74,
                                                                                  frame_count = 1,
                                                                                  variation_count = 1,
                                                                                  axially_symmetrical = false,
                                                                                  direction_count = 1,
                                                                                  shift = util.by_pixel(12, 20),
                                                                                  scale = 3.8,
                                                                                  hr_version =
                                                                                      {
                                                                                          filename = "__base__/graphics/entity/accumulator/remnants/hr-accumulator-remnants.png",
                                                                                          line_length = 1,
                                                                                          width = 172,
                                                                                          height = 146,
                                                                                          frame_count = 1,
                                                                                          variation_count = 1,
                                                                                          axially_symmetrical = false,
                                                                                          direction_count = 1,
                                                                                          shift = util.by_pixel(12, 35),
                                                                                          scale = 1.8,
                                                                                      },
                    })
                }
        })

        local accumulator = table.deepcopy(data.raw["accumulator"]["accumulator"])
        accumulator.name = "advanced-accumulator-rampant-industry"
        accumulator.collision_box[1][1] = accumulator.collision_box[1][1] * 3.1
        accumulator.collision_box[1][2] = accumulator.collision_box[1][2] * 2.9 + 1.1
        accumulator.collision_box[2][1] = accumulator.collision_box[2][1] * 3.1
        accumulator.collision_box[2][2] = accumulator.collision_box[2][2] * 2.9 + 1.1

        accumulator.minable.result = "advanced-accumulator-rampant-industry"

        accumulator.selection_box[1][1] = accumulator.selection_box[1][1] * 3.1
        accumulator.selection_box[1][2] = accumulator.selection_box[1][2] * 2.9 + 1.1
        accumulator.selection_box[2][1] = accumulator.selection_box[2][1] * 3.1
        accumulator.selection_box[2][2] = accumulator.selection_box[2][2] * 2.9 + 1.1
        accumulator.corpse = "advanced-accumulator-remnants-rampant-industry"

        accumulator.max_health = 2000

        accumulator.energy_source.buffer_capacity = "67.5MJ"
        accumulator.energy_source.input_flow_limit = "4MW"
        accumulator.energy_source.output_flow_limit = "4MW"

        scalePicture(1.6, accumulator.picture)
        scalePicture(1.6, accumulator.charge_animation)

        accumulator.picture.layers[2].shift = {3.2,0}
        accumulator.picture.layers[2].hr_version.shift = {3.2,0}

        accumulator.next_upgrade = nil

        local picture = function (tint, repeat_count)
            return {
                layers =
                    {
                        {
                            filename = "__base__/graphics/entity/accumulator/accumulator.png",
                            priority = "high",
                            width = 66,
                            height = 94,
                            repeat_count = repeat_count,
                            shift = util.by_pixel(0, -10),
                            tint = tint,
                            animation_speed = 0.5,
                            scale = 3.6,
                            hr_version =
                                {
                                    filename = "__base__/graphics/entity/accumulator/hr-accumulator.png",
                                    priority = "high",
                                    width = 130,
                                    height = 189,
                                    repeat_count = repeat_count,
                                    shift = util.by_pixel(0, -11),
                                    tint = tint,
                                    animation_speed = 0.5,
                                    scale = 1.8
                                }
                        },
                        {
                            filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
                            priority = "high",
                            width = 120,
                            height = 54,
                            repeat_count = repeat_count,
                            shift = {3.2, 1},
                            draw_as_shadow = true,
                            scale = 3.6,
                            hr_version =
                                {
                                    filename = "__base__/graphics/entity/accumulator/hr-accumulator-shadow.png",
                                    priority = "high",
                                    width = 234,
                                    height = 106,
                                    repeat_count = repeat_count,
                                    shift = {3.2, 1},
                                    draw_as_shadow = true,
                                    scale = 1.8
                                }
                        }
                    }
            }
        end

        local charging = {
            layers =
                {
                    picture({ r=1, g=1, b=1, a=1 } , 24),
                    {
                        filename = "__base__/graphics/entity/accumulator/accumulator-charge.png",
                        priority = "high",
                        width = 90,
                        height = 100,
                        line_length = 6,
                        frame_count = 24,
                        blend_mode = "additive",
                        shift = util.by_pixel(0, -50),
                        scale = 3.6,
                        hr_version =
                            {
                                filename = "__base__/graphics/entity/accumulator/hr-accumulator-charge.png",
                                priority = "high",
                                width = 178,
                                height = 206,
                                line_length = 6,
                                frame_count = 24,
                                blend_mode = "additive",
                                shift = util.by_pixel(0, -50),
                                scale = 1.8
                            }
                    }
                }
        }

        local discharging = {
            layers =
                {
                    picture({ r=1, g=1, b=1, a=1 } , 24),
                    {
                        filename = "__base__/graphics/entity/accumulator/accumulator-discharge.png",
                        priority = "high",
                        width = 88,
                        height = 104,
                        line_length = 6,
                        frame_count = 24,
                        blend_mode = "additive",
                        scale = 3.6,
                        shift = util.by_pixel(-2, -50),
                        hr_version =
                            {
                                filename = "__base__/graphics/entity/accumulator/hr-accumulator-discharge.png",
                                priority = "high",
                                width = 170,
                                height = 210,
                                line_length = 6,
                                frame_count = 24,
                                blend_mode = "additive",
                                shift = util.by_pixel(-1, -50),
                                scale = 1.8
                            }
                    }
                }
        }

        accumulator.charge_animation = charging
        accumulator.discharge_animation = discharging

        local recipe = table.deepcopy(data.raw["recipe"]["accumulator"])
        recipe.name = "advanced-accumulator-rampant-industry"
        recipe.ingredients = {
            {"steel-plate", 20},
            {"electronic-circuit", 30},
            {"accumulator", 9}
        }
        recipe.energy_required = 35
        recipe.result = "advanced-accumulator-rampant-industry"

        local item = table.deepcopy(data.raw["item"]["accumulator"])
        item.name = "advanced-accumulator-rampant-industry"
        item.icons = {{icon = item.icon, tint={0.7,0.7,1,1}}}
        item.icon = nil
        item.place_result = "advanced-accumulator-rampant-industry"
        item.order = "e[accumulator]-a[zaccumulator]"

        local solarTech = table.deepcopy(data.raw["technology"]["electric-energy-accumulators"])

        solarTech.localised_name = nil

        solarTech.name = "rampant-industry-technology-electric-energy-accumulators-2"
        solarTech.effects = {
            {
                type = "unlock-recipe",
                recipe = "advanced-accumulator-rampant-industry"
            }
        }
        solarTech.prerequisites = { "electric-energy-accumulators", "electric-energy-distribution-2", "space-science-pack" }
        solarTech.unit =
            {
                count = 4000,
                ingredients =
                    {
                        {"automation-science-pack", 1},
                        {"logistic-science-pack", 1},
                        {"chemical-science-pack", 1},
                        {"utility-science-pack", 1},
                        {"space-science-pack", 1}
                    },
                time = 60
            }

        data:extend({
                accumulator,
                recipe,
                item,
                solarTech
        })
    end
end

return power
