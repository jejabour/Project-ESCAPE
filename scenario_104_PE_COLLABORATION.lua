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
    addGMFunction(_("buttonGM", "+ COLLABORATION Mission"), gmCOLLABORATION)
    addGMFunction(_("buttonGM", "+ Alert Level"), gmAlertLevel)
    addGMFunction(_("buttonGM", "+ Commands"), gmCommmands)
end

-- COLLABORATION Mission Commands
function gmCOLLABORATION()
    clearGMFunctions()
    gmMainMenu()
    addGMFunction(_("buttonGM", "- COLLABORATION Mission"), gmMainMenu)
    addGMFunction(_("buttonGM", "   Start Moving"), gmCOLLABORATION_Undock)
    addGMFunction(_("buttonGM", "   Victory"), gmVictory)
    addGMFunction(_("buttonGM", "   Defeat"), gmDefeat)
end

function gmAlertLevel()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Alert Level"), gmMainMenu)
    addGMFunction(_("buttonGM", "   Normal"), gmAlertNormal)
    addGMFunction(_("buttonGM", "   Yellow"), gmAlertYellow)
    addGMFunction(_("buttonGM", "   Red"), gmAlertRed)
end

function gmCommmands()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "- Commands"), gmMainMenu)
    addGMFunction(_("buttonGM", "   Clear Mission"), gmClearMission)
end

-- #####################################################################################################################
-- ## COLLABORATION Mission Commands                                                                                  ##
-- #####################################################################################################################
function gmCOLLABORATION_Undock()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    mission_state = 2
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

    alertLevel = "normal"
end

function gmAlertYellow()
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "yellow"
end

function gmAlertRed()
    clearGMFunctions()
    gmMainMenu()

    alertLevel = "red"
end

-- #####################################################################################################################
-- ## Commands                                                                                                        ##
-- #####################################################################################################################
function gmClearMission()
    gmAlertNormal()

    PlayerShip1:destroy()
    PlayerShip2:destroy()
    waveNumber = 0

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
    waveNumber = 0

    -- Create the two ships for the players
    PlayerShip1 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    PlayerShip1:setPosition(23500, 16100):setCallSign("Red Team")
    PlayerShip2 = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    PlayerShip2:setPosition(23500, 16100):setCallSign("Blue Team")

    -- Create FOB
    fob = SpaceStation():setFaction("Human Navy"):setTemplate("Large Station")
    fob:setPosition(23500, 16100):setCallSign("Nebula Citadel")

    -- Create fleet of friendly ships
    NavyShip1 = CpuShip():setFaction("Human Navy"):setTemplate("Phobos T3")
    NavyShip1:setCanBeDestroyed(false):orderDefendTarget(fob)
    NavyShip2 = CpuShip():setFaction("Human Navy"):setTemplate("Phobos T3")
    NavyShip2:setCanBeDestroyed(false):orderDefendTarget(fob)
    NavyShip3 = CpuShip():setFaction("Human Navy"):setTemplate("Phobos T3")
    NavyShip3:setCanBeDestroyed(false):orderDefendTarget(fob)

    -- Add friendly ships to friendList
    table.insert(friendList, NavyShip1)
    table.insert(friendList, NavyShip2)
    table.insert(friendList, NavyShip3)

    -- Establish a mission state variable
    mission_state = 0
end

function init()
    gmSetMission()
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

--- Return the distance between two objects.
function distance(obj1, obj2)
    local x1, y1 = obj1:getPosition()
    local x2, y2 = obj2:getPosition()
    local xd, yd = (x1 - x2), (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)
end