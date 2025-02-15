arning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Nosmakos'
description 'TPZ-CORE - Loot Npcs'
version '1.0.0'

shared_scripts { 'config.lua', 'locales.lua' }
server_scripts { 'server/*.lua' }
client_scripts { 'client/dataview_loot.js', 'client/tp-client_main.lua' }

dependencies {
    'tpz_core',
    'tpz_characters',
    'tpz_inventory',
}