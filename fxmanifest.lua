--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'illegalLocations'
author 'iSicko'
version '3.0.0'
repository 'https://github.com/iSickos/esx_illegal'
description 'Upgraded esx_illegal to work with ox_target, ox_inventory and ox_lib'

--[[ Manifest ]] --
dependencies {
	'/server:5848',
	'/onesync',
	'oxmysql',
	'ox_inventory',
	'ox_lib',
	'ox_target',
}

shared_scripts {
	'@ox_lib/init.lua'
}

client_scripts {
	'locales/*.lua',
	'config.lua',
	'client/**/*.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/**/*.lua'
}

files {
	'locales/*.json'
}