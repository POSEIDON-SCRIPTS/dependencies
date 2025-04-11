--[[ local object = 0
RegisterCommand('spawnobject', function(source, args, rawCommand) --example of how the gizmo could be used /spawnobject {object model name}
    if object ~= 0 then
        DeleteEntity(object)
        object = 0
        return
    end
    local objectName = args[1] or "gunrack_outsider02"
    local playerPed = PlayerPedId()
    local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0, 1.0, 0)

    local model = joaat(objectName)
    --lib.requestModel(model, 5000)
    RequestModel(model, false)
    repeat Wait(0) until HasModelLoaded(model)
    object = CreateObject(model, offset.x, offset.y, offset.z, true, false, false)
    repeat Wait(0) until DoesEntityExist(object)

    local objectPositionData = exports.object_gizmo:useGizmo(object) --export for the gizmo. just pass an object handle to the function.
    if objectPositionData == nil then
        print("Object Gizmo failed to get object position data.")
        Delete
        return
    end

    print(json.encode(objectPositionData, { indent = true }))
end, false) ]]
