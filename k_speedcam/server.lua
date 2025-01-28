RegisterNetEvent('payforthespeedcam', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local fine = Config.fine
    xPlayer.removeAccountMoney('money', fine)
end)

