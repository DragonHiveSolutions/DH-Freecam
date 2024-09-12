-- client.lua
local filters = {"DeathFailMPDark", "MP_Bull_tost", "DrugsMichaelAliensFight", "HeistCelebPass", "FocusOut"}
local currentFilterIndex = 1
local cam = nil
local freeCamActive = false
local initialPos = nil
local currentFOV = 90.0 -- Default FOV
local rollAngle = 0.0 -- Initial roll angle
local filterActive = false -- Filter toggle state
local helpersVisible = true -- Toggle for control helpers

-- Function to toggle free camera mode
local function toggleFreeCam()
    if not freeCamActive then
        -- Activate Free Cam
        freeCamActive = true
        local playerPed = PlayerPedId()
        initialPos = GetEntityCoords(playerPed)

        -- Create a new camera
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        -- Set camera properties
        SetCamCoord(cam, initialPos.x, initialPos.y, initialPos.z + 1.0)
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamFov(cam, currentFOV)

        -- Set the camera as active
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        -- Hide HUD and radar
        DisplayHud(false)
        DisplayRadar(false)
		TriggerEvent('es:setMoneyDisplay', 0.0)

        -- Freeze the player to prevent movement
        FreezeEntityPosition(playerPed, true)
    else
        -- Deactivate Free Cam
        freeCamActive = false

        -- Destroy the camera
        DestroyCam(cam, false)
        RenderScriptCams(false, false, 0, true, true)
        cam = nil

        -- Show HUD and radar again
        DisplayHud(true)
        DisplayRadar(true)
		TriggerEvent('es:setMoneyDisplay', 1.0)

        -- Unfreeze the player
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

-- Function to calculate the forward vector from the camera's rotation
local function GetCamForwardVector(cam)
    local rot = GetCamRot(cam, 2)
    local x = -math.sin(math.rad(rot.z)) * math.abs(math.cos(math.rad(rot.x)))
    local y = math.cos(math.rad(rot.z)) * math.abs(math.cos(math.rad(rot.x)))
    local z = math.sin(math.rad(rot.x))
    return vector3(x, y, z)
end

-- Function to calculate the right vector from the camera's rotation
local function GetCamRightVector(cam)
    local forwardVector = GetCamForwardVector(cam)
    return vector3(-forwardVector.y, forwardVector.x, 0.0)
end

-- Function to toggle a filter
local function toggleFilter()
    if filterActive then
        ClearTimecycleModifier()
        filterActive = false
    else
        SetTimecycleModifier("yell_tunnel_nodirect")
        filterActive = true
    end
end

-- Function to disable specific player controls
local function disablePlayerControls()
    DisableControlAction(0, 30, true) -- Move Left/Right
    DisableControlAction(0, 31, true) -- Move Up/Down
    DisableControlAction(0, 140, true) -- Melee Attack Light
    DisableControlAction(0, 141, true) -- Melee Attack Heavy
    DisableControlAction(0, 142, true) -- Melee Attack Alternative
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 22, true) -- Jump
    DisableControlAction(0, 23, true) -- Enter Vehicle
    DisableControlAction(0, 75, true) -- Exit Vehicle
    DisableControlAction(0, 45, true) -- Reload
end

-- Function to draw text on the screen
local function DrawText2D(text, x, y, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Function to draw control helpers
local function DrawHelpers()
    if helpersVisible then
        DrawText2D("W/S: Move Forward/Backward", 0.01, 0.70, 0.35)
        DrawText2D("A/D: Move Left/Right", 0.01, 0.73, 0.35)
        DrawText2D("Q/E: Move Up/Down", 0.01, 0.76, 0.35)
        DrawText2D("Page Up/Down: Zoom In/Out", 0.01, 0.79, 0.35)
        DrawText2D("Arrow Keys: Roll Camera", 0.01, 0.82, 0.35)
        DrawText2D("F1: Toggle Filter", 0.01, 0.85, 0.35)
        DrawText2D("F2: Toggle Helpers", 0.01, 0.88, 0.35)
    end
end

-- Listen for the activation command
RegisterCommand(Config.ActivationCommand, function()
    toggleFreeCam()
end, false)

-- Main thread to handle free camera movement and keybinds
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if freeCamActive then
            -- Disable player controls
            disablePlayerControls()

            -- Get the camera's current position and rotation
            local camPos = GetCamCoord(cam)
            local camRot = GetCamRot(cam, 2)

            -- Camera movement controls
            if IsControlPressed(1, 32) then -- W key
                camPos = camPos + (GetCamForwardVector(cam) * 0.1)
            end
            if IsControlPressed(1, 33) then -- S key
                camPos = camPos - (GetCamForwardVector(cam) * 0.1)
            end
            if IsControlPressed(1, 34) then -- A key (move left)
                camPos = camPos + (GetCamRightVector(cam) * 0.1)
            end
            if IsControlPressed(1, 35) then -- D key (move right)
                camPos = camPos - (GetCamRightVector(cam) * 0.1)
            end
            if IsControlPressed(1, 44) then -- Q key (move up)
                camPos = camPos + vector3(0.0, 0.0, 0.1)
            end
            if IsControlPressed(1, 38) then -- E key (move down)
                camPos = camPos - vector3(0.0, 0.0, 0.1)
            end

            -- Set camera position
            SetCamCoord(cam, camPos)

            -- Camera rotation controls (mouse controls yaw and pitch)
            local xMagnitude = GetControlNormal(0, 1) * 8.0 -- Mouse X
            local yMagnitude = GetControlNormal(0, 2) * 8.0 -- Mouse Y

            -- Roll controls (adjust Z axis rotation for tilt)
            if IsControlPressed(1, 174) then -- Arrow Left to roll left (tilt)
                rollAngle = rollAngle - 1.0
            end
            if IsControlPressed(1, 175) then -- Arrow Right to roll right (tilt)
                rollAngle = rollAngle + 1.0
            end

            camRot = vector3(camRot.x - yMagnitude, camRot.y, camRot.z - xMagnitude)
            SetCamRot(cam, camRot.x, rollAngle, camRot.z, 2) -- Apply roll angle separately

            -- Zoom controls (FOV adjustment)
            if IsControlPressed(1, 16) then -- Scroll up or Page Up key to zoom in
                currentFOV = math.max(30.0, currentFOV - 1.0) -- Min FOV of 30
                SetCamFov(cam, currentFOV)
            end
            if IsControlPressed(1, 17) then -- Scroll down or Page Down key to zoom out
                currentFOV = math.min(120.0, currentFOV + 1.0) -- Max FOV of 120
                SetCamFov(cam, currentFOV)
            end

            -- Toggle filter cycling with F1 key
            if IsControlJustPressed(1, 288) then -- F1 key
                cycleFilter()
            end

            -- Toggle helpers with F2 key
            if IsControlJustPressed(1, 289) then -- F2 key
                helpersVisible = not helpersVisible
            end

            -- Draw control helpers
            DrawHelpers()
        end
    end
end)


function cycleFilter()
    if filterActive then
        StopScreenEffect(filters[currentFilterIndex])
    end
    currentFilterIndex = currentFilterIndex % #filters + 1
    StartScreenEffect(filters[currentFilterIndex], 0, true)
    filterActive = true
end