local usingGizmo = false
local editingStop = false
local house = nil

local function toggleNuiFrame(bool)
    usingGizmo = bool

    if not bool then
        house = nil
    end
    
    SetNuiFocus(bool, bool)
end

local function DrawText3D(x, y, z, text)
    local r, g, b, a = 255, 255, 255, 255
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())


    if onScreen then
        SetTextScale(0.25, 0.25)
        SetTextFontForCurrentCommand(6)
        SetTextColor(r, g, b, a)
        SetTextCentre(1)
        DisplayText(str, _x, _y + 0.09)
    end
end

local function useGizmo(handle, house2)
    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            handle = handle,
            position = GetEntityCoords(handle),
            rotation = GetEntityRotation(handle)
        }
    })

    if house2 then 
        house = house2
    end

    toggleNuiFrame(true)

    while usingGizmo do
        local coords = GetEntityCoords(handle)
        DrawText3D(coords.x, coords.y + 1.0, coords.z - 0.5, "Current Mode: Translate\n[W] - Translate Mode\n[R] - Rotate Mode\n[LALT] - Place On Ground\n[Esc] - Done Editing - Stop Editing\n[Backspace] ")
        SendNUIMessage({
            action = 'setCameraPosition',
            data = {
                position = GetFinalRenderedCamCoord(),
                rotation = GetFinalRenderedCamRot(0)
            }
        })
        Wait(0)
    end
    local data = {
        handle = handle,
        position = GetEntityCoords(handle),
        rotation = GetEntityRotation(handle)
    }
    SetTimeout(1000, function()
        editingStop = false
    end)
    return not editingStop and data or nil
end

RegisterNUICallback('moveEntity', function(data, cb)
    local entity = data.handle

    if house then 
        if exports['POS-Housing']:PointInside(house, data.position) then
            local position = data.position
            local rotation = data.rotation
            SetEntityCoords(entity, position.x, position.y, position.z, false, false, false, false)
            SetEntityRotation(entity, rotation.x, rotation.y, rotation.z, 0, false)
        end
    else
        local position = data.position
        local rotation = data.rotation
        SetEntityCoords(entity, position.x, position.y, position.z, false, false, false, false)
        SetEntityRotation(entity, rotation.x, rotation.y, rotation.z, 0, false)
    end


    cb('ok')
end)

RegisterNUICallback('placeOnGround', function(data, cb)
    PlaceObjectOnGroundProperly(data.handle, false)
    cb('ok')
end)

RegisterNUICallback('finishEdit', function(data, cb)
    toggleNuiFrame(false)
    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            handle = nil,
        }
    })
    cb('ok')
end)

RegisterNUICallback('swapMode', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('stopEditing', function(data, cb)
    toggleNuiFrame(false)
    editingStop = true
    SendNUIMessage({
        action = 'setGizmoEntity',
        data = {
            handle = nil,
        }
    })
    cb('ok')
end)


exports("useGizmo", useGizmo)
