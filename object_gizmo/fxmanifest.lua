fx_version 'cerulean'
game 'rdr3'
lua54 'yes'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
ui_page 'web/dist/index.html'

client_scripts {
	'@PolyZone/client.lua',
	"client/*.lua"
}

--[[ shared_scripts {
	'@ox_lib/init.lua'
} ]]


files {
	'web/dist/index.html',
	'web/dist/**/*',
}
