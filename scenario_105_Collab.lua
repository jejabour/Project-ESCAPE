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

-- AMBUSH Mission Commands
function gmCollab()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Collab Mission"),gmMainMenu)
    addGMFunction(_("buttonGM", "   Drop Intel"),gmAmbush_SpawnWave)
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
    waveNumber = 0
    alertLevel = "normal"

    nebula_citadel = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy"):setRepairDocked(true)
    nebula_citadel:setPosition(23500, 16100):setCallSign("Nebula Citadel")

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

    initShip()

    createShips()

end



function gmAmbush_SpawnWave()
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




function update(delta)

    TraineeShip:commandSetAlertLevel(alertLevel)

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

    TraineeShip1:addToShipLog("This is the final frontier!"
    .. " The enemy is fast approaching us from Sector H4, and their largest battlehip is on the way! We need you to team up with another group to fight off invading enemies "
    .. "near our Nebula Citadel base, and destroy the enemy mothership, Odin! We estimate about 20 minutes before they get here. Good luck!", "white")

    TraineeShip2:addToShipLog("This is the final frontier!"
    .. " The enemy is fast approaching us from Sector H4, and their largest battlehip is on the way! We need you to team up with another group to fight off invading enemies "
    .. "near our Nebula Citadel base, and destroy the enemy mothership, Odin! We estimate about 20 minutes before they get here. Good luck!", "white")

end


function createShips()

    ExShip1 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-12666, 39095):setScanned(true):orderAttack(nebula_citadel)
    ExShip2 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-8769, 42007):setScanned(true):orderAttack(nebula_citadel)
    ExShip3 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-5657, 44321):setScanned(true):orderAttack(nebula_citadel)
    ExShip4 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(-1810, 46548):setScanned(true):orderAttack(nebula_citadel)

    ExForetress = CpuShip():setTemplate("Fortress"):setFaction("Exuari"):setPosition(-32127, 62007):setScanned(true):orderStandGround()

    -- ExShip5 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(23152, 55882):setScanned(true):orderStandGround()
    -- ExShip6 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(26948, 55346):setScanned(true):orderStandGround()
    -- ExShip7 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(31069, 54316):setScanned(true):orderStandGround()

    -- ExShip8 = CpuShip():setTemplate("Gunship"):setFaction("Exuari"):setPosition(28862, 62216):setScanned(true):orderStandGround()

    -- ExShip9 = CpuShip():setTemplate("Adder MK5"):setFaction("Exuari"):setPosition(31379, 77307):setScanned(true):orderDefendLocation(31379, 77307)

    -- ExStation = SpaceStation():setTemplate("Medium Station"):setFaction("Exuari"):setPosition(32554, 64435):setScanned(true)

    NavyShip1 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(19254, 23354):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip2 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(29786, 23184):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip3 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(17872, 10134):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)
    NavyShip4 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(27632, 10076):setScanned(true):setWeaponStorageMax("Homing", 12):setWeaponStorage("Homing", 12):setCanBeDestroyed(False):orderDefendTarget(nebula_citadel)

    -- NavyStation = SpaceStation():setTemplate("Medium Station"):setFaction("Human Navy"):setPosition(25388, 86065):setScanned(true)

    -- table.insert(enemyList, ExShip1)
    -- table.insert(enemyList, ExShip2)
    -- table.insert(enemyList, ExShip3)
    -- table.insert(enemyList, ExShip4)
    -- table.insert(enemyList, ExShip5)
    -- table.insert(enemyList, ExShip6)
    -- table.insert(enemyList, ExShip7)
    -- table.insert(enemyList, ExShip8)
    -- table.insert(enemyList, ExShip9)
    -- table.insert(enemyList, ExStation)
    -- table.insert(friendList, NavyShip1)
    -- table.insert(friendList, NavyShip2)
    -- table.insert(friendList, NavyShip3)
    -- table.insert(friendList, NavyShip4)
    -- table.insert(friendList, NavyStation)

end



-- #####################################################################################################################
-- ## Victory and Defeat                                                                                                    ##
-- #####################################################################################################################

function gmVictory()
    clearGMFunctions()
    gmMainMenu()

    message_victory = "Thank you, crew, for your service! The threat has been defeated, and the mission is complete. Return for debriefing."

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

    TraineeShip:destroy()


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

    for _, nebula in ipairs(nebulaeList) do
        if nebula:isValid() then
            nebula:destroy()
        end
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
