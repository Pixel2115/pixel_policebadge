ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterCommand("badge", function(source, args, rawcmd)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobname = xPlayer.job.name
    if jobname == 'police' then
        local badge = GetBadge(xPlayer.identifier)
        local grade = xPlayer.job.grade_label
        local data = GetCharName(xPlayer.identifier)
        TriggerClientEvent("pixel_badge:show", -1, source, {badge=badge, grade=grade, data=data})
    end
end)

RegisterCommand("givebadge", function(source, args, rawcmd)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
        if tonumber(args[1]) and args[2] and args[3] then
            local tPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
            if tPlayer ~= nil then
                GiveBadge(tPlayer.identifier, args[2], args[3])
            end
        end
    end
end)

function GetBadge(identifier)
    local a = MySQL.Sync.fetchAll("SELECT callsign, badge FROM pixel_badge WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    local a = a[1]
    if a ~= nil then
        return a.callsign.." - "..a.badge
    else
        return "N/A"
    end
end

function GetCharName(identifier)
    local d = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    d = d[1]
    return d.firstname.." "..d.lastname
end

function GiveBadge(identifier, callsign, badge)
    local a = MySQL.Sync.fetchAll("SELECT * FROM pixel_badge WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    a = a[1]
    if a == nil then
        MySQL.Async.execute("INSERT INTO pixel_badge (identifier, callsign, badge) VALUES (@identifier, @callsign, @badge)", {
            ['@identifier'] = identifier,
            ['@callsign'] = callsign,
            ['@badge'] = badge
        });
    else
        MySQL.Async.execute("UPDATE pixel_badge SET callsign=@callsign, badge=@badge WHERE identifier = @identifier", {
            ['@identifier'] = identifier,
            ['@callsign'] = callsign,
            ['@badge'] = badge
        });
    end
end