-- Name: Scenario 5: FUNNEL
-- Description: A wave of asteroids have appeared in the shape of a funnel. The team must navigate through the funnel, and some enemy ships, to find the friendly space station containing supplies, and return back to the base.
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
    -- The ship starts x=22598, 16086. From this point,
    -- increasing X moves it to the right. Increasing Y moves it down.

--}

-- ##########################################################################
-- ## GM MENU ##
-- ##########################################################################

function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "FUNNEL                    +"), gmFUNNEL)
    addGMFunction(_("buttonGM", "Alert Level               +"),gmAlertLevel)
    addGMFunction(_("buttonGM", "Extra Commands      +"), gmExtraCommmands)
end

function gmAlertLevel()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Alert level                -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Normal"),gmAlertNormal)
    addGMFunction(_("buttonGM", "Yellow"),gmAlertYellow)
    addGMFunction(_("buttonGM", "Red"),gmAlertRed)
end

function gmExtraCommmands()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Extra Commands       -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Create CC"),gmCreateCentralCommand)
    addGMFunction(_("buttonGM", "Set Mission"),gmSetFunnel)
    addGMFunction(_("buttonGM", "Clear Mission"), gmClearMission)

end

-- FUNNEL missions
function gmFUNNEL()
    -- Clear and reset the menu
    clearGMFunctions()
    addGMFunction(_("buttonGM", "FUNNEL                     -"), gmMainMenu)
    addGMFunction(_("buttonGM", "Start Moving"), gmFUNNEL_1)
    addGMFunction(_("buttonGM", "Return Home"), gmFUNNEL_2)


end


-- When undocked, tell all the ships to stop being idle
function gmFUNNEL_1()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    orderFly()

    mission_state = 2

end

-- Tell them to come back to Orion Starforge after docking at the target station
function gmFUNNEL_2()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    orion_starforge:sendCommsMessage(TraineeShip,("Good job retrieving the supplies. Make your way back to Orion Starforge."))
    -- addGMMessage("Moving to mission state 3")
    mission_state = 3

end


-- ##########################
-- SET SCENARIO
-- ##########################

function gmSetFunnel()
    clearGMFunctions()
    gmMainMenu()

    TraineeShip = {}
    enemyList = {}
    friendList = {}
    waveNumber = 0
    alertLevel = "normal"

     -- Create the main ship for the trainees.
    initShip()
 
-- ####################################
    --- THE FUNNEL
    -- Left side. (object type, x-start-loc, y-start, x-end, y, end, amount)
    placeRandom_funnel(Asteroid, 300, 3700, 27000, 19700, 73600, 9000)
    -- Right side
    placeRandom_funnel(Asteroid, 300, 41000, 24500, 39000, 72800, 8000) 

    -- Surrounding the docking station
    placeRandom_funnel(Asteroid, 75, 20000, 80000, 13648, 96000, 3000)
    placeRandom_funnel(Asteroid, 60, 40000, 78000, 22000, 99500, 3000)

    -- Place a ton of probes randomly throughout the asteroid belt
    placeRandom_probes()

    --Place some enemies and good Guys
    createShips()

    mission_state = 0

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

    for _, probe in ipairs(probeList) do
        if probe:isValid() then
            probe:destroy()
        end
    end

    for _, aster in ipairs(asteroidList) do
        if aster:isValid() then
            aster:destroy()
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

    message_victory = "Good job, the supplies have been safely recovered. Return for mission debriefing."

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
    probeList = {}
    friendList = {}
    asteroidList = {}
    waveNumber = 0
    alertLevel = "normal"

    -- Create the command station
    orion_starforge = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    orion_starforge:setPosition(23500, 16100):setCallSign("Orion Starforge")

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
    initShip()

-- ####################################
    --- THE FUNNEL
    -- Left side. (object type, x-start-loc, y-start, x-end, y, end, amount)
    placeRandom_funnel(Asteroid, 300, 3700, 27000, 19700, 73600, 9000)
    -- Right side
    placeRandom_funnel(Asteroid, 300, 41000, 24500, 39000, 72800, 8000)
 

    -- Surrounding the docking station
    placeRandom_funnel(Asteroid, 75, 20000, 80000, 13648, 96000, 3000)
    placeRandom_funnel(Asteroid, 60, 40000, 78000, 22000, 99500, 3000)

    -- Place the probes
    placeRandom_probes()

    --Place some enemies and good Guys
    createShips()

    mission_state = 0



end

function update(delta)

    TraineeShip:commandSetAlertLevel(alertLevel)

    if TraineeShip:isDocked(orion_starforge) or TraineeShip:isDocked(NavyStation) then
        TraineeShip:setWeaponStorage("homing", 12):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())

    end

    if mission_state == 0 and TraineeShip:isDocked(orion_starforge) then
        mission_state = 1
        -- addGMMessage("moving to Mission state 1")
    end

    if mission_state == 1 and not TraineeShip:isDocked(orion_starforge) then

        orderFly()

        mission_state = 2
        -- addGMMessage("moving to Mission state 2")
        

    end


    if mission_state == 2 and TraineeShip:isDocked(NavyStation) then
        orion_starforge:sendCommsMessage(TraineeShip,("Now that you've gotten the supplies, make your way back to Orion Starforge."))
        -- addGMMessage("Moving to mission state 3")
        mission_state = 3
    end

    if mission_state == 3 and TraineeShip:isDocked(orion_starforge) then

        message_victory = "Good job, the supplies have been safely recovered. Return for mission debriefing."

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

function initShip()
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(23524, 16802):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(90)
    -- TraineeShip:commandTargetRotation(190) -- make sure it's facing away from station
    TraineeShip:commandDock(orion_starforge)

    TraineeShip:addToShipLog("A wave of asteroids have appeared around our location"
    .. " in the shape of a funnel. Unfortunately, we need supplies from a docking station in sector J6 that has been surrounded by asteroids on all sides except through the asteroids. "
    .. "Be warned, when we sent out probes in the asteroid belt, we detected several Exuari ships. Navigate the asteroids, dock to pick up the supplies, and return to Orion Starforge. ", "white")

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

    end
end

-- ####################################
    -- THE PROBES 
    -- Place a ton of probes randomly throughout the asteroid belt
    -- x = x-start + (x-end - x-start)
    -- y = y-start + (y-end - y-start)
function placeRandom_probes()
    for n=1, 60 do
        local f = random(0, 1)
        local x = 3000 + (50000 - 6000) * f
        local y = 30000 + (90000 - 40000) * f

        local r = random(0, 360)
        local distance = random(0, 30000)
        x = x + math.cos(r / 180 * math.pi) * distance
        y = y + math.sin(r / 180 * math.pi) * distance

        probe = ScanProbe():setPosition(x, y):setTarget(x, y):setFaction("Human Navy"):setOwner(TraineeShip):setLifetime(60 * 30)
        table.insert(probeList, probe)

    end
end

-- ####################################
    -- THE ENEMIES 
function createShips()

    ExShip1 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(18427, 43827):setScanned(true):orderStandGround()
    ExShip2 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(23009, 43849):setScanned(true):orderStandGround()
    ExShip3 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(27059, 43447):setScanned(true):orderStandGround()
    ExShip4 = CpuShip():setTemplate("Phobos M3"):setFaction("Exuari"):setPosition(31601, 42900):setScanned(true):orderStandGround()

    ExShip5 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(23152, 55882):setScanned(true):orderStandGround()
    ExShip6 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(26948, 55346):setScanned(true):orderStandGround()
    ExShip7 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(31069, 54316):setScanned(true):orderStandGround()

    ExShip8 = CpuShip():setTemplate("Gunship"):setFaction("Exuari"):setPosition(28862, 62216):setScanned(true):orderStandGround()

    ExShip9 = CpuShip():setTemplate("Adder MK5"):setFaction("Exuari"):setPosition(31379, 77307):setScanned(true):orderDefendLocation(31379, 77307)

    ExStation = SpaceStation():setTemplate("Medium Station"):setFaction("Exuari"):setPosition(32554, 64435):setScanned(true)

    NavyShip1 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(19254, 23354):setScanned(true)
    NavyShip2 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(29786, 23184):setScanned(true)
    NavyShip3 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(22800, 28202):setScanned(true)
    NavyShip4 = CpuShip():setTemplate("Phobos T3"):setFaction("Human Navy"):setPosition(28308, 28433):setScanned(true)

    NavyStation = SpaceStation():setTemplate("Medium Station"):setFaction("Human Navy"):setPosition(25388, 86065):setScanned(true)

    table.insert(enemyList, ExShip1)
    table.insert(enemyList, ExShip2)
    table.insert(enemyList, ExShip3)
    table.insert(enemyList, ExShip4)
    table.insert(enemyList, ExShip5)
    table.insert(enemyList, ExShip6)
    table.insert(enemyList, ExShip7)
    table.insert(enemyList, ExShip8)
    table.insert(enemyList, ExShip9)
    table.insert(enemyList, ExStation)
    table.insert(friendList, NavyShip1)
    table.insert(friendList, NavyShip2)
    table.insert(friendList, NavyShip3)
    table.insert(friendList, NavyShip4)
    table.insert(friendList, NavyStation)

end

function orderFly()

    NavyShip1:orderFlyTowards(31065, 72565)
    NavyShip2:orderFlyTowards(31065, 72565)
    NavyShip3:orderFlyTowards(31065, 72565)
    NavyShip4:orderFlyTowards(31065, 72565)
    ExShip1:orderStandGround()
    ExShip2:orderStandGround()
    ExShip3:orderStandGround()
    ExShip4:orderStandGround()
    ExShip5:orderStandGround()
    ExShip6:orderStandGround()
    ExShip7:orderStandGround()
    ExShip8:orderStandGround()


end


--- Return the distance between two objects.
function distance(obj1, obj2)
    local x1, y1 = obj1:getPosition()
    local x2, y2 = obj2:getPosition()
    local xd, yd = (x1 - x2), (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)
end
