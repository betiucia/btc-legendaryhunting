fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'btc-legendaryhunting'
version '3.0.0'

shared_scripts {
    'config.lua',
    'locales/*.lua'
}

client_script {
    'client/client.lua',
}

server_scripts {
    'server/*.lua',
}

escrow_ignore {
    'config.lua',
    'locales/*.lua'
}

dependencies {
    'btc-core',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',   
    'nui/script.js',
    'nui/images/*.png',
    'nui/fonts/*.ttf'
}

lua54 'yes'
