local currentGear = 0
local animationDict = "veh@driveby@first_person@passenger_rear_right_handed@smg"
local animationName = "outro_90r"
local animationDuration = 1000 

function PlayGearChangeAnimation(gear)
    RequestAnimDict(animationDict)
    while not HasAnimDictLoaded(animationDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animationDict, animationName, 8.0, 1.0, animationDuration, 48, 0, 0, 0, 0)

    Citizen.Wait(animationDuration)
    StopAnimTask(PlayerPedId(), animationDict, animationName, 1.0)
end

function OnGearChange(newGear)
    if newGear ~= currentGear then
        currentGear = newGear
        PlayGearChangeAnimation(currentGear)
    end
end

RegisterNetEvent("gearChange")
AddEventHandler("gearChange", OnGearChange)

function DetectGearChange()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 then
        local newGear = GetVehicleCurrentGear(vehicle)

        if newGear ~= currentGear then
            TriggerEvent("gearChange", newGear)
        end
    else
        if currentGear ~= 0 then
            currentGear = 0
            StopAnimTask(PlayerPedId(), animationDict, animationName, 1.0)
            ClearPedTasks(PlayerPedId())
        end
    end
end

Citizen.CreateThread(function()
    while true do
        DetectGearChange()
        Citizen.Wait(100)
    end
end)