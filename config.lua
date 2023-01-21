Config                            = {}

Config.Locale = 'en'

--Drug Zones
Config.plantZones = {

--[[
    Template with description and examples.

    zoneName = {                        -- Zone name must be unique
        blip = true,                    -- true/false or 1/0.                                                                                                               (bool)
        blipName = 'Label',             -- blip label.                                                                                                                      (string)
        sprite = 496,                   -- https://docs.fivem.net/docs/game-references/blips/#blips.                                                                        (int)
        spriteColor = 0,                -- https://docs.fivem.net/docs/game-references/blips/#blip-colors.                                                                  (int)
        circleColor = 1,                -- https://docs.fivem.net/docs/game-references/blips/#blip-colors.                                                                  (int)
        item = 'weed',                  -- item to give after harvesting a plant. (Keep in mind that you have to add this item to ox_inventory or it will notify invIsFull) (string)
        coords = vector3(x, y, z),      -- zone coordinates.                                                                                                                (vector3)
        plantProp = 'prop_weed_01',     -- Object Name: 'prop_weed_02' or Object Hash: -305885281. https://forge.plebmasters.de/objects https://gtahash.ru/                (string)
        maxPropCount = 10,              -- max prop count.                                                                                                                  (int)
        density = 20,                   -- density of random plant spawn.                                                                                                   (int)
        harvestAmount = 1,              -- amount that will be given to player upon harvesting.                                                                             (int)
        growTime = false,               -- In seconds grow time of a plant if not maxed out. (use 0/false for instant grow time)                                            (int/bool)
        harvestDuration = 1,            -- In seconds or use 0 for instant harvesting.                                                                                      (int)
        itemsRequired = {},             -- To turn off use empty object, false will spam errors. Ex: {'scissors', 'shovel'} (Keep in mind that there is no count check.)    (obj of strings)
        skillCheck = false,             -- skill check before harvesting a plant. Ex: {'easy', 'medium'} (use false to turn off)                                            (obj of strings/obj)
    --  {'easy', 'medium', 'hard', { areaSize = 50, speedMultiplier = 1 } }  https://overextended.github.io/docs/ox_lib/Interface/Client/skillcheck

        harvestWeedText = 'Label',      --third eye label                                                                                                                   (string)
        harvestingWeedText = 'Label'    --progbar label                                                                                                                     (string)
        icon = 'fa-solid fa-cannabis'   --third eye icon                                                                                                                    (string) 
    }
]]


	--Weed
	weedField = {
        blip = true,
        blipName = TranslateCap('blipWeedField'),
        sprite = 496,
        spriteColor = 0,
        circleColor = 1,

        item = 'weed',
        harvestAmount = 1,

        coords = vector3(1274.1881, 2465.4106, 72.4883),
        plantProp = 'prop_weed_01',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        harvestDuration = 1,
        itemsRequired = {},
        skillCheck = false,

        harvestText = TranslateCap('harvestWeed'),       --third eye label
        harvestingText = TranslateCap('harvestingWeed'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    },

    --Cocaine
	cocaineField = {
        blip = true,
        blipName = TranslateCap('blipCocaineField'),
        sprite = 501,
        spriteColor = 0,
        circleColor = 1,

        item = 'cocaine',
        harvestAmount = 1,

        coords = vector3(913.2745, 2567.0198, 62.4642),
        plantProp = 'prop_bush_neat_05',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        harvestDuration = 1,
        itemsRequired = {},
        skillCheck = false,

        harvestText = TranslateCap('harvestCocaine'),       --third eye label
        harvestingText = TranslateCap('harvestingCocaine'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    },

    --Opium
	OpiumField = {
        blip = true,
        blipName = TranslateCap('blipOpiumField'),
        sprite = 497,
        spriteColor = 0,
        circleColor = 1,

        item = 'opium',
        harvestAmount = 1,

        coords = vector3(1658.7078, 1828.4070, 101.5216),
        plantProp = 'prop_plant_cane_01a',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        harvestDuration = 1,
        itemsRequired = {},
        skillCheck = false,

        harvestText = TranslateCap('harvestOpium'),       --third eye label
        harvestingText = TranslateCap('harvestingOpium'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    }

}