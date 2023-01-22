Config                            = {}

Config.Locale = 'en'

--Plant Zones
Config.plantZones = {

--[[
    Template with description and examples.
    Maybe I left smth out idk use my examples instead

    zoneName = {                        -- Zone name must be unique
        blip = true,                    -- true/false or 1/0.                                                                                                               (bool)
        blipName = 'Label',             -- blip label.                                                                                                                      (string)
        sprite = 496,                   -- https://docs.fivem.net/docs/game-references/blips/#blips.                                                                        (int)
        spriteColor = 0,                -- https://docs.fivem.net/docs/game-references/blips/#blip-colors.                                                                  (int)
        circleColor = 1,                -- https://docs.fivem.net/docs/game-references/blips/#blip-colors.                                                                  (int)
        giveItem = 'weed',              -- item to give after harvesting a plant. (Keep in mind that you have to add this item to ox_inventory or it will notify invIsFull) (string)
        coords = vector3(x, y, z),      -- zone coordinates.                                                                                                                (vector3)
        plantProp = 'prop_weed_01',     -- Object Name: 'prop_weed_02' or Object Hash: -305885281. https://forge.plebmasters.de/objects https://gtahash.ru/                 (string)
        maxPropCount = 10,              -- max prop count.                                                                                                                  (int)
        density = 20,                   -- density of random plant spawn.                                                                                                   (int)
        giveAmount = 1,                 -- amount that will be given to player upon harvesting.                                                                             (int)
        growTime = false,               -- In seconds grow time of a plant if not maxed out. (use 0/false for instant grow time)                                            (int/bool)
        duration = 1,            -- In seconds or use 0 for instant harvesting.                                                                                      (int)
        itemsRequired = {},             -- To turn off use empty object, false will spam errors. Ex: {scissors = 1, shovel = 3}     (obj of strings)
        skillCheck = false,             -- skill check before harvesting a plant. Ex: {'easy', 'medium'} (use false to turn off)                                            (obj of strings/obj)
    --  {'easy', 'medium', 'hard', { areaSize = 50, speedMultiplier = 1 } }  https://overextended.github.io/docs/ox_lib/Interface/Client/skillcheck
        animDictionary  = 'string'
        animClip        = 'string'
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

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        giveItem = 'weed',
        giveAmount = 1,

        coords = vector3(1274.1881, 2465.4106, 72.4883),
        plantProp = 'prop_weed_01',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        duration = 1,
        itemsRequired = { shovel = 1 },
        skillCheck = {'easy'},

        harvestText = TranslateCap('harvestWeed'),       --third eye label
        durationLabel = TranslateCap('harvestingWeed'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    },

    --Cocaine
	cocaineField = {
        blip = true,
        blipName = TranslateCap('blipCocaineField'),
        sprite = 501,
        spriteColor = 0,
        circleColor = 1,

        giveItem = 'cocaine',
        giveAmount = 1,

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        coords = vector3(913.2745, 2567.0198, 62.4642),
        plantProp = 'prop_fib_plant_02',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        duration = 1,
        itemsRequired = { scissors = 1 },
        skillCheck = false,

        harvestText = TranslateCap('harvestCocaine'),       --third eye label
        durationLabel = TranslateCap('harvestingCocaine'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    },

    --Opium
	OpiumField = {
        blip = true,
        blipName = TranslateCap('blipOpiumField'),
        sprite = 497,
        spriteColor = 0,
        circleColor = 1,

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        giveItem = 'opium',
        giveAmount = 1,

        coords = vector3(1658.7078, 1828.4070, 101.5216),
        plantProp = 'prop_plant_cane_01a',

        maxPropCount = 10,
        density = 20,
        growTime = 0,
        duration = 1,
        itemsRequired = { scissors = 1 },
        skillCheck = false,

        harvestText = TranslateCap('harvestOpium'),       --third eye label
        durationLabel = TranslateCap('harvestingOpium'),  --progbar label
        icon = 'fa-solid fa-cannabis'
    }

}

--Interiors 
Config.interiors = {

    weedInterior = {
        blip            = true,
        blipName        = TranslateCap('blipWeedProc'),
        sprite          = 496,
        spriteColor     = 0,

        entranceCoords  = vec3(722.4758, 2330.1638, 51.7504),
        entranceSize    = vec3(1.5, 1, 2),
        entranceDebug   = true,

        teleportTo      = vec3(1065.8807, -3183.4065, -40.1635),
        teleportBack    = vec3(721.9970, 2331.2434, 50.7504),

        exitCoords      = vec3(1066.6925, -3183.4819, -39.1638),
        exitSize        = vec3(1, 1.5, 2),
        exitDebug       = true,
    }

}

--Process 
Config.process = {

    weedDryOne = {
        
        target          = vec4(1039.0546875, -3200.1828613281, -36.646793365479, 0),
        targetSize      = vec3(0.3, 0.3, 1),
        targetDebug     = true,
        targetLabel     = TranslateCap('dryWeed'),
        targetIcon      = "fa-solid fa-sun",

        itemsRequired   = { weed = 3, rope = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'weed',
        takeAmount      = 3,
        giveItem        = 'dryweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,
        processingText  = TranslateCap('dryingWeed'),
    },

    weedDryTwo = {
        
        target          = vec4(1041.2764892578, -3200.5249023438, -36.63752746582, 0),
        targetSize      = vec3(0.3, 0.3, 1),
        targetDebug     = true,
        targetLabel     = TranslateCap('dryWeed'),
        targetIcon      = "fa-solid fa-sun",

        itemsRequired   = { weed = 3, rope = 1 },
        
        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'weed',
        takeAmount      = 3,
        giveItem        = 'dryweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,
        processingText  = TranslateCap('dryingWeed'),
    },

    weedDryThree = {
        
        target          = vec4(1040.0469970703, -3200.4514160156, -36.63752746582, 0),
        targetSize      = vec3(0.3, 0.3, 1),
        targetDebug     = true,
        targetLabel     = TranslateCap('dryWeed'),
        targetIcon      = "fa-solid fa-sun",

        itemsRequired   = { weed = 3, rope = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'weed',
        takeAmount      = 3,
        giveItem        = 'dryweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,
        processingText  = TranslateCap('dryingWeed'),
    },

    weedGrindOne = {

        target          = vec4(1038.2886962891, -3205.4338378906, -38.283721923828, 0),
        targetSize      = vec3(0.5, 0.5, 0.1),
        targetDebug     = true,
        targetLabel     = TranslateCap('grindWeed'),
        targetIcon      = "fas fa-hand-scissors",

        itemsRequired   = { dryweed = 3, grinder = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'dryweed',
        takeAmount      = 3,
        giveItem        = 'grindedweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,

        processingText  = TranslateCap('grindingWeed')
    },

    weedGrindTwo = {

        target          = vec4(1038.4423828125, -3206.0952148438, -38.283721923828, 0),
        targetSize      = vec3(0.5, 0.5, 0.1),
        targetDebug     = true,
        targetLabel     = TranslateCap('grindWeed'),
        targetIcon      = "fas fa-hand-scissors",

        itemsRequired   = { dryweed = 3, grinder = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'dryweed',
        takeAmount      = 3,
        giveItem        = 'grindedweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,

        processingText  = TranslateCap('grindingWeed')
    },

    weedGrindThree = {

        target          = vec4(1033.5692138672, -3205.4299316406, -38.283721923828, 0),
        targetSize      = vec3(0.5, 0.5, 0.1),
        targetDebug     = true,
        targetLabel     = TranslateCap('grindWeed'),
        targetIcon      = "fas fa-hand-scissors",

        itemsRequired   = { dryweed = 3, grinder = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'dryweed',
        takeAmount      = 3,
        giveItem        = 'grindedweed',
        giveAmount      = 1,

        skillCheck      = false,
        processDuration = 2,

        processingText  = TranslateCap('grindingWeed')

    }

}