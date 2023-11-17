-- Name: Scenario 4: AMBUSH
-- Description: A Kraylor ship carrying vital information was being escorted by the Human Navy when they were attacked by Exuari. All ships were abandoned in the skirmish. It's up to the players to navigate to the battle location, find which ship was the Kraylor ship, and retrieve the intel.
-- Type: Project ESCAPE


-- ##########################################################################
-- ## GM MENU ##
-- ##########################################################################

function gmMainMenu()
    clearGMFunctions()
    addGMFunction(_("buttonGM", "AMBUSH      +"), gmScenario4)
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


--- Scenario 4 Commands
function gmScenario4()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "AMBUSH     -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Drop Intel"),gmAmbush_1)
    addGMFunction(_("buttonGM", "Spawn Enemies"),gmAmbush_2)
    addGMFunction(_("buttonGM", "Activate Enemies"),gmAmbush_3)
    addGMFunction(_("buttonGM", "Bring Enemies"),gmAmbush_4)
    addGMFunction(_("buttonGM", "Defeat"),gmDefeat)
    addGMFunction(_("buttonGM", "Victory"),gmVictory)
    addGMFunction(_("buttonGM", "Set Mission"),gmSetScenario4)


end


function gmUsefulCommmands()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Useful Commands -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Create CC"),gmCreateCentralCommand)
    addGMFunction(_("buttonGM", "Clear Mission"), gmClearMission)

end


-- ##########################################################################
-- ## Scenario 4 UNDER CONSTRUCTION ##
-- ##########################################################################

-- Destroys the Kraylor ship, creates a supply drop, and sends a message to Relay
function gmAmbush_1()
    clearGMFunctions()
    gmMainMenu()

    central_command:sendCommsMessage(TraineeShip,("The supply drop has fallen out of the Kraylor transport. Grab it, and return to base."))

    TargetShip:destroy()

    transport_drop = SupplyDrop():setFaction("Human Navy"):setPosition(47589, -26790)

    mission_state = 2

end

-- Sends the comm message to Relay saying Exuari ships appear near the player and CC
-- Spawns those ships, and two friendlies near CC. All ships by CC are 'frozen' however
function gmAmbush_2()
    clearGMFunctions()
    gmMainMenu()

    -- message from command saying Exuari appeared next to trainees, and central command
    central_command:sendCommsMessage(TraineeShip,([[The Exuari must have discovered that we sent for this intel, and are attacking central command!
    Be aware, some must have heard the explosion and are coming after you too. Defend yourselves and central command!]]))

    -- Spawn two enemies near the trainees
    ExShip5 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(53328, -27216):orderAttack(TraineeShip):setScanned(true)
    ExShip6 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(56023, -25758):orderAttack(TraineeShip):setScanned(true)

    -- spawn three by central command, but they're set to idle
    ExShip7 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(19148, 18485):orderIdle():setScanned(true)
    ExShip8 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(20327, 14200):orderIdle():setScanned(true)
    -- ExShip9 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(24316, 13208):orderIdle():setScanned(true)

    -- spawn two weak and one decent friendly ships by command, set to idle
    NavyShip3 = CpuShip():setTemplate("Adder MK8"):setFaction("Human Navy"):setPosition(22427, 16224):orderIdle():setScanned(true):setWeaponStorageMax("HVLI", 6):setWeaponStorage("HVLI", 6)
    -- NavyShip4 = CpuShip():setTemplate("Adder MK8"):setFaction("Human Navy"):setPosition(24134, 17232):orderIdle():setScanned(true):setWeaponStorageMax("HVLI", 6):setWeaponStorage("HVLI", 6)
    NavyShip5 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(24931, 16094):orderIdle():setScanned(true):setWeaponStorageMax("homing", 12):setWeaponStorage("homing", 12)

    table.insert(enemyList, ExShip5)
    table.insert(enemyList, ExShip6)
    table.insert(enemyList, ExShip7)
    table.insert(enemyList, ExShip8)
    table.insert(friendList, NavyShip3)
    table.insert(friendList, NavyShip5)

    mission_state = 3

end

-- 'Activates' the ships near CC, takes them off idle
function gmAmbush_3()
    clearGMFunctions()
    gmMainMenu()

    
    ExShip7:orderRoaming()
    ExShip8:orderRoaming()
    -- ExShip9:orderRoaming()
    NavyShip3:orderDefendTarget(central_command)
    -- NavyShip4:orderDefendTarget(central_command)
    NavyShip5:orderDefendTarget(central_command)

    mission_state = 4



end

-- Brings the enemy ships from where the supply drop was to CC if they're still alive
function gmAmbush_4()
    clearGMFunctions()
    gmMainMenu()


    if ExShip5:isValid() then
        ExShip5:setPosition(28824, 12817)
    end

    if ExShip6:isValid() then
        ExShip6:setPosition(28957, 14802)
    end

    mission_state = 5

    central_command:sendCommsMessage(TraineeShip,("The enemies you left by the supply drop location have followed you to the base!"))

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


-- ##########################
-- SET SCENARIO
-- ##########################

function gmSetScenario4()
    clearGMFunctions()
    gmMainMenu()

    TraineeShip = {}
    enemyList = {}
    friendList = {}
    waveNumber = 0
    alertLevel = "normal"

     -- Create the main ship for the trainees.
     TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
     TraineeShip:setPosition(23400, 16100):setCallSign("J.E. Thompson")
     TraineeShip:setRotation(180) -- make sure it's facing away from station
     TraineeShip:commandDock(central_command)
 
     TraineeShip:addToShipLog("An envoy of our ships were escorting a captured Kraylor ship,"
     .. " but were ambushed by Exuari in sector G7. It seems all the ships in the skirmish have been abandoned, but "
     .. "there is still intel on the Kraylor ship. Find the Kraylor ship, destroy the ship to expose the intel package, grab it, and bring it back. "
     .. "Your Science officer will be able to determine the factions of any unknown ships.", "white")
 
     
     TargetShip = CpuShip():setTemplate("Equipment Freighter 2"):setFaction("Kraylor"):setPosition(47589, -26790):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     ExShip1 = CpuShip():setTemplate("Adder MK6"):setFaction("Exuari"):setPosition(40112, -23993):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     ExShip2 = CpuShip():setTemplate("Battlestation"):setFaction("Exuari"):setPosition(42746, -27708):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     ExShip3 = CpuShip():setTemplate("Blade"):setFaction("Exuari"):setPosition(49928, -23979):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     ExShip4 = CpuShip():setTemplate("Adder MK6"):setFaction("Exuari"):setPosition(49352, -16801):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     NavyShip1 = CpuShip():setTemplate("Karnack"):setFaction("Human Navy"):setPosition(45414, -23553):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
     NavyShip2 = CpuShip():setTemplate("Karnack"):setFaction("Human Navy"):setPosition(49966, -27447):orderIdle():setScanned(false):setShieldsMax(1, 1) :setHull(1, 60)
     
 
     table.insert(enemyList, ExShip1)
     table.insert(enemyList, ExShip2)
     table.insert(enemyList, ExShip3)
     table.insert(enemyList, ExShip4)
     table.insert(enemyList, TargetShip)
     table.insert(friendList, NavyShip1)
     table.insert(friendList, NavyShip2)

    mission_state = 1

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
        central_command = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
        central_command:setPosition(23500, 16100):setCallSign("Central Command")

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
-- Create 50 Asteroids
    placeRandom(Asteroid, 50, -7500, -10000, -12500, 30000, 2000)
    placeRandom(VisualAsteroid, 50, -7500, -10000, -12500, 30000, 2000)

    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    -- Create the main ship for the trainees.
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(22598, 16086):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(central_command)

    TraineeShip:addToShipLog("An envoy of our ships were escorting a captured Kraylor ship,"
    .. " but were ambushed by Exuari in sector G7. It seems all the ships in the skirmish have been abandoned, but "
    .. "there is still intel on the Kraylor ship. Find the Kraylor ship, destroy the ship to expose the intel package, grab it, and bring it back. "
    .. "Your Science officer will be able to determine the factions of any unknown ships.", "white")

    
    TargetShip = CpuShip():setTemplate("Equipment Freighter 2"):setFaction("Kraylor"):setPosition(47589, -26790):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    ExShip1 = CpuShip():setTemplate("Adder MK6"):setFaction("Exuari"):setPosition(40112, -23993):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    ExShip2 = CpuShip():setTemplate("Battlestation"):setFaction("Exuari"):setPosition(42746, -27708):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    ExShip3 = CpuShip():setTemplate("Blade"):setFaction("Exuari"):setPosition(49928, -23979):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    ExShip4 = CpuShip():setTemplate("Adder MK6"):setFaction("Exuari"):setPosition(49352, -16801):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    NavyShip1 = CpuShip():setTemplate("Karnack"):setFaction("Human Navy"):setPosition(45414, -23553):orderIdle():setScanned(false):setShieldsMax(1, 1):setHull(1, 60)
    NavyShip2 = CpuShip():setTemplate("Karnack"):setFaction("Human Navy"):setPosition(49966, -27447):orderIdle():setScanned(false):setShieldsMax(1, 1) :setHull(1, 60)
    

    table.insert(enemyList, ExShip1)
    table.insert(enemyList, ExShip2)
    table.insert(enemyList, ExShip3)
    table.insert(enemyList, ExShip4)
    table.insert(enemyList, TargetShip)
    table.insert(friendList, NavyShip1)
    table.insert(friendList, NavyShip2)

    -- In relation to Human Navy{
    
        -- Good Guys [USN, TSN, CUF, Human Navy]

        -- Neutral [Arlenians, Independent]

        -- Bad Guys [Exuari, Ktlitans, Kraylor, Ghosts]
    
    -- }

    mission_state = 1

end

function update(delta)

    if TraineeShip:isDocked(central_command) then
        TraineeShip:setWeaponStorage("homing", 12):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())

    end
    

    -- Mission State 1 is set in the init function. Next state occurs when the TargetShip, the Kraylor ship, is destroyed
    if mission_state == 1  and not TargetShip:isValid() then
        
        -- Create a supply drop where the targetship was
        transport_drop = SupplyDrop():setFaction("Human Navy"):setPosition(47589, -26790)

        -- Send a comm from central command
        central_command:sendCommsMessage(TraineeShip,("The supply drop has fallen out of the Kraylor transport. Grab it, and return to base."))
    
        -- set mission_state to 2
        mission_state = 2
        
    end

    -- trigger next events when the supply drop is picked up.
    -- Spawn 2 enemy ships near the trainees
    -- Spawn 3 enemy ships and 2 friendly ships by Central Command, but they're idle
    if mission_state == 2 and not transport_drop:isValid() then

        -- message from command saying Exuari appeared next to trainees, and central command
        central_command:sendCommsMessage(TraineeShip,([[The Exuari must have discovered that we sent for this intel, and are attacking central command!
        Be aware, some must have heard the explosion and are coming after you too. Defend yourselves and central command!]]))

        -- Spawn two enemies near the trainees
        ExShip5 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(53328, -27216):orderAttack(TraineeShip):setScanned(true)
        ExShip6 = CpuShip():setTemplate("Adder MK4"):setFaction("Exuari"):setPosition(56023, -25758):orderAttack(TraineeShip):setScanned(true)

        -- spawn three by central command, but they're set to idle
        ExShip7 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(19148, 18485):orderIdle():setScanned(true)
        ExShip8 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(20327, 14200):orderIdle():setScanned(true)
        ExShip9 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(24316, 13208):orderIdle():setScanned(true)

        -- spawn two weak and one decent friendly ships by command, set to idle
        NavyShip3 = CpuShip():setTemplate("Adder MK8"):setFaction("Human Navy"):setPosition(22427, 16224):orderIdle():setScanned(true):setWeaponStorageMax("HVLI", 6):setWeaponStorage("HVLI", 6)
        -- NavyShip4 = CpuShip():setTemplate("Adder MK8"):setFaction("Human Navy"):setPosition(24134, 17232):orderIdle():setScanned(true):setWeaponStorageMax("HVLI", 6):setWeaponStorage("HVLI", 6)
        NavyShip5 = CpuShip():setTemplate("Guard"):setFaction("Human Navy"):setPosition(24931, 16094):orderIdle():setScanned(true):setWeaponStorageMax("homing", 12):setWeaponStorage("homing", 12)

        table.insert(enemyList, ExShip5)
        table.insert(enemyList, ExShip6)
        table.insert(enemyList, ExShip7)
        table.insert(enemyList, ExShip8)
        table.insert(enemyList, ExShip9)
        table.insert(friendList, NavyShip3)
        table.insert(friendList, NavyShip5)

        mission_state = 3

    end

    -- Activates the ships near Central Command
    if mission_state == 3 then

        -- Trigger when the trainees are near central command. "Activate" the cpu ships
        if distance(TraineeShip, central_command) < 7500 then
            ExShip7:orderRoaming()
            ExShip8:orderRoaming()
            -- ExShip9:orderRoaming()
            NavyShip3:orderDefendTarget(central_command)
            -- NavyShip4:orderDefendTarget(central_command)
            NavyShip5:orderDefendTarget(central_command)

            mission_state = 4

        end

    end

    -- 
    if mission_state == 4 then

        -- or not ExShip9:isValid()
        -- the idea is that if the trainees left the two back there, then they'll both appear by central command when they're destroyed one ship here
        if not ExShip7:isValid() or not ExShip8:isValid()  then
           
            if ExShip5:isValid() then
                ExShip5:setPosition(28824, 12817)
            end

            if ExShip6:isValid() then
                ExShip6:setPosition(28957, 14802)
            end

            mission_state = 5

        end

        -- binary search, sequential, merge, quick sort, stability, inplace, know how to recognize if expression is done iteratively or recursive form
    
    end

    if mission_state == 5 then


        if not ExShip5:isValid() and not ExShip6:isValid() and not ExShip7:isValid() and not ExShip8:isValid() then
            mission_state = 6
        end

        -- and not ExShip9:isValid()



    end

    if mission_state == 6 then
    
        if TraineeShip:isDocked(central_command) then
        
            central_command:sendCommsMessage(TraineeShip,([[Thank you, crew, for your service! The threat has been defeated, the intel recovered, and the mission is complete. Return for debriefing.]]))
            
            victory("Human Navy")
        end

    
    end


    -- GM will manage alert levels, so this will reset it constantly to what
    -- the GM has set it to

    
    TraineeShip:commandSetAlertLevel(alertLevel)
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