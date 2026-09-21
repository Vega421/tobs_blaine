fx_version "cerulean"
game "gta5"

author "Vega"
description "Paleto and Fleeca bank heists for vRP"
version "1.4.1"

shared_scripts {"config/config.lua", "locales/locales.lua"}
client_scripts {"client/callbacks.lua", "client/bridge.lua", "client/main.lua"}
server_scripts {"@vrp/lib/utils.lua", "config/config_server.lua", "server/callbacks.lua", "server/bridge.lua", "server/main.lua"}
