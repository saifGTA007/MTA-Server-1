local window

local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    return x, y, width, height
end

local function isUsernameValid(username)
    return type(username) == 'string' and string.len(username) > 3
end

local function isPasswordValid(password)
   return type(password) == 'string' and string.len(password) > 3
end

addEvent('login-menu:open', true)

addEventHandler('login-menu:open', root, function()

    -- set a direction to look at
    setCameraMatrix(0, 0, 100, 0, 100, 50)
    fadeCamera(true)

    -- initialize the cursor
    showCursor(true, true)
    guiSetInputMode('no_binds')

    -- creating the menu gui__(x_position, y_position, width, height, 'title or labelText', ifRelative, ParentObject)

    local x, y, width, height = getWindowPosition(400, 250)
    window = guiCreateWindow(x, y, width, height, 'Login to the Server', false)
    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)

    local usernameLabel = guiCreateLabel(15, 30, width - 30, 20, 'Username:', false, window)

    local usernameErrorLabel = guiCreateLabel(width - 120, 30, 140, 20, 'Username Required', false, window)
    guiLabelSetColor(usernameErrorLabel, 255, 50, 50)
    guiSetVisible(usernameErrorLabel, false)

    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)

    local passwordLabel = guiCreateLabel(15, 100, width - 30, 20, 'Password:', false, window)
    local passwordErrorLabel = guiCreateLabel(width - 115, 100, 140, 20, 'Password Required', false, window)
    guiLabelSetColor(passwordErrorLabel, 255, 50, 50)
    guiSetVisible(passwordErrorLabel, false)

    local passwordInput = guiCreateEdit(10, 120, width - 20, 30, '', false, window)
    guiEditSetMasked(passwordInput, true)

    local loginButton = guiCreateButton(10, 170, width - 20, 30, 'Login', false, window)
    addEventHandler('onClientGUIClick', loginButton, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end

        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local inputValid = true

        if not isUsernameValid(username) then
            inputValid = false
            guiSetVisible(usernameErrorLabel, true)
        else
           guiSetVisible(usernameErrorLabel, false)
        end

        if not isPasswordValid(password) then
            inputValid = false
            guiSetVisible(passwordErrorLabel, true)
        else
            guiSetVisible(passwordErrorLabel, false)
        end

        if not inputValid then
            return
        end
        triggerServerEvent('auth:login-attempt', localPlayer, username, password)

    end, false)

    local registerButton = guiCreateButton(10, 210, width / 2 - 15, 30, 'Register', false, window)
    local forgotPasswordButton = guiCreateButton(width / 2 + 5, 210, width / 2 - 15, 30, 'Forgot Password', false, window)

    addEvent('login-menu:close', true)
    addEventHandler('login-menu:close', root, function()
        destroyElement(window)
        showCursor(false)
        guiSetInputMode('allow_binds')
    end)

end, true)
