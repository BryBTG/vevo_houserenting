server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
	'config.lua'
}

client_scripts {
	'client.lua',
	'config.lua'
}

dependencies {
    'es_extended',
	'cron',
}