fx_version 'adamant'

game 'gta5'

author 'daavee#0291'
description 'dv_drugsystem'

shared_script 'config.lua'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}