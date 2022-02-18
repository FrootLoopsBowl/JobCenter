fx_version 'adamant'
game 'gta5'

shared_scripts {
    "shared/config.lua",
    "shared/sv_config.lua"
}

server_scripts {
    "server/events.lua"
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",

    "client/function.lua",
    "client/menu.lua"

}