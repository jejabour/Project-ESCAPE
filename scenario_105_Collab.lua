-- Name: Scenario 6: Collab
-- Description: Team up with your coworkers to defeat the Exuari mothership, and defend your base at the same time!
-- Type: Project ESCAPE

-- #####################################################################################################################
-- ## Notes                                                                                                           ##
-- #####################################################################################################################

-- ######## FACTIONS #########
-- In relation to Human Navy{
    -- Good Guys [USN, TSN, CUF, Human Navy]

    -- Neutral [Arlenians, Independent]

    -- Bad Guys [Exuari, Ktlitans, Kraylor, Ghosts]
-- }

-- ######## LOCATION #########
-- When trying to place things{

    -- It's easiest to just place an object in game and use the location
    -- on the top right to get an idea of where you are
    -- The ship starts x=22598, 16086. From this point,
    -- increasing X moves it to the right. Increasing Y moves it down.

--}

-- #####################################################################################################################
-- ## GM Menu                                                                                                         ##
-- #####################################################################################################################
function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "+ Collab MISSION"), gmCollab)
    addGMFunction(_("buttonGM", "+ Alert Level"),gmAlertLevel)
    addGMFunction(_("buttonGM", "+ Commands"), gmCommmands)
end


function gmCollab()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Collab Mission"),gmMainMenu)
    addGMFunction(_("buttonGM", "   Spawn Wave"),gmSpawnWave)
    addGMFunction(_("buttonGM", "   Move Ships"),gmMove_Ships)
    addGMFunction(_("buttomGM", "   UpdateMission"),gmUpdateMission)
    addGMFunction(_("buttonGM", "   Defeat"),gmDefeat)
    addGMFunction(_("buttonGM", "   Victory"),gmVictory)
    addGMFunction(_("buttonGM", "   Set Mission"),gmSetCollab)
end

function gmAlertLevel()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Alert Level"),gmMainMenu)
    addGMFunction(_("buttonGM", "   Normal"),gmAlertNormal)
    addGMFunction(_("buttonGM", "   Yellow"),gmAlertYellow)
    addGMFunction(_("buttonGM", "   Red"),gmAlertRed)
end

function gmCommmands()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Commands"),gmMainMenu)
    addGMFunction(_("buttonGM", "   Create FOB"),gmCreateStart_Station)
    addGMFunction(_("buttonGM", "   Clear Mission"), gmClearMission)
end


-- #####################################################################################################################
-- ## Init Function                                                                                               ##
-- #####################################################################################################################

function init()

    gmMainMenu()


    TraineeShip = {}
    enemyList = {}
    friendList = {}
    asteroidList = {}
    waveNumber = 0
    alertLevel = "normal"

    nebula_citadel = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy"):setRepairDocked(true)
    nebula_citadel:setPosition(23500, 16100):setCallSign("Nebula Citadel"):setCanBeDestroyed(false)

    -- Nebula that hide the enemy station.
    Nebula():setPosition(-43300, 2200)
    Nebula():setPosition(-34000, -700)
    Nebula():setPosition(-32000, -10000)
    Nebula():setPosition(-24000, -14300)
    Nebula():setPosition(-28600, -21900)

    -- Random nebulae in the system
    Nebula():setPosition(-8000, -38300)
    Nebula():setPosition(24000, -30700)
    Nebula():setPosition(42300, 3100)
    Nebula():setPosition(49200, 10700)
    Nebula():setPosition(3750, 31250)
    Nebula():setPosition(-39500, 18700)

    -- Create 50 Asteroids
    placeRandom(Asteroid, 50, -7500, -10000, -12500, 30000, 2000)
    placeRandom(VisualAsteroid, 50, -7500, -10000, -12500, 30000, 2000)

    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    initShip()

    placeRandom_funnel(Asteroid, 90, -43743, 60000, 69000, 38300, 30000)
    -- addGMMessage(asteroidList[0])


    createShips()

    mission_state = 0

end

function gmSetCollab()

    gmMainMenu()

    TraineeShip = {}
    enemyList = {}
    friendList = {}
    asteroidList = {}
    waveNumber = 0
    alertLevel = "normal"

    initShip()

    placeRandom_funnel(Asteroid, 90, -43743, 60000, 69000, 38300, 30000)

    createShips()

end



function gmSpawnWave()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
    waveNumber = waveNumber + 1

    local totalScoreRequirement = math.pow(waveNumber * 0.8, 1.3) * 10

    local scoreInSpawnPoint = 0
    local spawnDistance = 2500
    local spawnPointLeader = nil
    local spawn_x, spawn_y, spawn_range_x, spawn_range_y = randomSpawnPointInfo(spawnDistance)
    while totalScoreRequirement > 0 do
        local ship = CpuShip():setFaction("Exuari")
        ship:setPosition(random(-spawn_range_x, spawn_range_x) + spawn_x, random(-spawn_range_y, spawn_range_y) + spawn_y)

        -- Make the first ship the leader at this spawn point
        if spawnPointLeader == nil then
            ship:orderRoaming()
            spawnPointLeader = ship
        else
            ship:orderDefendTarget(spawnPointLeader)
        end

        -- Set ship type
        local typeRoll = random(0, 10)
        local score
        if typeRoll < 2 then
            if irandom(1, 100) < 80 then
                ship:setTemplate("MT52 Hornet")
            else
                ship:setTemplate("MU52 Hornet")
            end
            score = 5
        elseif typeRoll < 3 then
            if irandom(1, 100) < 80 then
                ship:setTemplate("Adder MK5")
            else
                ship:setTemplate("WX-Lindworm")
            end
            score = 7
        elseif typeRoll < 6 then
            if irandom(1, 100) < 80 then
                ship:setTemplate("Phobos T3")
            else
                ship:setTemplate("Piranha F12")
            end
            score = 15
        elseif typeRoll < 7 then
            ship:setTemplate("Ranus U")
            score = 25
        elseif typeRoll < 8 then
            if irandom(1, 100) < 50 then
                ship:setTemplate("Stalker Q7")
            else
                ship:setTemplate("Stalker R7")
            end
            score = 25
        elseif typeRoll < 9 then
            ship:setTemplate("Atlantis X23")
            score = 50
        else
            ship:setTemplate("Odin")
            score = 250
        end
        assert(score ~= nil)

        -- Destroy ship if it was too strong else take it
        if score > totalScoreRequirement * 1.1 + 5 then
            ship:destroy()
            if ship == spawnPointLeader then spawnPointLeader = nil end
        else
            table.insert(enemyList, ship)
            totalScoreRequirement = totalScoreRequirement - score
            scoreInSpawnPoint = scoreInSpawnPoint + score
        end

        -- Start new spawn point farther away
        if scoreInSpawnPoint > totalScoreRequirement * 2.0 then
            spawnDistance = spawnDistance + 5000
            spawn_x, spawn_y, spawn_range_x, spawn_range_y = randomSpawnPointInfo(spawnDistance)
            scoreInSpawnPoint = 0
            spawnPointLeader = nil
        end
    end
end

function randomSpawnPointInfo(distance)
    local x, y
    local rx, ry
    if random(0, 100) < 50 then
        if random(0, 100) < 50 then
            x = -distance + 23500
        else
            x = distance - 23500
        end
        rx = 2500
        y = 16100
        ry = 5000 + 1000 * waveNumber
    else
        x = 23500
        rx = 5000 + 1000 * waveNumber
        if random(0, 100) < 50 then
            y = -distance + 16100
        else
            y = distance - 23500
        end
        ry = 2500
    end
    return x, y, rx, ry
end

function gmMove_Ships()

    clearGMFunctions()
    gmMainMenu()

    nebula_citadel:sendCommsMessage(TraineeShip1, ("The Exuari have jumped to the Nebula Citadel! We need as much backup as we can get now! "))
    nebula_citadel:sendCommsMessage(TraineeShip2, ("The Exuari have jumped to the Nebula Citadel! We need as much backup as we can get now! "))

    if ExShip5:isValid() then
        -- Move it close to CC
        ExShip5:setPosition(13282, 18050)
    end

    if ExShip6:isValid() then
        -- Move it close to CC
        ExShip6:setPosition(15359, 13848)
    end

    if ExShip7:isValid() then
        -- Move it close to CC
        ExShip7:setPosition(22263, 24628)
    end

    if ExShip8:isValid() then
        -- Move it close to CC
        ExShip8:setPosition(21843, 9814):orderRoaming()
    end

    if ExShip9:isValid() then
        -- Move it close to CC
        ExShip9:setPosition(35423, 21283):orderRoaming()
    end

    if ExForetress:isValid() then
        -- Move it close to CC
        ExForetress:setPosition(14120, 22797):orderRoaming()
    end


end

function gmUpdateMission()

    OdinLoc = ExForetress:getSectorName()

    nebula_citadel:sendCommsMessage(TraineeShip1, ("We have received intel that confirms the location of the Odin in Sector " ..OdinLoc.. ". If you can destroy the Odin, all enemy ships should retreat!"))

    nebula_citadel:sendCommsMessage(TraineeShip2, ("We have received intel that confirms the location of the Odin in Sector " ..OdinLoc.. ". If you can destroy the Odin, all enemy ships should retreat!"))

end


function update(delta)

    TraineeShip1:commandSetAlertLevel(alertLevel)

    TraineeShip2:commandSetAlertLevel(alertLevel)


    if TraineeShip1:isDocked(nebula_citadel) then
        TraineeShip1:setWeaponStorage("homing", 24):setWeaponStorage("nuke", 10):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 12):setWeaponStorage("HVLI", 24)
        TraineeShip1:setScanProbeCount(TraineeShip1:getMaxScanProbeCount())
    end

    if TraineeShip2:isDocked(nebula_citadel) then
        TraineeShip2:setWeaponStorage("homing", 24):setWeaponStorage("nuke", 10):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 12):setWeaponStorage("HVLI", 24)
        TraineeShip2:setScanProbeCount(TraineeShip1:getMaxScanProbeCount())
    end

    if not ExForetress:isValid() then
        for _, enemy in ipairs(enemyList) do
            if enemy:isValid() then
                enemy:destroy()
            end
        end

    end

    

end



function initShip()
    TraineeShip1 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis"):setWeaponStorageMax("Homing", 24):setWeaponStorage("Homing", 24):setCanBeDestroyed(False)
    TraineeShip1:setWeaponStorageMax("EMP", 12):setWeaponStorage("EMP", 12):setWeaponStorageMax("Nuke", 10):setWeaponStorage("Nuke", 10):setWeaponStorageMax("HVLI", 24):setWeaponStorage("HVLI", 24)
    TraineeShip1:setPosition(22598, 16100):setCallSign("Blue Team")
    TraineeShip1:setRotation(180) -- make sure it's facing away from station
    TraineeShip1:commandDock(nebula_citadel)

    TraineeShip2 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis"):setWeaponStorageMax("Homing", 24):setWeaponStorage("Homing", 24):setCanBeDestroyed(False)
    TraineeShip2:setWeaponStorageMax("EMP", 12):setWeaponStorage("EMP", 12):setWeaponStorageMax("Nuke", 10):setWeaponStorage("Nuke", 10):setWeaponStorageMax("HVLI", 24):setWeaponStorage("HVLI", 24)
    TraineeShip2:setPosition(24402, 16100):setCallSign("Green Team")
    TraineeShip2:setRotation(0) -- make sure it's facing away from station
    TraineeShip2:commandDock(nebula_citadel)

    message_collab = "This is the final frontier!"
    .. " The enemy is fast approaching us from Sector H4, and their largest battleship, the Odin, is on the way! We need you to team up with another group to intercept the Odin "
    .. "before it reaches the Nebula Citadel! We don't know their ETA, so assume they are within minutes of arriving. Good luck!"

    -- Display a popup message on each players screen.
    -- addCustomMessage(role, name of the string???, string)
    TraineeShip1:addCustomMessage("relay", "message_get_data", message_collab)

    TraineeShip2:addCustomMessage("relay", "message_get_data", message_collab)

    TraineeShip1:addToShipLog("This is the final frontier!"
    .. " The enemy is fast approaching us from Sector H4, and their largest battleship, the Odin, is on the way! We need you to team up with another group to intercept the Odin "
    .. "before it reaches the Nebula Citadel! We don't know their ETA, so assume they are within minutes of arriving. Good luck!", "white")

    TraineeShip1:addToShipLog("As one last ditch effort, have your science officer scan the Odin in one more attempt to ask for peace, and relay their response.", "white")

    TraineeShip2:addToShipLog("This is the final frontier!"
    .. " The enemy is fast approaching us from Sector H4, and their largest battleship, the Odin, is on the way! We need you to team up with another group to intercept the Odin "
    .. "before it reaches the Nebula Citadel! We don't know their ETA, so assume they are within minutes of arriving. Good luck!", "white")

    TraineeShip2:addToShipLog("As one last ditch effort, have your science officer scan the Odin in one more attempt to ask for peace, and relay their response.", "white")

end


function createShips()

    ExShip1 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-6539, 33015):orderAttack(nebula_citadel)
    ExShip2 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-2642, 36852):orderAttack(nebula_citadel)
    ExShip3 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(2636, 40254):orderAttack(nebula_citadel)
    ExShip4 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(6879, 42643):orderAttack(nebula_citadel)

    ExForetress = CpuShip():setTemplate("Fortress"):setFaction("Exuari"):setPosition(-20129, 56910):orderAttack(nebula_citadel):setCallSign("Odin"):setImpulseMaxSpeed(30)
    ExForetress:setDescriptions("", "We do not want compromise, we declare war!")

    ExShip5 = CpuShip():setTemplate("Gunner"):setFaction("Exuari"):setPosition(-16269, 45690):orderStandGround():setWeaponStorageMax("HVLI", 3):setWeaponStorage("HVLI", 3)
    ExShip6 = CpuShip():setTemplate("Gunner"):setFaction("Exuari"):setPosition(-12357, 50486):orderStandGround():setWeaponStorageMax("HVLI", 3):setWeaponStorage("HVLI", 3)
    ExShip7 = CpuShip():setTemplate("Gunner"):setFaction("Exuari"):setPosition(-8188, 54737):orderStandGround():setWeaponStorageMax("HVLI", 3):setWeaponStorage("HVLI", 3)

    ExShip8 = CpuShip():setTemplate("MT52 Hornet"):setFaction("Exuari"):setPosition(-20197, 55877):orderDefendTarget(ExForetress)
    ExShip9 = CpuShip():setTemplate("MT52 Hornet"):setFaction("Exuari"):setPosition(-20023, 57836):orderDefendTarget(ExForetress)

    -- ExStation = SpaceStation():setTemplate("Medium Station"):setFaction("Exuari"):setPosition(32554, 64435):setScanned(true)

    NavyShip1 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(19254, 23354):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip2 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(29786, 23184):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip3 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(17872, 10134):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip4 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(27632, 10076):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)

    -- NavyStation = SpaceStation():setTemplate("Medium Station"):setFaction("Human Navy"):setPosition(25388, 86065):setScanned(true)

    table.insert(enemyList, ExShip1)
    table.insert(enemyList, ExShip2)
    table.insert(enemyList, ExShip3)
    table.insert(enemyList, ExShip4)
    table.insert(enemyList, ExShip5)
    table.insert(enemyList, ExShip6)
    table.insert(enemyList, ExShip7)
    table.insert(enemyList, ExShip8)
    table.insert(enemyList, ExShip9)
    table.insert(enemyList, ExForetress)
    table.insert(friendList, NavyShip1)
    table.insert(friendList, NavyShip2)
    table.insert(friendList, NavyShip3)
    table.insert(friendList, NavyShip4)
    -- table.insert(friendList, NavyStation)

end



-- #####################################################################################################################
-- ## Victory and Defeat                                                                                                    ##
-- #####################################################################################################################

function gmVictory()
    clearGMFunctions()
    gmMainMenu()

    message_victory = "Thank you, crew, for your service! The Odin has been defeated and all enemy ships have fled! Return for debriefing."

    -- Display a mesasage on the main screen for 2 minutes
    globalMessage(message_victory, 120)

    -- Display a popup message on each players screen.
    -- addCustomMessage(role, name of the string???, string)
    TraineeShip:addCustomMessage("helms", "helms_message_victory", message_victory)
    TraineeShip:addCustomMessage("engineering", "engineering_message_victory", message_victory)
    TraineeShip:addCustomMessage("weapons", "weapon_message_victory", message_victory)
    TraineeShip:addCustomMessage("science", "science_message_victory", message_victory)
    TraineeShip:addCustomMessage("relay", "relay_message_victory", message_victory)

end

function gmDefeat()
    clearGMFunctions()
    gmMainMenu()

    message_defeat = "The mission has been lost. Report for debriefing."

    globalMessage(message_defeat)

    -- Display a mesasage on the main screen for 2 minutes
    globalMessage(message_defeat, 120)

    -- Display a popup message on each players screen.
    -- addCustomMessage(role, name of the string???, string)
    TraineeShip:addCustomMessage("helms", "helms_message_defeat", message_defeat)
    TraineeShip:addCustomMessage("engineering", "engineering_message_defeat", message_defeat)
    TraineeShip:addCustomMessage("weapons", "weapon_message_defeat", message_defeat)
    TraineeShip:addCustomMessage("science", "science_message_defeat", message_defeat)
    TraineeShip:addCustomMessage("relay", "relay_message_defeat", message_defeat)

    -- victory("Exuari")
end


-- #####################################################################################################################
-- ## Alert Level                                                                                                     ##
-- #####################################################################################################################
function gmAlertNormal()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "normal"
end

function gmAlertYellow()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "yellow"
end

function gmAlertRed()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "red"
end


-- #####################################################################################################################
-- ## Commands                                                                                                        ##
-- #####################################################################################################################
function gmCreateStart_Station()
    gmMainMenu()

    if orion_starforge:getPosition() == nil then
        orion_starforge = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
        orion_starforge:setPosition(23500, 16100):setCallSign("Orion Starforge")
    end
end

function gmClearMission()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    TraineeShip1:destroy()
    TraineeShip2:destroy()

    waveNumber = 0

    alertLevel = "normal"

    for _, friend in ipairs(friendList) do
        if friend:isValid() then
            friend:destroy()
        end
    end

    for _, enemy in ipairs(enemyList) do
        if enemy:isValid() then
            enemy:destroy()
        end
    end

    for _, aster in ipairs(asteroidList) do
        if aster:isValid() then
            aster:destroy()
        end
    end

end


-- ####################################
-- THE FUNNEL 
-- Creates the asteroids for the funnel
-- x = x-start + (x-end - x-start)
-- y = y-start + (y-end - y-start)
function placeRandom_funnel(object_type, number, x1, y1, x2, y2, random_amount)
    for n = 1, number do
        local f = random(0, 1)
        local x = x1 + (x2 - x1) * f
        local y = y1 + (y2 - y1) * f

        local r = random(0, 360)
        local distance = random(0, random_amount)
        x = x + math.cos(r / 180 * math.pi) * distance
        y = y + math.sin(r / 180 * math.pi) * distance

        ast = object_type():setPosition(x, y)
        table.insert(asteroidList, ast)
        -- addGMMessage("Adding to list?")

    end
end


--- Place objects randomly in a rough line
-- Distribute a `number` of random `object_type` objects in a line from point
-- x1,y1 to x2,y2, with a random distance up to `random_amount` between them.
function placeRandom(object_type, number, x1, y1, x2, y2, random_amount)
    for n = 1, number do
        local f = random(0, 1)
        local x = x1 + (x2 - x1) * f
        local y = y1 + (y2 - y1) * f

        local r = random(0, 360)
        local distance = random(0, random_amount)
        x = x + math.cos(r / 180 * math.pi) * distance
        y = y + math.sin(r / 180 * math.pi) * distance

        object_type():setPosition(x, y)
    end
end

--- Return the distance between two objects.
function distance(obj1, obj2)
    local x1, y1 = obj1:getPosition()
    local x2, y2 = obj2:getPosition()
    local xd, yd = (x1 - x2), (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)
end
