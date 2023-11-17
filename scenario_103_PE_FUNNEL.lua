-- Name: Scenario 5: FUNNEL
-- Description: This is a scenario about funneling the group
-- Type: Project ESCAPE

-- ##########################################################################
-- ## NOTES ##
-- ##########################################################################

-- ######## FACTIONS #########
-- In relation to Human Navy{
    -- Good Guys [USN, TSN, CUF, Human Navy]

    -- Neutral [Arlenians, Independent]

    -- Bad Guys [Exuari, Ktlitans, Kraylor, Ghosts]
-- }

-- ######## LOCATION #########
-- When trying to place things{

    --It's easiest to just place an object in game and use the location
    -- on the top right to get an idea of where you are
    -- The ship starts x=23400, y=16100. From this point,
    -- increasing X moves it to the right. Increasing Y moves it down.

--}

-- ##########################################################################
-- ## GM MENU ##
-- ##########################################################################

function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "FUNNEL              +"), gmFUNNEL)
    addGMFunction(_("buttonGM", "Alert Level         +"),gmAlertLevel)
    addGMFunction(_("buttonGM", "Extra Commands +"), gmUsefulCommmands)
end

function gmAlertLevel()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Alert level -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Normal"),gmAlertNormal)
    addGMFunction(_("buttonGM", "Yellow"),gmAlertYellow)
    addGMFunction(_("buttonGM", "Red"),gmAlertRed)
end

function gmUsefulCommmands()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Useful Commands -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Create CC"),gmCreateCentralCommand)
    addGMFunction(_("buttonGM", "Clear Mission"), gmClearMission)

end

-- FUNNEL missions
function gmFUNNEL()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
    addGMFunction(_("buttonGM", "FUNNEL    -"), gmMainMenu)
    addGMFunction(_("buttonGM", "FUNNEL_1"), gmFUNNEL_1)
    addGMFunction(_("buttonGM", "FUNNEL_2"), gmFUNNEL_2)
    addGMFunction(_("buttonGM", "FUNNEL_3"), gmFUNNEL_3)


end





function gmFUNNEL_1()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()


end


function gmFUNNEL_2()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()


end


function gmFUNNEL_3()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()


end




-- ##########################################################################
-- ## GM Alert Level ##
-- ##########################################################################

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
-- ## Victory and Defeat Messages ##
-- ##########################################################################

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



-- ##########################################################################
-- ## Initial Function ##
-- ##########################################################################

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
    central_command = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
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

    
--- Place objects randomly in a rough line
-- Distribute a `number` of random `object_type` objects in a line from point
-- x1,y1 to x2,y2, with a random distance up to `random_amount` between them.
-- placeRandom(object_type, number, x1, y1, x2, y2, random_amount)
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

    TraineeShip:addToShipLog("A wave of asteroids have appeared around our location"
    .. " in the shape of a funnel. Unfortunately, we need supplies from a docking station that has been surrounded by asteroids on all sides except through the asteroids. "
    .. "Be warned, when we sent out probes in the asteroid belt, we detected several Exuari ships. Navigate the asteroids, dock to pick up the supplies, and return to Central Command. ", "white")





    --- THE FUNNEL

    -- placeRandom(Asteroid, 400, 500, 63555, 40000, 58468, 15000)
    -- placeRandom(Asteroid, 700, 70000, 33555, 98000, 0, 15000)
    placeRandom(Asteroid, 300, -7500, 31000, 6500, 100000, 14000)
    placeRandom(Asteroid, 300, 60000, 26229, 45000, 100000, 15000)



    -- Surrounding the docking station
    placeRandom(Asteroid, 75, 9202, 109076, -4023, 146011, 4000)
    placeRandom(Asteroid, 60, 4000, 142230, 42797, 100689, 4000)


    -- Place a ton of probes randomly throughout the asteroid belt
    for n=1, 45 do
        local f = random(0, 1)
        local x = 3500 + (50000 - 3500) * f
        local y = 55000 + (90000 - 55000) * f

        local r = random(0, 360)
        local distance = random(0, 50000)
        x = x + math.cos(r / 180 * math.pi) * distance
        y = y + math.sin(r / 180 * math.pi) * distance

        probe = ScanProbe():setPosition(x, y):setTarget(x, y):setFaction("Human Navy"):setOwner(TraineeShip):setLifetime(60 * 30)

    end

    --Place some enemies and good Guys

    ExShip1 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(18427, 43827):setScanned(true)
    ExShip2 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(35471, 44081):setScanned(true)
    ExShip3 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(30078, 47937):setScanned(true)
    ExShip4 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(25326, 71373):setScanned(true)

    ExShip5 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(22215, 52416):setScanned(true)

    ExShip6 = CpuShip():setTemplate("Gunship"):setFaction("Exuari"):setPosition(30735, 61092):setScanned(true)

    ExStation = SpaceStation():setTemplate("Medium Station"):setFaction("Exuari"):setPosition(24451, 57579):setScanned(true)

    NavyShip1 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(19254, 23354):setScanned(true)
    NavyShip2 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(29786, 23184):setScanned(true)

    NavyStation = SpaceStation():setTemplate("Medium Station"):setFaction("Human Navy"):setPosition(12423, 123339):setScanned(true)

    table.insert(enemyList, ExShip1)
    table.insert(enemyList, ExShip2)
    table.insert(enemyList, ExShip3)
    table.insert(enemyList, ExShip4)
    table.insert(enemyList, ExShip5)
    table.insert(enemyList, ExShip6)
    table.insert(enemyList, ExStation)
    table.insert(friendList, NavyShip1)
    table.insert(friendList, NavyShip2)
    table.insert(friendList, NavyStation)

    mission_state = 0
    

    -- addGMMessage("Going to mission_state 1")

end

function update(delta)

    if TraineeShip:isDocked(central_command) then
        TraineeShip:setWeaponStorage("homing", 12):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())

    end

    if mission_state == 0 and TraineeShip:isDocked(central_command) then
        mission_state = 1
        addGMMessage("moving to Mission state 1")
    end

    if mission_state == 1 and not TraineeShip:isDocked(central_command) then
       
        NavyShip1:orderFlyTowards(30326, 72195)
        NavyShip2:orderFlyTowards(21627, 74268)
        ExShip1:orderRoaming()
        ExShip2:orderRoaming()
        ExShip3:orderRoaming()
        ExShip4:orderRoaming()
        ExShip5:orderRoaming()

        mission_state = 2
        addGMMessage("moving to Mission state 2")
        

    end


    if mission_state == 2 and TraineeShip:isDocked(NavyStation) then
        central_command:sendCommsMessage(TraineeShip,("Good job retrieving the supplies. Make your way back to Central Command."))
        addGMMessage("Moving to mission state 3")
        mission_state = 3
    end

    if mission_state == 3 and TraineeShip:isDocked(central_command) then

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