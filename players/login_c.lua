local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    return x, y, width, height
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
    local window = guiCreateWindow(x, y, width, height, 'Login to the Server', false)

    local usernameLabel = guiCreateLabel(15, 30, width - 30, 20, 'Username:', false, window)
    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)

    local passwordLabel = guiCreateLabel(15, 100, width - 30, 20, 'Password:', false, window)
    local passwordInput = guiCreateEdit(10, 120, width - 20, 30, '', false, window)

    local loginButton = guiCreateButton(10, 170, width - 20, 30, 'Login', false, window)
    local registerButton = guiCreateButton(10, 210, width / 2 - 15, 30, 'Register', false, window)
    local forgotPasswordButton = guiCreateButton(width / 2 + 5, 210, width / 2 - 15, 30, 'Forgot Password', false, window)

end, true)

triggerEvent('login-menu:open', localPlayer)
