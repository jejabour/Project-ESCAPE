-- Name: Tutorial
-- Description: This is a tutorial spotlighting each officer's roles
-- Type: Project ESCAPE


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
    central_command = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    central_command:setPosition(23500, 16100):setCallSign("Central Command")

    -- Nebula that hide the enemy station.
    -- Nebula():setPosition(-43300, 2200)
    Nebula():setPosition(-34000, -700)
    -- Nebula():setPosition(-32000, -10000)
    Nebula():setPosition(-24000, -14300)
    -- Nebula():setPosition(-28600, -21900)

    -- Random nebulae in the system
    -- Nebula():setPosition(-8000, -38300)
    Nebula():setPosition(24000, -30700)
    Nebula():setPosition(42300, 3100)
    Nebula():setPosition(49200, 10700)
    -- Nebula():setPosition(3750, 31250)
    -- Nebula():setPosition(-39500, 18700)

    -- Create 50 Asteroids
    placeRandom(Asteroid, 50, -7500, -10000, -12500, 30000, 5000)
    placeRandom(VisualAsteroid, 50, -7500, -10000, -12500, 30000, 5000)

    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    -- Create the main ship for the trainees.
    initShip()


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
    addGMFunction(_("buttonGM", "+ Tutorials"), gmTutorials)
    addGMFunction(_("buttonGM", "+ Alert Level"),gmAlertLevel)
    addGMFunction(_("buttonGM", "+ Extra Commands"), gmExtraCommmands)
end

function gmAlertLevel()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "- Alert Level"),gmMainMenu)
    addGMFunction(_("buttonGM", "Normal"),gmAlertNormal)
    addGMFunction(_("buttonGM", "Yellow"),gmAlertYellow)
    addGMFunction(_("buttonGM", "Red"),gmAlertRed)
end

function gmTutorials()
    clearGMFunctions() -- Clear the Menu
    
    addGMFunction(_("buttonGM", "- Tutorial"), gmMainMenu)
    addGMFunction(_("buttonGM", "Helms"), gmHelms)
    addGMFunction(_("buttonGM", "Engineering"), gmEngineering)
    addGMFunction(_("buttonGM", "Engineering-2"), gmEngineering_2)
    addGMFunction(_("buttonGM", "Science"), gmScience)
    addGMFunction(_("buttonGM", "Weapons"), gmWeapons)
    addGMFunction(_("buttonGM", "Relay"), gmRelay)
    addGMFunction(_("buttonGM", "Send Mission"), gmSendMission)
    addGMFunction(_("buttonGM", "Surprise Station"), surpriseStation)

end

function gmSendMission()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen


    update_Relay = ("You can check the logs by tapping the long icon "
    .. "on the bottom of the screen, and close it by tapping anywhere "
    .. "in the message")
    TraineeShip:addCustomMessage("Relay", "Relay-message1", update_Relay)

    TraineeShip:addToShipLog("We've picked up a distress signal at a friendly station in sector E5. "
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
    .. "want them to go in. Now, exit this menu by tapping anywhere, then place a waypoint on the green station in sector E5",
    "yellow")

    exampleStation = SpaceStation():setTemplate("Medium Station"):setFaction("Human Navy"):setCommsScript("")
    exampleStation:setPosition(9444, -7000)
    
    -- if spawn_station:isFriendly()


end


function surpriseStation()

        
    exampleStation:sendCommsMessage(TraineeShip, "Thank you for responding to our distress signal. Now prepare to die!")

    TraineeShip:addCustomMessage("weapons", "weapon_message_victory", "There is an enemy ship! Load some Homing Missiles by tapping Homing, then the Load buttons. Once those are ready, tap the enemy to lock on, and fire them from the respective side of your ship by tapping Left:Homing or Right:Homing!. Don't forget to activate your shields on the bottom right!")

    exampleStation:setFaction("Exuari")
    ExShip1 = CpuShip():setTemplate("Phobos T3"):setFaction("Exuari"):setPosition(9500, -7100):orderAttack(TraineeShip):setScanned(true):setShieldsMax(25):setHull(40)
    


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

function gmHelms()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    TraineeShip:addCustomMessage("helms", "helms_start_message", "This is the Helms screen! You can activate your impulse drives by sliding the slider on your left. "
    .. "This is how you will typically move around, and you can tap anywhere in the radar to change direction. "
    .. "You can also set your jump drive to quickly travel long distances by setting the slider to a certain distance, then pressing Jump. "
    .. "This will launch you in the direction your ship is facing. "
    .. "You also have Combat Maneuver, which quickly moves your ship in a very short distance, useful for dodging. "
    .. "Right now, you are docked at a station. Tap Undock to try moving around.")

end



function gmEngineering()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    TraineeShip:addCustomMessage("engineering", "engineering_start_message", "This is the Engineering screen! You are in control of the ship's wellbeing. "
    .. "You have repair men on the top of your screen that you can tap on, then tap a location of your ship to get them repairing. "
    .. "On the bottom of the screen, you have the systems, how much power they have, and their coolant. "
    .. "You can tap on a system, then on the right using the sliders, increase or descrease their power and coolant. More power will create heat, which needs coolant. "
    .. "Things will take damage and get hot while playing, so stay vigilant!")

end

function gmEngineering_2()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    TraineeShip:addCustomMessage("engineering", "engineering_effects_message", "Your systems have been changed to represent a possible scenario. "
    .. "Use your repair men to fix the red areas on the ship, and distribute coolant to cool overheating systems. ")

    TraineeShip:setSystemHealth("reactor", 0.3)
    TraineeShip:setSystemHeat("reactor", 0.9)

    -- TraineeShip:setSystemHeat("beamweapons", 0.9)

    -- TraineeShip:setSystemHeat("missilesystem", 0.3)

    -- TraineeShip:setSystemHeat("maneuvering", 0.9) -- I don't know what the proper name for maneuvering is
    
    -- TraineeShip:setSystemHealth("impulse", 0.4)
    TraineeShip:setSystemHeat("impulse", 0.6)

    -- TraineeShip:setSystemHeat("jumpdrive", 0.9)
    
    TraineeShip:setSystemHealth("frontshield", 0.7)
    TraineeShip:setSystemHeat("frontshield", 0.5)

    -- TraineeShip:setSystemHeat("rearshield", 0.9)

end



function gmScience()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    ship_pos_x, ship_pos_y = TraineeShip:getPosition()

    ship_pos_x = ship_pos_x - 16900
    ship_pos_y = ship_pos_y - 10198

    -- addGMMessage(ship_pos_x)

    ExShipS = CpuShip():setFaction("Exuari"):setTemplate("Adder MK4"):setPosition(ship_pos_x, ship_pos_y):setScanned(false):setShieldsMax(20, 20):setHull(60)
    
    

    TraineeShip:addCustomMessage("science", "science_start_message", "This is the Science screen! You have a wider view than most of the other roles, and can "
    .. "scan other ships. Once you tap on a ship, you can press the Scan button to play an alignment minigame, which, upon completion, will show you information "
    .. "on the right-hand side, including their faction. ")

    TraineeShip:addCustomMessage("science", "science_second_message", "There is an unidentified ship at 300 degrees, about 20 units away. "
    .. "You can tell by the distance by the faint rings on your radar, and the direction by the numbers on the outer edge. "
    .. "Tap on that ship, then hit the scan button on the right, and slide the sliders to align the frequency waves in the slider minigame.")

    mission_state = 2

end


function gmWeapons()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    TraineeShip:addCustomMessage("weapons", "weapons_start_message", "This is the Weapons screen! You are in control of your ships shields and attacking other ships. "
    .. "In addition to the Shields button in the lower right corner, you have a number of weapons to choose from, those being Homing Missiles, Nukes, Mines, EMPs, HVLI's, and your ships beams. "
    .. "Your ships beams will fire automatically at anything in the red radius shown in front of your ship on the radar as long as a ship is targeted, done by tapping. ")

    TraineeShip:addCustomMessage("weapons", "weapons_second_message", "To fire your other weapons, you will first have to load them into a tube. Tap on a weapon name to see the tubes it can be loaded into, "
    .. "Then tap one of the tubes. It will take a moment to load up, then you can tap the tube your weapon is loaded into to fire. ")

    TraineeShip:addCustomMessage("weapons", "weapons_third_message", "You'll notice your ship only has Left facing tubes, Right facing tubes, and a Rear facing tube. This means your main weapons can only be fired "
    .. "From those directions, with Mines being the only weapon launched from the rear. You will have to coordinate with your Helms officer to face the proper direction in order to efficiently attack enemies. ")

    TraineeShip:addCustomMessage("weapons", "weapons_fourth_message", "An enemy has spawned next to you. Try attacking them with missles by coordinating the direction your ship faces with the helms officer. ")


    ship_pos_x, ship_pos_y = TraineeShip:getPosition()

    ship_pos_x = ship_pos_x + 900
    ship_pos_y = ship_pos_y - 3000


    ExShipW = CpuShip():setFaction("Exuari"):setTemplate("Adder MK9"):setPosition(ship_pos_x, ship_pos_y):orderIdle():setScanned(true):setShieldsMax(20, 20):setHull(60, 60)
    

end

function gmRelay()
    clearGMFunctions() -- Clear the Menu
    gmMainMenu() -- Return to main screen

    TraineeShip:addCustomMessage("relay", "relay_start_message", "This is the Relay screen! You have a wider view than every other role, and you can send "
    .. "probes to check the area around you.  "
    .. "on the right had side, including their faction. ")

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

    -- if not ExShip1:isValid() then
    --     TraineeShip:addCustomMessage("weapons", "weapon_message_victory", "Great job! Note that you must also have a ship targeted, by tapping them, for you beams to fire. "
    --     .. "Keep in contact with your helms officer to ensure the ship is facing the right way for your weapons to hit!")
    -- end

    TraineeShip:commandSetAlertLevel(alertLevel)

    -- spawn_station:setCommsScript("You're a stinky butt")

    while mission_state == 2 and ExShipS:isScannedBy(TraineeShip) do
        
        
        addGMMessage("Made it here")

        TraineeShip:addCustomMessage("science", "science_scanned_message", "Good job. Now you can see details on the right such as the Faction this ship "
        .. "belongs to, it's shield health, and hull health. If you were to scan it again, it would be a more difficult wavelength challenge"
        .. " but you would also see more detailed information about their various systems.")

        mission_sate = 3
    end


end

-- ##########################################################################
-- ## Functions Used Elsewhere ##
-- ##########################################################################

function initShip()
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis"):setCanBeDestroyed(false)
    TraineeShip:setPosition(22598, 16100):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(central_command)
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


