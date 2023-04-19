
-- Name = Discord ID
Default = "0"
Squishy = "678794043018182675"
Spoomples = "461771557531025409"
Nut = "901908732525559828"
Cosmic = "767513529036832799"
Trashcam = "827596624590012457"
Skeltan = "489114867215630336"
AgentX = "490613035237507091"
Blocky = "584329002689363968"
DepressedYoshi = "491581215782993931"
Yosho = "711762825676193874"
YoshoAlt = "561647968084557825"
KanHeaven = "799106550874243083"
Bloxxel64Nya = "662354972171567105"
Vince = "282702284608110593"
Average = "397219199375769620"
Elby = "673582558507827221"
Crispyman = "817821798363955251"
Butter = "759464398946566165"
Mathew = "468134163493421076"

local m = gMarioStates[0]

modelTable = {
    [Default] = {
        maxNum = 0,
        [0] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        }
    },
    [Squishy] = {
        maxNum = 12,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [2] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        },
        [3] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        },
        [4] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        },
        [5] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        },
        [6] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
        },
        [7] = {
            model = smlua_model_util_get_id("blocky_geo"),
            modelName = "Blocky",
            icon = get_texture_info("icon-blocky")
        },
        [8] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        },
        [9] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            icon = get_texture_info("icon-croc")
        },
        [10] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
        },
        [11] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO
        },
        [12] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD
        }
    },
    [Spoomples] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        }
    },
    [Nut] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        },
        [3] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        }
    },
    [Cosmic] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        }
    },
    [Trashcam] = {
        maxNum = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        },
        [3] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO
        },
    },
    [Skeltan] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        }
    },
    [AgentX] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
        }
    },
    [Blocky] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("blocky_geo"),
            modelName = "Blocky",
            icon = get_texture_info("icon-blocky")
        }
    },
    [DepressedYoshi] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [Yosho] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [YoshoAlt] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [KanHeaven] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = m.character.hudHeadTexture
        }
    },
    [Bloxxel64Nya] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = m.character.hudHeadTexture
        }
    },
    [Vince] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            icon = get_texture_info("icon-croc")
        }
    },
    [Average] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
        }
    },
    [Elby] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = m.character.hudHeadTexture
        }
    },
    [Crispyman] = {
        maxNum = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO
        },
    },
    [Butter] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Mathew] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = get_texture_info("icon-mathew")
        }
    },
}

local stallScriptTimer = 0

--- @param m MarioState
function mario_update(m)
    if stallScriptTimer < 5 then
        stallScriptTimer = stallScriptTimer + 1
        return
    end
    discordID = network_discord_id_from_local_index(0)
    if modelTable[discordID] == nil then
        discordID = "0"
        menuTable[3][2].status = 0
    end

    if modelTable[discordID][menuTable[3][2].status].icon ~= nil then
        if modelTable[discordID][menuTable[3][2].status].icon == "Default" then
            lifeIcon = m.character.hudHeadTexture
        else
            lifeIcon = modelTable[discordID][menuTable[3][2].status].icon
        end
    else
        lifeIcon = get_texture_info("icon-nil")
    end
    if maxModelNum == nil then
        maxModelNum = modelTable[discordID].maxNum
        mod_storage_save(menuTable[3][2].nameSave, "0")
    end

    if menuTable[3][3].status == 0 or network_discord_id_from_local_index(0) == nil or discordID == "0" then return end
    if m.playerIndex == 0 then
        if discordID ~= "0" or discordID ~= "678794043018182675" or discordID ~= nil then
            gPlayerSyncTable[0].modelId = modelTable[discordID][menuTable[3][2].status].model
            if modelTable[discordID][menuTable[3][2].status].forcePlayer ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= nil then
                gNetworkPlayers[m.playerIndex].overrideModelIndex = modelTable[discordID][menuTable[3][2].status].forcePlayer
            end
        else
            gPlayerSyncTable[0].modelId = nil
        end
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

--- @param m MarioState
function on_player_connected(m)
    gPlayerSyncTable[m.playerIndex].modelId = nil
end

hook_event(HOOK_MARIO_UPDATE, mario_update)