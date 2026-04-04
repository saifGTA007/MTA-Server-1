local MIN_PASSWORD_LENGTH  = 6

local function isPasswordValid(pass)
    return string.len(pass) >= MIN_PASSWORD_LENGTH
end

-- create an account
addCommandHandler('accregister', function(player, command, username, password)

    -- check if the username or the password was provided
    if not username or not password then
        return outputChatBox('SYNTAX : /' .. command .. ' [username] [password]', player, 255, 255, 255)
    end

    -- check if the account already exists
    if getAccount(username) then
        return outputChatBox('An Account with this username Already exists !', player, 255, 50, 50)
    end

    -- check if the password is valid
    if not isPasswordValid(password) then
        return outputChatBox('Invalid password', player, 255, 50, 50)
    end

    -- hash the password
    passwordHash(password, 'bcrypt', {}, function (hashedPassword)

        -- create the account
        local account = addAccount(username, hashedPassword)
        setAccountData(account, 'hashed_password', hashedPassword)

        -- let the user know that the account was created successfully
        outputChatBox('Account created successfully !, you can login with /login',player, 50, 255, 50)
    end)
end, false, false)

-- Login
addEvent('auth:login-attempt', true)
addEventHandler('auth:login-attempt', root, function(username, password)

    local player = source

     passwordHash(password, 'bcrypt', {}, function (hashedPassword)

        local account = getAccount(username)
        if not account then
            outputChatBox('No account with this username or password was found.',source, 255, 50, 50)
        end

        local hashed_password = getAccountData(account, 'hashed_password')

        passwordVerify(password, hashed_password, function (isValid)
            if not isValid then
                return outputChatBox('No account with this username or password was found.',player, 255, 50, 50)
            end

            if logIn(player, account, hashed_password) then
                spawnPlayer(player, 0, 0, 5)
                setCameraTarget(player, player)
                return triggerClientEvent(player, 'login-menu:close', player)
            end
            return outputChatBox('An unknown error occured while authenticating.', player, 255, 50, 50)
        end)
     end)
end)


-- Logout

addCommandHandler('acclogout',function (player, command)

    logOut(player)
end, false, false)
