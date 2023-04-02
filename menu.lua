
gGlobalSyncTable.RoomTimerF = 0

gGlobalSyncTable.bubbleDeath = 0
gGlobalSyncTable.playerInteractions = gServerSettings.playerInteractions
gGlobalSyncTable.playerKnockbackStrength = gServerSettings.playerKnockbackStrength
gGlobalSyncTable.stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar
gGlobalSyncTable.GlobalAQS = true
gGlobalSyncTable.GlobalMoveset = true

local menu = false
local optionType = 0
local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1

function hud_print_description(CMDName, Line1, Line2, Line3, Line4, Line5, Line6, Line7, Line8, Line9)
    local m = gMarioStates[0]
    if descriptions then
        djui_hud_print_text(CMDName, (halfScreenWidth + 100), 85, 0.3)
        if Line1 ~= nil then djui_hud_print_text(Line1, (halfScreenWidth + 100), 100, 0.3) end
        if Line2 ~= nil then djui_hud_print_text(Line2, (halfScreenWidth + 100), 108, 0.3) end
        if Line3 ~= nil then djui_hud_print_text(Line3, (halfScreenWidth + 100), 116, 0.3) end
        if Line4 ~= nil then djui_hud_print_text(Line4, (halfScreenWidth + 100), 124, 0.3) end
        if Line5 ~= nil then djui_hud_print_text(Line5, (halfScreenWidth + 100), 132, 0.3) end
        if Line6 ~= nil then djui_hud_print_text(Line6, (halfScreenWidth + 100), 140, 0.3) end
        if Line7 ~= nil then djui_hud_print_text(Line7, (halfScreenWidth + 100), 148, 0.3) end
        if Line8 ~= nil then djui_hud_print_text(Line8, (halfScreenWidth + 100), 156, 0.3) end
        if Line9 ~= nil then djui_hud_print_text(Line9, (halfScreenWidth + 100), 164, 0.3) end
    end
end

function hud_print_toggle_status(SyncTable)
    if SyncTable then
        djui_hud_print_text("On", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
    elseif not SyncTable then
        djui_hud_print_text("Off", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
    end
end

function hud_print_unique_toggle_status(SyncTable, ToggleText1, ToggleText2, ToggleText3, ToggleRequirement1, ToggleRequirement2, ToggleRequirement3)
    if ToggleRequirement1 == nil then ToggleRequirement1 = 0 end
    if ToggleRequirement2 == nil then ToggleRequirement2 = 1 end
    if ToggleRequirement3 == nil then ToggleRequirement3 = 2 end

    if SyncTable == ToggleRequirement1 then djui_hud_print_text(ToggleText1, (halfScreenWidth), 70 + (optionHover * 10), 0.3) end
    if SyncTable == ToggleRequirement2 then djui_hud_print_text(ToggleText2, (halfScreenWidth), 70 + (optionHover * 10), 0.3) end
    if SyncTable == ToggleRequirement3 then djui_hud_print_text(ToggleText3, (halfScreenWidth), 70 + (optionHover * 10), 0.3) end
end


function mario_update(m)
    if network_is_server() and m.playerIndex == 0 then
        gGlobalSyncTable.RoomTimerF = gGlobalSyncTable.RoomTimerF + 1
    end

    if gGlobalSyncTable.bubbleDeath ~= 2 then
        gServerSettings.bubbleDeath = gGlobalSyncTable.bubbleDeath
    else 
        gServerSettings.bubbleDeath = 0
    end
    gServerSettings.playerInteractions = gGlobalSyncTable.playerInteractions
    gServerSettings.playerKnockbackStrength = gGlobalSyncTable.playerKnockbackStrength
    gServerSettings.stayInLevelAfterStar = gGlobalSyncTable.stayInLevelAfterStar
end



menuTable = {
    [1] = {
        name = "Movement",
        tabMax = 6,
        [1] = {
            name = "Moveset",
            status = tonumber(mod_storage_load("MoveSave")),
            statusMax = 2,
            statusDefault = 0,
            --Status Toggle Names
            [0] = "Default",
            [1] = "Character",
            [2] = "Quality of Life",
            --Description
            Line1 = "Change small things about",
            Line2 = "how Mario moves to make",
            Line3 = "movement feel better"
        },
        [2] = {
            name = "Lava Groundpound",
            status = tonumber(mod_storage_load("LGPSave")),
            statusMax = 1,
            --Description
            Line1 = "Ground-Pounding on lava will",
            Line2 = "give you a speed and height",
            Line3 = "boost, at the cost of health."
        },
        [3] = {
            name = "Anti-Quicksand",
            status = tonumber(mod_storage_load("AQSSave")),
            statusMax = 1,
            restriction = true,
            --Description
            Line1 = "Makes instant quicksand act",
            Line2 = "like lava, preventing what",
            Line3 = "may seem like an unfair",
            Line4 = "deaths. (Does not include",
            Line5 = "Lava Groundpound functions)"
        },
        [4] = {
            name = "Modded Wallkick",
            status = tonumber(mod_storage_load("WKSave")),
            statusMax = 1,
            --Description
            Line1 = "Adds Wallsliding and more",
            Line2 = "lenient angles you can wall",
            Line3 = "kick at, best for a more",
            Line4 = "modern experience."
        },
        [5] = {
            name = "Strafing",
            status = tonumber(mod_storage_load("StrafeSave")),
            statusMax = 1,
            statusDefault = 0,
            --Description
            Line1 = "Forces Mario to face the",
            Line2 = "direction the Camera is",
            Line3 = "facing, similar to Sonic Robo",
            Line4 = "Blast 2. Recommended if you",
            Line5 = "play with Mouse and Keyboard."
        },
        [6] = {
            name = "Ledge Parkour",
            status = tonumber(mod_storage_load("LedgeSave")),
            statusMax = 1,
            --Description
            Line1 = "Toggles the ability to press",
            Line2 = "A or B while moving fast onto",
            Line3 = "a ledge to trick off of it!",
            Line4 = "Recommended if you want",
            Line5 = "to retain your speed going",
            Line6 = "off a ledge."
        },
    },
    [2] = {
        name = "HUD",
        tabMax = 4,
        [1] = {
            name = "HUD Type",
            status = tonumber(mod_storage_load("HUDSave")),
            statusMax = 4,
            statusDefault = 1,
            --Description
            Line1 = "Changes which HUD the screen",
            Line2 = "displays! (WIP)"
        },
        [2] = {
            name = "Descriptions",
            status = tonumber(mod_storage_load("DescSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles these descriptions",
            Line2 = "you see on the right,",
            Line3 = "Recommended to turn Off if",
            Line4 = "you like a more minimalistic",
            Line5 = "menu."
        },
        [3] = {
            name = "Server Popups",
            status = tonumber(mod_storage_load("notifSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Shows Tips/Hints about the",
            Line2 = "server every 3-5 minutes.",
            Line3 = "Recommended for if you're",
            Line4 = "new to the server."
        },
        [4] = {
            name = "Show Rules",
            status = tonumber(mod_storage_load("RulesSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if the Rules Screen",
            Line2 = "Displays upon joining. By",
            Line3 = "turning this option off,",
            Line4 = "You're confirming that you",
            Line5 = "have Read and Understand",
            Line6 = "the Rules."
        },
    },
    [3] = {
        name = "HUD",
        tabMax = 4,
        [1] = {
            name = "Star Spawn Cutscene",
            status = tonumber(mod_storage_load("SSCSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if Star Spawning",
            Line2 = "Cutscenes play, Recommended",
            Line3 = "if you don't know where a",
            Line4 = "star spawns."
        },
        [2] = {
            name = "Personal Model",
            status = tonumber(mod_storage_load("ModelSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if Star Spawning",
            Line2 = "Cutscenes play, Recommended",
            Line3 = "if you don't know where a",
            Line4 = "star spawns."
        },
    }
}

function displaymenu()
    local m = gMarioStates[0]

    halfScreenWidth = djui_hud_get_screen_width()*0.5

    if menu then
        djui_hud_set_color(0, 0, 0, 50)
        djui_hud_render_rect(0, 0, 1000, 1000)
    end

    djui_hud_set_render_behind_hud(false)

    --Room Timer--

    minutes = 0
    Seconds = 0
    Hours = 0
    if math.floor(gGlobalSyncTable.RoomTimerF/30/60) < 0 then
        Seconds = math.ceil(gGlobalSyncTable.speedrunTimer/30)
    else
        Hours = math.floor(gGlobalSyncTable.RoomTimerF/30/60/60)
        minutes = math.floor(gGlobalSyncTable.RoomTimerF/30/60%60)
        Seconds = math.floor(gGlobalSyncTable.RoomTimerF/30)%60
    end

    RoomTime = string.format("%s:%s:%s", string.format("%02d", Hours), string.format("%02d", minutes), string.format("%02d", Seconds))

    if is_game_paused() and not djui_hud_is_pause_menu_created() then
        djui_hud_set_font(FONT_NORMAL)
        if m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
            if (m.controller.buttonPressed & L_TRIG) ~= 0 and menu == false then
                menu = true
            elseif (m.controller.buttonPressed & B_BUTTON) ~= 0 and menu then
                menu = false
            end
            djui_hud_set_resolution(RESOLUTION_DJUI)
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)) + 1, 43, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)), 42, 1)
        end
        djui_hud_set_resolution(RESOLUTION_N64)
        if m.action == ACT_EXIT_LAND_SAVE_DIALOG then
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 33), 31, 0.3)
            djui_hud_print_text(RoomTime, (halfScreenWidth - 32.5), 42, 0.7)
        end
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 35), 30, 0.3)
        djui_hud_print_text(RoomTime, (halfScreenWidth - 35), 40, 0.7)
    else 
        menu = false
    end

    if menu then
        if optionHoverTimer >= 8 then
            optionHoverTimer = -1
        end
        if optionHoverTimer ~= -1 then
            optionHoverTimer = optionHoverTimer + 1
        end

        if (m.controller.stickY < -10 or (m.controller.buttonDown & D_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover + 1
            optionHoverTimer = 0
        elseif (m.controller.stickY > 10 or (m.controller.buttonDown & U_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover - 1
            optionHoverTimer = 0
        end

        if (m.controller.stickX < -10 or (m.controller.buttonDown & L_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            if optionTab == 1 and not (network_is_server() or network_is_moderator()) then
                optionTab = 3
            elseif optionTab == 1 and (network_is_server() or network_is_moderator()) then
                optionTab = 4
            else
                optionTab = optionTab - 1
            end
            optionHoverTimer = 0
        elseif (m.controller.stickX > 10 or (m.controller.buttonDown & R_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            if optionTab == 3 and not (network_is_server() or network_is_moderator()) then
                optionTab = 1
            elseif optionTab == 4 and (network_is_server() or network_is_moderator()) then
                optionTab = 1
            else
                optionTab = optionTab + 1
            end
            optionHoverTimer = 0
        end

        djui_hud_set_font(FONT_MENU)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(0, 0, 0, 170)
        djui_hud_render_rect((halfScreenWidth - 87), ((djui_hud_get_screen_height()*0.5) - 92), 174, 204)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect((halfScreenWidth - 85), ((djui_hud_get_screen_height()*0.5) - 90), 170, 200)
        djui_hud_set_color(0, 150, 0, 255)
        djui_hud_print_text("Squishys", (halfScreenWidth - (djui_hud_measure_text("Squishys")* 0.3 / 2)), 35, 0.3)
        djui_hud_print_text("'", (halfScreenWidth + 24), 35, 0.3)
        djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("Server")* 0.3 / 2)), 50, 0.3)

        
        if descriptions then
            djui_hud_set_color(0, 0, 0, 170)
            djui_hud_render_rect((halfScreenWidth + 91), ((djui_hud_get_screen_height()*0.5) - 42), 104, 104)
            djui_hud_set_color(0, 0, 0, 220)
            djui_hud_render_rect((halfScreenWidth + 93), ((djui_hud_get_screen_height()*0.5) - 40), 100, 100)
            djui_hud_set_color(0, 150, 0, 255)
        end

        --Toggles--
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_resolution(RESOLUTION_N64)
        if network_is_server() or network_is_moderator() then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30)), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 45), 70, 0.3)
            djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2) - 15), 70, 0.3)
            djui_hud_print_text("Other", (halfScreenWidth - (djui_hud_measure_text("Other")* 0.3 / 2) + 15), 70, 0.3)
            djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("Server")* 0.3 / 2) + 45), 70, 0.3)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30) + 15), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 30), 70, 0.3)
            djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2)), 70, 0.3)
            djui_hud_print_text("Other", (halfScreenWidth - (djui_hud_measure_text("Other")* 0.3 / 2) + 30), 70, 0.3)
        end

        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10), 70, 9)
        djui_hud_set_color(255, 255, 255, 255)
        
        if optionHover < 1 then
            optionHover = menuTable[optionTab].tabMax
        elseif  optionHover > menuTable[optionTab].tabMax then
            optionHover = 1
        end
        local hoverLimit = 0
        if menuTable[optionTab] ~= nil then
            if menuTable[optionTab].tabMax < 1 then return end
                djui_hud_print_text(menuTable[optionTab][1].name, (halfScreenWidth - 70), 80, 0.3)
            if menuTable[optionTab].tabMax < 2 then return end
                djui_hud_print_text(menuTable[optionTab][2].name, (halfScreenWidth - 70), 90, 0.3)
            if menuTable[optionTab].tabMax < 3 then return end
                djui_hud_print_text(menuTable[optionTab][3].name, (halfScreenWidth - 70), 100, 0.3)
            if menuTable[optionTab].tabMax < 4 then return end
                djui_hud_print_text(menuTable[optionTab][4].name, (halfScreenWidth - 70), 110, 0.3)
            if menuTable[optionTab].tabMax < 5 then return end
                djui_hud_print_text(menuTable[optionTab][5].name, (halfScreenWidth - 70), 120, 0.3)
            if menuTable[optionTab].tabMax < 6 then return end
                djui_hud_print_text(menuTable[optionTab][6].name, (halfScreenWidth - 70), 130, 0.3)
            end
        if menuTable[optionTab][optionHover].status ~= nil then
            if menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status] ~= nil then
                djui_hud_print_text(menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status], (halfScreenWidth), 70 + (optionHover * 10), 0.3)
            else
                if menuTable[optionTab][optionHover].status > 0 then
                    djui_hud_print_text("On", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                else
                    djui_hud_print_text("Off", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                end
            end
        else
            if menuTable[optionTab][optionHover].statusDefault then
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].statusDefault
            else
                menuTable[optionTab][optionHover].status = 1
            end
        end

        if optionTab == 3 then
            if optionHover < 1 then
                optionHover = 3
            elseif  optionHover > 3 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Star Spawn Cutscene", (halfScreenWidth - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Star Spawn Cutscene:", "Toggles if Star Spawning","Cutscenes play, Recommended","if you don't know where a","star spawns.")
                hud_print_toggle_status(SSC)
            end
            djui_hud_print_text("Personal Model", (halfScreenWidth - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Personal Model:", "Toggles your own Custom","Player Model, Only avalible","for users with at least","one Custom Model.","","","Contact The Host for more","information about","Custom Models and DynOS")
                if discordID ~= "0" then
                    djui_hud_print_text(modelTable[discordID][currModel].modelName, halfScreenWidth, 70 + (optionHover * 10), 0.3)
                else
                    djui_hud_print_text("N/A", halfScreenWidth, 70 + (optionHover * 10), 0.3)
                end
            end
            djui_hud_print_text("Locally Display Models", (halfScreenWidth - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Locally Display Models:", "Toggles if Custom Player","Models Display locally,","Recommended if other people's","Custom models are getting","in the way.","","Contact The Host for more","information about","Custom Models and DynOS")
                hud_print_toggle_status(modelToggle)
            end
        elseif optionTab == 4 then
            if optionHover < 1 then
                optionHover = 6
            elseif  optionHover > 6 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Death Type", (halfScreenWidth - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Death Type:", "Chenges how players die","and respawn after death.")
                hud_print_unique_toggle_status(gGlobalSyncTable.bubbleDeath,"Normal", "Bubble")
            end
            djui_hud_print_text("Player Interactions", (halfScreenWidth - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Player Interactions:", "Changes if and how players","interact with each other.")
                hud_print_unique_toggle_status(gGlobalSyncTable.playerInteractions,"Non-Solid", "Solid", "Friendly Fire")
            end
            djui_hud_print_text("Player Knockback", (halfScreenWidth - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Player Knockback:", "Changes how far players get","knocked back after being hit","by another player.")
                hud_print_unique_toggle_status(gGlobalSyncTable.playerKnockbackStrength,"Weak", "Normal", "Too Much", 10, 25, 60)
            end
            djui_hud_print_text("On Star Collection", (halfScreenWidth - 70), 110, 0.3)
            if optionHover == 4 then
                hud_print_description("On Star Collection:", "Determines what happens","after you collect a star.")
                hud_print_unique_toggle_status(gGlobalSyncTable.stayInLevelAfterStar, "Leave Level", "Stay in Level", "Non-Stop")
            end
            djui_hud_print_text("Global Movesets", (halfScreenWidth - 70), 120, 0.3)
            if optionHover == 5 then
                hud_print_description("Global Movesets:", "Determines if players can","locally change what moveset","they're using, Off forces","everyone to default.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalMoveset)
            end
            djui_hud_print_text("Global Anti-Quicksand", (halfScreenWidth - 70), 130, 0.3)
            if optionHover == 6 then
                hud_print_description("Global Anti-Quicksand:", "Determines if players can","locally change AQS or if","it's forced off.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalAQS)
            end
        end
    end
end

function before_update(m)
    if menu then
        if m.playerIndex ~= 0 then return end        
        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            optionHoverTimer = 0
            menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].status + 1
            if menuTable[optionTab][optionHover].status > menuTable[optionTab][optionHover].statusMax then
                menuTable[optionTab][optionHover].status = 0
            end
            print("Saving configuration to 'squishys-server.sav'")

            if optionTab == 3 and optionHover == 1 then
                if SSC then
                    SSC = false
                    mod_storage_save("SSCSave", "false")
                elseif SSC == false then
                    SSC = true
                    mod_storage_save("SSCSave", "true")
                end
            end

            if optionTab == 3 and optionHover == 2 then
                currModel = currModel + 1
                if modelTable[discordID][currModel] == nil then
                    currModel = 0
                end
                mod_storage_save("ModelSave", tostring(currModel))
            end

            if optionTab == 3 and optionHover == 3 then
                if modelToggle then
                    modelToggle = false
                    mod_storage_save("LDMSave", "false")
                elseif modelToggle == false then
                    modelToggle = true
                    mod_storage_save("LDMSave", "true")
                end
            end

            if optionTab == 4 and optionHover == 1 then
                gGlobalSyncTable.bubbleDeath = gGlobalSyncTable.bubbleDeath + 1
                if gGlobalSyncTable.bubbleDeath > 1 then
                    gGlobalSyncTable.bubbleDeath = 0
                end
            end

            if optionTab == 4 and optionHover == 2 then
                gGlobalSyncTable.playerInteractions = gGlobalSyncTable.playerInteractions + 1
                if gGlobalSyncTable.playerInteractions > 2 then
                    gGlobalSyncTable.playerInteractions = 0
                end
            end

            if optionTab == 4 and optionHover == 3 then
                if gGlobalSyncTable.playerKnockbackStrength == 10 then
                    gGlobalSyncTable.playerKnockbackStrength = 25
                elseif gGlobalSyncTable.playerKnockbackStrength == 25 then
                    gGlobalSyncTable.playerKnockbackStrength = 60
                elseif gGlobalSyncTable.playerKnockbackStrength == 60 then
                    gGlobalSyncTable.playerKnockbackStrength = 10
                end
            end

            if optionTab == 4 and optionHover == 4 then
                gGlobalSyncTable.stayInLevelAfterStar = gGlobalSyncTable.stayInLevelAfterStar + 1
                if gGlobalSyncTable.stayInLevelAfterStar > 2 then
                    gGlobalSyncTable.stayInLevelAfterStar = 0
                end
            end

            if optionTab == 4 and optionHover == 5 then
                if gGlobalSyncTable.GlobalMoveset then
                    gGlobalSyncTable.GlobalMoveset = false
                elseif gGlobalSyncTable.GlobalMoveset == false then
                    gGlobalSyncTable.GlobalMoveset = true
                end
            end

            if optionTab == 4 and optionHover == 6 then
                if gGlobalSyncTable.GlobalAQS then
                    gGlobalSyncTable.GlobalAQS = false
                elseif gGlobalSyncTable.GlobalAQS == false then
                    gGlobalSyncTable.GlobalAQS = true
                end
            end
        end
        m.controller.rawStickY = 0
        m.controller.rawStickX = 0
        m.controller.stickMag = 0
        m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
        m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
        m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
    end
end

-- Toggle Saves --
if mod_storage_load("MoveSave") == nil then
    print("'Moveset' not found in 'squishys-server.sav', set to default 'default'")
    mod_storage_save("MoveSave", "0")
end

if mod_storage_load("LGPSave") == nil then
    print("'Lava Groundpound' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("LGPSave", "1")
end

if mod_storage_load("AQSSave") == nil then
    print("'Anti-Quicksand' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("AQSSave", "1")
end

if mod_storage_load("WKSave") == nil then
    print("'Modded Wallkick' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("WKSave", "1")
end

if mod_storage_load("StrafeSave") == nil then
    print("'Strafe' not found in 'squishys-server.sav', set to default 'off'")
    mod_storage_save("StrafeSave", "0")
end

if mod_storage_load("LedgeSave") == nil then
    print("'Ledge Parkour' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("LedgeSave", "1")
end

if mod_storage_load("CRRSave") == nil then
    print("'Extra Hud' > 'Red Coin Radar' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CRRSave", "1")
end

if mod_storage_load("CRSSave") == nil then
    print("'Extra Hud' > 'Red Coin Radar' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CRSSave", "1")
end

if mod_storage_load("CTSave") == nil then
    print("'Extra Hud' > 'Cap Timer' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CTSave", "1")
end

if mod_storage_load("notifSave") == nil then
    print("'Server Popups' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("notifSave", "1")
end

if mod_storage_load("CMDSave") == nil then
    print("'Commands' not found in 'squishys-server.sav', set to default 'off'")
    mod_storage_save("CMDSave", "0")
end

if mod_storage_load("DescSave") == nil then
    print("'Descriptions' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("DescSave", "1")
end

if mod_storage_load("RulesSave") == nil then
    print("'Show Rules' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("RulesSave", "1")
end

if mod_storage_load("SSCSave") == nil then
    print("'Star Spawn Cutscene' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("SSCSave", "1")
end

if mod_storage_load("ModelSave") == nil then
    print("'Player-Specific Models' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("ModelSave", "1")
end

if mod_storage_load("LDMSave") == nil then
    print("'Locally Display Models' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("LDMSave", "1")
end
print("Saving configuration to 'squishys-server.sav'")

--Save to Variable--
gPlayerSyncTable[0].moveset = tonumber(mod_storage_load("MoveSave"))
LGP = tonumber(mod_storage_load("LGPSave"))
AQS = tonumber(mod_storage_load("AQSSave"))
gPlayerSyncTable[0].wallSlide = tonumber(mod_storage_load("WKSave"))
strafeToggle = tonumber(mod_storage_load("StrafeSave"))
LedgeToggle = tonumber(mod_storage_load("LedgeSave"))
notif = tonumber(mod_storage_load("notifSave"))
descriptions = tonumber(mod_storage_load("DescSave"))
showRules = tonumber(mod_storage_load("RulesSave"))
SSC = tonumber(mod_storage_load("SSCSave"))
currModel = tonumber(mod_storage_load("ModelSave"))
modelToggle = tonumber(mod_storage_load("LDMSave"))

hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)