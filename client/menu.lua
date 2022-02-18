local jobMenu = RageUI.CreateMenu("Job Center", "Menu Job")
local openJobsSubMenu = RageUI.CreateSubMenu(jobMenu, "Job Center", "Menu Job")
local closeJobsSubMenu = RageUI.CreateSubMenu(jobMenu, "Job Center", "Menu Job")

local applyMenu = RageUI.CreateMenu("Job Center", "Menu Job")

local isOpen = false
jobMenu.Closed = function()
    isOpen = false
    RageUI.Visible(jobMenu, false)
end

local isOpen2 = false
applyMenu.Closed = function()
    isOpen2 = false
    RageUI.Visible(applyMenu, false)
end

function OpenJobCenterMenu()
    if isOpen then
        isOpen = false
        RageUI.Visible(jobMenu, false)
    else
        isOpen = true
        RageUI.Visible(jobMenu, true)
        Citizen.CreateThread(function()
            while isOpen do
                Wait(1)
                RageUI.IsVisible(jobMenu, function()

                    RageUI.Button("Sans-Candidature", "Pour avoir un emploi sans candidature", {}, true, {}, openJobsSubMenu)

                    RageUI.Button("Candidature", "Pour avoir un emploi avec candidature", {}, true, {}, closeJobsSubMenu)
                    
                end)

                RageUI.IsVisible(openJobsSubMenu, function()
                    for k, v in pairs(Config.OpenJobs) do
                        RageUI.Button(v.Label, v.Description, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("jobCenter:job", v.JobName, v.JobGrade)
                                Notifications("Vous avez postulé comme "..v.Label)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(closeJobsSubMenu, function()
                    for k, v in pairs(Config.CloseJobs) do
                        RageUI.Button(v.Label, v.Description, {}, true, {
                            onSelected = function()
                                local chosejob = v.Label
                                local choseweb = v.JobWebhook
                                ApplyMenu(chosejob, choseweb)
                            end
                        })
                    end

                end)
            end
        end)
    end
end

function ApplyMenu(Job, Webhook)
    if isOpen2 then
        isOpen2 = false
        RageUI.Visible(applyMenu, false)
    else
        isOpen2 = true
        RageUI.Visible(applyMenu, true)
        Citizen.CreateThread(function()
            while isOpen2 do
                Wait(1)
                RageUI.IsVisible(applyMenu, function()
                    RageUI.Button("Prénom + Nom", description, {}, true, {
                        onSelected = function()
                            rpname = KeyBoardInput('Prénom + Nom', '', 100, false)
                        end
                    })
                    RageUI.Button("Date de naissance", description, {}, true, {
                        onSelected = function()
                            rpdate = KeyBoardInput('Date de naissance', '', 100, false)
                        end
                    })
                    RageUI.Button("Pourquoi vous ?", description, {}, true, {
                        onSelected = function()
                            rpdescription = KeyBoardInput('Pourquoi vous ?', '', 1000, false)
                        end
                    })
                    RageUI.Button("Envoyer votre demande", description, {}, true, {
                        onSelected = function()
                            print("Informations : "..rpname.." - "..rpdate.."\nPourquoi vous ? : "..rpdescription)
                            local text = "Informations : "..rpname.." - "..rpdate.."\nPourquoi vous ? : "..rpdescription
                            TriggerServerEvent("jobCenter:send", Job, text, Webhook)
                            Notifications("Vous avez postulé comme "..Job)
                            RageUI.CloseAll()
                        end
                    })
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local pCoords = GetEntityCoords(PlayerPedId())
        if #(pCoords - Config.Pos) < 1.5 then
            Help('~b~Appuyez sur E pour accéder au pole emploi')
            if IsControlJustReleased(0, 38) then
                OpenJobCenterMenu()
            end
        elseif #(pCoords - Config.Pos) < 7.0 then
            DrawMarker(21, Config.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 20, 147, 220, 0, 1, 2, 0, nil, nil, 0)
        end
    end
end)

if Config.ShowBlip then

    Citizen.CreateThread(function()
        local

        blips = AddBlipForCoord(Config.Pos)
        SetBlipSprite(blips, 351)
        SetBlipDisplay(blips, 4)
        SetBlipScale(blips, 1.0)
        SetBlipColour(blips, 5)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pole Emploi")
        EndTextCommandSetBlipName(blips)        
    end)

end

if Config.Ped then

    Citizen.CreateThread(function()
        local hash = GetHashKey("ig_bankman")
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        ped = CreatePed("PED_TYPE_CIVFEMALE", "ig_bankman", Config.PedPos, 196.44, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end)

end