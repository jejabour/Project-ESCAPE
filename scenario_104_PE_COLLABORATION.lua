-- Name: Scenario 6: COLLABORATION
-- Description: The war is nearing it's end! We have one more final assault targeting the Exuari base, but they won't go down without a fight. Team up with another group for the last push and claim victory for the Human Navy!
-- Type: Project ESCAPE

-- #####################################################################################################################
-- ## Notes                                                                                                           ##
-- #####################################################################################################################

-- ##### FACTIONS #####
-- In relation to Human Navy {
    -- Good Guys [USN, TSN, CUF, Human Navy]

    -- Neutral [Arlenians, Independent]

    -- Bad Guys [Exuari, Ktlitans, Kraylor, Ghosts]
-- }

-- ##### LOCATION #####
-- When trying to place things {

    -- It's easiest to just place an object in game and use the location
    -- on the top right to get an idea of where you are
    -- The ship starts x=23400, y=16100. From this point,
    -- increasing X moves it to the right. Increasing Y moves it down.

-- }

-- #####################################################################################################################
-- ## GM Menu                                                                                                         ##
-- #####################################################################################################################
function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "COLLABORATION    ▶"), gmCOLLABORATION)
    addGMFunction(_("buttonGM", "Alert Level          ▶"), gmAlertLevel)
    addGMFunction(_("buttonGM", "Commands         ▶"), gmCommmands)
end

-- COLLABORATION Mission Commands
function gmCOLLABORATION()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "COLLABORATION    ▼"), gmMainMenu)
    addGMFunction(_("buttonGM", "   • Start Moving "), gmCOLLABORATION_Undock)
    addGMFunction(_("buttonGM", "   • Victory          "), gmVictory)
    addGMFunction(_("buttonGM", "   • Defeat           "), gmDefeat)
    addGMFunction(_("buttonGM", "Alert Level          ▶"), gmAlertLevel)
    addGMFunction(_("buttonGM", "Commands         ▶"), gmCommmands)
end

function gmAlertLevel()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "COLLABORATION    ▶"), gmMainMenu)
    addGMFunction(_("buttonGM", "Alert Level          ▼"), gmMainMenu)
    addGMFunction(_("buttonGM", "   • Normal       "), gmAlertNormal)
    addGMFunction(_("buttonGM", "   • Yellow        "), gmAlertYellow)
    addGMFunction(_("buttonGM", "   • Red            "), gmAlertRed)
    addGMFunction(_("buttonGM", "Commands         ▶"), gmCommmands)
end

function gmCommmands()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "COLLABORATION    ▶"), gmMainMenu)
    addGMFunction(_("buttonGM", "Alert Level          ▶"), gmMainMenu)
    addGMFunction(_("buttonGM", "Commands         ▼"), gmMainMenu)
    addGMFunction(_("buttonGM", "   • Clear Mission"), gmClearMission)
end

-- #####################################################################################################################
-- ## COLLABORATION Mission Commands                                                                                  ##
-- #####################################################################################################################
function gmCOLLABORATION_Undock()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
end

function gmVictory()
    clearGMFunctions()
    gmMainMenu()

    message_victory = "Thank you, crew, for your service! The threat has been defeated, the intel recovered, and the mission is complete. Return for debriefing."

    -- Display a mesasage on the main screen for 2 minutes
    globalMessage(message_victory, 120)

    -- Display a popup message on each players screen
    TraineeShip:addCustomMessage("helms", "helms_message_victory", message_victory)
    TraineeShip:addCustomMessage("engineering", "engineering_message_victory", message_victory)
    TraineeShip:addCustomMessage("weapons", "weapon_message_victory", message_victory)
    TraineeShip:addCustomMessage("science", "science_message_victory", message_victory)
    TraineeShip:addCustomMessage("relay", "relay_message_victory", message_victory)

    -- victory("Human Navy")
end

function gmDefeat()
    clearGMFunctions()
    gmMainMenu()

    message_defeat = "The mission has been lost. Report for debriefing."

    globalMessage(message_defeat)

    -- Display a mesasage on the main screen for 2 minutes
    globalMessage(message_defeat, 120)

    -- Display a popup message on each players screen
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
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "Normal"
end

function gmAlertYellow()
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "Yellow"
end

function gmAlertRed()
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "Red"
end

-- #####################################################################################################################
-- ## Commands                                                                                                        ##
-- #####################################################################################################################
function gmClearMission()
    gmAlertNormal()

    PlayerShip1:destroy()
    PlayerShip2:destroy()

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

end

-- #####################################################################################################################
-- ## Helper Functions                                                                                                ##
-- #####################################################################################################################
function gmSetMission()
    gmAlertNormal()

    enemyList = {}
    friendList = {}

    -- Create FOB
    x, y = 0, 0
    NebulaCitadel = SpaceStation():setFaction("Human Navy"):setTemplate("Large Station")
    NebulaCitadel:setPosition(0, 0):setCallSign("Nebula Citadel")
    x, y = NebulaCitadel:getPosition()

    -- Create the two ships for the players
    PlayerShip1 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    PlayerShip1:setPosition(x, y):commandDock(NebulaCitadel):setCallSign("Red")
    PlayerShip2 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    PlayerShip2:setPosition(x, y):commandDock(NebulaCitadel):setCallSign("Blue")

    -- Create enemy mother ship
    EnemyMotherShip = CpuShip():setFaction("Exuari"):setTemplate("Ryder"):setPosition(x + 10000, y)
    --                            Idx,  Arc,    Dir,    Range,  CycleTime,  Dmg
    EnemyMotherShip:setBeamWeapon(0,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(1,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(2,    20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(3,    20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(4,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(5,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(6,    20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(7,    20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(8,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(9,    20,    -90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(10,   20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:setBeamWeapon(11,   20,     90,     1200.0, 9.0,        1)
    EnemyMotherShip:orderFlyTowards(x, y)

    -- Add enemy mother ship to enemyList
    table.insert(enemyList, EnemyMotherShip)

    -- Add nebula to obscure enemy mother ship
    nebula = Nebula():setPosition(x + 10000, y)

    -- Spawn the first waves of ships
    spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")
    spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")
    spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")

    -- Spawn space objects
    --          Type            Number  x1      y1      x2      y2      Random variance in position
    spawnObject(Asteroid,       1000,  -50000, -50000,  50000,  50000)  --,  100000                      )
    spawnObject(VisualAsteroid, 1000,  -50000, -50000,  50000,  50000)  --,  100000                      )
    spawnObject(Nebula,         10,    -50000, -50000,  50000,  50000)

    -- Establish a mission state variable
    mission_state = 0
end

function init()
    gmSetMission()
end

-- Spawn a ship with the given origin, target, faction, and template
function spawnShip(origin, target, faction, template)
    x, y = origin:getPosition()
    Ship = CpuShip():setFaction(faction):setTemplate(template):setPosition(x, y):setHullMax(0):setShieldsMax(0)
    if faction == "Exuari" then
        table.insert(enemyList, Ship)
        x, y = target:getPosition()
        Ship:orderFlyTowards(x, y)
    else
        table.insert(friendlyList, Ship)
        Ship:orderDefendTarget(target)
    end
    return
end

-- Changes to make every time step
function update(delta)
    if spawnDelay ~= nil then
        spawnDelay = spawnDelay - delta
        if spawnDelay < 0 then
            spawnDelay = nil
            spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")
            spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")
            spawnShip(EnemyMotherShip, NebulaCitadel, "Exuari", "Dagger")
            --spawnShip(NebulaCitadel, NebulaCitadel, "Human Navy", "MU52 Hornet")
        end
        return
    end

    spawnDelay = 15
end

-- Place objects randomly in a rough line
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

-- Place objects at some random location in the box bounded by the two given coordinate points
function spawnObject(object_type, number, x1, y1, x2, y2)
    for n = 1, number do
        local x = random(x1, x2)
        local y = random(y1, y2)
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