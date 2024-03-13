--// HIDDEN CONFIG
bot = getBot()
bot.legit_mode = BotAnimationMove_nei
bot.move_interval = 200     -- min 75, max 1000 (default:150)
bot.move_range = MovementSpeed_nei

editMessage = true
autoDetect = true          -- auto detect farmable
itmSeed = ItemIdRotation_nei + 1         -- don't edit
root = false                -- set true if root farming 
ignoreGemsHarvest = false   -- enables / disables ignoring gems when harvest.
detectFloat = true          -- detect floating ItemIdRotation_nei after farm
changeColorSkin = true          -- set true if wanna change color skin bot
buyCloth = true                 -- set true if buy and wear clothes
editNoteProfile = false          -- edit note profile every store pack
pnbInTutorial = false                -- set true if want pnb in tutorial
whiteListOwner = "OWNER"            -- no ban whitelist name in world tutorial
restTime = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}        -- (only hours 0-23)
autoCleanFire = false                            -- set true if want auto fire farm (need fire hose)
storageFirehose = "WORLD"                            -- storage to take fire hose
doorFirehose = "ID"                               -- id door to enter world storage
customTile = false                  -- Set true if custom breaking pos for pnb in world
customX = 0                         -- Custom breaking pos x
customY = 0                         -- Custom breaking pos y
delayExecute = 2000         -- execute between bot delay
variationDelay = true       -- variation delay for DelayPunch_nei
breakVariationDelay = 10    -- if DelayPunch_nei 180 so variation will be 170-190

listChat = {'Its dangerous to go out at night these days','The new building in the city is gigantic.','A real news reporter must have integrity.',
'Its fun to doodle on the blackboard.','My uncles best friend will do the eulogy.','The new hotels location is sublime.',
'Teamwork makes dream work.','We bought a lot of marshmallows to roast tonight at camp.','I want to go for a picnic by myself.',
'Can you please ring my phone? I cant seem to find it.'}

emoteChat = {
    "/troll","/lol","/smile","/cry","/mad","/wave","/dance","/dab",
    "/love","/kiss","/sleep","/yes","/no","/wink","/cheer","/sad","/fp"
}
for i, botz in pairs(getBots()) do
    if botz.name:upper() == bot.name:upper() then
        indexBot = i
    end
    indexLast = i
end
bot.collect_range = 3
bot.auto_reconnect = true
bot.reconnect_interval = DelayReconnect_nei
bot.collect_interval = 500
bot.auto_leave_on_mod = true

world = ""
doorFarm = ""
worldPNB = ""
worldBreak = ""
doorBreak = ""
cray = ""
crays = ""
profit = 0
fossil = 0
profitSeed = 0
totalFarm = 0
totalTree = 0
readyTree = 0
unreadyTree = 0
list = {}
mode3Tile = {0,1,2}
tileBreak = {}
t = os.time()
waktu = {}
tree = {}
fossilz = {}
FarmFile_neiBot = {}
fileneikoescript = {}
fileneikoescript[indexBot] = {}
fired = false
nuked = false
startTime = os.time()

dividerSSeed = math.ceil(indexLast / #StorageSeed_nei)
storageSeed = StorageSeed_nei[math.ceil(indexBot / dividerSSeed)]

dividerSPack = math.ceil(indexLast / #StoragePack_nei)
storagePack = StoragePack_nei[math.ceil(indexBot / dividerSPack)]

dividerSPick = math.ceil(indexLast / #StoragePickaxe_nei)
worldPickaxe = StoragePickaxe_nei[math.ceil(indexBot / dividerSPick)]

for i = math.floor(BreakRow_nei/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end

for i = 0, math.ceil(BreakRow_nei/2) - 1 do
    table.insert(tileBreak,i)
end

function punch(x,y)
    return bot:hit(bot.x+x,bot.y+y)
end

function findItem(id)
    return bot:getInventory():findItem(id)
end

function place(id,x,y)
    return bot:place(bot.x+x,bot.y+y,id)
end

function tilePunch(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg ~= 0 or getTile(x - 1,y + num).bg ~= 0 then
            return true
        end
    end
    return false
end

function tilePlace(x,y)
    for _,num in pairs(tileBreak) do
        if getTile(x - 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then
            return true
        end
    end
    return false
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
    end
    return count
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function read(fileneikoescript)
    local fileName = fileneikoescript
    local file = io.open(fileName, "r")
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
        cray = lines[1]
        data = split(lines[1], ':')
        if tablelength(data) == 2 then
            neikoe1 = data[1]
            neikoe2 = data[2]
        end
        table.remove(lines, 1)
        file = io.open(fileName, "w")
        if file then
            for _, line in ipairs(lines) do
                file:write(line .. "\n")
            end
            file:write(cray)
            file:close()
        end
    end
    return neikoe1,neikoe2
end

local GetBot = function(bot)
    local status = getBot(bot).status
    local status_Naming = {
        [BotStatus.offline] = "Offline",
        [BotStatus.online] = "Online",
        [BotStatus.account_banned] = "Banned",
        [BotStatus.location_banned] = "Location Banned",
        [BotStatus.server_overload] = "Login Failed",
        [BotStatus.too_many_login] = "Login Failed",
        [BotStatus.maintenance] = "Maintenance",
        [BotStatus.version_update] = "Version Update",
        [BotStatus.server_busy] = "Server Busy",
        [BotStatus.error_connecting] = "Error Connecting",
        [BotStatus.logon_fail] = "Login Failed",
        [BotStatus.http_block] = "HTTP Blocked",
        [BotStatus.wrong_password] = "Wrong Password",
        [BotStatus.advanced_account_protection] = "Advanced Account Protection",
        [BotStatus.bad_name_length] = "Bad Name Length",
        [BotStatus.invalid_account] = "Invalid Account",
        [BotStatus.guest_limit] = "Guest Limit",
        [BotStatus.changing_subserver] = "Changing Subserver",
        [BotStatus.captcha_requested] = "Captcha",
        [BotStatus.mod_entered] = "Mod Entered",
        [BotStatus.high_load] = "High Load"
    }
    return status_Naming[status] or "offline"
end

function getUptime()
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local days = math.floor(elapsedTime / 86400)
    local hours = math.floor((elapsedTime % 86400) / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    return string.format("%dd %02dh %02dm", days, hours, minutes)
end

function waktuWorld()
    strWaktu = ""
    for _,worldzz in pairs(FarmFile_neiBot) do
        strWaktu = strWaktu.."\n||"..worldzz:upper().."|| ("..(waktu[worldzz] or "?").." | "..(tree[worldzz] or "?").." | "..(fossilz[worldzz] or "?").." )"
    end
    return strWaktu
end


function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function onVarSearchTutorial(variant, netid)
    if variant:get(0):getString() == "OnRequestWorldSelectMenu" then
        local text = variant:get(1):getString()
        local lines = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        for i, value in ipairs(lines) do
            if i == 3 then
                kalimat = lines[3]
                local nilai = kalimat:match("|([a-zA-Z0-9%s]+)|"):gsub("|", ""):gsub("%s", "")
                print(bot.name.." World PNB in "..nilai)
                worldPNB = nilai
            end
        end
    end
end

function tileDrop(x,y,num)
    local count = 0
    local stack = 0
    for _,obj in pairs(bot:getWorld():getObjects()) do
        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then
            count = count + obj.count
            stack = stack + 1
        end
    end
    if stack < 20 and count <= (4000 - num) then
        return true
    end
    return false
end

function getData()
    local data = {online = 0,offline = 0,gems = 0,bot = #getBots()}
    for _,client in pairs(getBots()) do
        if GetBot(client.name):lower() == 'online' then
            data.online = data.online + 1
        else
            data.offline = data.offline + 1
        end
        data.gems = data.gems + client.gem_count
    end
    return data
end

function callEvent(msg)
    local wh = Webhook.new(WebhookSecondURL_nei)
    wh.username = "NEIKOE SCRIPT - WEBHOOK"
    wh.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1215642885509357628/Picsart_24-03-08_19-50-17-259.jpg?ex=65fd7ea9&is=65eb09a9&hm=b262445cadf62cca361596edead1621771e140a05e09d2d4e4979e09ee298f6d&=&format=webp&width=570&height=570"
    wh.embed1.use = true
    wh.embed1.color = 15548997 
    wh.embed1.description = "".. msg
    wh:send()
end

function pingnei(msg)
    local wh = Webhook.new(WebhookSecondURL_nei)
    wh.username = "NEIKOE SCRIPT - WEBHOOK"
    wh.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1215642885509357628/Picsart_24-03-08_19-50-17-259.jpg?ex=65fd7ea9&is=65eb09a9&hm=b262445cadf62cca361596edead1621771e140a05e09d2d4e4979e09ee298f6d&=&format=webp&width=570&height=570"
    wh.content = "@everyone"
    wh.embed1.use = true
    wh.embed1.color = 15548997 
    wh.embed1.description = "".. msg
    wh:send()
end

function botEvents(info) -- ini yang aseli njir
    local nei_count = #getBots() 
    local nei_per_group = 48
    local nei_hook = {} 
    local nei_webhook_new = {} 
    local nei_current_time = os.time() - t

    for i = 1,nei_count,nei_per_group do
        local nei_group = {}
        for j = i, i + nei_per_group - 1 do
            if j <= nei_count then
                table.insert(nei_group,getBots()[j].name:upper())
            end
        end
        table.insert(nei_hook,nei_group)
    end

    for i,entry in ipairs(WebhookMainMSGId2_nei) do
        local nei_entry = { url = WebhookMainURL_nei,msg = entry,bot = {} }
        if nei_hook[i] then
            nei_entry.bot = nei_hook[i]
        end
        table.insert(nei_webhook_new,nei_entry)
    end

    for i,entry in ipairs(nei_webhook_new) do
        if #entry.bot > 0 then
            local nei_wh = Webhook.new(entry.url)
            local nei_username = "NEIKOE SCRIPT - WEBHOOK"
            local nei_avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1215642885509357628/Picsart_24-03-08_19-50-17-259.jpg?ex=65fd7ea9&is=65eb09a9&hm=b262445cadf62cca361596edead1621771e140a05e09d2d4e4979e09ee298f6d&=&format=webp&width=570&height=570"
            local total_bot = #entry.bot
            local nei_title = "BOT STATUS"
            local nei_thumbnail = "https://media.discordapp.net/attachments/1205088853099028480/1209099876642721813/Picsart_24-02-14_15-40-23-071.png?ex=65f82602&is=65e5b102&hm=8f2da9f341a0fb2831f2670c1e89fad2a7fa46830813262f2cfd30f981f9f88b&=&format=webp&quality=lossless&width=616&height=616"
            local nei_color = "16776960"
            local nei_date = "Neikoe Script | Rotation V1.9 \n" .. os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)
            local nei_description = "Updated <t:" .. os.time() .. ":R>"

            nei_wh.embed1.use = true
            nei_wh.username = nei_username
            nei_wh.avatar_url = nei_avatar_url
            nei_wh.embed1.title = nei_title
            nei_wh.embed1.thumbnail = nei_thumbnail
            nei_wh.embed1.footer.text = nei_date 
            nei_wh.embed1.description = nei_description
            nei_wh.embed1.color = nei_color


            if total_bot > 24 then total_bot = 24 end 
            for j = 1,total_bot do
                local status_bot = ':question:'
                if GetBot(getBots()[j].name):lower() == 'online' then status_bot = "<:dotgreennei:1206515388733718548>" else status_bot = "<:dotrnei:1214766079210033173>" end 
                local status_all = "Bot Status: " .. GetBot(getBots()[j].name) .. "" .. status_bot .. "\n" .. 
                    "Bot Level: " .. getBots()[j].level .. "\n" .. 
                    "Bot Gems: " .. getBots()[j].gem_count .. "\n" .. 
                    "World: ||" .. getBots()[j]:getWorld().name:upper() .. "|| [" .. getBots()[j].x .. "," .. getBots()[j].y .. "]"
                nei_wh.embed1:addField(
                    "[" .. j .. "] " .. entry.bot[j] .. "",status_all,false)
            end

            if #entry.bot > 24 then
                nei_wh.embed2.use = true 
                nei_wh.embed2.footer.text = nei_date 
                nei_wh.embed2.color = nei_color
                for j = 24,#entry.bot do
                    local status_bot = ':question:'
                    if GetBot(getBots()[j].name):lower() == 'online' then status_bot = "<:dotgreennei:1206515388733718548>" else status_bot = "<:dotrnei:1214766079210033173>" end 
                    local status_all = "Bot Status: " .. GetBot(getBots()[j].name) .. "" .. status_bot .. "\n" .. 
                    "Bot Level: " .. getBots()[j].level .. "\n" .. 
                    "Bot Gems: " .. getBots()[j].gem_count .. "\n" .. 
                    "World: ||" .. getBots()[j]:getWorld().name:upper() .. "|| [" .. getBots()[j].x .. "," .. getBots()[j].y .. "]"
                    nei_wh.embed2:addField(
                        "[" .. j .. "] " .. entry.bot[j] .. "" .. status_bot,status_all,false)
                end
            end
            if entry.msg == '' then 
                nei_wh:send()
            else
                nei_wh:edit(entry.msg) 
            end
            sleep(50)
        end
    end
end

function callWebhook()
    local mainWebhook = Webhook.new(WebhookMainURL_nei)
    mainWebhook.embed1.use = true
    mainWebhook.username = "NEIKOE SCRIPT - WEBHOOK"
    mainWebhook.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1215642885509357628/Picsart_24-03-08_19-50-17-259.jpg?ex=65fd7ea9&is=65eb09a9&hm=b262445cadf62cca361596edead1621771e140a05e09d2d4e4979e09ee298f6d&=&format=webp&width=570&height=570"
    mainWebhook.embed1.title = "BOT DETAILS"
    mainWebhook.embed1.thumbnail = "https://media.discordapp.net/attachments/1205088853099028480/1209099876642721813/Picsart_24-02-14_15-40-23-071.png?ex=65f82602&is=65e5b102&hm=8f2da9f341a0fb2831f2670c1e89fad2a7fa46830813262f2cfd30f981f9f88b&=&format=webp&quality=lossless&width=616&height=616"
    mainWebhook.embed1.color = 16776960
    mainWebhook.embed1.description = "Updated <t:".. os.time() ..":R>"
    
    botStatus = ""
    if GetBot(bot.status) == "Online" then
        botStatus = GetBot(bot.status).." <:dotgreennei:1206515388733718548>"
    else
        botStatus = GetBot(bot.status).." <:dotrnei:1214766079210033173>"
    end

    mainWebhook.embed1:addField( "<:botnei_2:1205836936296665108> ".. bot.name:upper() .." (".. bot.level ..")", "Bot Status: ".. botStatus .."\nBot Number: ".. indexBot .."\nCurrent World: ||".. bot:getWorld().name .."||", false)
    mainWebhook.embed1:addField("<:sspnei:1205840397130137610> Storage List","Pack Name: ".. StoreItemName_nei .."\nPack Profit: ".. profit .."\nSeed Profit: ".. profitSeed, false)
    mainWebhook.embed1:addField("<:dirttreenei:1205844729997037659> Farm Detect","Total Tree: ".. totalTree .."\nReady Tree: ".. readyTree .."\nUnready Tree: ".. unreadyTree .. "\nFossil Rock Found: ".. fossil, false)
    mainWebhook.embed1:addField("<:lucifernei:1205836619815583764> Script Access","Username: ".. Login_nei, false)
    mainWebhook.embed1:addField("<:megaphonenei:1205840144825982986> Script Runtime", getUptime(),false)
    mainWebhook.embed1.footer.text = "Neikoe Script | Rotation V1.9 \n" .. os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)
    if editMessage then
        mainWebhook:edit(WebhookMainMSGId1_nei)
    else
        mainWebhook:send()
    end
end

function buyClothes()
    currentClothes = {}
    for _,inventory in pairs(bot:getInventory():getItems()) do
        if getInfo(inventory.id).clothing_type ~= 0 then
            table.insert(currentClothes,inventory.id)
        end
    end
    sleep(100)
    jumlahClothes = #currentClothes
    if jumlahClothes < 5 then
        print(bot.name:upper().." buy and wearing cloth! ")
        sleep(100)
        callEvent(bot.name:upper().." | buy and wearing cloth! ")
        sleep(100)
        bot:sendPacket(2,"action|buy\nitem|rare_clothes")
        sleep(100)
        for _,num in pairs(bot:getInventory():getItems()) do
            if getInfo(num.id).clothing_type ~= 0 then
                if num.id ~= 3934 and num.id ~= 3932 then
                    bot:wear(num.id)
                    sleep(1000)
                end
            end
        end
    end
end

function OnVariantList(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():lower():find("inaccessible") then
            nuked = true
        end
    end
end

function warp(world,id)
    cok = 0
    nuked = false
    addEvent(Event.variantlist, OnVariantList)
    while not bot:isInWorld(world:upper()) and not nuked do
        if bot.status == BotStatus.online and bot:getPing() == 0 then
            bot:disconnect()
            sleep(1000)
        end
        while bot.status ~= BotStatus.online do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                sleep(8000)
            end
        end
        if id ~= "" then
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
        else
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
        end
        listenEvents(5)
        sleep(DelayWarp_nei)
        if cok == 5 then
            print(bot.name:upper().." hard warp! bot while offline for a while ")
            sleep(100)
            pingnei(bot.name:upper().." | hard warp! bot while offline for a while ")
            sleep(100)
            while bot.status == BotStatus.online do
                bot:disconnect()
                bot.auto_reconnect = false
                sleep(1000)
            end
            sleep(6 * 60000)
            cok = 0
            bot.auto_reconnect = true
        else
            cok = cok + 1
        end
    end
    if nuked then
        print(bot.name:upper().." can't go to "..world.." it's inaccessible! ")
        sleep(100)
        pingnei(bot.name:upper().." | can't go to "..world.." it's inaccessible! ")
        sleep(100)
    end
    if id ~= "" and getTile(bot.x,bot.y).fg == 6 and not nuked then
        if bot.status == BotStatus.online and bot:getPing() == 0 then
            bot:disconnect()
            sleep(1000)
        end
        while bot.status ~= BotStatus.online do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                sleep(8000)
            end
        end
        for i = 1,3 do
            if getTile(bot.x,bot.y).fg == 6 then
                bot:sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
                sleep(1000)
            end
        end
        if getTile(bot.x,bot.y).fg == 6 then
            print(bot.name:upper().." can't go to "..world.." maybe wrong id or hard warp! ")
            sleep(100)
            pingnei(bot.name:upper().." | can't go to "..world.." maybe wrong id or hard warp! ")
            sleep(100)
            nuked = true
        end
    end
    sleep(100)
    removeEvent(Event.variantlist)
end

function detect()
    local store = {}
    local count = 0
    for _,tile in pairs(getTiles()) do
        if tile:hasFlag(0) and tile.fg ~= 0 then
            if store[tile.fg] then
                store[tile.fg].count = store[tile.fg].count + 1
            else
                store[tile.fg] = {fg = tile.fg, count = 1}
            end
        end
    end
    for _,tile in pairs(store) do
        if tile.count > count and tile.fg % 2 ~= 0 then
            count = tile.count
            itmSeed = tile.fg
            ItemIdRotation_nei = itmSeed - 1
            print(bot.name:upper().." will find "..getInfo(ItemIdRotation_nei).name)
            sleep(100)
            callEvent(bot.name:upper().." | will find "..getInfo(ItemIdRotation_nei).name)
            sleep(100)
        end
    end
end

function packInfo(link,id,desc)
    local text = [[
        $webHookUrl = "]]..link..[[/messages/]]..id..[["
        $footerObject = @{
            text = " ]]..os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)..[["
        }
        $thumbnailObject = @{
            url = "https://media.discordapp.net/attachments/1205088853099028480/1209099876642721813/Picsart_24-02-14_15-40-23-071.png?ex=65f82602&is=65e5b102&hm=8f2da9f341a0fb2831f2670c1e89fad2a7fa46830813262f2cfd30f981f9f88b&=&format=webp&quality=lossless&width=616&height=616" 
        }
        $fieldArray = @(
            @{
                name = "<:worldnei:1212576766640660520> Storage World"
                value = "Name World: ||]]..bot:getWorld().name.."\n"..[[||**  ** ]].."\n"..[[<:botnei_2:1205836936296665108> **Bot Logs** ]].."\n"..[[Grow Id: ]]..bot.name.."\n"..[[Pack Name: ]]..StoreItemName_nei.."\n"..[[Pack Result: ]]..profit.."\n"..[[Seed Result: ]]..profitSeed.."\n"..[[**  ** ]].."\n"..[[<:growscannei:1212582948851687454> **Growscan World** ]]..desc.."\n"..[[ "
                inline = "false"
            }
        )
        $embedObject = @{
            title = "Pack Info | Rotation V1.9"
            color = "16756592"
            footer = $footerObject
            thumbnail = $thumbnailObject
            fields = $fieldArray
        }
        $embedArray = @($embedObject)
        $payload = @{
            embeds = $embedArray
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'
    ]]
    local file = io.popen("powershell -command -", "w")
    file:write(text)
    file:close()
end

function reconnect(world,id,x,y)
    nuked = false
    if bot.level >= StopScriptAtLvl_nei then
        print(bot.name:upper().." reach level u set and script stopped! ")
        sleep(100)
        pingnei(bot.name:upper().." | reach level u set and script stopped! ")
        sleep(100)
        bot:stopScript()
    end
    if RestBot_nei then
        currentRest = false
        local timeNow = os.date("*t")
        for _,i in pairs(restTime) do
            if i == timeNow.hour and timeNow.min == 0 then
                currentRest = true
            end
        end
        if currentRest then
            print(bot.name:upper().." resting! ")
            sleep(100)
            callEvent(bot.name:upper().." | resting! ")
            sleep(100)
            if RestBotDisconnect_nei then
                bot.auto_reconnect = false
                bot:disconnect()
                sleep(60000 * RestBotTime_nei)
                bot.auto_reconnect = true
            else
                goExit()
                sleep(60000 * RestBotTime_nei)
                if bot.status == BotStatus.online then
                    bot:disconnect()
                    sleep(1000)
                end
            end
        end
    end

    if bot.status ~= BotStatus.online or bot:getPing() == 0 then
        print(bot.name:upper().." cooldown 1mins for re-login ")
        sleep(100)
        callEvent(bot.name:upper().." | cooldown 1mins for re-login ")
        sleep(100)
        sleep(60000)
        print(bot.name:upper().." reconnecting ")
        sleep(100)
        callEvent(bot.name:upper().." | reconnecting ")
        sleep(100)
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                print(bot.name:upper().." has been banned! ")
                sleep(100)
                pingnei(bot.name:upper().." | has been banned! ")
                sleep(100)
                stopScript()
            end
        end
        if TakePickaxe_nei and bot:getInventory():findItem(98) == 0 and bot.status == BotStatus.online then
            TakePickaxe_neiaxe()
            sleep(100)
        end
        while bot:getWorld().name ~= world:upper() do
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."\ninvitedWorld|0")
            sleep(DelayWarp_nei)
            print(bot.name:upper().." has reconnected. Please check on your lucifer whether the bot is stuck or not. If the bot is stuck, please re-run the script ")
            sleep(100)
            callEvent(bot.name:upper().." | has reconnected. Please check on your lucifer whether the bot is stuck or not. If the bot is stuck, please re-run the script  ")
            sleep(100)
        end

        if nuked then
            print(bot.name:upper().." can't go to "..world.." it's inaccessible! ")
            sleep(100)
            pingnei(bot.name:upper().." | can't go to "..world.." it's inaccessible! ")
            sleep(100)
            removeEvent(Event.variantlist)
            sleep(100)
        end

        if id ~= "" and getTile(bot.x,bot.y).fg == 6 then
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
            sleep(2000)
        end
        if x and y and (bot.x ~= x or bot.y ~= y) then
            bot:findPath(x,y)
            sleep(100)
        end
        
    end
end

function reconnectHarvest(world,id)
    if bot.status ~= BotStatus.online or bot:getPing() == 0 then
        print(bot.name:upper().." reconnecting ")
        sleep(100)
        callEvent(bot.name:upper().." | reconnecting ")
        sleep(100)
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                print(bot.name:upper().." has been banned! ")
                sleep(100)
                pingnei(bot.name:upper().." | has been banned! ")
                sleep(100)
                stopScript()
            end
        end
        if TakePickaxe_nei and bot:getInventory():findItem(98) == 0 and bot.status == BotStatus.online then
            TakePickaxe_neiaxe()
            sleep(100)
        end
        while not bot:isInWorld(world:upper()) do
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
            sleep(DelayWarp_nei)
        end
        if id ~= "" and getTile(bot.x,bot.y).fg == 6 then
            bot:sendPacket(3,"action|join_request\nname|"..world:upper().."|"..id:upper().."\ninvitedWorld|0")
            sleep(1000)
        end
        
        
    end
end

function infoPack()
    local str = ""
    growscan = getBot():getWorld().growscan
    for id, count in pairs(growscan:getObjects()) do
        str = str.."\n"..getInfo(id).name..": x"..count
    end
    return str
end

function storeSeed(world)
    bot.auto_collect = false
    bot.collect_interval = 9999999
    sleep(100)
    warp(storageSeed,DoorSeed_nei)
    sleep(100)
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    if changeColorSkin then
        bot:setSkin(math.random(1,8))
        sleep(100)
    end
    print(bot.name:upper().." dropping seed at "..bot:getWorld().name:upper())
    sleep(100)
    callEvent(bot.name:upper().." | dropping seed at ||"..bot:getWorld().name:upper().."||")
    sleep(100)
    ba = bot:getInventory():findItem(itmSeed)
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == TileSeed_nei or tile.bg == TileSeed_nei then
            if tileDrop(tile.x,tile.y,100) then
                bot:findPath(tile.x - 1,tile.y)
                bot:setDirection(false)
                sleep(100)
                if bot:getInventory():findItem(itmSeed) > 100 then
                    bot:sendPacket(2,"action|drop\n|itemID|"..itmSeed)
                    sleep(500)
                    bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..itmSeed.."|\ncount|100")
                    sleep(500)
                    reconnect(storageSeed,DoorSeed_nei,tile.x - 1,tile.y)
                end
                if bot:getInventory():findItem(itmSeed) <= 100 then
                    break
                end
            end
        end
    end
    sleep(100)
    ba = ba - bot:getInventory():findItem(itmSeed)
    profitSeed = profitSeed + ba
    sleep(100)
    if SafetyWorld_nei then
        join()
    end
    warp(world,doorFarm)
    sleep(100)
    bot.auto_collect = true
    bot.collect_interval = 100
end

function clear()
    for _,item in pairs(AutoTrashList_nei) do
        if bot:getInventory():findItem(item) > 0 then
            bot:sendPacket(2,"action|trash\n|itemID|"..item)
            bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..item.."|\ncount|"..bot:getInventory():findItem(item)) 
            sleep(500)
        end
    end
end

function goExit()
    while bot:getWorld().name ~= "EXIT" do
        bot:sendPacket(3,"action|join_request\nname|EXIT\ninvitedWorld|0")
        sleep(2000)
    end
end

function checkTutorial()
    goExit()
    sleep(100)
    worldPNB = ""
    sleep(100)
    addEvent(Event.variantlist, onVarSearchTutorial)
    while worldPNB == "" and bot:getWorld().name == "EXIT" do
        bot:sendPacket(3,"action|world_button\nname|_16")
        listenEvents(5)
        sleep(2000)
    end
    sleep(100)
    removeEvent(Event.variantlist)
    sleep(100)
end

function pnbTutorial()
    warp(worldPNB,"")
    sleep(100)
    bot.ignore_gems = false
    if bot:getWorld().name == worldPNB and bot:getWorld():hasAccess(bot.x-1,bot.y) > 0 then
        if bot:getInventory():findItem(ItemIdRotation_nei) >= BreakRow_nei and bot:getWorld().name == worldPNB:upper() and bot:getWorld():hasAccess(bot.x-1,bot.y) > 0 then
            ex = bot.x
            ye = bot.y
            bot.auto_collect = true
            while bot:getInventory():findItem(ItemIdRotation_nei) > BreakRow_nei and bot:getInventory():findItem(itmSeed) <= 190 and bot:getWorld().name == worldPNB:upper() do
                while bot.x ~= ex and bot.y ~= ye do
                    findPath(ex,ye)
                end
                for i,player in pairs(bot:getWorld():getPlayers()) do
                    if player.netid ~= getLocal().netid and player.name:upper() ~= whiteListOwner:upper() then
                        bot:say("/ban " .. player.name)
                        sleep(1000)
                    end
                end
                while tilePlace(ex,ye) and bot:getWorld().name == worldPNB do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(ItemIdRotation_nei,-1,i)
                            sleep(DelayPlace_nei)
                            reconnect(worldPNB,"",ex,ye)
                        end
                    end
                end
                while tilePunch(ex,ye) and bot:getWorld().name == worldPNB do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            if variationDelay then
                                sleep(math.random(DelayPunch_nei - breakVariationDelay,DelayPunch_nei + breakVariationDelay))
                            else
                                sleep(DelayPunch_nei)
                            end
                            reconnect(worldPNB,"",ex,ye)
                        end
                    end
                end
            end
        end
    elseif bot:isInWorld() and bot:getWorld():hasAccess(bot.x-1,bot.y) == 0 then
        checkTutorial()
    end
end

function pnbOtherWorld()
    worldBreak,doorBreak = read(PnbFile_nei)
    sleep(100)
    warp(worldBreak,doorBreak)
    sleep(100)
    print(bot.name:upper().." doing pnb at "..bot:getWorld().name:upper())
    sleep(100)
    callEvent(bot.name:upper().." | doing pnb at ||"..bot:getWorld().name:upper().."||")
    sleep(100)
    botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
    sleep(100)
    callWebhook()
    sleep(100)
    bot.ignore_gems = false
    if not nuked and bot:isInWorld(worldBreak:upper()) then
        if bot:getInventory():findItem(ItemIdRotation_nei) >= BreakRow_nei and bot:getWorld().name == worldBreak:upper() then
            ex = bot.x
            ye = bot.y
            bot.auto_collect = true
            while bot:getInventory():findItem(ItemIdRotation_nei) > BreakRow_nei and bot:getInventory():findItem(itmSeed) <= 190 and bot.x == ex and bot.y == ye and bot:getWorld().name == worldBreak:upper() do
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(ItemIdRotation_nei,-1,i)
                            sleep(DelayPlace_nei)
                            reconnect(worldBreak,doorBreak,ex,ye)
                        end
                    end
                end
                while tilePunch(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            if variationDelay then
                                sleep(math.random(DelayPunch_nei - breakVariationDelay,DelayPunch_nei + breakVariationDelay))
                            else
                                sleep(DelayPunch_nei)
                            end
                            reconnect(worldBreak,doorBreak,ex,ye)
                        end
                    end
                end
            end
        end
    end
end

function pnb(world)
    if bot:isInWorld() then
        if AutoChat_nei then
            chatBot = listChat[math.random(1,#listChat)]
            bot:say(chatBot)
            sleep(1000)
            chatBot = emoteChat[math.random(1,#emoteChat)]
            bot:say(chatBot)
            sleep(1000)
        end
        if bot:getInventory():findItem(98) > 0 then
            bot:wear(98)
            sleep(100)
        end
        if changeColorSkin then
            bot:setSkin(math.random(1,8))
            sleep(100)
        end
    end
    if pnbInTutorial then
        pnbTutorial()
    elseif PNBAnotherworld_nei then
        pnbOtherWorld()
    else
        if bot:getInventory():findItem(ItemIdRotation_nei) >= BreakRow_nei and bot:getWorld().name == world:upper() then
            if not customTile then
                ex = 1
                ye = bot.y
                if ye > 40 then
                    ye = ye - 10
                elseif ye < 11 then
                    ye = ye + 10
                end
                if getTile(ex,ye).fg ~= 0 and getTile(ex,ye).fg ~= itmSeed then
                    ye = ye - 1
                end
            else
                ex = customX
                ye = customY
            end
            sleep(100)
            bot:findPath(ex,ye)
            sleep(100)
            print(bot.name:upper().." doing pnb at world farm")
            sleep(100)
            callEvent(bot.name:upper().." | doing pnb at world farm")
            sleep(100)
            botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
            sleep(100)
            callWebhook()
            sleep(100)
            bot.ignore_gems = false
            bot.auto_collect = true
            while bot:getInventory():findItem(ItemIdRotation_nei) > BreakRow_nei and bot:getInventory():findItem(itmSeed) <= 190 and bot.x == ex and bot.y == ye do
                while tilePlace(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then
                            place(ItemIdRotation_nei,-1,i)
                            sleep(DelayPlace_nei)
                            reconnect(world,doorFarm,ex,ye)
                        end
                    end
                end
                while tilePunch(ex,ye) do
                    for _,i in pairs(tileBreak) do
                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then
                            punch(-1,i)
                            if variationDelay then
                                sleep(math.random(DelayPunch_nei - breakVariationDelay,DelayPunch_nei + breakVariationDelay))
                            else
                                sleep(DelayPunch_nei)
                            end
                            reconnect(world,doorFarm,ex,ye)
                        end
                    end
                end
            end
        end
    end
    sleep(100)
    clear()
    sleep(100)
    if ignoreGemsHarvest then
        bot.ignore_gems = true
    end
    sleep(100)
    if buyCloth and bot.gem_count >= 1500 then
        while bot:getInventory().slotcount < 36 do
            bot:buy("upgrade_backpack")
            sleep(200)
        end
        buyClothes()
    end
    if bot.gem_count > StoreItemGems_nei then
        buyPack(world)
        sleep(100)
    end
    warp(world,doorFarm)
    sleep(100)
    if not SaveAllSeed_nei then
        plant(world)
    end
    sleep(100)
end

function buyPack(world)
    bot.auto_collect = false
    bot.collect_interval = 9999999
    sleep(100)
    while bot:getInventory().slotcount < 36 do
        bot:buy("upgrade_backpack")
        sleep(200)
    end
    while bot.gem_count > StoreItemPrice_nei do
        if bot.gem_count > StoreItemPrice_nei and bot:getInventory():findItem(StoreItemNumber_nei[1]) < 200 then
            bot:buy(StoreItemName_nei)
            print(bot.name:upper().." buying pack! ")
            sleep(100)
            callEvent(bot.name:upper().." | buying pack! ")
            sleep(100)
            profit = profit + 1
            sleep(1000)
            if bot:getInventory():findItem(StoreItemNumber_nei[1]) == 0 then
                bot:buy("upgrade_backpack")
                sleep(200)
            end
        else
            break
        end
        if bot:getInventory():findItem(StoreItemNumber_nei[1]) == 200 then
            break
        end
    end
    sleep(100)
    if editNoteProfile then
        netid = getLocal().netid
        bot:sendPacket(2,"action|wrench\n|netid|"..netid)
        sleep(1000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|notebook_edit")
        sleep(1000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|paginated_personal_notebook_view\npageNum|0|\nbuttonClicked|editPnPage")
        sleep(1000)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|paginated_personal_notebook_edit\npageNum|0|\nbuttonClicked|save\n\npersonal_note|Total Profit Pack : "..profit)
        sleep(1000)
    end
    sleep(100)
    warp(storagePack,DoorPack_nei)
    sleep(100)
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    if changeColorSkin then
        bot:setSkin(math.random(1,8))
        sleep(100)
    end
    if bot:getWorld().name == storagePack:upper() then
        print(bot.name:upper().." dropping pack at "..bot:getWorld().name:upper())
        sleep(100)
        callEvent(bot.name:upper().." | dropping pack at ||"..bot:getWorld().name:upper().."||")
        sleep(100)
        for _,pack in pairs(StoreItemNumber_nei) do
            for _,tile in pairs(bot:getWorld():getTiles()) do
                if tile.fg == TilePack_nei or tile.bg == TilePack_nei then
                    if tileDrop(tile.x,tile.y,bot:getInventory():findItem(pack)) then
                        bot:findPath(tile.x - 1,tile.y)
                        sleep(100)
                        bot:setDirection(false)
                        sleep(100)
                        reconnect(storagePack,DoorPack_nei,tile.x - 1,tile.y)
                        if bot:getInventory():findItem(pack) > 0 and tileDrop(tile.x,tile.y,bot:getInventory():findItem(pack)) then
                            bot:sendPacket(2,"action|drop\n|itemID|"..pack)
                            sleep(500)
                            bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|"..pack.."|\ncount|"..bot:getInventory():findItem(pack))
                            sleep(500)
                            reconnect(storagePack,DoorPack_nei,tile.x - 1,tile.y)
                        end
                    end
                end
                if bot:getInventory():findItem(pack) == 0 then
                    break
                end
            end
        end
    end
    sleep(100)
    if SafetyWorld_nei then
        join()
    end
    warp(world,doorFarm)
    sleep(100)
    bot.auto_collect = true
    bot.collect_interval = 100
    sleep(100)
end

function isPlantable(tile)
    local tempTile = getTile(tile.x, tile.y + 1)
    if not tempTile.fg then 
        return false 
    end
    local collision = getInfo(tempTile.fg).collision_type
    return tempTile and ( collision == 1 or collision == 2 )
end

function plant(world)
    print(bot.name:upper().." doing plant and harvest ")
    sleep(100)
    callEvent(bot.name:upper().." | doing plant and harvest ")
    sleep(100)
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    if changeColorSkin then
        bot:setSkin(math.random(3,6))
        sleep(100)
    end
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if getTile(tile.x,tile.y).fg == 0 and isPlantable(getTile(tile.x,tile.y)) and bot:getWorld():hasAccess(tile.x,tile.y) > 0 and bot:getInventory():findItem(itmSeed) > 0 and bot:getWorld().name == world:upper() then
            bot:findPath(tile.x,tile.y)
            for _, i in pairs(mode3Tile) do
                while getTile(tile.x + i,tile.y).fg == 0 and isPlantable(getTile(tile.x + i,tile.y)) and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot:getInventory():findItem(itmSeed) > 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                    place(itmSeed,i,0)
                    sleep(DelayPlant_nei)
                    reconnect(world,doorFarm,tile.x,tile.y - 1)
                end
            end
        end
    end
end

function TakePickaxe_neiaxe()
    bot.auto_collect = false
    sleep(100)
    warp(worldPickaxe,DoorPickaxe_nei)
    sleep(100)
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    print(bot.name:upper().." taking a pickaxe ")
    sleep(100)
    callEvent(bot.name:upper().." | taking a pickaxe ")
    sleep(100)
    while bot:getInventory():findItem(98) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == 98 then
                bot:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3)
                sleep(100)
            end
            if bot:getInventory():findItem(98) > 0 then
                break
            end
        end
        sleep(500)
    end
    bot:moveTo(-1,0)
    sleep(100)
    bot:setDirection(false)
    sleep(100)
    while bot:getInventory():findItem(98) > 1 do
        bot:sendPacket(2,"action|drop\n|itemID|98")
        sleep(500)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|98|\ncount|"..(bot:getInventory():findItem(98) - 1))
        sleep(500)
    end
    bot:wear(98)
    sleep(100)
    goExit()
    sleep(100)
    bot.auto_collect = true
end

function takeFirehose()
    bot.auto_collect = false
    sleep(100)
    warp(storageFirehose,doorFirehose)
    sleep(100)
    while bot:getInventory():findItem(3066) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == 3066 then
                bot:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3)
                sleep(100)
            end
            if bot:getInventory():findItem(3066) > 0 then
                break
            end
        end
        sleep(500)
    end
    bot:moveTo(-1,0)
    sleep(100)
    bot:setDirection(false)
    sleep(100)
    while bot:getInventory():findItem(3066) > 1 do
        bot:sendPacket(2,"action|drop\n|itemID|3066")
        sleep(500)
        bot:sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|3066|\ncount|"..(bot:getInventory():findItem(3066) - 1))
        sleep(500)
    end
    goExit()
    sleep(100)
    bot.auto_collect = true
end

function take(world)
    warp(storageSeed,DoorSeed_nei)
    sleep(100)
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    if changeColorSkin then
        bot:setSkin(math.random(1,8))
        sleep(100)
    end
    while bot:getInventory():findItem(itmSeed) == 0 do
        for _,obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == itmSeed then
                bot:findPath(round(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
                bot:collect(3)
                sleep(100)
                if bot:getInventory():findItem(itmSeed) > 0 then
                    break
                end
            end
        end
        print(bot.name:upper().." go to "..bot:getWorld().name:upper().." for take seed ")
        sleep(100)
        callEvent(bot.name:upper().." | go to ||"..bot:getWorld().name:upper().."|| for take seed ")
        sleep(100)
    end
    warp(world,doorFarm)
    sleep(100)
end

function harvest(world)
    print(bot.name:upper().." do harvesting at "..bot:getWorld().name:upper())
    sleep(100)
    callEvent(bot.name:upper().." | do harvesting at ||"..bot:getWorld().name:upper().."||")
    sleep(100)
    callWebhook()
    sleep(100)
    tiley = 0
    tree[world] = 0
    if ignoreGemsHarvest then
        bot.ignore_gems = true
    end
    if AutoChat_nei then
        chatBot = listChat[math.random(1,#listChat)]
        bot:say(chatBot)
        sleep(1000)
        chatBot = emoteChat[math.random(1,#emoteChat)]
        bot:say(chatBot)
        sleep(1000)
    end
    if changeColorSkin then
        bot:setSkin(math.random(2,7))
        sleep(100)
    end
    if bot.level < AmountLvlingOnly_nei and OnlyLvling_nei then
        for _,tile in pairs(bot:getWorld():getTiles()) do
            reconnectHarvest(world,doorFarm)
            if tile:canHarvest() and bot:isInWorld(world:upper()) and bot:getWorld():hasAccess(tile.x,tile.y) > 0 and bot.level < AmountLvlingOnly_nei and getBot().status == BotStatus.online then
                botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
                sleep(100)
                callWebhook()
                sleep(100)
                bot:findPath(tile.x,tile.y)
                if tiley ~= tile.y and indexBot then
                    tiley = tile.y
                    botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
                    sleep(100)
                    callWebhook()
                    sleep(100)
                end
                for _, i in pairs(mode3Tile) do
                    if getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 then
                        tree[world] = tree[world] + 1
                        while getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot.x == tile.x and bot.y == tile.y do
                            punch(i,0)
                            sleep(DelayHarvest_nei)
                            reconnect(world,doorFarm,tile.x,tile.y)
                        end
                    end
                end
                if root then
                    for _, i in pairs(mode3Tile) do
                        while getTile(tile.x + i, tile.y + 1).fg == (ItemIdRotation_nei + 4) and bot.x == tile.x and bot.y == tile.y do
                            punch(i, 1)
                            sleep(DelayHarvest_nei)
                            reconnect(world,doorFarm,tile.x,tile.y)
                        end
                    end
                end
                bot:collect(3)
            end
            if bot.level >= AmountLvlingOnly_nei then
                break
            end
        end
    end
    if bot.level >= AmountLvlingOnly_nei or not OnlyLvling_nei then
        if SaveAllSeed_nei then
            for _,tile in pairs(bot:getWorld():getTiles()) do
                reconnectHarvest(world,doorFarm)
                if tile:canHarvest() and bot:isInWorld(world:upper()) and bot:getWorld():hasAccess(tile.x,tile.y) > 0 then
                    botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
                    sleep(100)
                    callWebhook()
                    sleep(100)
                    bot:findPath(tile.x,tile.y)
                    if tiley ~= tile.y and indexBot then
                        tiley = tile.y
                        print(bot.name:upper().." will save seed, and not planting.")
                        sleep(100)
                        callEvent(bot.name:upper().." | will save seed, and not planting.")
                        sleep(100)
                        botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
                        sleep(100)
                        callWebhook()
                        sleep(100)
                    end
                    for _, i in pairs(mode3Tile) do
                        if getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot:getWorld().name == world:upper() then
                            tree[world] = tree[world] + 1
                            while getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                                punch(i,0)
                                sleep(DelayHarvest_nei)
                                reconnect(world,doorFarm,tile.x,tile.y)
                            end
                        end
                    end
                    if root then
                        for _, i in pairs(mode3Tile) do
                            while getTile(tile.x + i, tile.y + 1).fg == (ItemIdRotation_nei + 4) and bot.x == tile.x and bot.y == tile.y do
                                punch(i, 1)
                                sleep(DelayHarvest_nei)
                                reconnect(world,doorFarm,tile.x,tile.y)
                            end
                        end
                    end
                    bot:collect(3)
                end
                if findItem(ItemIdRotation_nei) >= 190 and bot:getWorld().name == world:upper() then
                    pnb(world)
                    sleep(100)
                    if findItem(itmSeed) > 190 then
                        storeSeed(world)
                        sleep(100)
                    end
                end
            end
        else
            for _,tile in pairs(bot:getWorld():getTiles()) do
                reconnectHarvest(world,doorFarm)
                if tile:canHarvest() and bot:isInWorld(world:upper()) and bot:getWorld():hasAccess(tile.x,tile.y) > 0 then
                    bot:findPath(tile.x,tile.y)
                    if tiley ~= tile.y and indexBot then
                        tiley = tile.y
                        botEvents(WebhookMainURL_nei,WebhookMainMSGId2_nei)
                        sleep(100)
                        callWebhook()
                        sleep(100)
                    end
                    for _, i in pairs(mode3Tile) do
                        if getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot:getWorld().name == world:upper() then
                            tree[world] = tree[world] + 1
                            while getTile(tile.x + i,tile.y).fg == itmSeed and getTile(tile.x + i,tile.y):canHarvest() and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                                punch(i,0)
                                sleep(DelayHarvest_nei)
                                reconnect(world,doorFarm,tile.x,tile.y)
                            end
                        end
                    end
                    if root then
                        for _, i in pairs(mode3Tile) do
                            while getTile(tile.x + i, tile.y + 1).fg == (ItemIdRotation_nei + 4) and bot.x == tile.x and bot.y == tile.y do
                                punch(i, 1)
                                sleep(DelayHarvest_nei)
                                reconnect(world,doorFarm,tile.x,tile.y)
                            end
                        end
                    end
                    for _, i in pairs(mode3Tile) do
                        while getTile(tile.x + i,tile.y).fg == 0 and isPlantable(getTile(tile.x + i,tile.y)) and findItem(itmSeed) > 0 and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                            place(itmSeed,i,0)
                            sleep(DelayPlant_nei)
                            reconnect(world,doorFarm,tile.x,tile.y)
                        end
                    end
                    bot:collect(3)
                end
                if bot:getInventory():findItem(ItemIdRotation_nei) >= 190 then
                    pnb(world)
                    sleep(100)
                    if bot:getInventory():findItem(itmSeed) > 150 then
                        storeSeed(world)
                        sleep(100)
                    end
                end
            end
        end
        if detectFloat then
            for _,obj in pairs(bot:getWorld():getObjects()) do
                if obj.id == ItemIdRotation_nei then
                    print(bot.name:upper().." detect float block at farm")
                    sleep(100)
                    callEvent(bot.name:upper().." | detect float block at farm")
                    sleep(100)
                    bot:findPath(round(obj.x / 32),math.floor(obj.y / 32))
                    sleep(100)
                    bot:collect(3)
                    sleep(100)
                end
                if bot:getInventory():findItem(ItemIdRotation_nei) >= 190 then
                    pnb(world)
                    sleep(100)
                    if bot:getInventory():findItem(itmSeed) > 150 then
                        storeSeed(world)
                        sleep(100)
                    end
                end
            end
        end
    end
    if FillPlant_nei then
        print(bot.name:upper().." fill planting at "..bot:getWorld().name:upper())
        sleep(100)
        callEvent(bot.name:upper().." | fill planting at ||"..bot:getWorld().name:upper().."||")
        sleep(100)
        for _,tile in pairs(bot:getWorld():getTiles()) do
            if bot:getInventory():findItem(itmSeed) == 0 then
                take(world)
                sleep(100)
            end
            if (tile.fg == 0 and tile.y ~= 0 and isPlantable(tile)) and bot:isInWorld(world:upper()) and bot:getWorld():hasAccess(tile.x,tile.y) > 0 then
                for _, i in pairs(mode3Tile) do
                    while getTile(tile.x + i,tile.y).fg == 0 and isPlantable(getTile(tile.x + i,tile.y)) and bot:getWorld():hasAccess(tile.x + i,tile.y) > 0 and bot:getInventory():findItem(itmSeed) > 0 and bot.x == tile.x and bot.y == tile.y and bot:getWorld().name == world:upper() do
                        place(itmSeed,i,0)
                        sleep(DelayPlant_nei)
                        reconnect(world,doorFarm,tile.x,tile.y)
                    end
                end
            end
        end
    end
end

function clearBlocks()
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if getTile(tile.x,tile.y).fg == ItemIdRotation_nei and bot.level >= AmountLvlingOnly_nei then
            bot:findPath(tile.x,tile.y)
            while getTile(tile.x,tile.y).fg == ItemIdRotation_nei and bot.x == tile.x and bot.y == tile.y do
                punch(0,0)
                sleep(DelayHarvest_nei)
                reconnect(world,doorFarm,tile.x,tile.y)
            end
        end
    end
end

function join()
    for _,wurld in pairs(SafetyListWorld_nei) do
        while bot:getWorld().name:upper() ~= wurld:upper() do
            if bot.status == BotStatus.online and bot:getPing() == 0 then
                bot:disconnect()
                sleep(1000)
            end
            while bot.status ~= BotStatus.online do
                sleep(1000)
                while bot.status == BotStatus.account_banned do
                    sleep(8000)
                end
            end
            bot:sendPacket(3,"action|join_request\nname|"..wurld:upper().."\ninvitedWorld|0")
            print(bot.name:upper().." go to "..bot:getWorld().name:upper().." to refresh history ")
            sleep(100)
            callEvent(bot.name:upper().." | go to ||"..bot:getWorld().name:upper().."|| to refresh history ")
            sleep(100)
            sleep(DelayWarp_nei)
        end
    end
end

function checkFire(world)
    totalTree = 0
    readyTree = 0
    unreadyTree = 0
    fossil = 0
    toxicwst = false
    for _,tile in pairs(bot:getWorld():getTiles()) do
        if tile:hasFlag(4096) then
            fired = true
        end
        if tile.fg == itmSeed then
            totalTree = readyTree + unreadyTree
            if tile:canHarvest() then
                readyTree = readyTree + 1
            end
        end
        if tile.fg == itmSeed then
            totalTree = readyTree + unreadyTree
            if not tile:canHarvest() then
                unreadyTree = unreadyTree + 1
            end
        end

        if tile.fg == 3918 then
            fossil = fossil + 1
        end
        if tile.fg == 778 then
            toxicwst = true
        end
    end
    fossilz[world] = fossil
end

--// LISENCE CONF
function getMachineGUID()
    local cmd = io.popen(
        'powershell -command "$MachineGUID = (Get-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Cryptography\").MachineGuid; $MachineGUID"')
    local machineGUID = cmd:read("*l")
    cmd:close()
    return machineGUID
end


function getMachineGUID()
    local cmd = io.popen('powershell -command "$MachineGUID = (Get-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Cryptography\").MachineGuid; $MachineGUID"')
    local machineGUID = cmd:read("*l")
    cmd:close()
    return machineGUID
end

function request(method, URL)
    local client = HttpClient.new()
    if method:upper() == "POST" then
        client.method = Method.post
    elseif method:upper() == "GET" then
        client.method = Method.get
    elseif method:upper() == "DELETE" then
        client.method = Method.delete
    elseif method:upper() == "PATCH" then
        client.method = Method.patch
    else
        return "Unknown method used"
    end

    client.url = URL
    response = client:request()
    return response.body
end

local jsonString = request("POST","http://game2.jagoanvps.cloud:5038/gt/loginlua?username="..Login_nei.."&password=1009&mac="..getMachineGUID())

local responsePattern = '"response":"(.-)"'
local messagePattern = '"message":"(.-)"'

local response = jsonString:match(responsePattern)
local message = jsonString:match(messagePattern)

if response and message then
    -- Print values
    print("Status: " .. response)
    print("Message: " .. message)
    callEvent("Neikoe script started!")

    if response == "Access approved" then
            while bot.status ~= BotStatus.online do
                print("Neikoe script started!")
                sleep(100)
                callEvent("Neikoe script started!")
                sleep(1000)
                while bot.status == BotStatus.account_banned do
                    print(bot.name:upper().." has been banned! ")
                    sleep(100)
                    pingnei(bot.name:upper().." | has been banned! ")
                    sleep(100)
                    bot:stopScript()
                end
            end

            for i = indexBot, 1, -1 do
                    sleep(delayExecute)
                    goExit()
            end

            while bot.status ~= BotStatus.online do
                sleep(1000)
                while bot.status == BotStatus.account_banned do
                    bot:stopScript()
                end
            end
--// END LISENCE

            if TakePickaxe_nei and bot:getInventory():findItem(98) == 0 then
                TakePickaxe_neiaxe()
                sleep(100)
            end

            if pnbInTutorial then
                checkTutorial()
                sleep(100)
            end

            while true do
                nuked = false
                fired = false
                toxicwst = false
                world,doorFarm = read(FarmFile_nei)
                if #FarmFile_neiBot == 10 then
                    FarmFile_neiBot = {}
                    waktu = {}
                    tree = {}
                end
                table.insert(FarmFile_neiBot,world)
                warp(world,doorFarm)
                sleep(100)
                totalFarm = totalFarm + 1
                if not nuked then
                    checkFire(world)
                    if not fired or autoCleanFire then
                        tt = os.time()
                        sleep(100)
                        if toxicwst then
                            
                            bot.anti_toxic = true
                            while true do 
                                cntToxic = 0
                                for _,tile in pairs(bot:getWorld():getTiles()) do
                                    if tile.fg == 778 then
                                        cntToxic = cntToxic + 1
                                        sleep(1000)
                                    end
                                end
                                if cntToxic == 0 then
                                    bot.anti_toxic = false
                                    break
                                end
                            end
                        end
                        if fired then
                            if bot:getInventory():findItem(3066) == 0 then
                                takeFirehose()
                                sleep(100)
                            end
                            
                            sleep(100)
                            bot.anti_fire = true
                            sleep(100)
                            while bot:getInventory():getItem(3066).isActive and bot:getInventory():findItem(3066) >= 1 do
                                sleep(1000)
                            end
                        end
                        sleep(100)
                        if autoDetect then
                            detect()
                        end
                        sleep(100)
                        clearBlocks()
                        sleep(100)
                        harvest(world)
                        sleep(100)
                        tt = os.time() - tt
                        sleep(100)
                        waktu[world] = math.floor(tt/3600).." Hours "..math.floor(tt%3600/60).." Minutes"
                        sleep(100)
                        print(bot.name:upper().." farm finish!")
                        sleep(100)
                        callEvent(bot.name:upper().." | farm finish!")
                        sleep(100)
                        if SafetyWorld_nei and tt > 60 then
                            join()
                        end
                    else
                        waktu[world] = "FIRED"
                        tree[world] = "FIRED"
                        
                        fired = false
                    end
                else
                    waktu[world] = "NUKED"
                    tree[world] = "NUKED"
                    sleep(100)
                    nuked = false
                    fired = false
                    sleep(5000)
                    if SafetyWorld_nei then
                        join()
                    end
                end
                if StopRotationAfterFarm_nei ~= 0 then
                    if totalFarm >= StopRotationAfterFarm_nei then
                        print(bot.name:upper().." stopped rotation!")
                        sleep(100)
                        callEvent(bot.name:upper().." | stopped rotation!")
                        sleep(100)
                        removeBot()
                        bot:stopScript()
                    end
                end
            end
    else
        messageBox = MessageBox.new()
        messageBox.title = "Neikoe Script"
        messageBox.description = "Login is not identified!\nPlease check the registered username\n\nScript by https://discord.gg/neikoe"
        messageBox:send()
        print("Login is not identified!")
        sleep(100)
    end
end
