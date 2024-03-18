-- HIDDEN CONFIG
ModeFastMove_nei = false  -- bot will do 5 movementspeed [default:false]
leveling = false -- Bot will do factory first until X level
untilLevel = 16
levelingItemIdRotation_nei = 54
levelingWorlds = {"WORLD:DOORID"} -- Can use DF
levelingStorages = {"WORLD:DOORID"} -- Storage for Taking & Dropping Seeds
-- Other Settings
delayOnExecute = 5000
VariationDelay = true -- Variation delay from DelayPunch_nei-10 until DelayPunch_nei+10
pickaxeID = 98
autoCleanFire = false -- Auto Clean fire in Farm World
firehoseStorage = "WORLD" -- For Taking Firehose
firehoseDoorID = "DOORID"
terminateOption = 2 -- 1=Remove Bot, 2=Stop Script, 3=Disconnect when Finish
moveInterval = 235
ignoreGems = false -- Ignore Gems Harvest
collectFloat = true -- Do Rotation from Floating Blocks
autoSpreadWorld = false
autoBuyClothes = true
randomSkinColor = true
AutoChat_neiList = {
    "Its dangerous to go out at night these days",
    "The new building in the city is gigantic.",
    "A real news reporter must have integrity.",
    "Its fun to doodle on the blackboard.",
    "My uncles best friend will do the eulogy.",
    "The new hotels location is sublime.",
    "Teamwork makes dream work.",
    "We bought a lot of marshmallows to roast tonight at camp.",
    "I want to go for a picnic by myself.",
    "Can you please ring my phone? I cant seem to find it."
}
autoCreatePnbWorld = false -- Bot will create pnb World locked with Small Lock
putJammer = false
jammerStorageWorld = "WORLD"
jammerStorageDoorID = "DOORID"
saveSeedCount = 50 -- Seed in BP Before Saving to the Storage

bot = getBot()
bot.auto_reconnect = true
bot.reconnect_interval = DelayReconnect_nei
bot.move_range = MovementSpeed_nei
bot.move_interval = moveInterval
bot.legit_mode = BotAnimationMove_nei
bot.ignore_gems = ignoreGems
bot.object_collect_delay = 150
bot.collect_interval = 100
bot.collect_range = 3
bot.auto_leave_on_mod = true

for i, botz in pairs(getBots()) do
    if botz.name:upper() == bot.name:upper() then
        indexBot = i
    end
    indexLast = i
end

AutoChat_neiRest = {"Can you please ring my phone? I cant seem to find it.", "I want to go for a picnic by myself.", "We bought a lot of marshmallows to roast tonight at camp.", "My uncles best friend will do the eulogy."}
randomEmoteRest = {"/sleep", "/love", "/cheer", "/smile", "/wave"}
emoteChat = {"/troll","/lol","/smile","/cry","/mad","/wave","/dance","/dab","/love","/kiss","/sleep","/yes","/no","/wink","/cheer","/sad","/fp"}

mode3Tile = {0,1,2}
mode3Tile2 = {0,-1,-2}
tileBreak = {}
worldNuked = false
levelingSeedID = levelingItemIdRotation_nei+1
worldTutor = ""
wrenchP = false
posTutorX, posTutorY = 50, 23
tutorNuked = false
noTutorWorld = false

profitPack = 0
profitSeed = 0
fossil = 0
editNoteProfile = true
waktu = {}
treez = {}
fossils = {}
farmWorlds = {}
farmWorlds[indexBot] = {}
worldList = {}
seedID = ItemIdRotation_nei+1
jammerStorageWorld = jammerStorageWorld:upper()
otherWorldNuked = false
ownWorldNuked = false
RestBotInterval_nei = RestBotInterval_nei*60
sleep(delayOnExecute*(indexBot-1))

startPlaytime = bot:getPlaytime()
startTime = os.time()

if autoCreatePnbWorld and BreakRow_nei > 3 then
    BreakRow_nei = 3
end

for i = math.floor(BreakRow_nei/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end

for i = 0, math.ceil(BreakRow_nei/2) - 1 do
    table.insert(tileBreak,i)
end

function read(filename)
    local farmWorlds = {}
    local file = io.open(filename, "r")
    if file then
        for line in file:lines() do
            table.insert(farmWorlds, line)
        end
        file:close()
    else
        print("Gagal membuka file ".. filename)
        bot:stopScript()
    end
    
    return farmWorlds
end

worldList = read(FarmFile_nei)
if PNBAnotherWorld_nei then
    pnbWorldList = read(PNBFile_nei)
    sleep(500)
    dividerPnb = math.ceil(indexLast / #pnbWorldList)
    pnbOtherWorldz = string.upper(pnbWorldList[math.ceil(indexBot / dividerPnb)])
    pnbOtherWorld, pnbWorldDoorID = pnbOtherWorldz:match("([^|]+):([^|]+)")
    -- print(bot.name:upper().." | Pnb Other World: "..pnbOtherWorld, pnbWorldDoorID)
    
end
sleep(500)

if autoSpreadWorld then
    for i = indexBot, #worldList, indexLast do
        table.insert(farmWorlds[indexBot], worldList[i])
    end
else
    for _, worldz in pairs(worldList) do
        table.insert(farmWorlds[indexBot], worldz)
    end
end

print(bot.name:upper().." | World List: ")
for _, asu in pairs(farmWorlds[indexBot]) do
    print(asu)
end

dividerSPickaxe = math.ceil(indexLast / #StoragePickaxe_nei)
storagePickaxez = string.upper(StoragePickaxe_nei[math.ceil(indexBot / dividerSPickaxe)])
storagePickaxe, storagePickaxeDoorID = storagePickaxez:match("([^|]+):([^|]+)")

dividerSSeed = math.ceil(indexLast / #StorageSeed_nei)
storageSeedz = string.upper(StorageSeed_nei[math.ceil(indexBot / dividerSSeed)])
storageSeed, storageSeedDoorID = storageSeedz:match("([^|]+):([^|]+)")

dividerSPack = math.ceil(indexLast / #StoragePack_nei)
storagePackz = string.upper(StoragePack_nei[math.ceil(indexBot / dividerSPack)])
storagePack, storagePackDoorID = storagePackz:match("([^|]+):([^|]+)")

dividerLeveling = math.ceil(indexLast / #levelingWorlds)
levelingWorldz = string.upper(levelingWorlds[math.ceil(indexBot / dividerLeveling)])
levelingWorld, levelingDoorID = levelingWorldz:match("([^|]+):([^|]+)")

divLvlStorage = math.ceil(indexLast / #levelingStorages)
levelingStoragez = string.upper(levelingStorages[math.ceil(indexBot / divLvlStorage)])
levelingStorage, levelingStorageID = levelingStoragez:match("([^|]+):([^|]+)")

dividerMID = math.ceil(indexLast / #WebhookMainMSGIdBot_nei)
messageID = string.upper(WebhookMainMSGIdBot_nei[math.ceil(indexBot / dividerMID)])

function callWebhook()
    local mainWebhook = Webhook.new(WebhookMainURL_nei)
    mainWebhook.embed1.use = true
    mainWebhook.username = "NEIKOE SCRIPT - WEBHOOK"
    mainWebhook.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1218366001670783046/SAVE_20240316_075840.jpg?ex=660766c2&is=65f4f1c2&hm=f43be191dce1e9d2fcb3366dd2bcc1b17f5f5cd36613d7082883db3c3c02031c&=&format=webp&width=570&height=570"
    mainWebhook.embed1.title = "BOT STATUS"
    mainWebhook.embed1.thumbnail = "https://media.discordapp.net/attachments/1205088853099028480/1218370866287480965/Picsart_24-03-16_08-30-12-099.png?ex=66076b4a&is=65f4f64a&hm=652015504cd2daca84509c8ee3bf929c87ae77107775ef566e00cda94ac4eb23&=&format=webp&quality=lossless&width=570&height=570"
    mainWebhook.embed1.color = 16776960
    mainWebhook.embed1.description = ""
    
    botStatus = ""
    if getBotStatus(bot.status) == "Online" then
        botStatus = getBotStatus(bot.status).."<:dotgreennei:1206515388733718548>"
    else
        botStatus = getBotStatus(bot.status).."<:dotrnei:1214766079210033173>"
    end
    
    mainWebhook.embed1:addField("<:lucifernei:1205836619815583764> Access Lisence","Username: ||".. Login_nei .."||", false)
    mainWebhook.embed1:addField("<:botnei_2:1205836936296665108> ".. bot.name:upper() .." (".. bot.level ..")", "Status: ".. botStatus .."\nNumber: ".. indexBot .. "\nGems: ".. bot.gem_count, true)
    mainWebhook.embed1:addField("<:sspnei:1205840397130137610> Storage List", "Pack Result: ".. profitPack .."\nSeed Result: ".. profitSeed,false)
    mainWebhook.embed1:addField("<:dirttreenei:1205844729997037659> Farm Detect (".. getWorldIndex().. "/".. #farmWorlds[indexBot] ..")", getWorldList(), false)
    mainWebhook.embed1:addField("<:buildernei:1205836792067006545> Runtime Script", "<t:".. os.time() ..":R> **|** ".. getUptime(),false)
    mainWebhook.embed1.footer.text = "Neikoe Script | Rotation V2.0 \n" .. os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)
    if WebhookEditSetting_nei then
        mainWebhook:edit(messageID)
    else
        mainWebhook:send()
    end
end

function growscanwh(desc)
    local growscanwh = Webhook.new(WebhookMainURL_nei)
    growscanwh.embed1.use = true
    growscanwh.username = "NEIKOE SCRIPT - WEBHOOK"
    growscanwh.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1218366001670783046/SAVE_20240316_075840.jpg?ex=660766c2&is=65f4f1c2&hm=f43be191dce1e9d2fcb3366dd2bcc1b17f5f5cd36613d7082883db3c3c02031c&=&format=webp&width=570&height=570"
    growscanwh.embed1.title = "BOT DETAILS"
    growscanwh.embed1.thumbnail = "https://media.discordapp.net/attachments/1205088853099028480/1218370866287480965/Picsart_24-03-16_08-30-12-099.png?ex=66076b4a&is=65f4f64a&hm=652015504cd2daca84509c8ee3bf929c87ae77107775ef566e00cda94ac4eb23&=&format=webp&quality=lossless&width=570&height=570"
    growscanwh.embed1.color = 16776960
    growscanwh.embed1.description = ""
    
    growscanwh.embed1:addField("<:worldnei:1212576766640660520> World Storage", "Current World: **||".. bot:getWorld().name .."||**", false)
    growscanwh.embed1:addField("<:sspnei:1205840397130137610> Result Bot","Pack Name: ".. StoreItemName_nei .."\nPack Profit: ".. profitPack .."\nSeed Profit: ".. profitSeed, false)
    growscanwh.embed1:addField("<:growscannei:1212582948851687454> Growscan Float", desc, false)
    growscanwh.embed1:addField("<:doornei:1205840679536820265> Last Dropped ", "<t:".. os.time() ..":R> **|** " .. bot.name:upper() .." (".. bot.level ..")", false)
    growscanwh.embed1.footer.text = "Neikoe Script | Rotation V2.0 \n" .. os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)
    if WebhookEditSetting_nei then
        growscanwh:edit(WebhookMainMSGIdGrowscan_nei)
    else
        growscanwh:send()
    end
end

function callEvent(msg)
    local mainEvent = Webhook.new(WebhookSecondURL_nei)
    mainEvent.embed1.use = true
    mainEvent.username = "NEIKOE SCRIPT - WEBHOOK"
    mainEvent.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1218366001670783046/SAVE_20240316_075840.jpg?ex=660766c2&is=65f4f1c2&hm=f43be191dce1e9d2fcb3366dd2bcc1b17f5f5cd36613d7082883db3c3c02031c&=&format=webp&width=570&height=570"
    mainEvent.embed1.color = 15548997
    mainEvent.embed1.description = "Bot **".. bot.name:upper().."** | ".. msg
    mainEvent:send()
end

function callAlert(msg)
    local mainEvent = Webhook.new(WebhookSecondURL_nei)
    mainEvent.content = "@everyone"
    mainEvent.embed1.use = true
    mainEvent.username = "NEIKOE SCRIPT - WEBHOOK"
    mainEvent.avatar_url = "https://media.discordapp.net/attachments/1205088853099028480/1218366001670783046/SAVE_20240316_075840.jpg?ex=660766c2&is=65f4f1c2&hm=f43be191dce1e9d2fcb3366dd2bcc1b17f5f5cd36613d7082883db3c3c02031c&=&format=webp&width=570&height=570"
    mainEvent.embed1.color = 15548997
    mainEvent.embed1.description = "Bot **".. bot.name:upper().."** | ".. msg
    mainEvent:send()
end

function getUptime()
    local elapsedTime = os.time() - startTime
    return string.format("%dd %02dh %02dm", math.floor(elapsedTime / 86400), math.floor((elapsedTime % 86400) / 3600), math.floor((elapsedTime % 3600) / 60))
end

function getWorldList()
    local desc = ""
    local str = ""
    for _, worldz in pairs(farmWorlds[indexBot]) do
        local farmWorldz, farmDoorIDz = string.match(worldz, "([^|]+):([^|]+)")
        farmWorldz = farmWorldz:upper()
        if farmWorldz == farmWorld:upper() then
            desc = desc .. "\n**||".. farmWorldz .."||** **|** " .. (waktu[farmWorldz] or "<a:processingnei_1:1218366932743618570>") .. " **|** ".. (treez[farmWorldz] or "<a:processingnei_1:1218366932743618570>")
        elseif waktu[farmWorldz] then
            desc = desc .. "\n**||".. farmWorldz .."||** **|** " .. (waktu[farmWorldz] or "<a:processingnei_1:1218366932743618570>") .. " **|** ".. (treez[farmWorldz] or "<a:processingnei_1:1218366932743618570>")
        end
    end
    return desc
end

function getWorldIndex()
    for i, worldz in pairs(farmWorlds[indexBot]) do
        farmIndexx, farmDoorIDxx = string.match(worldz, "([^|]+):([^|]+)")
        if farmIndexx:upper() == farmWorld:upper() then
            return i
        end
    end
    return "0"
end

function scanTreeY()
    treeY = {}
    for _, tile in pairs(getTiles()) do
        if tile.fg == seedID and tile:canHarvest() and hasAccess(tile.x, tile.y) > 0 then
            if not indexOf(treeY, tile.y) then
                table.insert(treeY, tile.y)
            end
        end
    end
end

function scanEmptyY()
    emptyTileY = {}
    for _, tile in pairs(getTiles()) do
        if tile.fg == 0 and isPlantable(tile.x,tile.y) and hasAccess(tile.x, tile.y) > 0 then
            if not indexOf(emptyTileY, tile.y) then
                table.insert(emptyTileY, tile.y)
            end
        end
    end
end

function findItem(id)
    return bot:getInventory():findItem(id)
end

function gscanFloat(id)
    return bot:getWorld().growscan:getObjects()[id] or 0
end

function gscanBlock(id)
    return bot:getWorld().growscan:getTiles()[id] or 0
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function getBotStatus(status)
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

function checkNuked(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():find("That world is inaccessible") then
            worldNuked = true
        end
    end
end

function warps(worldName, doorID)
    worldNuked = false
    warpAttempt = 0
    addEvent(Event.variantlist, checkNuked)
    while bot:getWorld().name:upper() ~= worldName:upper() and not worldNuked do
        print(bot.name:upper().." | warp to "..worldName)
        if bot.status == BotStatus.online and bot:getPing() == 0 then
            bot:disconnect()
            sleep(2000)
        end

        while bot.status ~= BotStatus.online do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                sleep(8000)
            end
        end

        if doorID ~= "" then
            bot:warp(worldName, doorID)
        else
            bot:warp(worldName)
        end

        listenEvents(7)

        if warpAttempt == 5 then
            warpAttempt = 0
            callAlert("got hard warp! Bot will rest for "..RestTimeWhenHardWarp.." mins")
            sleep(RestTimeWhenHardWarp * 60000)
            callEvent("reconnect from hardwarp rest!")
            if bot:getWorld().name:upper() ~= worldName:upper() then
                bot:disconnect()
                sleep(1000)
                while bot.status ~= BotStatus.online do
                    sleep(1000)
                end
            end
        else
            warpAttempt = warpAttempt + 1
        end
    end

    if worldNuked then
        print(worldName, "is nuked")
        callAlert(worldName.." is nuked!")
    end
    
    if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                print("Account has been banned")
                callAlert("Account has been banned")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end
        for i = 1,3 do
            if getTile(bot.x,bot.y).fg == 6 then
                bot:warp(worldName, doorID)
                sleep(2000)
            end
        end
        if getTile(bot.x,bot.y).fg == 6 then
            print("Bot can't entered to ".. worldName)
            callAlert("can't entered to "..worldName..", door id "..doorID)
            sleep(100)
            worldNuked = true
        end
    end
    sleep(100)
    removeEvent(Event.variantlist)
end

function shouldRest()
    if (bot:getPlaytime() - startPlaytime) >= RestBotInterval_nei then
        return true
    end
    return false
end

function reconnect(worldName, doorID, posX, posY)
    if RestBot_nei and shouldRest() then
        print(bot.name:upper().." | resting!")
        callAlert("resting!")
        if RestBotDisconnect_nei then
            bot.auto_reconnect = false
            bot:disconnect()
            sleep(RestBotTime_nei*60000)
            bot.auto_reconnect = true
            while bot.status ~= BotStatus.online do
                sleep(1000)
            end
        else
            while bot:isInWorld() do
                bot:leaveWorld()
                sleep(3000)
            end
            sleep(RestBotTime_nei*60000)
        end
        callAlert("reconnecting from resting!")

        startPlaytime = bot:getPlaytime()

        warpingBackAttempt = 0
        while not bot:isInWorld(worldName:upper()) do
            print(bot.name:upper().." | go back to "..worldName)

            bot:warp(worldName)
            sleep(DelayWarp_nei)
            if warpingBackAttempt == 5 then
                print(bot.name:upper().." | can't re-login! Bot got hardwarp and will resting again.")
                callAlert("can't re-login! Bot got hardwarp and will resting again.")
                sleep(RestTimeWhenHardWarp * 60000)
            else
                warpingBackAttempt = warpingBackAttempt + 1
            end
        end
        if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
            print(bot.name:upper().." | warping")
            bot:warp(worldName, doorID)
            sleep(3000)
        end
        if posX and posY and not bot:isInTile(posX, posY) then
            sleep(300)
            bot:findPath(posX, posY)
            sleep(200)
        end
        
    end
    
    if bot.level >= StopScriptAtLvl_nei then
        bot:stopScript()
    end

    if bot.status ~= BotStatus.online then
        print(bot.name:upper().." | reconnecting")
        callEvent("reconnecting")
        callWebhook()
        sleep(100)
        while bot.status ~= BotStatus.online do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                print(bot.name:upper() .. " | has been banned")
                callAlert("has been banned")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end

        while bot:isInTutorial() do
            sleep(1000)
        end
        
        warpingBackAttempt = 0
        while not bot:isInWorld(worldName:upper()) do
            print(bot.name:upper().." | go back to "..worldName)
            bot:warp(worldName)
            sleep(DelayWarp_nei)
            if warpingBackAttempt == 5 then
                print(bot.name:upper().." | can't re-login! Bot got hardwarp and will resting again.")
                callAlert("can't re-login! Bot got hardwarp and will resting again.")
                sleep(RestTimeWhenHardWarp * 60000)
            else
                warpingBackAttempt = warpingBackAttempt + 1
            end
        end
        if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
            print(bot.name:upper().." | warping")
            bot:warp(worldName, doorID)
            sleep(3000)
        end
        if posX and posY and not bot:isInTile(posX, posY) then
            sleep(300)
            bot:findPath(posX, posY)
            sleep(200)
        end
    end

    while bot:isInTutorial() do
        sleep(1000)
    end
    
end

function buyClothes()
    currentClothes = {}
    for _, inventory in pairs(bot:getInventory():getItems()) do
        if getInfo(inventory.id).clothing_type ~= 0 then
            table.insert(currentClothes, inventory.id)
        end
    end
    sleep(100)
    while bot:getInventory().slotcount < 36 do
        bot:buy("upgrade_backpack")
        sleep(700)
    end
    sleep(100)
    jumlahClothes = #currentClothes
    if jumlahClothes < 5 then
        bot:sendPacket(2,"action|buy\nitem|rare_clothes")
        sleep(500)
        for _, num in pairs(bot:getInventory():getItems()) do
            if getInfo(num.id).clothing_type ~= 0 then
                if num.id ~= 3934 and num.id ~= 3932 then
                    bot:wear(num.id)
                    sleep(1000)
                end
            end
        end
    end
end

function readyTreeScan(idSeed)
    local readyTree = 0
    for _, tile in pairs(getTiles()) do
        if tile.fg == idSeed and tile:canHarvest() and hasAccess(tile.x, tile.y) > 0 then
            readyTree = readyTree + 1
        end
    end
    return readyTree
end

function harvest(worldz, doorz, seedz)
    local harvestY = 0
    local blockz = seedz - 1
    warps(worldz, doorz)
    if not worldNuked and bot:isInWorld(worldz:upper()) then
        callEvent("do harvesting at "..worldz:upper())
        bot.auto_collect = true
        bot.collect_interval = 150
        bot.ignore_gems = ignoreGems

        for _, tile in pairs(getTiles()) do
            reconnect(worldz, doorz)
            if tile.fg == seedz and tile:canHarvest() and hasAccess(tile.x, tile.y) > 0 and findItem(blockz) < 190 and bot.status == BotStatus.online and not botIsInY(tile.y) then
                
                if ModeFastMove_nei then
                    if #bot:getPath(tile.x, tile.y) > 5 then
                        bot:findPath(tile.x, tile.y)
                    else
                        bot:moveTile(tile.x, tile.y)
                        sleep(50)
                    end
                else
                    bot:findPath(tile.x, tile.y)
                end

                if harvestY ~= tile.y then
                    harvestY = tile.y
                end

                if bot:isInTile(tile.x, tile.y) then
                    for _, i in pairs(mode3Tile) do
                        while getTile(bot.x+i, bot.y).fg == seedz and hasAccess(bot.x+i, bot.y) > 0 and getTile(bot.x+i, bot.y):canHarvest() and bot:isInTile(tile.x, tile.y) and bot.status == BotStatus.online do
                            bot:hit(bot.x+i, bot.y)
                            sleep(DelayHarverst_nei)
                            while bot.status == BotStatus.online and (bot:getPing() > 300 or bot:getPing()) == 0 do
                                sleep(1000)
                            end
                            reconnect(worldz, doorz, tile.x, tile.y)
                        end
                    end
                end
                
            end
        end
        
    end
end

function isPlantable(x,y)
    local tempTile = getTile(x,y + 1)
    if not tempTile.fg then return false end
    local collision = getInfo(tempTile.fg).collision_type
    return tempTile and ( collision == 1 or collision == 2 or collision == 4)
end

function plant(worldz, doorz, seedz)
    warps(worldz, doorz)
    if not worldNuked and bot:isInWorld(worldz:upper()) then
        callEvent("do planting at "..worldz:upper())
        for _, tile in pairs(getTiles()) do
            reconnect(worldz, doorz)
            if tile.fg == 0 and isPlantable(tile.x, tile.y) and hasAccess(tile.x, tile.y) > 0 and findItem(seedz) > 0 and bot.status == BotStatus.online and not botIsInY(tile.y) then
                
                if ModeFastMove_nei then
                    if #bot:getPath(tile.x, tile.y) > 5 then
                        bot:findPath(tile.x, tile.y)
                    else
                        bot:moveTile(tile.x, tile.y)
                        sleep(50)
                    end
                else
                    bot:findPath(tile.x, tile.y)
                end

                if bot:isInTile(tile.x, tile.y) then
                    for _, i in pairs(mode3Tile) do
                        while getTile(bot.x+i, bot.y).fg == 0 and hasAccess(bot.x+i, bot.y) and isPlantable(bot.x+i, bot.y) and bot:isInTile(tile.x, tile.y) and bot.status == BotStatus.online and findItem(seedz) > 0 do
                            bot:place(bot.x+i, bot.y, seedz)
                            sleep(DelayPlant_nei)
                            while bot.status == BotStatus.online and (bot:getPing() > 300 or bot:getPing()) == 0 do
                                sleep(1000)
                            end
                            reconnect(worldz, doorz, tile.x, tile.y)
                        end
                    end
                end
                
            end
        end
    end
end

function checkTrash()
    for _, trash in pairs(AutoTrashList_nei) do
        if findItem(trash) > 0 then
            return true
        end
    end
    return false
end

function checkGoods()
    for _, good in pairs(WhiteListItem_nei) do
        if findItem(good) > 50 then
            return true
        end
    end
    return false
end

function dropGoods()
    for _, good in pairs(WhiteListItem_nei) do
        if findItem(good) > 150 then
            dropItem(good, storagePack, storagePackDoorID)
            sleep(200)
        end
    end
end

function trashJunk()
    for _, trash in pairs(AutoTrashList_nei) do
        if findItem(trash) > 100 then
            bot:trash(trash, findItem(trash))
            sleep(1500)
        end
    end
end

function dropItem(itemID, worldName, doorID)
    bot.auto_collect = false
    bot.collect_interval = 99999
    
    warps(worldName, doorID)
    if not worldNuked then
        if bot:isInWorld(worldName:upper()) then
            print(bot.name:upper().." | dropping item at "..worldName:upper())
            callEvent("dropping item at "..worldName:upper())
            growscanwh(infoPack())
            
            if itemID == seedID then
                profitSeed = profitSeed + findItem(seedID)
            end

            ye = bot.y
            for _, tile in pairs(getTiles()) do
                reconnect(worldName, doorID)
                if tile.y == ye and tile.x > bot.x and tile.x <= 99 then
                    if tileDrop(tile.x, tile.y, findItem(itemID)) then
                        bot:findPath(tile.x-1, tile.y)
                        bot:setDirection(false)
                        sleep(100)
                        bot:fastDrop(itemID, findItem(itemID))
                        sleep(500)
                        reconnect(worldName, doorID, tile.x, tile.y)
                    end
                end
                if findItem(itemID) == 0 then
                    break
                end
            end
            callWebhook()
            sleep(100)
        end
    end
end

function takePickaxe()
    bot.auto_collect = false
    bot.collect_interval = 100
    warps(storagePickaxe, storagePickaxeDoorID)
    if not worldNuked then
        if bot:isInWorld(storagePickaxe:upper()) then
            print(bot.name:upper().." | take pickaxe at "..bot:getWorld().name)
            callEvent("take pickaxe at "..bot:getWorld().name)
            
            for _, obj in pairs(getObjects()) do
                if obj.id == pickaxeID then
                    bot:findPath(round(obj.x/32), math.floor(obj.y/32))
                    sleep(100)
                    bot:collectObject(obj.oid, 4)
                    sleep(500)
                    reconnect(storagePickaxe, storagePickaxeDoorID)
                end
                if findItem(pickaxeID) > 0 then
                    break
                end
            end
            
            while findItem(pickaxeID) > 1 do
                bot:moveRight()
                sleep(100)
                bot:setDirection(true)
                sleep(50)
                bot:drop(pickaxeID, findItem(pickaxeID)-1)
                sleep(500)
                reconnect(storagePickaxe, storagePickaxeDoorID)
            end

            if findItem(pickaxeID) > 0 and not bot:getInventory():getItem(pickaxeID).isActive then
                bot:wear(pickaxeID)
                sleep(100)
            end

        end
    end
end

function takeFirehose()
    firehoseID = 3066
    bot.auto_collect = false
    bot.collect_interval = 100
    warps(firehoseStorage, firehoseDoorID)
    if not worldNuked and bot:isInWorld(firehoseStorage:upper()) then
        print(bot.name:upper().." | take firehose at "..bot:getWorld().name)
        callEvent("take firehose at "..bot:getWorld().name)
        
        for _, obj in pairs(getObjects()) do
            if obj.id == firehoseID then
                bot:findPath(round(obj.x/32), math.floor(obj.y/32))
                sleep(100)
                bot:collectObject(obj.oid, 4)
                sleep(500)
                reconnect(firehoseStorage, firehoseDoorID)
            end
            if findItem(firehoseID) > 0 then
                break
            end
        end
        
        while findItem(firehoseID) > 1 do
            bot:moveRight()
            sleep(100)
            bot:setDirection(true)
            sleep(50)
            bot:drop(firehoseID, findItem(firehoseID)-1)
            sleep(500)
            reconnect(firehoseStorage, firehoseDoorID)
        end

        if findItem(firehoseID) > 0 and not bot:getInventory():getItem(firehoseID).isActive then
            bot:wear(firehoseID)
            sleep(100)
        end
    end
end

function PNB()
    warps(farmWorld, farmDoorID)
    if not worldNuked and bot:isInWorld(farmWorld:upper()) then
        print(bot.name:upper().." | doing pnb at world farm")
        callWebhook()
        sleep(100)
        callEvent("doing pnb at world farm")

        if AutoChat_nei then
            bot:say(tostring(AutoChat_neiList[math.random(1, #AutoChat_neiList)]))
            sleep(1000)
            bot:say(tostring(emoteChat[math.random(1, #emoteChat)]))
            sleep(1000)
        end

        if randomSkinColor then
            bot:setSkin(math.random(2,7))
            sleep(100)
        end
        
        if findItem(98) > 0 and not bot:getInventory():getItem(98).isActive then
            bot:wear(98)
            sleep(200)
        end
        
        bot.auto_collect = true
        bot.ignore_gems = false
        
        if getTile(bot.x, bot.y).fg == 6 then
            bot:warp(farmWorld, farmDoorID)
            sleep(2000)
        end

        pnbY = bot.y
        sleep(100)
        pnbY = (pnbY == 1) and (pnbY + 2) or (pnbY == 53) and (pnbY - 2) or pnbY
        pnbX = (bot.x > 50) and 98 or 1

        if getTile(pnbX, pnbY).fg ~= 0 and getTile(pnbX, pnbY).fg ~= seedID then
            pnbY = pnbY - 1
        end

        if #bot:getPath(pnbX, pnbY) > 0 and not bot:isInTile(pnbX, pnbY) then
            bot:findPath(pnbX, pnbY)
            sleep(200)
        end

        if bot:isInTile(pnbX, pnbY) then
            while findItem(ItemIdRotation_nei) > 0 and bot:isInWorld(farmWorld:upper()) and findItem(seedID) < 199 and bot.x == pnbX and bot.y == pnbY do
                if pnbX < 50 then
                    for _, i in pairs(tileBreak) do
                        if getTile(bot.x-1, bot.y+i).fg == 0 and getTile(bot.x-1, bot.y+i).bg == 0 and getTile(bot.x, bot.y).fg ~= 6 then
                            bot:place(bot.x-1, bot.y+i, ItemIdRotation_nei)
                            sleep(DelayPlace_nei)
                            reconnect(farmWorld, farmDoorID, pnbX, pnbY)
                        end
                    end
                    
                    for _, i in pairs(tileBreak) do
                        while getTile(bot.x-1, bot.y+i).fg ~= 0 or getTile(bot.x-1, bot.y+i).bg ~= 0 and getTile(bot.x, bot.y).fg ~= 6 do
                            bot:hit(bot.x-1, bot.y+i)
                            if VariationDelay then
                                sleep(math.random(DelayPunch_nei-10, DelayPunch_nei+10))
                            else
                                sleep(DelayPunch_nei)
                            end
                            reconnect(farmWorld, farmDoorID, pnbX, pnbY)
                        end
                    end
                    
                else
                    for _, i in pairs(tileBreak) do
                        if getTile(bot.x+1, bot.y+i).fg == 0 and getTile(bot.x+1, bot.y+i).bg == 0 and getTile(bot.x, bot.y).fg ~= 6 then
                            bot:place(bot.x+1, bot.y+i, ItemIdRotation_nei)
                            sleep(DelayPlace_nei)
                            reconnect(farmWorld, farmDoorID, pnbX, pnbY)
                        end
                    end

                    for _, i in pairs(tileBreak) do
                        while getTile(bot.x+1, bot.y+i).fg ~= 0 or getTile(bot.x+1, bot.y+i).bg ~= 0 and getTile(bot.x, bot.y).fg ~= 6 do
                            bot:hit(bot.x+1, bot.y+i)
                            if VariationDelay then
                                sleep(math.random(DelayPunch_nei-10, DelayPunch_nei+10))
                            else
                                sleep(DelayPunch_nei)
                            end
                            reconnect(farmWorld, farmDoorID, pnbX, pnbY)
                        end
                    end
                    
                end
            end
        end

    end
end

function checkWrench(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("my_worlds") then
        wrenchP = true
        unlistenEvents()
    end
end

function checkMyWorld(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("add_button") then
        teks = varlist:get(1):getString()
        worldTutor = string.match(teks, "add_button|([^|]+)|")
        sleep(100)
        unlistenEvents()
    end
end

function checkTutorial()
    worldTutor = ""
    if not bot:isInWorld() then
        warps(farmWorld, "")
    end
    if bot:isInWorld() then
        netidd = getLocal().netid
        addEvent(Event.variantlist, checkWrench)
        bot:wrenchPlayer(netidd)
        listenEvents(5)
        if wrenchP then
            addEvent(Event.variantlist, checkMyWorld)
            bot:sendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|".. netidd .."|\nbuttonClicked|my_worlds")
            listenEvents(5)
        end
        removeEvent(Event.variantlist)
    end
end

function PNBTutorial(seedz)
    local blockz = seedz-1
    warps(worldTutor, "")
    if not worldNuked and bot:isInWorld(worldTutor:upper()) then
        print(bot.name:upper().." | doing pnb at "..bot:getWorld().name)
        callWebhook()
        sleep(100)
        callEvent("doing pnb at "..bot:getWorld().name)

        if AutoChat_nei then
            bot:say(tostring(AutoChat_neiList[math.random(1, #AutoChat_neiList)]))
            sleep(1000)
            bot:say(tostring(emoteChat[math.random(1, #emoteChat)]))
            sleep(1000)
        end

        if randomSkinColor then
            bot:setSkin(math.random(2,7))   
            sleep(100)
        end

        if not bot:isInTile(posTutorX, posTutorY) then
            bot:findPath(posTutorX, posTutorY)
            sleep(200)
        end

        if findItem(98) > 0 and not bot:getInventory():getItem(98).isActive then
            bot:wear(98)
            sleep(100)
        end

        bot.auto_collect = true
        bot.object_collect_delay = 100
        bot.ignore_gems = false
        
        while findItem(blockz) > 0 and findItem(seedz) < 196 and bot:isInWorld(worldTutor:upper()) and getTile(bot.x, bot.y).fg ~= 6 do
            
            if math.random() < 0.03 and AutoChat_nei then
                bot:say(tostring(AutoChat_neiRest[math.random(1, #AutoChat_neiRest)]))
                sleep(300)
                bot:say(tostring(randomEmoteRest[math.random(1, #randomEmoteRest)]))
                sleep(500)
                bot:moveRight()
                sleep(1000)
                bot:findPath(bot.x-4, bot.y)
                bot:say("/sleep")
                sleep(3000)
                bot:findPath(posTutorX, posTutorY)
                sleep(200)
            end
            
            for i,player in pairs(getPlayers()) do
                if player.netid ~= getLocal().netid and player.name:upper() ~= WhiteListOwner_nei:upper() then
                    bot:say("/ban " .. player.name)
                    sleep(1000)
                end
            end
            
            for _,i in pairs(tileBreak) do
                if getTile(posTutorX + i, posTutorY - 1).fg == 0 and getTile(posTutorX + i, posTutorY - 1).bg == 0 and bot:isInTile(posTutorX, posTutorY) and findItem(blockz) > 0 then
                    bot:place(bot.x + i, bot.y - 1, blockz)
                    sleep(DelayPlace_nei)
                    reconnect(worldTutor, "", posTutorX, posTutorY)
                end
            end
            
            for _,i in pairs(tileBreak) do
                while getTile(posTutorX + i, posTutorY - 1).fg ~= 0 or getTile(posTutorX + i, posTutorY - 1).bg ~= 0 and bot:isInTile(posTutorX, posTutorY) and bot.status == BotStatus.online and getTile(bot.x, bot.y).fg ~= 6 do
                    bot:hit(bot.x + i, bot.y - 1)
                    if VariationDelay then
                        sleep(math.random(DelayPunch_nei - 10,DelayPunch_nei + 10))
                    else
                        sleep(DelayPunch_nei)
                    end
                    reconnect(worldTutor, "", posTutorX, posTutorY)
                end
            end

        end
    elseif worldNuked then
        fileName = "WORLD"..bot.name:upper()..".txt"
        deleteFile(fileName)
        sleep(100)
        createPnb()
        tutorNuked = true
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

function buyPacks()
    print(bot.name:upper().." | buying pack!")
    callEvent("buying pack!")
    
    bot.auto_collect = false
    bot.collect_interval = 99999

    while bot:getInventory().slotcount < 36 do
        bot:buy("upgrade_backpack")
        sleep(1000)
        reconnect(farmWorld, farmDoorID)
    end

    while bot.gem_count > StoreItemPrice_nei do
        if bot.gem_count > StoreItemPrice_nei and bot:getInventory():findItem(StoreItemNumber_nei[1]) < 200 then
            bot:buy(StoreItemName_nei)
            profitPack = profitPack + 1
            sleep(1000)
            if bot:getInventory():findItem(StoreItemNumber_nei[1]) == 0 then
                bot:buy("upgrade_backpack")
                sleep(1000)
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
        bot:sendPacket(2,"action|dialog_return\ndialog_name|paginated_personal_notebook_edit\npageNum|0|\nbuttonClicked|save\n\npersonal_note|Total Profit Pack : "..profitPack)
        sleep(1000)
    end
    sleep(100)

    warps(storagePack, storagePackDoorID)
    if not worldNuked and bot:isInWorld(storagePack:upper()) then
        callEvent("dropping pack")
        growscanwh(infoPack())
        for _, pack in pairs(StoreItemNumber_nei) do
            for _, tile in pairs(getTiles()) do
                if tile.x > bot.x and tile.y == bot.y and tile.x <= 99 then
                    if tileDrop(tile.x, tile.y, findItem(pack)) then
                        bot:findPath(tile.x-1, tile.y)
                        sleep(100)
                        bot:setDirection(false)
                        sleep(100)
                        reconnect(storagePack, storagePackDoorID, tile.x-1, tile.y)
                        if findItem(pack) > 0 and tileDrop(tile.x, tile.y, findItem(pack)) then
                            bot:findPath(tile.x-1, tile.y)
                            sleep(100)
                            bot:fastDrop(pack, findItem(pack))
                            sleep(500)
                            reconnect(storagePack, storagePackDoorID, tile.x-1, tile.y)
                        end
                    end
                    if findItem(pack) == 0 then
                        break
                    end
                end
            end
        end
    end
    sleep(100)

    if SafetyWorld_nei then
        joinRandom()
    end
    callWebhook()
    sleep(100)
    bot.collect_interval = 100
end

function playerIsInTile(x,y)
    for _, player in pairs(getPlayers()) do
        if not player.isLocalPlayer then
            if math.floor(player.posx/32) == x and math.floor(player.posy/32) == y then
                return true
            end
        end
    end
    return false
end

function otherWorldPnb()
    local pnbOtherX, pnbOtherY = 1, 1
    warps(pnbOtherWorld, pnbWorldDoorID)
    if not worldNuked and bot:isInWorld(pnbOtherWorld:upper()) then
        print(bot.name:upper().." | doing pnb at "..bot:getWorld().name)
        callWebhook()
        sleep(100)
        callEvent("doing pnb at "..bot:getWorld().name)

        for ex = PNBPos_nei.x, 97, PNBDistance_nei do
            if not playerIsInTile(ex, PNBPos_nei.y) and #bot:getPath(ex, PNBPos_nei.y) > 0 and getTile(ex, PNBPos_nei.y).fg ~= 6 then
                bot:findPath(ex, PNBPos_nei.y)
                if bot:isInTile(ex, PNBPos_nei.y) then
                    pnbOtherX, pnbOtherY = bot.x, bot.y
                    break
                end
            end
        end
        sleep(100)

        if pnbOtherX == 1 and pnbOtherY == 1 then
            callAlert("your pnb world is full! Change position or distance.")
            bot:stopScript()
        end
        
        if bot:isInTile(pnbOtherX, pnbOtherY) then
            if AutoChat_nei then
                bot:say(tostring(AutoChat_neiList[math.random(1, #AutoChat_neiList)]))
                sleep(1000)
                bot:say(tostring(emoteChat[math.random(1, #emoteChat)]))
                sleep(1000)
            end

            if randomSkinColor then
                bot:setSkin(math.random(2,7))   
                sleep(100)
            end

            if findItem(98) > 0 and not bot:getInventory():getItem(98).isActive then
                bot:wear(98)
                sleep(100)
            end

            bot.auto_collect = true
            bot.object_collect_delay = 100
            bot.ignore_gems = false

            while findItem(ItemIdRotation_nei) > 0 and findItem(seedID) ~= 200 and bot:isInWorld(pnbOtherWorld:upper()) and getTile(bot.x, bot.y).fg ~= 6 and bot:isInTile(pnbOtherX, pnbOtherY) do
            
                if math.random() < 0.03 and AutoChat_nei then
                    bot:say(tostring(AutoChat_neiRest[math.random(1, #AutoChat_neiRest)]))
                    sleep(500)
                    bot:say(tostring(randomEmoteRest[math.random(1, #randomEmoteRest)]))
                    sleep(500)

                    for ex = PNBPos_nei.x, 97, PNBDistance_nei do
                        if not playerIsInTile(ex, PNBPos_nei.y) then
                            bot:findPath(ex, PNBPos_nei.y)
                            if bot:isInTile(ex, PNBPos_nei.y) then
                                pnbOtherX, pnbOtherY = bot.x, bot.y
                                break
                            end
                        end
                    end
                    sleep(100)
                    
                end
                
                for _,i in pairs(tileBreak) do
                    if getTile(pnbOtherX + i, pnbOtherY - 1).fg == 0 and getTile(pnbOtherX + i, pnbOtherY - 1).bg == 0 and bot:isInTile(pnbOtherX, pnbOtherY) and findItem(ItemIdRotation_nei) > 0 then
                        bot:place(bot.x + i, bot.y - 1, ItemIdRotation_nei)
                        sleep(DelayPlace_nei)
                        reconnect(pnbOtherWorld, pnbWorldDoorID, pnbOtherX, pnbOtherY)
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    while getTile(pnbOtherX + i, pnbOtherY - 1).fg ~= 0 or getTile(pnbOtherX + i, pnbOtherY - 1).bg ~= 0 and bot:isInTile(pnbOtherX, pnbOtherY) and getTile(bot.x, bot.y).fg ~= 6 do
                        bot:hit(bot.x + i, bot.y - 1)
                        if VariationDelay then
                            sleep(math.random(DelayPunch_nei - 10,DelayPunch_nei + 10))
                        else
                            sleep(DelayPunch_nei)
                        end
                        reconnect(pnbOtherWorld, pnbWorldDoorID, pnbOtherX, pnbOtherY)
                    end
                end

            end
        end
    elseif worldNuked then
        fileName = "WORLD"..bot.name:upper()..".txt"
        deleteFile(fileName)
        sleep(100)
        createPnb()
        otherWorldNuked = true
    end
end

function joinRandom()
    print(bot.name:upper().." | join random world for safety farm")
    callEvent("join random world for safety farm")

    for _, worldz in pairs(SafetyListWorld_nei) do
        local tai = worldz:upper()
        warps(tai,"")
        if not worldNuked and bot:isInWorld(tai:upper()) then
            if #bot:getPath(bot.x+1, bot.y) > 0 then
                bot:moveRight()
                sleep(200)
            end
            if #bot:getPath(bot.x-2, bot.y) > 0 then
                bot:moveLeft(2)
                sleep(200)
            end
            bot:say(tostring(AutoChat_neiList[math.random(1, #AutoChat_neiList)]))
            sleep(1000)
            bot:say(tostring(emoteChat[math.random(1, #emoteChat)]))
            sleep(1000)
        end
    end
end

function generateRandomChar(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for _ = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randomIndex, randomIndex)
    end

    return result
end

function saveToFile(value, filename)
    local file = io.open(filename, "w")
    if file then
        file:write(value)
        file:close()
    else
        print("Gagal membuka file pnb")
    end
end

function deleteFile(filename)
    local success, err = os.remove(filename)

    if success then
        print("Berhasil menghapus file")
    else
        print("Gagal menghapus file " .. err)
    end
end

function readFile(filename)
    local file = io.open(filename, "r")
    local content = nil

    if file then
        content = file:read("*all")
        file:close()
    end

    return content
end

function createPnb()
    newPnbWorld = ""
    newPnbNuked = false
    isLocked = false
    lockedTiles = {[242] = true,[202] = true ,[204] = true ,[206] = true ,[1796] = true,[7188] = true,[2408] = true,[2950] = true,[4428] = true,[4802] = true,[5814] = true,[5260] = true,[5980] = true,[8470] = true,[13200] = true,[12654] = true,[11902] = true,[11550] = true,[11586] = true,[10410] = true,[9640] = true}

    fileName = "WORLD"..bot.name:upper()..".txt"
    fileContent = readFile(fileName)
    if fileContent then
        newPnbWorld = fileContent
        sleep(100)
        warps(newPnbWorld,"")
        if not worldNuked then
            newPnbNuked = false
            print(bot.name:upper().." | PNB World : "..newPnbWorld)
            callEvent("Created PNB World : "..newPnbWorld)
        else
            newPnbNuked = true
        end
    end

    if newPnbNuked or newPnbWorld == "" then
        callEvent("Creating PNB World")
        newPnbWorld = ""
        while newPnbWorld == "" do
            newWorld = generateRandomChar(12)
            print(bot.name:upper().." | Generated World Name: "..newWorld)
            sleep(100)
            warps(newWorld, "")
            if not worldNuked then
                if bot:isInWorld(newWorld:upper()) then
                    
                    for _, tile in pairs(getTiles()) do
                        reconnect(newWorld, "")
                        if lockedTiles[tile.fg] then
                            isLocked = true
                        end
                    end
                    
                    if not isLocked then
                        newPnbWorld = newWorld:upper()
                        print(bot.name:upper().." | PNB World : "..newPnbWorld)
                        callEvent("Created PNB World : "..newPnbWorld)

                        if bot.gem_count > 2000 and findItem(242) == 0 then
                            bot:buy("world_lock")
                            sleep(500)
                            if getTile(bot.x, bot.y).fg == 6 and findItem(242) > 0 then
                                bot:place(bot.x, bot.y-1, 242)
                                sleep(500)
                                reconnect(newPnbWorld,"")
                            end
                        elseif bot.gem_count >= 50 and findItem(202) == 0 then
                            bot:buy("small_lock")
                            sleep(500)
                            if getTile(bot.x, bot.y).fg == 6 and findItem(202) > 0 then
                                bot:place(bot.x, bot.y-1, 202)
                                sleep(500)
                                reconnect(newPnbWorld,"")
                            end
                        end
                        sleep(300)
                        if getTile(bot.x-1, bot.y).fg == 0 and findItem(226) > 0 then
                            bot:place(bot.x-1, bot.y, 226)
                            sleep(500)
                            bot:hit(bot.x-1, bot.y)
                            sleep(300)
                        end
                        saveToFile(newPnbWorld, fileName)
                        break
                    end
                end
            end
        end
    end
end

function totalPlayerInWorld()
    local totalPlayer = 0
    for _, player in pairs(getPlayers()) do
        if not player.isLocalPlayer and player.name:upper() ~= WhiteListOwner_nei:upper() then
            totalPlayer = totalPlayer + 1
        end
    end
    return totalPlayer
end

function pnbOwnWorld(seedz)
    local blockz = seedz - 1
    warps(newPnbWorld, "")
    if not worldNuked and bot:isInWorld(newPnbWorld:upper()) then
        print(bot.name:upper().." | doing pnb at "..bot:getWorld().name)
        callWebhook()
        sleep(100)
        callEvent("doing pnb at "..bot:getWorld().name)

        if AutoChat_nei then
            bot:say(tostring(AutoChat_neiList[math.random(1, #AutoChat_neiList)]))
            sleep(1000)
            bot:say(tostring(emoteChat[math.random(1, #emoteChat)]))
            sleep(1000)
        end

        if randomSkinColor then
            bot:setSkin(math.random(2,7))   
            sleep(100)
        end

        if findItem(98) > 0 and not bot:getInventory():getItem(98).isActive then
            bot:wear(98)
            sleep(100)
        end

        bot.auto_collect = true
        bot.object_collect_delay = 100
        bot.collect_interval = 100
        bot.ignore_gems = false

        while findItem(blockz) > 0 and findItem(seedz) ~= 200 and bot:isInWorld(newPnbWorld:upper()) do
            if math.random() < 0.03 and AutoChat_nei then
                bot:say(tostring(AutoChat_neiRest[math.random(1, #AutoChat_neiRest)]))
                sleep(500)
                bot:say(tostring(randomEmoteRest[math.random(1, #randomEmoteRest)]))
                sleep(2000)
            end

            if totalPlayerInWorld() > 0 and getTile(bot.x, bot.y-1).fg == 202 then
                print(bot.name:upper().." rest for a while! We detect another player in pnb world")
                callEvent("rest for a while! We detect another player in pnb world")
                while totalPlayerInWorld() > 0 do
                    sleep(3000)
                end
            end

            if getTile(bot.x, bot.y-1).fg == 242 then
                for i,player in pairs(getPlayers()) do
                    if player.netid ~= getLocal().netid and player.name:upper() ~= WhiteListOwner_nei:upper() then
                        bot:say("/ban " .. player.name)
                        sleep(1000)
                    end
                end
            end
            
            for _,i in pairs(tileBreak) do
                if getTile(bot.x + i, bot.y - 2).fg == 0 and getTile(bot.x + i, bot.y - 2).bg == 0 and findItem(blockz) > 0 then
                    bot:place(bot.x + i, bot.y - 2, blockz)
                    sleep(DelayPlace_nei)
                    reconnect(newPnbWorld, "")
                end
            end
            
            for _,i in pairs(tileBreak) do
                while getTile(bot.x + i, bot.y - 2).fg ~= 0 or getTile(bot.x + i, bot.y - 2).bg ~= 0 do
                    bot:hit(bot.x + i, bot.y - 2)
                    if VariationDelay then
                        sleep(math.random(DelayPunch_nei - 10,DelayPunch_nei + 10))
                    else
                        sleep(DelayPunch_nei)
                    end
                    reconnect(newPnbWorld, "")
                end
            end
        end
    elseif worldNuked then
        fileName = "WORLD"..bot.name:upper()..".txt"
        deleteFile(fileName)
        ownWorldNuked = true
    end
end

function takeItem(itemID, amount, worldName, doorID)
    bot.auto_collect = false
    bot.collect_interval = 100
    warps(worldName, doorID)
    if not worldNuked and bot:isInWorld(worldName:upper()) then
        callEvent("taking item at "..worldName:upper())
        for _, obj in pairs(getObjects()) do
            reconnect(worldName, doorID)
            if obj.id == itemID then
                if #bot:getPath(math.floor(obj.x / 32),math.floor(obj.y / 32)) > 0 then
                    bot:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                    sleep(100)
                end
                bot:collectObject(obj.oid, 4)
                sleep(500)
                reconnect(worldName, doorID)
            end
            if findItem(itemID) >= amount then
                break
            end
        end
    
        while findItem(itemID) > amount and getTile(bot.x+1, bot.y).fg == 0 do
            bot:setDirection(false)
            bot:drop(itemID, findItem(itemID)-amount)
            sleep(500)
            if findItem(itemID) > amount and getTile(bot.x+1, bot.y).fg == 0 then
                bot:moveRight()
                sleep(100)
            end
            reconnect(worldName, doorID)
        end
    end
end

function botIsInY(y)
    for _, player in pairs(getPlayers()) do
        if not player.isLocalPlayer then
            if math.floor(player.posy/32) == y then
                return true
            end
        end
    end
    return false
end

function onlyHarvest()
    warps(harvestWorld, farmDoorID)
    if not worldNuked and bot:isInWorld(harvestWorld:upper()) then
        callEvent("harvest only until level "..AmountLvlingOnly_nei)
        bot.auto_collect = false
        bot.collect_interval = 100
        bot.ignore_gems = ignoreGems
        
        for _, tile in pairs(getTiles()) do
            reconnect(harvestWorld, farmDoorID)
            if tile.fg == seedID and tile:canHarvest() and hasAccess(tile.x, tile.y) > 0 and bot.level < AmountLvlingOnly_nei then
                
                if ModeFastMove_nei then
                    if #bot:getPath(tile.x, tile.y) > 5 then
                        bot:findPath(tile.x, tile.y)
                    else
                        bot:moveTile(tile.x, tile.y)
                    end
                else
                    bot:findPath(tile.x, tile.y)
                end
                
                if bot:isInTile(tile.x, tile.y) then
                    for _, i in pairs(mode3Tile) do
                        while getTile(bot.x+i, bot.y).fg == seedID and hasAccess(bot.x+i, bot.y) > 0 and getTile(bot.x+i, bot.y):canHarvest() and bot:isInTile(tile.x, tile.y) do
                            bot:hit(bot.x+i, bot.y)
                            sleep(DelayHarverst_nei)
                            while bot.status == BotStatus.online and (bot:getPing() > 300 or bot:getPing()) == 0 do
                                sleep(1000)
                            end
                            reconnect(harvestWorld, farmDoorID, tile.x, tile.y)
                        end
                    end
                end

            end
        end
    end
end

function indexOf(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

function filterOddIndices(tbl)
    local result = {}
    for i, v in ipairs(tbl) do
        if i % 2 == 1 then
            table.insert(result, v)
        end
    end
    return result
end

function scanFloating()
    floatY = {}
    for _, obj in pairs(getObjects()) do
        if obj.id == ItemIdRotation_nei and #bot:getPath(math.floor(obj.x/32), math.floor(obj.y/32)) > 0 then
            local yValue = math.floor(obj.y/32)
            if not indexOf(floatY, yValue) then
                table.insert(floatY, yValue)
            end
        end
    end
end

function takeFloating()
    bot.auto_collect = true
    bot.collect_interval = 100
    warps(farmWorld, farmDoorID)
    if not worldNuked and bot:isInWorld(farmWorld:upper()) then
        print(bot.name:upper().." | collect floating block")
        callWebhook()
        sleep(100)
        callEvent("collect floating block")

        scanFloating()
        sleep(100)
        floatY = filterOddIndices(floatY)
        sleep(100)

        for _, fly in pairs(floatY) do
            for flx = 0, 99, 9 do
                if #bot:getPath(flx, fly) > 0 then
                    bot:findPath(flx, fly)
                    sleep(100)
                    reconnect(farmWorld, farmDoorID, flx, fly)
                    if findItem(ItemIdRotation_nei) > 196 then
                        break
                    end
                end
            end
            if findItem(ItemIdRotation_nei) > 196 then
                break
            end
        end
    end
end

function scanFire()
    local totalFire = 0
    for _, tile in pairs(getTiles()) do
        if tile:hasFlag(4096) then
            totalFire = totalFire + 1
        end
    end
    return totalFire
end

function zigZagPlant()
    warps(farmWorld, farmDoorID)
    if not worldNuked and bot:isInWorld(farmWorld:upper()) then
        bot.auto_collect = true
        bot.collect_interval = 100
        bot.ignore_gems = ignoreGems
        
        sleep(100)
        scanEmptyY()
        sleep(100)

        for i, ye in pairs(emptyTileY) do
            local modeTile = (i % 2 == 1) and mode3Tile or mode3Tile2
            local direction = (i % 2 == 1) and 1 or -1

            for ex = (i % 2 == 1) and 0 or 99, (i % 2 == 1) and 99 or 0, direction do
                reconnect(farmWorld, farmDoorID)
                if getTile(ex, ye).fg == 0 and isPlantable(ex, ye) and hasAccess(ex, ye) > 0 and findItem(seedID) > 0 and bot:isInWorld(farmWorld:upper()) then

                    if ModeFastMove_nei then
                        if #bot:getPath(ex, ye) > 5 then
                            bot:findPath(ex, ye)
                        else
                            bot:moveTile(ex, ye)
                            sleep(50)
                        end
                    else
                        bot:findPath(ex, ye)
                    end

                    if bot:isInTile(ex, ye) then
                        for _, m in pairs(modeTile) do
                            while getTile(bot.x+m, bot.y).fg == 0 and isPlantable(bot.x+m, bot.y) and hasAccess(bot.x+m, bot.y) > 0 and bot:isInTile(ex, ye) and bot:isInWorld(farmWorld:upper()) and findItem(seedID) > 0 do
                                bot:place(bot.x+m, bot.y, seedID)
                                sleep(DelayPlant_nei)
                                while bot.status == BotStatus.online and (bot:getPing() > 300 or bot:getPing()) == 0 do
                                    sleep(1000)
                                end
                                reconnect(farmWorld, farmDoorID, ex, ye)
                            end
                        end
                    end
                    
                end
            end
            
        end 
    end
end

function zigZagHarvest()
    harvestY = 0
    warps(farmWorld, farmDoorID)
    if not worldNuked and bot:isInWorld(farmWorld:upper()) then
        bot.auto_collect = true
        bot.collect_interval = 100
        bot.ignore_gems = ignoreGems

        sleep(100)
        scanTreeY()
        sleep(100)

        for i, ye in pairs(treeY) do
            local modeTile = (i % 2 == 1) and mode3Tile or mode3Tile2
            local direction = (i % 2 == 1) and 1 or -1

            for ex = (i % 2 == 1) and 0 or 99, (i % 2 == 1) and 99 or 0, direction do
                reconnect(farmWorld, farmDoorID)
                if getTile(ex, ye).fg == seedID and getTile(ex, ye):canHarvest() and hasAccess(ex, ye) > 0 and findItem(ItemIdRotation_nei) < 190 and bot:isInWorld(farmWorld:upper()) then

                    if ModeFastMove_nei then
                        if #bot:getPath(ex, ye) > 5 then
                            bot:findPath(ex, ye)
                        else
                            bot:moveTile(ex, ye)
                            sleep(50)
                        end
                    else
                        bot:findPath(ex, ye)
                    end

                    if harvestY ~= ye then
                        harvestY = ye
                    end

                    if bot:isInTile(ex, ye) then
                        for _, m in pairs(modeTile) do
                            while getTile(bot.x+m, bot.y).fg == seedID and getTile(bot.x+m, bot.y):canHarvest() and hasAccess(bot.x+m, bot.y) > 0 and bot:isInTile(ex, ye) and bot:isInWorld(farmWorld:upper()) do
                                bot:hit(bot.x+m, bot.y)
                                sleep(DelayHarverst_nei)
                                while bot.status == BotStatus.online and (bot:getPing() > 300 or bot:getPing()) == 0 do
                                    sleep(1000)
                                end
                                reconnect(farmWorld, farmDoorID, ex, ye)
                            end
                        end
                    end
                    
                end
            end
            
        end 
    end
end

function rotasiMain()
    if #farmWorlds[indexBot] == 0 then
        print(bot.name:upper().." not enough world to spread")
        callAlert("not enough world to spread")
        bot:stopScript()
    end

    for _, list in pairs(farmWorlds[indexBot]) do
        farmWorld, farmDoorID = string.match(list, "([^|]+):([^|]+)")
        farmWorld = farmWorld:upper()

        print(bot.name:upper().." | go to ".. farmWorld)
        callWebhook()
        sleep(100)
        callEvent("go To ".. farmWorld)

        checkTutorial()
        for i = 1,3 do
            if worldTutor == "" then
                checkTutorial()
                sleep(200)
            end
        end

        if PNBInTutorialWorld_nei then
            if worldTutor == "" then
                print(bot.name:upper().." | don't have tutorial world!")
                callAlert("don't have tutorial world!")
                noTutorWorld = true
            end
        elseif autoCreatePnbWorld then
            if bot.gem_count < 50 and findItem(202) < 1 then
                harvest(farmWorld, farmDoorID, seedID)
                sleep(100)
            end
            if putJammer and findItem(226) == 0 then
                takeItem(226, 1, jammerStorageWorld:upper(), jammerStorageDoorID)
                sleep(100)
            end
            createPnb()
        end

        if leveling and bot.level < untilLevel then
            print(bot.name:upper().." | doing leveling until level ".. untilLevel)
            callWebhook()
            sleep(100)
            callEvent("doing leveling until level ".. untilLevel)

            while bot.level < untilLevel do
                warps(levelingWorld, levelingDoorID)
                if not worldNuked and bot:isInWorld(levelingWorld:upper()) then
                    if findItem(levelingSeedID) == 0 and gscanBlock(levelingSeedID) < 200 then
                        takeItem(levelingSeedID, 100, levelingStorage, levelingStorageID)
                        sleep(100)
                        warps(levelingWorld, levelingDoorID)
                        sleep(100)
                    end
                    
                    if findItem(levelingItemIdRotation_nei) < 196 then
                        harvest(levelingWorld, levelingDoorID, levelingSeedID)
                        sleep(100)
                    end
                    
                    if findItem(levelingSeedID) > 0 then
                        plant(levelingWorld, levelingDoorID, levelingSeedID)
                        sleep(100)
                    end
                    
                    if findItem(levelingSeedID) > 50 then
                        dropItem(levelingSeedID, levelingStorage, levelingStorageID)
                        sleep(100)
                        warps(levelingWorld, levelingDoorID)
                        sleep(100)
                    end
                    
                    if bot:isInWorld(levelingWorld:upper()) then
                        if findItem(levelingItemIdRotation_nei) > 0 then
                            if tutorNuked then
                                pnbOwnWorld(levelingSeedID)
                            else
                                PNBTutorial(levelingSeedID)
                            end
                            warps(levelingWorld, levelingDoorID)
                            sleep(100)
                        end
                    end
    
                    while readyTreeScan(levelingSeedID) == 0 do
                        print(bot.name:upper().." | waiting tree")
                        bot:say("/sleep")
                        sleep(30000)
                    end
                else
                    print(bot.name:upper().." | leveling world nuked! ["..levelingWorld:upper().."]")
                    callAlert("leveling world nuked! ("..levelingWorld:upper()..")")
                    bot:stopScript()
                end
            end
            if findItem(levelingSeedID) > 0 then
                dropItem(levelingSeedID, levelingStorage, levelingStorageID)
                sleep(100)
            end

        elseif OnlyLvling_nei and bot.level < AmountLvlingOnly_nei then

            print(bot.name:upper().." | harvest only until level ".. AmountLvlingOnly_nei)
            callWebhook()
            
            for _, farms in pairs(farmWorlds[indexBot]) do
                harvestWorld, hdoor = string.match(farms, "([^|]+):([^|]+)")
                harvestWorld = harvestWorld:upper()

                if bot.level < AmountLvlingOnly_nei then
                    warps(harvestWorld, farmDoorID)
                    if not worldNuked and bot:isInWorld(harvestWorld:upper()) then
                        if readyTreeScan(seedID) > 0 then
                            onlyHarvest()
                        end
                    end
                end
                if bot.level >= AmountLvlingOnly_nei then
                    break
                end
            end

        end
        
        warps(farmWorld, farmDoorID)
        if not worldNuked and bot:isInWorld(farmWorld:upper()) then
            if gscanBlock(778) > 0 then
                print(bot.name:upper().." | clearing toxic waste at "..farmWorld)
                callEvent("clearing toxic waste at "..farmWorld)
                bot.anti_toxic = true
                while gscanBlock(778) > 0 do
                    sleep(1000)
                end
                bot.anti_toxic = false
            end
            
            if scanFire() > 0 and autoCleanFire then
                if findItem(3066) == 0 then
                    takeFirehose()
                    sleep(100)
                    warps(farmWorld, farmDoorID)
                    sleep(100)
                end
                print(bot.name:upper().." | clearing fire at "..farmWorld)
                callEvent("clearing fire at "..farmWorld)
                bot.anti_fire = true
                while bot:getInventory():getItem(3066).isActive and findItem(3066) > 0 do
                    sleep(1000)
                end
            end

            warps(farmWorld, farmDoorID)
            if not worldNuked and bot:isInWorld(farmWorld:upper()) then
                rotationStart = os.time()
                while true do
                    if TakePickaxe_nei and findItem(pickaxeID) ~= 1 then
                        takePickaxe()
                        sleep(100)
                        warps(farmWorld, farmDoorID)
                    end
                    
                    if collectFloat and gscanFloat(ItemIdRotation_nei) > 0 and findItem(ItemIdRotation_nei) < 196 then
                        takeFloating()
                        sleep(100)
                    end
    
                    if findItem(ItemIdRotation_nei) < 190 then
                        if ModeZigzag_nei then
                            zigZagHarvest()
                        else
                            harvest(farmWorld, farmDoorID, seedID)
                        end
                        sleep(100)
                    end
    
                    if not SaveAllSeed_nei and findItem(seedID) > 0 then
                        if ModeZigzag_nei then
                            zigZagPlant()
                        else
                            plant(farmWorld, farmDoorID, seedID)
                        end
                        sleep(100)
                    end
                    
                    if findItem(seedID) >= saveSeedCount then
                        dropItem(seedID, storageSeed, storageSeedDoorID)
                        sleep(100)
                        if SafetyWorld_nei then
                            joinRandom()
                        end
                    end
    
                    if findItem(ItemIdRotation_nei) > 0 then
                        bot.collect_interval = 100
                        if TakePickaxe_nei and findItem(pickaxeID) ~= 1 then
                            takePickaxe()
                            sleep(100)
                            warps(farmWorld, farmDoorID)
                        end

                        if tutorNuked or otherWorldNuked then
                            if ownWorldNuked then
                                createPnb()
                                sleep(100)
                                pnbOwnWorld(seedID)
                            else
                                pnbOwnWorld(seedID)
                                sleep(100)
                            end
                        elseif PNBInTutorialWorld_nei then
                            PNBTutorial(seedID)
                            sleep(100)
                        elseif PNBAnotherWorld_nei then
                            otherWorldPnb()
                            sleep(100)
                        elseif autoCreatePnbWorld then
                            pnbOwnWorld(seedID)
                            sleep(100)
                        else
                            PNB()
                            sleep(100)
                        end
                    end
    
                    if autoBuyClothes and bot.gem_count >= 1500 then
                        buyClothes()
                        sleep(100)
                    end
    
                    if checkTrash() then
                        trashJunk()
                        sleep(100)
                    end
    
                    if checkGoods() then
                        dropGoods()
                        sleep(100)
                    end
                    
                    if StoreItemSetting_nei and bot.gem_count >= (StoreItemPrice_nei*StoreItemMinPack_nei) then
                        buyPacks()
                        sleep(100)
                    end
    
                    warps(farmWorld, farmDoorID)
                    if not worldNuked and bot:isInWorld(farmWorld:upper()) then
                        totalTree = readyTreeScan(seedID)
                        print("detect ready tree: "..totalTree)
                        callEvent("detect ready tree: "..totalTree)
                        
                        totalFloat = gscanFloat(ItemIdRotation_nei)
                        print("detect floating block: "..totalFloat)
    
                        sleep(200)
                        if collectFloat then
                            if totalFloat < 35 and totalTree == 0 then
                                if findItem(seedID) > 0 then
                                    if ModeZigzag_nei then
                                        zigZagPlant(levelingWorld, levelingDoorID, levelingSeedID)
                                    else
                                        plant(levelingWorld, levelingDoorID, levelingSeedID)
                                    end
                                end
                                sleep(100)
                                treez[farmWorld] = gscanBlock(seedID)
                                fossils[farmWorld] = gscanBlock(3918)

                                
                                elapsedTime = os.time() - rotationStart
                                waktu[farmWorld] = math.floor(elapsedTime / 3600) .. "h ".. math.floor((elapsedTime % 3600) / 60) .."m"
    
                                print(bot.name:upper() .. " | " .. farmWorld:upper() .. " finished for: " .. math.floor(elapsedTime / 3600) .. " hours ".. math.floor((elapsedTime % 3600) / 60) .." minutes")
                                break
                            end
                        else
                            if totalTree == 0 then
                                if findItem(seedID) > 0 then
                                    if ModeZigzag_nei then
                                        zigZagPlant(levelingWorld, levelingDoorID, levelingSeedID)
                                    else
                                        plant(levelingWorld, levelingDoorID, levelingSeedID)
                                    end
                                end
                                sleep(100)
                                treez[farmWorld] = gscanBlock(seedID)
                                fossils[farmWorld] = gscanBlock(3918)

                                if tile.fg == 3918 then
                                    fossil = fossil + 1
                                end
                                
                                elapsedTime = os.time() - rotationStart
                                waktu[farmWorld] = math.floor(elapsedTime / 3600) .. "h ".. math.floor((elapsedTime % 3600) / 60) .."m"
                                
                                print(bot.name:upper() .. " | " .. farmWorld:upper() .. " finished for: " .. math.floor(elapsedTime / 3600) .. " hours ".. math.floor((elapsedTime % 3600) / 60) .." minutes")
    
                                break
                            end
                        end
                    end
                    
                    fossils[farmWorld] = gscanBlock(3918)
                    elapsedTime = os.time() - rotationStart
                    waktu[farmWorld] = math.floor(elapsedTime / 3600) .. "h ".. math.floor((elapsedTime % 3600) / 60) .."m"
                    
                end
            end
        end
    end
end

function main()
    if ModeLooping_nei then
        while true do
            rotasiMain()
        end
    else
        rotasiMain()
    end
    
    if findItem(seedID) > 0 then
        dropItem(seedID, storageSeed, storageSeedDoorID)
        callEvent("Done all world!")
    end
    
    if terminateOption == 1 then
        bot.auto_reconnect = false
        bot:disconnect()
        removeBot()
    elseif terminateOption == 2 then
        bot.auto_reconnect = false
        bot:stopScript()
    else
        bot.auto_reconnect = false
        bot:disconnect()
        bot:stopScript()
    end
    
end

while bot.status ~= BotStatus.online do
    sleep(1000)
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

    if response == "Access approved! Please Wait." then
        while bot.status ~= BotStatus.online do
            print("Neikoe script started!")
            sleep(100)
            callEvent("Neikoe script started!")
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                print(bot.name:upper().." has been banned! ")
                sleep(100)
                callEvent(bot.name:upper().." | has been banned! ")
                sleep(100)
                bot:stopScript()
            end
        end

        while bot.status ~= BotStatus.online do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                bot:stopScript()
            end
        end
        main()
    else
        messageBox = MessageBox.new()
        messageBox.title = "Neikoe Script"
        messageBox.description = "Login is not identified!\nPlease check the registered username\n\nScript by https://discord.gg/neikoe"
        messageBox:send()
        print("Login is not identified!")
        sleep(100)
    end
end
