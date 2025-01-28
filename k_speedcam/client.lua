local streetRadars, radarJobWhitelist = Config.coordsspeedcam, {
    
    ["police"] = true,
    ["ambulance"] = true,
    ["policebcso"] = true
}

Citizen.CreateThread(function()
    Citizen.Wait(25)
    for i = 1, #streetRadars, 1 do
        local radar = streetRadars[i]
        local blip = AddBlipForCoord(radar.coords)
        SetBlipSprite(blip, 184)
        SetBlipScale(blip, 0.65)
        SetBlipColour(blip, 63)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fotoradar")
        EndTextCommandSetBlipName(blip)
        -- prop
        local propHash = GetHashKey("p_tv_cam_02_s")
        
        RequestModel(propHash)
        while not HasModelLoaded(propHash) do
            Citizen.Wait(100)
        end

        local radarProp = CreateObject(propHash, radar.coords.x, radar.coords.y, radar.coords.z - 1.0, false, false, false)
        
        SetEntityHeading(radarProp, 70.0)
        
        FreezeEntityPosition(radarProp, true)
    end
end)


RegisterNetEvent('speedcam', function()
    AddEventHandler('esx:enteredVehicle', function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local playerPed = PlayerPedId()
            local playerPosition = GetEntityCoords(playerPed)
            for i = 1, #streetRadars, 1 do
                local radar = streetRadars[i]
                local dist = #(radar.coords - playerPosition)
                local speedconfig = Config.speed
               
                if dist < 50 then
                    if IsPedInAnyVehicle(playerPed, false) then
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        local speed = GetEntitySpeed(vehicle) * 3.6                     
                        if speed > speedconfig then
                            local fine = Config.fine
                            local random = math.random(1, 100)
                            local getfine = Config.getfine
                            if random <= Config.getfine then 
                                PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds", true)
                                StartScreenEffect("RaceTurbo", 1000, false)
                                TriggerServerEvent('payforthespeedcam')
                                ESX.ShowNotification('Jedziesz za szybko, otrzymałeś mandat!')

                            end
                        end                        
                        local randomTimeout = math.random(5000, 15000)
                        Citizen.Wait(randomTimeout) -- gracz po dostaniu mandatu ma chwile "spokoju"
           
                            end
                        end
                    end
                end
            end)
        end) 
    end)

TriggerEvent('speedcam')




