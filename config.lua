lib.locale()
Config                            = {}

Config.Framework = 'esx'    -- esx, ox

Config.Locale = 'en'

--Plant Zones
Config.plantZones = {

	--Weed Harvesting Example
	weedField = {
        blipOptions = {
            blip = true,
            blipName = locale('blipWeedField'),
            sprite = 496,
            spriteColor = 0,
            circleColor = 1,
        },
        coords = vector3(1274.1881, 2465.4106, 72.4883),

        jobCheck        = {police = 1},

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        giveItem = 'weed',
        giveAmount = 1,

        plantProp = 'prop_weed_01',
        maxPlantCount = 10,
        density = 20,
        growTime = 0,

        itemsRequired = { shovel = 1 },
        skillCheck = {'easy'},
        duration = 1,

        harvestText = locale('harvestWeed'),       --third eye label
        icon = 'fa-solid fa-cannabis',             --third eye icon
        durationLabel = locale('harvestingWeed'),  --progbar label
    },

}

-- Interior example using IPLs: https://wiki.rage.mp/index.php?title=Interiors_and_Locations
-- Load IPLs and fix holes: https://github.com/Bob74/bob74_ipl
Config.interiors = {

    weedInterior = {
        blipOptions = {
            blip            = true,
            blipName        = locale('blipWeedProc'),
            sprite          = 496,
            spriteColor     = 0,
        },

        entranceCoords  = vec3(722.4758, 2330.1638, 51.7504),
        entranceSize    = vec3(1.5, 1, 2),
        entranceDebug   = false,

        teleportTo      = vec3(1065.8807, -3183.4065, -40.1635),
        teleportBack    = vec3(721.9970, 2331.2434, 50.7504),

        exitCoords      = vec3(1066.6925, -3183.4819, -39.1638),
        exitSize        = vec3(1, 1.5, 2),
        exitDebug       = false,
    }

}

-- Weed processing example 
Config.process = {

    weedDryOne = {
        
        target          = vec4(1039.0546875, -3200.1828613281, -36.646793365479, 0),
        targetSize      = vec3(0.3, 0.3, 1),
        targetDebug     = false,
        targetLabel     = locale('dryWeed'),
        targetIcon      = "fa-solid fa-sun",

        jobCheck        = {police = 1},

        itemsRequired   = { weed = 3, rope = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'weed',
        takeAmount      = 3,
        giveItem        = 'dryweed',
        giveAmount      = 1,

        skillCheck      = false,
        duration = 2,
        processingText  = locale('dryingWeed'),
    },

    weedGrind = {

        target          = vec4(1038.2886962891, -3205.4338378906, -38.283721923828, 0),
        targetSize      = vec3(0.5, 0.5, 0.1),
        targetDebug     = false,
        targetLabel     = locale('grindWeed'),
        targetIcon      = "fas fa-hand-scissors",

        jobCheck        = {},

        itemsRequired   = { dryweed = 3, grinder = 1 },

        animDictionary  = 'amb@world_human_gardener_plant@female@exit',
        animClip        = 'exit_female',

        takeItem        = 'dryweed',
        takeAmount      = 3,
        giveItem        = 'grindedweed',
        giveAmount      = 1,

        skillCheck      = false,
        duration = 2,

        processingText  = locale('grindingWeed')
    }

}