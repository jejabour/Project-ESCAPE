-- Name: Scenario 1-3
-- Description: A collection of scenario's designed to enforce leadership and Extreme Ownership principles
-- Type: Project ESCAPE

-- Scenario
-- @script scenario_71_projectESCAPE

-- ##########################################################################
-- ## GM MENU ##
-- ##########################################################################
function gmMainMenu()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Rescue JJ           +"),gmRescueJJ)
    addGMFunction(_("buttonGM", "Waves               +"),gmWaves)
    addGMFunction(_("buttonGM", "Retrieve Data       +"),gmRetrieveData)
    addGMFunction(_("buttonGM", "Modify Main Ship +"),gmModifyShip)
    addGMFunction(_("buttonGM", "End Scenario        +"),gmEndScenario)
    addGMFunction(_("buttonGM", "Alert Level         +"),gmAlertLevel)
    addGMFunction(_("buttonGM", "Extra Commands      +"), gmUsefulCommmands)
end

--- Rescue JJ GM Commands
function gmRescueJJ()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Rescue JJ -"),gmMainMenu)
    addGMFunction(_("buttonGM", "1) Destroy JJ's Ship"),gmRescueJJ1)
    addGMFunction(_("buttonGM", "2) We're Good"),gmRescueJJ2)
    addGMFunction(_("buttonGM", "3) Air Running Out"),gmRescueJJ3)
    addGMFunction(_("buttonGM", "4) Suffocating"),gmRescueJJ4)
    addGMFunction(_("buttonGM", "5) JJ Dead, Extract"),gmRescueJJ5)
    addGMFunction(_("buttonGM", "5) JJ Alive, Extract"),gmRescueJJ6)
    addGMFunction(_("buttonGM", "Set Mission"),gmSetRescueJJ)
end

--- Waves GM Commands
function gmWaves()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Waves -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Spawn Next Wave"),gmSpawnNextWave)
    addGMFunction(_("buttonGM", "Set Mission"),gmSetWaves)
end

--- Retrieve Data GM Commands
function gmRetrieveData()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Retrieve Data -"),gmMainMenu)
    addGMFunction(_("buttonGM", "1) Docked at Station"),gmRetrieveData1)
    addGMFunction(_("buttonGM", "2) Enemies Arrive"),gmRetrieveData2)
    addGMFunction(_("buttonGM", "3) Data Retrieved"),gmRetrieveData3)
    addGMFunction(_("buttonGM", "3) Data Lost"),gmRetrieveData4)
    addGMFunction(_("buttonGM", "Set Mission"),gmSetRetrieveData)
end

function gmModifyShip()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "Modify Trainee Ship -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Reset Hull"),gmResetHull)
    addGMFunction(_("buttonGM", "Reset Energy"),gmResetEnergy)
    -- addGMFunction(_("buttonGM", "Fill Weapon Supply"),gmResetWeapons)
    -- addGMFunction(_("buttonGM", "Remove Weapons"),gmRemoveWeapons)
    addGMFunction(_("buttonGM", "Reset Probe Supply"),gmResetProbes)
end

function gmEndScenario()
    clearGMFunctions() -- Clear the menu
    addGMFunction(_("buttonGM", "End Scenario -"),gmMainMenu)
    addGMFunction(_("buttonGM", "Victory"),gmVictory)
    addGMFunction(_("buttonGM", "Defeat"),gmDefeat)
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


-- ##########################################################################
-- ## GM RescueJJ Commands ##
-- ##########################################################################
--- 1) Destroy JJ's Ship
-- Do this when trainees get nearby or sit around waiting too long
function gmRescueJJ1()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    -- Destroy JJ Johnson's ship and activate the enemies on-site
    jj_transport:destroy()
    exuari_guard1:orderRoaming()
    exuari_guard2:orderRoaming()

    -- Spawn the life pod
    lifepod = SupplyDrop()
    lifepod:setFaction("Human Navy")
    lifepod:setPosition(3750, 31250)
    lifepod:setCallSign("JJ Johnson's Lifepod")
    lifepod:setDescriptions(
        _("scienceDescription-lifepod", "Life Pod"),
        _("scienceDescription-lifepod", "JJ Johnson and his crew in Life Pod")
    )
    lifepod:setScanningParameters(1,1)

    table.insert(friendList, lifepod)

    -- Notify the trainees
    nebula_citadel:sendCommsMessage(TraineeShip,
        _("incCall", "JJ Johnson's ship has been attacked and destroyed, but "
        .. "not before it launched an escape pod. \n Life signs are detected "
        .. "in the pod. Please retrieve the pod to see if JJ Johnson "
        .. "survived. His death would be a great blow to the region's peace "
        .. "negotiations.")
    )
end


-- 2) We're Good
-- Do this shortly after the capsule ejects
function gmRescueJJ2()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    lifepod:sendCommsMessage(TraineeShip,
        _("incCall", "Greetings crew of the J.E. Thompson, this is JJ Johnson. "
        .. "Thank you for responding to our signal. My crew and I managed to launch "
        .. "in an escape pod before our ship was destroyed - we should be able to "
        .. "hold out until you can pick us up. We will stand by until then!")
    )

end

-- 3) Air Running out
-- ~1 minute later; a leak has sprung
function gmRescueJJ3()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    lifepod:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, come in! My crew has discovered that we "
        .. "took some damage during the launch; we are losing air rapidly and have "
        .. "no way to replenish it. I'm not sure how long we have, but please "
        .. "hurry!")
    )

end

-- 4) Suffocating
-- After 1-3 minutes to heighten stress, they'll die soon
function gmRescueJJ4()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    lifepod:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, mayday, mayday, our crew is starting to "
        .. "faint from the lack of air; we need you ASAP!")
    )

end

-- 5) JJ Dead, Extract
-- After 5-6 minutes. Let them fly back to base if there's time, then end scenario
function gmRescueJJ5()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    nebula_citadel:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, this is Central Command. We've lost JJ "
        .. "Johnson and his crew. This is a great tragedy not only for their "
        .. "families and friends but also for our nation's peace as a whole. Return "
        .. "to command for debriefing.")
    )

end

-- 6) JJ Alive, Extract
function gmRescueJJ6()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    nebula_citadel:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, this is Central Command. Great work "
        .. "retrieving JJ Johnson safely! Return him to command and report for your "
        .. "debriefing.")
    )

end

function gmSetRescueJJ()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    nebula_citadel = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    nebula_citadel:setPosition(23500, 16100):setCallSign("Nebula Citadel")

    -- Create the main ship for the trainees.
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(22598, 16086):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(nebula_citadel)

    TraineeShip:addToShipLog("The diplomat, JJ Johnson, was traveling back from "
    .. "peace talks with our enemy faction, the Exuari. We have just received a "
    .. "distress signal from his vessel and need to respond immediately due to the "
    .. "sensitive nature of his work. If we lose JJ, we may very well lose our "
    .. "uneasy peace and fall into war. Ensure his safe return at all costs.",
    "white")

    -- Create JJ Johnson's ship
    -- We create a ship rather than go straight to just having an escape pod so
    -- if the trainees probe the area they can see his ship.
    jj_transport = CpuShip()
    jj_transport:setTemplate("Flavia")
    jj_transport:setFaction("Human Navy")
    jj_transport:setPosition(3750, 31250)
    jj_transport:setCallSign("RT-4")
    jj_transport:setCommsScript("")
    jj_transport:setHull(1):setShieldsMax(1, 1)

    -- Small Exuari strike team, guarding RT-4 in the nebula at G5.
    exuari_guard1 = CpuShip()
    exuari_guard1:setTemplate("Adder MK5")
    exuari_guard1:setFaction("Exuari")
    exuari_guard1:setPosition(3550, 31250)
    exuari_guard1:setRotation(0)

    exuari_guard2 = CpuShip()
    exuari_guard2:setTemplate("Adder MK5")
    exuari_guard2:setFaction("Exuari")
    exuari_guard2:setPosition(3950, 31250)
    exuari_guard2:setRotation(180)

    -- Set orders
    jj_transport:orderIdle()
    exuari_guard1:orderIdle()
    exuari_guard2:orderIdle()

    table.insert(enemyList, exuari_guard1)
    table.insert(enemyList, exuari_guard2)
    table.insert(friendList, jj_transport)
end

-- ##########################################################################
-- ## Waves ##
-- ##########################################################################

function gmSetWaves()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    waveNumber = 0

    deep_space_ix = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    deep_space_ix:setPosition(23500, 16100):setCallSign("Deep Space IX")

    -- Create the main ship for the trainees.
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(22598, 16086):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(deep_space_ix)

    TraineeShip:addToShipLog("The attack on JJ Johnson has shown that our peace "
    .. "with the Exuari faction is over and war has begun. We have received reports "
    .. "that an attack on Central Command is soon to take place. We have requested "
    .. "reinforcements, but until they arrive, you and the other ships already "
    .. "on-station must defend us. They could arrive at any moment - be prepared.", "white")

    human_m1 = CpuShip()
    human_m1:setFaction("Human Navy")
    human_m1:setTemplate("MT52 Hornet")
    human_m1:setCallSign("HM1")
    human_m1:setScanned(true)
    human_m1:setPosition(23490, 16050)
    human_m1:orderDefendTarget(deep_space_ix)

    human_m2 = CpuShip()
    human_m2:setFaction("Human Navy")
    human_m2:setTemplate("MT52 Hornet")
    human_m2:setCallSign("HM2")
    human_m2:setScanned(true)
    human_m2:setPosition(23490, 16050)
    human_m2:orderDefendTarget(deep_space_ix)

    human_m3 = CpuShip()
    human_m3:setFaction("Human Navy")
    human_m3:setTemplate("MT52 Hornet")
    human_m3:setCallSign("HM3")
    human_m3:setScanned(true)
    human_m3:setPosition(23490, 16050)
    human_m3:orderDefendTarget(deep_space_ix)

    table.insert(friendList, human_m1)
    table.insert(friendList, human_m2)
    table.insert(friendList, human_m3)
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

function gmSpawnNextWave()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
    waveNumber = waveNumber + 1

    local totalScoreRequirement = math.pow(waveNumber * 0.8, 1.3) * 10

    local scoreInSpawnPoint = 0
    local spawnDistance = 5000
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

-- ##########################################################################
-- ## Retrieve Data ##
-- ##########################################################################

--- 1) Docked at Station
function gmRetrieveData1()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    satellite:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, welcome to the E.O.S. Scope satellite. I "
        .. "am the station-board Artificial Intelligence that runs this unmanned "
        .. "platform. I have been informed of your mission by Central Command and "
        .. "have prepared the data for your retrieval. Please send two crew members "
        .. "to the data storage facility to pickup the hard drive.")
        )

end

--- 2) Enemies Arrive
function gmRetrieveData2()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    hostile_1 = CpuShip()
    hostile_1:setTemplate("Phobos T3")
    hostile_1:setFaction("Exuari")
    hostile_1:setPosition(60000, 35000)
    hostile_1:setScanned(true)
    hostile_1:orderRoaming()

    hostile_2 = CpuShip()
    hostile_2:setTemplate("MT52 Hornet")
    hostile_2:setFaction("Exuari")
    hostile_2:setPosition(60000, 35010)
    hostile_2:setScanned(true)
    hostile_2:orderRoaming()

    hostile_3 = CpuShip()
    hostile_3:setTemplate("MT52 Hornet")
    hostile_3:setFaction("Exuari")
    hostile_3:setPosition(60000, 35020)
    hostile_3:setScanned(true)
    hostile_3:orderRoaming()

    table.insert(enemyList, hostile_1)
    table.insert(enemyList, hostile_2)
    table.insert(enemyList, hostile_3)

    satellite:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, as you may already be aware, the reported "
        .. "hostile force has now arrived. Good luck. ")
        )
end

--- 3) Data Retrieved
function gmRetrieveData3()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    repair_station:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, great job retrieving the data. Report for debriefing.")
        )
end

--- 4) Data Lost
function gmRetrieveData4()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    repair_station:sendCommsMessage(TraineeShip,
        _("incCall", "J.E. Thompson, it is regrettable that you've failed this "
        .. "mission. Now our enemies will have intel that will harm the war effort "
        .. "- and likely lead to our defeat.")
        )
end


function gmSetRetrieveData()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    repair_station = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
    repair_station:setPosition(23500, 16100):setCallSign("Repair Station")
    
    -- Create the main ship for the trainees.
    TraineeShip = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis")
    TraineeShip:setPosition(22598, 16086):setCallSign("J.E. Thompson")
    TraineeShip:setRotation(180) -- make sure it's facing away from station
    TraineeShip:commandDock(repair_station)

    TraineeShip:addToShipLog("We have received reports that a hostile force is "
    .. "enroute to Orion Starforge. This station "
    .. "has codes to enable comms back to Earth's central command post that must be retrieved before the Exuari get their hands "
    .. "on it. Retrieve the codes and return them to the Repair Station. Do not allow the Exuari "
    .. "to have it.", "white")

    satellite = SpaceStation():setTemplate("Small Station"):setFaction("Human Navy"):setPosition(60500, 42100):setCallSign("Orion Starforge"):setCommsScript("")
  

    table.insert(friendList, satellite)



end


-- ##########################################################################
-- ## GM Modify Trainee Ship ##
-- ##########################################################################

--- Resets trainee ship hull to full
function gmResetHull()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    TraineeShip:setHull(TraineeShip:getHullMax())
end

--- Resets trainee ship energy to full
function gmResetEnergy()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    TraineeShip:setEnergy(TraineeShip:getEnergyLevelMax())
end

-- --- Refills trainee ship weapons
-- function gmResetWeapons()
--     -- Clear and reset the menu
--     clearGMFunctions()
--     gmMainMenu()
-- end

--- Resets trainee ship probe supply
function gmResetProbes()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())
end

-- --- Removes weapons from trainee ship (ie missiles, etc.)
-- function gmRemoveWeapons()
--     -- Clear and reset the menu
--     clearGMFunctions()
--     gmMainMenu()
-- end

-- ##########################################################################
-- ## GM End Scenario ##
-- ##########################################################################

function gmVictory()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    victory_message = "Victory! Mission Success! Report for debriefing."

    globalMessage(victory_message)
    TraineeShip:addCustomMessage("Helms", "Helms_Victory", victory_message)
    TraineeShip:addCustomMessage("Weapons", "Weapons_Victory", victory_message)
    TraineeShip:addCustomMessage("Engineering", "Engineering_Victory", victory_message)
    TraineeShip:addCustomMessage("Science", "Science_Victory", victory_message)
    TraineeShip:addCustomMessage("Relay", "Relay_Victory", victory_message)
end

function gmDefeat()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()

    defeat_message = "Defeat! Mission Failure! Report for debriefing."

    globalMessage(defeat_message)
    TraineeShip:addCustomMessage("Helms", "Helms_Defeat", defeat_message)
    TraineeShip:addCustomMessage("Weapons", "Weapons_Defeat", defeat_message)
    TraineeShip:addCustomMessage("Engineering", "Engineering_Defeat", defeat_message)
    TraineeShip:addCustomMessage("Science", "Science_Defeat", defeat_message)
    TraineeShip:addCustomMessage("Relay", "Relay_Defeat", defeat_message)
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

    if not central_command:isValid() then
        central_command = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy")
        central_command:setPosition(23500, 16100):setCallSign("Central Command")

    end

end

function gmClearMission()
    -- Clear and reset the menu
    clearGMFunctions()
    gmMainMenu()
    addGMMessage("Start")

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

    if nebula_citadel:isValid() then nebula_citadel:destroy() end
        
    if deep_space_ix:isValid() then  deep_space_ix:destroy() end
       
    if repair_station:isValid() then  repair_station:destroy() end
       
    if orion_starforge:isValid() then orion_starforge:destroy() end


end


-- ##########################################################################
-- ## INIT ##
-- ##########################################################################

--- Runs when the scenario starts
-- Sets up initial game state, creating ships, stations, environment, etc.
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

end

--- Runs during game loop
-- Victory conditions handled manually by GM, so nothing monitored here so far.
function update(delta)
    -- Intentionally blank

    -- GM will manage alert levels, so this will reset it constantly to what
    -- the GM has set it to
    TraineeShip:commandSetAlertLevel(alertLevel)
    
    if TraineeShip:isDocked(orion_starforge) then
        TraineeShip:setWeaponStorage("homing", 20):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())
    end

    if TraineeShip:isDocked(nebula_citadel) then
        TraineeShip:setWeaponStorage("homing", 20):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())
    end

    if TraineeShip:isDocked(repair_station) then
        TraineeShip:setWeaponStorage("homing", 20):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())
    end

    if TraineeShip:isDocked(deep_space_ix) then
        TraineeShip:setWeaponStorage("homing", 20):setWeaponStorage("nuke", 4):setWeaponStorage("mine", 8):setWeaponStorage("EMP", 6):setWeaponStorage("HVLI", 20)
        TraineeShip:setScanProbeCount(TraineeShip:getMaxScanProbeCount())
    end
end

--- Return the distance between two objects.
function distance(obj1, obj2)
    local x1, y1 = obj1:getPosition()
    local x2, y2 = obj2:getPosition()
    local xd, yd = (x1 - x2), (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)
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

-- vim:foldmethod=manual
