---@diagnostic disable: param-type-mismatch, assign-type-mismatch, missing-parameter
--Mods are bundled here to prevent lag and clutter--
--Credits go to all their original mod creators--

--Star Heal--

local HP_TO_HEAL_COUNTER_UNITS_FACTOR = 1 / 0x40
local MAX_HP_IN_HEAL_COUNTER_UNITS = 0x880 * HP_TO_HEAL_COUNTER_UNITS_FACTOR

local function on_interact(interactor, interactee, interactType, interactValue)
    --FUTURE: add back original condition when it's fixed in source
    --if not interactValue or interactType ~= INTERACT_STAR_OR_KEY then
    if interactType ~= INTERACT_STAR_OR_KEY or interactor.playerIndex ~= 0 then
        return
    end
    
    --FUTURE: exclude stuff that's already collected when source makes it possible
    
    interactor.hurtCounter = 0
    interactor.healCounter = MAX_HP_IN_HEAL_COUNTER_UNITS
        - interactor.health * HP_TO_HEAL_COUNTER_UNITS_FACTOR
end

local once
local TECH_KB = {
    [ACT_GROUND_BONK]             = ACT_BACKWARD_ROLLOUT,
    [ACT_BACKWARD_GROUND_KB]      = ACT_BACKWARD_ROLLOUT,
    [ACT_HARD_BACKWARD_GROUND_KB] = ACT_BACKWARD_ROLLOUT,
    [ACT_HARD_FORWARD_GROUND_KB]  = ACT_FORWARD_ROLLOUT,
    [ACT_FORWARD_GROUND_KB]       = ACT_FORWARD_ROLLOUT,
    [ACT_DEATH_EXIT_LAND]         = ACT_BACKWARD_ROLLOUT,
  
}
local tech_tmr = 0
local burn_press = 0
local slopetimer = 0

z = 0
--Teching hook mario action--

local function localtechaction(m)
    if TECH_KB[m.action] then
        tech_tmr = 0
    end
    if m.action ~= ACT_BURNING_GROUND then
        burn_press = 0
    end
end

--Door Bust Stuff--

define_custom_obj_fields({
    oDoorDespawnedTimer = 'u32',
    oDoorBuster = 'u32'
})

function approach_number(current, target, inc, dec)
    if current < target then
        current = current + inc
        if current > target then
            current = target
        end
    else
        current = current - dec
        if current < target then
            current = target
        end
    end
    return current
end

function lateral_dist_between_object_and_point(obj, pointX, pointZ)
    if obj == nil then return 0 end
    local dx = obj.oPosX - pointX
    local dz = obj.oPosZ - pointZ

    return math.sqrt(dx * dx + dz * dz)
end

--- @param o Object
function bhv_broken_door_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_DAMAGE
    o.oIntangibleTimer = 0
    o.oGraphYOffset = -5
    o.oDamageOrCoinValue = 3
    obj_scale(o, 0.85)

    o.hitboxRadius = 80
    o.hitboxHeight = 100
    o.oGravity = 3
    o.oFriction = 0.8
    o.oBuoyancy = 1

    o.oVelY = 50
end

--- @param o Object
function bhv_broken_door_loop(o)
    if o.oForwardVel > 10 then
        object_step()
        if o.oForwardVel < 30 then
            o.oInteractType = 0
        end
    else
        cur_obj_update_floor()
        o.oFaceAnglePitch = approach_number(o.oFaceAnglePitch, -0x4000, 0x500, 0x500)
    end

    -- TODO debug doors getting stuck on toad or whatever

    obj_flicker_and_disappear(o, 300)
end

id_bhvBrokenDoor = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_broken_door_init, bhv_broken_door_loop)

local visible = false
extraVel = 0
IdiotSound = audio_sample_load("Idiot.mp3")
--- @param m MarioState
function mario_update(m)
    if m.playerIndex ~= 0 then return end

    --Wallslide
    gPlayerSyncTable[m.playerIndex].wallSlide = menuTable[1][4].status

    --Ledge Parkour
    if menuTable[1][6].status == 1 then
        if (m.action == ACT_LEDGE_GRAB or m.action == ACT_LEDGE_CLIMB_FAST) then
            ledgeTimer = ledgeTimer + 1
        else
            ledgeTimer = 0
            velStore = m.forwardVel
        end

        if ledgeTimer <= 5 and velStore >= 15 then
            if m.action == ACT_LEDGE_CLIMB_FAST and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SIDE_FLIP, 0)
                m.vel.y = 30 * velStore/50 + 20
                m.forwardVel = velStore * 1.1
            end

            if m.action == ACT_LEDGE_GRAB and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SLIDE_KICK, 0)
                m.vel.y = 10 * velStore/50
                m.forwardVel = velStore + 15
            end
        else
            if m.action == ACT_LEDGE_CLIMB_FAST and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
                set_mario_action(m, ACT_FORWARD_ROLLOUT, 0)
                m.vel.y = 10
                m.forwardVel = 20
            end

            if m.action == ACT_LEDGE_GRAB and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                set_mario_action(m, ACT_JUMP_KICK, 0)
                m.vel.y = 20
                m.forwardVel = 10
            end
        end
    end

    --Disable PU's
    if (m.pos.x > 57344) or (m.pos.x < -57344) or (m.pos.z > 57344) or (m.pos.z < -57344) then
        warp_restart_level()
        audio_sample_play(IdiotSound, m.pos, 1)
    end

    local obj = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvBlueCoinSwitch)
    if obj ~= nil then
        if m.marioObj.platform == obj or obj.oAction == 1 or obj.oAction == 2 then
            visible = true
        else
            visible = false
        end
    end

    --Teching + New Spam Burnout--
    if m.playerIndex == 0 then
        if TECH_KB[m.action] and m.health > 255 then
        tech_tmr = tech_tmr + 1
            if tech_tmr <= 9.9 and (m.controller.buttonPressed & Z_TRIG) ~= 0 then
                play_character_sound(m, CHAR_SOUND_UH2)
                m.vel.y = 21.0
                m.particleFlags = m.particleFlags | ACTIVE_PARTICLE_SPARKLES
                tech_tmr = 0
                return set_mario_action(m, TECH_KB[m.action], 1)
            end
        end

        if m.action == ACT_BURNING_GROUND then
            if (m.controller.buttonPressed & Z_TRIG) ~= 0 then
                burn_press = burn_press + 1
                m.particleFlags = m.particleFlags | PARTICLE_DUST
                play_sound(SOUND_GENERAL_FLAME_OUT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            end
            if burn_press >= 5 then
                m.marioObj.oMarioBurnTimer = 161
                m.hurtCounter = 0
                set_mario_action(m, ACT_WALKING, 0)
            end
        end
        --Instant Slope Jump--

        if (m.action == ACT_BUTT_SLIDE) or (m.action == ACT_HOLD_BUTT_SLIDE) then
            slopetimer = slopetimer + 1
            if (slopetimer <= 5) and ((m.controller.buttonPressed & A_BUTTON) ~= 0) then
                if (m.action == ACT_BUTT_SLIDE) then
                    set_mario_action(m, ACT_JUMP, 0)
                elseif (m.action == ACT_HOLD_BUTT_SLIDE) then
                    set_mario_action(m, ACT_HOLD_JUMP, 0)
                end
            end
        else
            slopetimer = 0
        end
    end

    --Strafing--
    if menuTable[1][5].status == 1 then
        if m.playerIndex ~= 0 then return end
        m.marioObj.header.gfx.angle.y = m.area.camera.yaw + 32250
    end

    --Door Bust--

    local door = nil
    if m.playerIndex == 0 then
        door = obj_get_first(OBJ_LIST_SURFACE)
        while door ~= nil do
            if door.behavior == get_behavior_from_id(id_bhvDoor) or door.behavior == get_behavior_from_id(id_bhvStarDoor) then
                if door.oDoorDespawnedTimer > 0 then
                    door.oDoorDespawnedTimer = door.oDoorDespawnedTimer - 1
                else
                    door.oPosY = door.oHomeY
                end
            end

            door = obj_get_next(door)
        end
    end

    door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local targetDoor = door
    local starDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)
    if starDoor ~= nil then
        if dist_between_objects(m.marioObj, starDoor) < dist_between_objects(m.marioObj, door) then
            targetDoor = starDoor
        else
            targetDoor = door
        end
    end

    if targetDoor ~= nil then
        local dist = 200
        if m.action == ACT_LONG_JUMP and m.forwardVel <= -70 then dist = 1000 end

        local starRequirement = 0
        if (m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE or m.action == ACT_JUMP_KICK or (m.action == ACT_LONG_JUMP and m.forwardVel <= -80)) and dist_between_objects(m.marioObj, targetDoor) < dist then
            local model = E_MODEL_CASTLE_CASTLE_DOOR
            -- just make obj_get_model_extended dammit
            if obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_1_STAR) ~= 0 then
                model = E_MODEL_CASTLE_DOOR_1_STAR
                starRequirement = 1
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_3_STARS) ~= 0 then
                model = E_MODEL_CASTLE_DOOR_3_STARS
                starRequirement = 3
            elseif obj_has_model_extended(targetDoor, E_MODEL_CCM_CABIN_DOOR) ~= 0 then
                model = E_MODEL_CCM_CABIN_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_METAL_DOOR) ~= 0 then
                model = E_MODEL_HMC_METAL_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_WOODEN_DOOR) ~= 0 then
                model = E_MODEL_HMC_WOODEN_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_BBH_HAUNTED_DOOR) ~= 0 then
                model = E_MODEL_BBH_HAUNTED_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_METAL_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_METAL_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_CASTLE_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_CASTLE_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_HAZY_MAZE_DOOR) ~= 0 then
                model = E_MODEL_HMC_HAZY_MAZE_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_GROUNDS_METAL_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_GROUNDS_METAL_DOOR
            elseif targetDoor.behavior == get_behavior_from_id(id_bhvStarDoor) ~= 0 then
                -- model = E_MODEL_CASTLE_STAR_DOOR_8_STARS
                model = E_MODEL_CASTLE_CASTLE_DOOR
                starRequirement = targetDoor.oBehParams >> 24
            end

            if m.numStars >= starRequirement then
                play_sound(SOUND_GENERAL_BREAK_BOX, m.marioObj.header.gfx.cameraToObject)
                targetDoor.oDoorDespawnedTimer = 339
                targetDoor.oPosY = 9999
                spawn_triangle_break_particles(30, 138, 1, 4)
                spawn_non_sync_object(
                    id_bhvBrokenDoor,
                    model,
                    targetDoor.oPosX, targetDoor.oHomeY, targetDoor.oPosZ,
                    --- @param o Object
                    function(o)
                        --if m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE then
                        --    o.oForwardVel = 100
                        --else
                        --    o.oForwardVel = 20

                        --    mario_set_forward_vel(m, -16)
                        --    set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        --    play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                        --end
                        o.oDoorBuster = gNetworkPlayers[m.playerIndex].globalIndex
                        o.oForwardVel = 80
                        set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                    end
                )
                if starRequirement == 50 and m.action == ACT_LONG_JUMP and m.forwardVel <= -80 then
                    set_mario_action(m, ACT_THROWN_BACKWARD, 0)
                    m.forwardVel = -300
                    m.faceAngle.y = -0x8000
                    m.vel.y = 20
                    m.pos.x = -200
                    m.pos.y = 2350
                    m.pos.z = 4900
                else
                    if m.playerIndex == 0 then set_camera_shake_from_hit(SHAKE_SMALL_DAMAGE) end
                end
            end
        end

        if lateral_dist_between_object_and_point(m.marioObj, -200, 6977) < 10 and gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_THROWN_BACKWARD then
            set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 0)
            m.hurtCounter = 4 * 4
            play_character_sound(m, CHAR_SOUND_ATTACKED)
            spawn_triangle_break_particles(20, 138, 3, 4)
            stop_background_music(SEQ_LEVEL_INSIDE_CASTLE)
        end
    end

    if gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_HARD_BACKWARD_AIR_KB and m.prevAction == ACT_THROWN_BACKWARD then
        m.actionTimer = m.actionTimer + 1
        m.invincTimer = 30
        set_camera_shake_from_hit(SHAKE_MED_DAMAGE)
        play_sound(SOUND_GENERAL_METAL_POUND, m.marioObj.header.gfx.cameraToObject)
    end
end

--- @param m MarioState
--- @param o Object
function allow_interact(m, o)
    if o.behavior == get_behavior_from_id(id_bhvBrokenDoor) and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end

--Wallslide--

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if not gPlayerSyncTable[m.playerIndex].wallSlide and mod_storage_load("Wallslide") then return end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        local rc = set_mario_action(m, ACT_WALL_KICK_AIR, 0)
        
        m.vel.y = 60.0

        if m.forwardVel < 20.0 then
            m.forwardVel = 20.0
        end
        m.wallKickTimer = 0
        return rc
    end

    -- attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls
    mario_set_forward_vel(m, -1.0)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    set_mario_animation(m, MARIO_ANIM_START_WALLKICK)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        mario_set_forward_vel(m, 0.0)
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end
    end

    m.actionTimer = m.actionTimer + 1
    if m.wall == nil and m.actionTimer > 2 then
        mario_set_forward_vel(m, 0.0)
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    -- gravity
    m.vel.y = m.vel.y + 3.5
    if m.vel.y < -20 then
        m.vel.y = -20
    end
    if m.vel.y > 10 then
        m.vel.y = 10
    end

    return 0
end

--The 60 degree part

local actions_able_to_wallkick =
{
    [ACT_JUMP] = ACT_JUMP,
    [ACT_HOLD_JUMP] = ACT_HOLD_JUMP,
    [ACT_DOUBLE_JUMP] = ACT_DOUBLE_JUMP,
    [ACT_TRIPLE_JUMP] = ACT_TRIPLE_JUMP,
    [ACT_SIDE_FLIP] = ACT_SIDE_FLIP,
    [ACT_BACKFLIP] = ACT_BACKFLIP,
    [ACT_LONG_JUMP] = ACT_LONG_JUMP,
    [ACT_WALL_KICK_AIR] = ACT_WALL_KICK_AIR,
    [ACT_TOP_OF_POLE_JUMP] = ACT_TOP_OF_POLE_JUMP,
    [ACT_FREEFALL] = ACT_FREEFALL
}

--Thanks Djoslin
function convert_s16(num)
    local min = -32768
    local max = 32767
    while (num < min) do
        num = max + (num - min)
    end
    while (num > max) do
        num = min + (num - max)
    end
    return num
end

--This is mostly copied from the wall bonk check code
---@param m MarioState
function wallkicks(m)
    if m.playerIndex ~= 0 then return end
    if not gPlayerSyncTable[m.playerIndex].wallSlide then return end
    if m.wall ~= nil then
        if (m.wall.type == SURFACE_BURNING) then return end

        local wallDYaw = (atan2s(m.wall.normal.z, m.wall.normal.x) - (m.faceAngle.y))
        --I don't really understand this however I do know the lower `limit` becomes, the more possible wallkick degrees.
        local limitNegative = (-((180 - 61) * (8192/45))) + 1
        local limitPositive = ((180 - 61) * (8192/45)) - 1
        --wallDYaw is s16, so I converted it
        wallDYaw = convert_s16(wallDYaw)

        --Standard air hit wall requirements
        if (m.forwardVel >= 16) and (actions_able_to_wallkick[m.action] ~= nil) then
            if (wallDYaw >= limitPositive) or (wallDYaw <= limitNegative) then
                mario_bonk_reflection(m, 0)
                m.faceAngle.y = m.faceAngle.y + 0x8000
                set_mario_action(m, ACT_AIR_HIT_WALL, 0)
            end
        end
    end
end

local function ternary(condition, ifTrue, ifFalse)
    if condition then
        return ifTrue
    end
    return ifFalse
end

local quicksand_death_surfaces = {
    [SURFACE_INSTANT_QUICKSAND] = true,
    [SURFACE_INSTANT_MOVING_QUICKSAND] = true
}

local noStrafeActs = {
    [ACT_WALKING] = true,
    [ACT_BRAKING] = true,
    [ACT_BRAKING_STOP] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_WALL_SLIDE] = true,
    [ACT_STAR_DANCE_EXIT] = true,
    [ACT_STAR_DANCE_NO_EXIT] = true,
    [ACT_STAR_DANCE_WATER] = true,
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_HOLD_JUMP] = true,
    [ACT_DEATH_EXIT] = true,
    [ACT_UNUSED_DEATH_EXIT] = true,
    [ACT_FALLING_DEATH_EXIT] = true,
    [ACT_SPECIAL_DEATH_EXIT] = true,
}

--- @param m MarioState
function on_set_mario_action(m)
    --Swim Star Anim--
    if (m.action == ACT_FALL_AFTER_STAR_GRAB) then
        m.action = ACT_STAR_DANCE_WATER
    end

    --Lava Groundpound--
    if menuTable[1][2].status == 1 then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_LAVA_BOOST then
            m.vel.y = m.vel.y * 1.1
            m.forwardVel = 70
            m.health = m.health - 272
        end
    end
    
    --Anti quicksand--
    if menuTable[1][3].status == 1 and gGlobalSyncTable.GlobalAQS then
        if m.action == ACT_QUICKSAND_DEATH then
            set_mario_action(m, ACT_LAVA_BOOST, 0)
            if m.flags & MARIO_METAL_CAP ~= 0 then
                return
            elseif m.flags & MARIO_CAP_ON_HEAD ~= 0 then
                m.hurtCounter =  12
            elseif m.flags & MARIO_CAP_ON_HEAD == 0 then
                m.hurtCounter =  18
            end
        end
    end

    --wallslide--
    if m.action == ACT_SOFT_BONK and gPlayerSyncTable[m.playerIndex].wallSlide then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        set_mario_action(m, ACT_WALL_SLIDE, 0)
    end

    --Strafing--
    if menuTable[1][5].status == 1 then
        if not noStrafeActs[m.action] then
            m.faceAngle.y = m.area.camera.yaw + 32250
        end
    end

    --Sideflip anywhere
    if (m.input & INPUT_A_PRESSED) ~= 0 then -- checks if marmite is going to do a steep jump and if a button is pressed
        if m.prevAction == ACT_TURNING_AROUND or m.prevAction == ACT_FINISH_TURNING_AROUND then -- checks if maio was turning around
            set_mario_action(m, ACT_SIDE_FLIP, 0) -- if all conditions are met set martin's action to sideflip
        end
    end
end

function update()
    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if (not SSC) and ((c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN)) then
        disable_time_stop_including_mario()
        m.freeze = 0
        c.cutscene = 0
    end
end

--For blue coin preview
function bhv_custom_hidden_blue_coin_loop(obj)
    if visible then
        cur_obj_enable_rendering()
    else
        cur_obj_disable_rendering()
    end
end

--Visable Lakitu--
-- define our variables to hold the global id of each Lakitu's owner, and its blink timer
define_custom_obj_fields({ oLakituOwner = 'u32', oLakituBlinkTimer = 's32' })

-- for some reason Lua doesn't treat booleans as 1/0 numbers
local boolToNumber = { [true] = 1, [false] = 0 }

local function obj_update_blinking(o, timer, base, range, length)
    -- update our timer
    if timer > 0 then timer = timer - 1
    else timer = base + (range * math.random()) end

    -- set Lakitu's blink state depending on what our timer is at
    o.oAnimState = boolToNumber[(timer <= length)]
    return timer
end

local function is_current_area_sync_valid()
    -- check all connected players to see if their area sync is valid
    for i = 0, (MAX_PLAYERS - 1) do
        local np = gNetworkPlayers[i]
        if np ~= nil and np.connected and (not np.currLevelSyncValid or not np.currAreaSyncValid) then
            return false
        end
    end
    return true
end

local function active_player(m, np)
    -- check if this player is connected and in the same level
    if not np.connected or np.currCourseNum ~= gNetworkPlayers[0].currCourseNum or np.currActNum ~= gNetworkPlayers[0].currActNum or np.currLevelNum ~= gNetworkPlayers[0].currLevelNum or
        np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return is_player_active(m)
end

local function obj_mark_for_deletion_on_sync(o)
    -- delete this Lakitu if the area's sync status is valid
    if gNetworkPlayers[0].currAreaSyncValid then obj_mark_for_deletion(o) end
end

local function bhv_custom_lakitu_init(o)
    -- set up Lakitu's flags
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    -- use the default Lakitu animations
    o.oAnimations = gObjectAnimations.lakitu_seg6_anims_060058F8
    cur_obj_init_animation(0)

    -- spawn Lakitu's cloud if this isn't the local player's Lakitu
    if network_local_index_from_global(o.oLakituOwner) ~= 0 then
        spawn_non_sync_object(id_bhvCloud, E_MODEL_MIST, o.oPosX, o.oPosY, o.oPosZ,
            function(obj)
                -- make the cloud a child of Lakitu
                obj.parentObj = o
                -- sm64 knows this is a Lakitu cloud if oBehParams2ndByte is set to 1
                -- if oBehParams2ndByte is 0, the cloud will behave as a Fwoosh
                obj.oBehParams2ndByte = 1
                -- make the cloud twice the size size of a normal cloud (all Lakitu clouds do this)
                obj_scale(obj, 2)
            end)
    end

    -- init the networked Lakitu
    network_init_object(o, true, { "oLakituOwner", "oFaceAngleYaw", "oFaceAnglePitch" })
end

local function bhv_custom_lakitu(o)
    -- get the gNetworkPlayers table for the player that owns this Lakitu
    local np = network_player_from_global_index(o.oLakituOwner)
    -- this isn't a valid network player, delete this Lakitu
    if np == nil then
        obj_mark_for_deletion_on_sync(o)
        return
    end

    -- get the mario state of the player that owns this Lakitu
    local m = gMarioStates[np.localIndex]

    -- don't update this Lakitu if it isn't our Lakitu
    if m.playerIndex ~= 0 then
        -- delete this Lakitu if it's owner isn't active
        if not active_player(m, np) then
            obj_mark_for_deletion_on_sync(o)
            return
        end
        -- show the Lakitu for other players
        cur_obj_unhide()

        -- determine whether Lakitu should blink
        o.oLakituBlinkTimer = obj_update_blinking(o, o.oLakituBlinkTimer, 20, 40, 4)
        return
    else
        -- the local player cannot see it's own Lakitu
        cur_obj_hide()
    end

    -- set the Lakitu position to the camera position of that player
    o.oPosX = gLakituState.curPos.x
    o.oPosY = gLakituState.curPos.y
    o.oPosZ = gLakituState.curPos.z

    -- look at Mario
    o.oHomeX = gLakituState.curFocus.x
    o.oHomeZ = gLakituState.curFocus.z

    o.oFaceAngleYaw = cur_obj_angle_to_home()
    o.oFaceAnglePitch = atan2s(cur_obj_lateral_dist_to_home(), o.oPosY - gLakituState.curFocus.y)

    -- send the current state of our Lakitu to other players if the area sync is valild
    if is_current_area_sync_valid() then
        network_send_object(o, false)
    end
end

local bhvPlayerLakitu = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_custom_lakitu_init, bhv_custom_lakitu)

-- spawn the local player's Lakitu when the area's sync state is valid (every time the player warps areas)
local function update_lakitu()
    -- spawn Lakitu with our custom Lakitu behavior and the default Lakitu model; and mark it as a sync object
    spawn_sync_object(bhvPlayerLakitu, E_MODEL_LAKITU, 0, 0, 0, function(o)
        -- save the global id of the player that owns this Lakitu
        o.oLakituOwner = gNetworkPlayers[0].globalIndex
    end)
end

--Player Colored Stars
--- @param o Object
local function bhv_star_init(o)
    o.globalPlayerIndex = gNetworkPlayers[0].globalIndex
end
id_bhvStar = hook_behavior(id_bhvStar, OBJ_LIST_LEVEL, false, bhv_star_init, nil)

--All Hooks
hook_behavior(id_bhvHiddenBlueCoin, OBJ_LIST_LEVEL, false, nil, bhv_custom_hidden_blue_coin_loop)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, localtechaction)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_ON_INTERACT, on_interact)
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_mario_action(ACT_WALL_SLIDE, act_wall_slide)
hook_event(HOOK_BEFORE_PHYS_STEP, wallkicks)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)
hook_event(HOOK_ON_SYNC_VALID, update_lakitu)