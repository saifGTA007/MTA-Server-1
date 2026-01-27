addCommandHandler('setrank', function (player, command, account, group)
    if not account or not group then
        return outputChatBox('SYNTAX /' .. command .. ' [account] [groupe]', player, 255, 255, 255)
    end

    -- 1. ensure that the provided account is valid
    local accountObj = getAccount(account)
    if not accountObj then
        return outputChatBox('The specified account does not exist.', player, 255, 100, 100)
    end

    -- 2.ensure that the group is valid

    local groupObj = aclGetGroup(group)
    if not groupObj then
        return outputChatBox('The specified group does not exist.', player, 255, 100, 100)
    end

    -- 3. prefix the account name with "user." to be a valid object in the ACL

    local objString = 'user.' .. account

    -- 3.1 if the account is saifgta, don't remove it from the admin acl group (basic protection)

    local accountName = getAccountName(accountObj)

    if accountName == 'saifgta' and group ~= 'Admin' then
        return outputChatBox('Owner Protrction, can`t remove Admin from saifgta, you fucking peasent trying to rebel against your god , i,ll destroy you ', player, 255, 0, 0)
    end

	-- 4. remove the user from all groups
    local groups = aclGroupList()
    for _, removalGroup in pairs(groups) do

        local removalGroupName = aclGroupGetName(removalGroup)


        aclGroupRemoveObject( removalGroup, objString)
    end

    -- if the provided group is Everyone, return

    if group == 'Everyone' then
        return outputChatBox('Successfully removed account ' .. account .. ' from all groups.', player, 100, 255, 100)
    end

    -- add the account to the ACL group using the object string

    aclGroupAddObject(groupObj, objString)

    -- let the user know that the operation was successfull

    outputChatBox('Successfully added account '.. account .. ' to the group ' .. group, player, 100, 255, 100)

end)

addCommandHandler('setaclright', function (player, command, acl, right, access)

    if not acl or not right or not access then
        return outputChatBox('SYNTAX /' .. command .. '[acl] [right] [access]', player, 255, 255, 255)
    end

    local aclObj = aclGet(acl)
    if not aclObj then
        return outputChatBox('the specified ACL does not exist.', player, 255, 100, 100)
    end

    local accessType = { ['true'] = true, ['false'] = false}
    local accessBoolien = accessType[string.lower(access)]
    if accessBoolien == nil then
        return outputChatBox('ACL access must be either TRUE or FALSE', player, 255, 100, 100)
    end

    aclSetRight(aclObj, right, accessBoolien)
    aclSave()
    outputChatBox('Successfully updated the ACL right.', player, 100, 255, 100)
end, true, false)
