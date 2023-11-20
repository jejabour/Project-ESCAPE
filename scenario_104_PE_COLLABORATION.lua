-- Name: Scenario 6: COLLABORATION
-- Description: The war is nearing it's end! We have one more final assault targeting the Exuari base, but they won't go down without a fight. Team up with another group for the last push and claim victory for the Human Navy!
-- Type: Project ESCAPE

-- #####################################################################################################################
-- ## NOTES                                                                                                           ##
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
-- ## GM MENU                                                                                                         ##
-- #####################################################################################################################

function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "COLLABORATION      +"), gmCOLLABORATION)
    addGMFunction(_("buttonGM", "Alert Level        +"), gmAlertLevel)
    addGMFunction(_("buttonGM", "Useful Commands    +"), gmUsefulCommmands)
end

function gmAlertLevel()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Alert level        -"), gmMainMenu)
    addGMFunction(_("buttonGM", "Normal"), gmAlertNormal)
    addGMFunction(_("buttonGM", "Yellow"), gmAlertYellow)
    addGMFunction(_("buttonGM", "Red"), gmAlertRed)
end

function gmUsefulCommmands()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Useful Commands    -"), gmMainMenu)
    addGMFunction(_("buttonGM", "Create FOB"), gmCreateFOB)
    addGMFunction(_("buttonGM", "Clear Mission"), gmClearMission)
end

-- COLLABORATION missions
function gmCOLLABORATION()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
    addGMFunction(_("buttonGM", "COLLABORATION      -"), gmMainMenu)
    addGMFunction(_("buttonGM", "Start Moving"), gmCOLLABORATION_1)
    addGMFunction(_("buttonGM", "Enemy Defeated"), gmCOLLABORATION_2)
end

-- When undocked, tell all ships to stop being idle
function gmCOLLABORATION_1()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()



    mission_state = 2
end

-- #####################################################################################################################
-- ## GM ALERT LEVEL                                                                                                  ##
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
-- ## Extra Commands                                                                                                  ##
-- #####################################################################################################################

function gmCreateFOB()
    gmMainMenu()
    -- Home = setPosition(23500, 16100)

    if fob:getPosition() == nil then
        fob = SpaceStation():setTemplate("Small Station"):setFaction("Human Navy")
        fob:setPosition(23500, 16100):setCallSign("Central Command")
    end
end

function gmCreateEnemyBase()
    gmMainMenu()


end

function gmClearMission()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    TraineeShip:destroy()

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

end

-- #####################################################################################################################
-- ## Victory and Defeat Messages                                                                                     ##
-- #####################################################################################################################

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

function gmVictory()
    clearGMFunctions()
    gmMainMenu()

    message_victory = "Thank you, crew, for your service! The threat has been defeated, the intel recovered, and the mission is complete. Return for debriefing."

    -- Display a mesasage on the main screen for 2 minutes
    globalMessage(message_victory, 120)

    -- Display a popup message on each players screen.
    -- addCustomMessage(role, name of the string???, string)
    TraineeShip:addCustomMessage("helms", "helms_message_victory", message_victory)
    TraineeShip:addCustomMessage("engineering", "engineering_message_victory", message_victory)
    TraineeShip:addCustomMessage("weapons", "weapon_message_victory", message_victory)
    TraineeShip:addCustomMessage("science", "science_message_victory", message_victory)
    TraineeShip:addCustomMessage("relay", "relay_message_victory", message_victory)

    -- victory("Human Navy")
end

-- #####################################################################################################################
-- ## Initialization Function                                                                                         ##
-- #####################################################################################################################

function init()
    -- Setup GM menu
    gmMainMenu()

    -- Setup global variables
    TraineeShip1 = {}
    TraineeShip2 = {}
    enemyList = {}
    friendList = {}
    waveNumber = 0
    alertLevel = "normal"

    -- Create the FOB
    fob = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    fob:setPosition(23500, 16100):setCallSign("FOB Charlie")
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