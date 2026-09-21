fx_version "cerulean"
game "gta5"

author "Vega"
description "Paleto Bay bank heist for vRP"
version "1.3.0"

shared_scripts {"TOB.lua", "locales.lua"}
client_scripts {"serverCallbackLib/client.lua", "bridge/client.lua", "client.lua"}
server_scripts {"@vrp/lib/utils.lua", "config_server.lua", "serverCallbackLib/server.lua", "bridge/server.lua", "server.lua"}
