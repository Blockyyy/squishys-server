E_MODEL_WEEDCAT = smlua_model_util_get_id("cosmic_geo")
E_MODEL_SPOOMPLES = smlua_model_util_get_id("pacman_geo")
E_MODEL_TRASHCAM = smlua_model_util_get_id("trashcam_geo")
E_MODEL_WOOPER = smlua_model_util_get_id("woop_geo")
E_MODEL_EROS = smlua_model_util_get_id("eros_geo")
E_MODEL_FREEMAN = smlua_model_util_get_id("gordon_geo")
E_MODEL_PRINCESS = smlua_model_util_get_id("peach_player_geo")
E_MODEL_BLOCKY = smlua_model_util_get_id("blocky_geo")
E_MODEL_YOSHI = smlua_model_util_get_id("yoshi_player_geo")
E_MODEL_NYA = smlua_model_util_get_id("nya_geo")

function name_without_hex(name)
    local nameTable = {}
    name:gsub(".", function(c) table.insert(nameTable, c) end)

    local removed = false
    for k, v in pairs(nameTable) do
        if v == "\\" and not removed then
            removed = true
            nameTable[k] = ""     -- \
            nameTable[k + 1] = "" -- #
            nameTable[k + 2] = "" -- f
            nameTable[k + 3] = "" -- f
            nameTable[k + 4] = "" -- f
            nameTable[k + 5] = "" -- f
            nameTable[k + 6] = "" -- f
            nameTable[k + 7] = "" -- f
            nameTable[k + 8] = "" -- \
        end
    end
    return table.concat(nameTable, "")
end

--- @param m MarioState
function mario_update(m)
    if m.playerIndex == 0 then
        if name_without_hex(gNetworkPlayers[0].name):find("Spoomples") then
            gPlayerSyncTable[0].modelId = E_MODEL_SPOOMPLES
        elseif name_without_hex(gNetworkPlayers[0].name):find("Cosmic") then
            gPlayerSyncTable[0].modelId = E_MODEL_WEEDCAT
        elseif name_without_hex(gNetworkPlayers[0].name):find("Trashcam") then
            gPlayerSyncTable[0].modelId = E_MODEL_TRASHCAM
        elseif name_without_hex(gNetworkPlayers[0].name):find("Skeltan") then
            gPlayerSyncTable[0].modelId = E_MODEL_WOOPER
        elseif name_without_hex(gNetworkPlayers[0].name):find("eros71") then
            gPlayerSyncTable[0].modelId = E_MODEL_EROS
        elseif name_without_hex(gNetworkPlayers[0].name):find("AgentX") then
            gPlayerSyncTable[0].modelId = E_MODEL_FREEMAN
        elseif name_without_hex(gNetworkPlayers[0].name):find("Peachy") then
            gPlayerSyncTable[0].modelId = E_MODEL_PRINCESS
        elseif name_without_hex(gNetworkPlayers[0].name):find("Blocky") then
            gPlayerSyncTable[0].modelId = E_MODEL_BLOCKY
        elseif name_without_hex(gNetworkPlayers[0].name):find("Yosho") then
            gPlayerSyncTable[0].modelId = E_MODEL_YOSHI
        elseif name_without_hex(gNetworkPlayers[0].name):find("DepressedYoshi") then
            gPlayerSyncTable[0].modelId = E_MODEL_YOSHI
        elseif name_without_hex(gNetworkPlayers[0].name):find("KanHeaven") then
            gPlayerSyncTable[0].modelId = E_MODEL_NYA
        elseif name_without_hex(gNetworkPlayers[0].name):find("Bloxxel64Nya") then
            gPlayerSyncTable[0].modelId = E_MODEL_NYA
        else
            gPlayerSyncTable[0].modelId = nil
        end
    end
    
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
        if name_without_hex(gNetworkPlayers[0].name):find("Cosmic") then
            gNetworkPlayers[m.playerIndex].overrideModelIndex = CT_WALUIGI
        end
    end
end


--- @param m MarioState
function on_player_connected(m)
    gPlayerSyncTable[m.playerIndex].modelId = nil
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)