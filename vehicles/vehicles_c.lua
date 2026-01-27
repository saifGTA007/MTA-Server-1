addCommandHandler('flycar', function ()

    local vehicle =getPedOccupiedVehicle(localPlayer)

    if not vehicle then
        outputChatBox("You are not in a vehicle", 255, 100, 100)
        return
    end

    setWorldSpecialPropertyEnabled('aircars', true)
    outputChatBox('successfull!', 100, 255, 100)
end)
