function createVehicleForPlayer(player, command, model)

    local db = exports.db:getConnection()
    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    y = y + 5

    dbExec(db, 'INSERT INTO vehicles (model, x, y, z, rx, ry, rz) VALUES (?, ?, ?, ?, ?, ?, ?)', model, x, y, z, rx, ry, rz)

    local vehicleObject = createVehicle(model, x, y, z, rx, ry, rz)

    dbQuery(function (queryHandle)

        local results = dbPoll(queryHandle, 0)
        local vehicle = results[1]

        setElementData(vehicleObject, "id", vehicle.id)

        end, db, 'SELECT id FROM vehicles ORDER BY id DESC LIMIT 1')
end

function loadAllVehicles(queryHandle)
    local results = dbPoll(queryHandle, 0)

    if not results then
            outputDebugString("No vehicles found in database or query failed")
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
