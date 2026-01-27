function createVehicleForPlayer(player, command, model)

    if not model then
        outputChatBox("Please provide a vehicle model.", player, 255, 100, 100)
        return outputChatBox("SYNTAX /" .. command .. ' [model_number] ', player, 255, 100, 100)
    end

    local db = exports.db:getConnection()
    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)

    local matrix = getElementMatrix(player)
    local right = matrix[1]
    local forward = matrix[2]


    local forwardDist = 5
    local rightDist = 3

    x = x + forward[1] * forwardDist + right[1] * rightDist
    y = y + forward[2] * forwardDist + right[2] * rightDist
    z = z + forward[3] * forwardDist + right[3] * rightDist + 1

    dbExec(db, 'INSERT INTO vehicles (model, x, y, z, rx, ry, rz) VALUES (?, ?, ?, ?, ?, ?, ?)', model, x, y, z, 0, 0, rz)

    local vehicleObject = createVehicle(model, x, y, z, rx, ry, rz)
    outputChatBox("Vehicle created successfully!", player, 0, 255, 0)


    dbQuery(function (queryHandle)

        local results = dbPoll(queryHandle, 0)
        local vehicle = results[1]

        setElementData(vehicleObject, "id", vehicle.id)

        end, db, 'SELECT id FROM vehicles ORDER BY id DESC LIMIT 1')
end


function loadAllVehicles(queryHandle)
    local results = dbPoll(queryHandle, 0)

    if not results then
            outputDebugString("No vehicles found in database or query failed.")
            return
    end

    for index, vehicleData in ipairs(results) do
        -- Create vehicle and check if it was successful
        local vehicleObject = createVehicle(vehicleData.model, vehicleData.x, vehicleData.y, vehicleData.z, vehicleData.rx, vehicleData.ry, vehicleData.rz)

        if vehicleObject then
            setElementData(vehicleObject, "id", vehicleData.id)
            outputDebugString("Loaded vehicle ID: " .. vehicleData.id)
        else
            outputDebugString("Failed to create vehicle from database. Model: " .. tostring(vehicleData.model))
        end
    end
end

addEventHandler('onResourceStart', resourceRoot, function()
    local db = exports.db:getConnection()

    dbQuery(loadAllVehicles, db, 'SELECT * FROM vehicles')
end)

addEventHandler('onResourceStop', resourceRoot, function ()

    local vehicles = getElementsByType('vehicle')

    for index, vehicle in pairs(vehicles) do
        local db = exports.db:getConnection()
        local id = getElementData(vehicle, 'id')
        local x, y, z = getElementPosition(vehicle)
        local rx, ry, rz = getElementRotation(vehicle)

        dbExec(db, 'UPDATE vehicles SET x = ?, y = ?, z = ?, rx = ?, ry = ?, rz = ? WHERE id = ?', x, y, z, rx, ry ,rz, id)
    end

end)

addCommandHandler('createvehicle', createVehicleForPlayer, false, false)
addCommandHandler('createveh', createVehicleForPlayer, false, false)
