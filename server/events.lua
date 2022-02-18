
ESX = nil

TriggerEvent(Config.ESX, function(obj) ESX = obj end)

RegisterNetEvent("jobCenter:job")
AddEventHandler("jobCenter:job", function(job, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setJob(job, grade)
end)

RegisterNetEvent("jobCenter:send")
AddEventHandler("jobCenter:send", function(Job, text, WebhookJob)
    local Content = {
        {
            ["color"] = 16711746,
            ["title"] = "Message JobCenter - "..Job,
            ["description"] = text
        }
    }
    PerformHttpRequest(Config.WebhookStaff, function(err, text, headers) end, "POST", json.encode({embeds = Content}), { ["Content-Type"] = "application/json" })
    PerformHttpRequest(WebhookJob, function(err, text, headers) end, "POST", json.encode({embeds = Content}), { ["Content-Type"] = "application/json" })
end)