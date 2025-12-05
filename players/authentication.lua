local MIN_PASSWORD_LENGTH  = 6

local function isPasswordValid(pass)
    return string.len(pass) >= MIN_PASSWORD_LENGTH
end

-- create an account
addCommandHandler('register', function(player, command, username, password)

    -- check if the username or the password was provided
    if not username or not password then
        return outputChatBox('SYNTAX : /' .. command .. '[username] [password]', player, 255, 255, 255)
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
        outputChatBox('Account created successfully !, you can login with /accountLogin',player, 50, 255, 50)
    end)
end, false, false)

-- Login

addCommandHandler('accountLogin', function (player, command, username, password)

    -- check if the username or the password was provided
    if not username or not password then
        return outputChatBox('SYNTAX : /' .. command .. '[username] [password]', player, 255, 255, 255)
    end

     passwordHash(password, 'bcrypt', {}, function (hashedPassword)

        local account = getAccount(username)
        if not account then
            outputChatBox('No account with this username or password was found.',player, 255, 50, 50)
        end

        local hashed_password = getAccountData(account, 'hashed_password')
        passwordVerify(password, hashed_password, function (isValid)
            if not isValid then
                return outputChatBox('No account with this username or password was found.',player, 255, 50, 50)
            end

            if logIn(player, account ,hashed_password) then
                return outputChatBox('LogIn successful !', player, 50, 255, 50)
            end
            return outputChatBox('An uknown error occured while authenticating', player, 255, 50, 50)
        end)
     end)
end, false, false)


-- Logout

addCommandHandler('accountLogout',function (player, command)

    logOut(player)
end, false, false)
