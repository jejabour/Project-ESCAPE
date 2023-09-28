-- Name: PE Tutorial
-- Description: This is a tutorial spotlighting each officer's roles
-- Type: Tutorial


-- #####################################################################
-- Initial setup function
-- #####################################################################

function init()
    -- Setup GM menu
    gmMainMenu()

    -- Setup global variables
    TraineeShip = {}
    enemyList = {}
    friendList = {}
    waveNumber = 0
    alertLevel = "normal"

    -- Create the command station
    central_command = SpaceStation():setTemplate("Small Station"):setFaction("Human Navy")
    central_command:setPosition(23500, 16100):setCallSign("Central Command")

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

    -- Create the main ship for the trainees.
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(23400, 16100):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(central_command)



    -- In relation to Human Navy{
    
        -- Good Guys [USN, TSN, CUF, Human Navy]

        -- Neutral [Arlenians, Independent]

        -- Bad Guys [Exuari, Ktlitans, Kraylor, Ghosts]
    
    -- }

    mission_state = 1

end

-- ##########################################################################
-- ## GM MENU ##
-- ##########################################################################
function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "Tutorials      +"), gmTutorials)
    addGMFunction(_("buttonGM", "Alert Level         +"),gmAlertLevel)
    addGMFunction(_("buttonGM", "Extra Commands      +"), gmUsefulCommmands)
end

function gmAlertLevel()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Alert level -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Normal"),gmAlertNormal)
    addGMFunction(_("buttonGM", "Yellow"),gmAlertYellow)
    addGMFunction(_("buttonGM", "Red"),gmAlertRed)
end

function gmTutorials()
    clearGMFunctions() -- Clear the Menu
    
    addGMFunction(_("buttonGM", "Tutorial -"), gmMainMenu)
    addGMFunction(_("buttonGM", "Send Mission"), gmSendMission)
    addGMFunction(_("buttonGM", "Jump"), gmSpawnStation)
    addGMFunction(_("buttonGM", "Weapons"), gmWeapons)
    addGMFunction(_("buttonGM", "Engineer"), gmEngineer)
    addGMFunction(_("buttonGM", "Science"), gmScience)
    addGMFunction(_("buttonGM", "Relay"), gmRelay)
end

function gmSendMission()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen


    update_Relay = ("You can check the logs by tapping the long icon "
    .. "on the bottom of the screen, and close it by tapping anywhere "
    .. "in the message")
    TraineeShip:addCustomMessage("Relay", "Relay-message1", update_Relay)

    TraineeShip:addToShipLog("We've picked up a distress signal in sector E5. "
    .. "Fly there, and see what's going on. "
    .. "Make sure you keep your crew up to date with information, as you are the "
    .. "only one who receives information. "
    .. "You can close this message by tapping anywhere in the message window.",
    "white")

    TraineeShip:addToShipLog("You can send out probes to reveal areas of interest "
    .. "by tapping 'Launch Probe', then tapping a location on the map. " 
    .. "Your probe count is refilled upon docking. ",
    "yellow")

    TraineeShip:addToShipLog("You can also place waypoints at any location. "
    .. "These will give your crewmates an indicator as to what direction you " 
    .. "want them to go in. ",
    "yellow")

    exampleStation = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy"):setCommsScript("")
    exampleStation:setPosition(9444, -7000)

    if distance(TraineeShip, exampleStation) < 6000 then
        
        TraineeShip:addToShipLog("This is a test. ", "yellow")
        
        exampleStation:sendCommsMessage(TraineeShip, "Thank you for responding to our distress signal. Now prepare to die!")



        ExShip7 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(9500, -7100):orderAttack(TraineeShip):setScanned(true)
    end
    
    -- if spawn_station:isFriendly()


end


function gmSpawnStation()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    -- Message1 = "This is a test message."
    -- TraineeShip:addCustomMessage("Helms", "Helms-message1", cur_locx)
    
    cur_locx, cur_locy = TraineeShip:getPosition()
    spawn_station = SpaceStation():setTemplate("Small Station"):setFaction("Human Navy")
    spawn_station:setPosition(cur_locx + 300, cur_locy - 400)

    

end

function gmWeapons()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

end



-- ##########################################################################
-- ## Extra Commands ##
-- ##########################################################################
function gmCreateCentralCommand()
    gmMainMenu()
    -- Home = setPosition(23500, 16100)

    if central_command:getPosition() == nil then
        central_command = SpaceStation():setTemplate("Small Station"):setFaction("Human Navy")
        central_command:setPosition(23500, 16100):setCallSign("Central Command")

    end
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

-- ##########################################################################
-- ## Update ##
-- ##########################################################################

function update(delta)

    if TraineeShip:isDocked(central_command) then
        TraineeShip:setWeaponStorage("homing", 12):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())

    end

    TraineeShip:commandSetAlertLevel(alertLevel)

    -- spawn_station:setCommsScript("You're a stinky butt")

end

-- ##########################################################################
-- ## Functions Used Elsewhere ##
-- ##########################################################################

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


