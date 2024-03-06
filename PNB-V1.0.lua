bot = getBot()

pnbMode = "UP" -- UP/DOWN
nei_autocollect_setting = true
terminateOption = 1 -- 1 = Stop Script; 2 = Disconnect; 3 = Remove Bot When Block is 0
delayOnExecute = 2000 -- Delay On Starting Script
variationDelay = true -- Variation Delay for nei_delay_punch (nei_delay_punch-10 - nei_delay_punch+10)
maxGems = 9999999 -- Max Gems Dropped in World [For Auto Next World]
maxSeedInBP = 50 -- Max Seed in Backpack before Dropping
pnbInTutorial = false -- Pnb in Tutorial World. Auto PNB in nei_world_pnb if don't Have
whiteListOwner = "yourGrowID" -- So u wont get banned by Bot
autoBuyPack = false
packName = "world_lock"
packPrice = 2000
packItemID = {242,}
minGems = 2000 -- Minimum Gems before Buying Packs
packWorld = ""
packDoorID = ""
autoRemoveBot = false
removeOnLevel = 18
exitOnRest = false
disconnectOnRest = false
restInterval = 3600 -- Second
randomSkinColor = true

nei_autochat_settingList = {"Its dangerous to go out at night these days", "The new building in the city is gigantic", "A real news reporter must have integrity", "Its fun to doodle on the blackboard", "`4Neikoe Script Is Best Store!"}
nei_webhookedit_setting = true
nei_whitelist_item = {5742, 5746, 5030, 1406} -- Bot Will Drop Items in list from BP
nei_whitelist_drop_amount = 100 -- bot will drop if item > 100 in Backpack 
nei_world_whitelist = ""
nei_door_whitelist = ""

bot.move_range = 4
bot.move_interval = 235
bot.auto_reconnect = true
bot.reconnect_interval = nei_delay_reconnect
bot.auto_collect = nei_autocollect_setting
bot.collect_range = 3
bot.collect_interval = 100
bot.auto_leave_on_mod = true

bot.legit_mode = true
bot.ignore_gems = not nei_collect_gems

bot.auto_rest_mode = nei_restbot_setting
bot.rest_time = nei_restbot_time
bot.rest_interval = restInterval

nei_storage_seed = string.upper(nei_storage_seed)
nei_storage_pickaxe = string.upper(nei_storage_pickaxe)
packWorld = string.upper(packWorld)
pnbMode = string.upper(pnbMode)
nei_world_whitelist = string.upper(nei_world_whitelist)

tileBreak = {}
selectedBot = {}
emptyWorld = {}
maxGemsWorld = {}
worldNuked = false
wrenchP = false
nei_pnb_distance = nei_pnb_distance + 1
worldTutor = ""
noTutorWorld = false
seedID = nei_itemid_block + 1
randomWorld = {"ASMEI", "DAW", "QUCU", "ALFAMARTS", "BUYPEPPER"}
nei_pnb_pos_x, nei_pnb_pos_y = nei_pnb_pos_x-1, nei_pnb_pos_y-1

gautReady = false
suckReady = false

startTime = os.time()
gemsIcon = "<:gemsnei_2:1205842132993187891>"
packIcon = "<:sspnei:1205840397130137610>"
seedIcon = "<:crystalsnei:1214463249685155880>"
blockIcon = "<:crystalbnei:1214463229477126165>"
totalBlock = 0
totalPack = 0
totalSeed = 0
totalGems = 0
gaiaID = 6946
utID = 6948

function getUptime()
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local days = math.floor(elapsedTime / 86400)
    local hours = math.floor((elapsedTime % 86400) / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    return string.format("%dd %02dh %02dm", days, hours, minutes)
end

function callWebhook(blocks, seeds, pack, gems)
    local wh = Webhook.new(nei_webhook_main_link)
    wh.embed1.use = true
    wh.embed1.title = "Neikoe Script | Auto PNB V1.0"
    wh.embed1.thumbnail = "https://media.discordapp.net/attachments/1205088853099028480/1209099876642721813/Picsart_24-02-14_15-40-23-071.png?ex=65f82602&is=65e5b102&hm=8f2da9f341a0fb2831f2670c1e89fad2a7fa46830813262f2cfd30f981f9f88b&=&format=webp&quality=lossless&width=616&height=616"
    wh.embed1.color = 16756592
    local desc = "Updated: <t:" .. os.time() .. ":R>\n\n"
    for _, botz in pairs(getBots()) do
        if botz.selected == true then
            desc = desc .. "**|** "..botz.name:upper().." ("..botz.level..")".. getStatus(botz.status).."\n"
        end
    end
    
    wh.embed1.description = desc

    if blocks then
        totalBlock = blocks
    end

    if seeds then
        totalSeed = seeds
    end

    if pack then
        totalPack = pack
    end

    if gems then
        totalGems = gems
    end

    wh.embed1:addField("<:gemsnei_2:1205842132993187891> **Bot Activities**", "**|** Float Gems: ".. totalGems .."\n**|** Block Amount: " .. totalBlock .. "\n**|** Seed Result: ".. totalSeed, true)
    wh.embed1.footer.text = "Bot Uptime " .. getUptime() .."\n" .. os.date("!%b-%d-%Y, %I:%M %p", os.time() + 7 * 60 * 60)
    if nei_webhookedit_setting == true then
        wh:edit(nei_webhook_main_id)
    else
        wh:send()
    end
end

function getStatus(stat)
    local online = "<:dotgreennei:1206515388733718548>"
    local offline = "<:dotrnei:1214766079210033173>"
    if stat == BotStatus.online then
        return online
    else
        return offline
    end
end

function callAlert(msg)
    local wh = Webhook.new(nei_webhook_second_link)
    wh.content = ""
    wh.embed1.use = true
    wh.embed1.color = 16756592
    wh.embed1.description = "".. msg
	wh:send()
end

function callEvent(msg)
    local wh = Webhook.new(nei_webhook_second_link)
    wh.embed1.use = true
    wh.embed1.color = 16756592 
    wh.embed1.description = "".. msg
    wh:send()
end

for _, botz in pairs(getBots()) do
    if botz.selected then
        table.insert(selectedBot, botz)
    end
end

for i, botz in pairs(selectedBot) do
    if botz.name:upper() == bot.name:upper() then
        botIndex = i
    end
end

for i = math.floor(nei_breakrow/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end

for i = 0, math.ceil(nei_breakrow/2) - 1 do
    table.insert(tileBreak,i)
end

for i, botz in pairs(selectedBot) do
    if botz.name:upper() == bot.name:upper() then
        nei_pnb_pos_x, nei_pnb_pos_y = nei_pnb_pos_x+nei_pnb_distance*(i-1), nei_pnb_pos_y
    end
end
print(bot.name:upper().." Position: X "..nei_pnb_pos_x.." and Y "..nei_pnb_pos_y)

function gscanFloat(id)
    return bot:getWorld().growscan:getObjects()[id] or 0
end

function gscanBlock(id)
    return bot:getWorld().growscan:getTiles()[id] or 0
end

function findItem(id)
    return bot:getInventory():findItem(id)
end

function checkNuked(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():find("World is inaccessible, please Remove!") then
            worldNuked = true
        end
    end
end

function warps(worldName, doorID)
    worldNuked = false
    warpAttempt = 0
    addEvent(Event.variantlist, checkNuked)
    while not bot:isInWorld(worldName:upper()) and not worldNuked do
        print("Warp to "..worldName)
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

        listenEvents(6)

        if warpAttempt == 5 then
            callAlert("Bot "..bot.name:upper().." hard warp and will rest for a while.")
            print(worldName, " hard Warp")
            sleep(2 * 60000)
            bot:disconnect()
            sleep(1000)
            while bot.status ~= BotStatus.online do
                sleep(1000)
            end
            warpAttempt = 0
        else
            warpAttempt = warpAttempt + 1
        end

    end

    if worldNuked then
        callAlert(worldName.." got nuked!")
        print(worldName, "nuked")
        -- bot:stopScript()
    end
    
    if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                callAlert(bot.name:upper() .. " has been banned!")
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
            print("can't entered world ".. worldName)
            callAlert("can't entered world ".. worldName)
            sleep(100)
            worldNuked = true
        end
    end
    sleep(100)
    removeEvent(Event.variantlist)
end

function reconnect(worldName, doorID, nei_pnb_pos_x, nei_pnb_pos_y)
    if nei_restbot_setting and bot:isResting() then
        while bot:isResting() do
            if exitOnRest and bot:isInWorld() then
                bot:leaveWorld()
            end
            if disconnectOnRest and bot.status == BotStatus.online then
                print(bot.name:upper() .. " will resting.")
                callEvent(bot.name:upper() .. " will resting.")
                bot.auto_reconnect = false
                bot:disconnect()
            end
            sleep(1000)
        end
        
        callEvent(bot.name:upper() .. " continue to world.")
        bot.auto_reconnect = true
        
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                callAlert(bot.name:upper() .. " has been banned!")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end
    
        while not bot:isInWorld(worldName:upper()) do
            bot:warp(worldName)
            sleep(nei_delay_warp)
        end
        
        if doorID ~= "" and getTile(bot.x,bot.y).fg == 6 then
            sleep(1000)
            bot:warp(worldName, doorID)
            sleep(2000)
        end
    
        if nei_pnb_pos_x and nei_pnb_pos_y and not bot:isInTile(nei_pnb_pos_x, nei_pnb_pos_y) then
            sleep(200)
            bot:findPath(nei_pnb_pos_x, nei_pnb_pos_y)
            sleep(200)
        end
        callWebhook(nil, nil, nil, nil)
    end
    if bot.status ~= BotStatus.online or bot:getPing() == 0 then
        callWebhook(nil, nil, nil, nil)

        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                callAlert(bot.name:upper() .. " has been banned!")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end
        
        while not bot:isInWorld(worldName:upper()) do
            bot:warp(worldName)
            sleep(nei_delay_warp)
        end
        
        if doorID ~= "" and getTile(bot.x,bot.y).fg == 6 then
            sleep(1000)
            bot:warp(worldName, doorID)
            sleep(2000)
        end
        
        if nei_pnb_pos_x and nei_pnb_pos_y and not bot:isInTile(nei_pnb_pos_x, nei_pnb_pos_y) then
            sleep(200)
            bot:findPath(nei_pnb_pos_x, nei_pnb_pos_y)
            sleep(200)
        end
        callWebhook(nil, nil, nil, nil)
    end
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function autoWear(itemID)
    bot.auto_collect = false
    bot.object_collect_delay = 100
    warps(nei_storage_pickaxe, nei_door_pickaxe)
    if bot:isInWorld() then
        for _, obj in pairs(getObjects()) do
            reconnect(nei_storage_pickaxe, nei_door_pickaxe)
            if obj.id == itemID then
                if #bot:getPath(math.floor(obj.x / 32)-1,math.floor(obj.y / 32)) > 0 then
                    bot:findPath(math.floor(obj.x / 32)-1,math.floor(obj.y / 32))
                    sleep(100)
                end
                bot:collectObject(obj.oid, 3)
                sleep(500)
            end
            if findItem(itemID) > 0 then
                break
            end
        end
        
        if findItem(itemID) > 1 then
            print("Item Count > 1, Bot Dropping")
            bot:setDirection(false)
            sleep(100)
            bot:drop(itemID, findItem(itemID)-1)
            sleep(500)
            while findItem(itemID) > 1 do
                bot:moveRight()
                sleep(100)
                bot:drop(itemID, findItem(itemID)-1)
                sleep(500)
                reconnect(nei_storage_pickaxe, nei_door_pickaxe)
            end
        end

        if findItem(itemID) == 1 then
            if not getBot():getInventory():getItem(itemID).isActive then
                bot:wear(itemID)
                sleep(300)
            end
        else
            print("No Item["..itemID.."] Found in Backpack!, Calling Auto Wear Again")
            sleep(3000)
            autoWear(itemID)
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

function dropItem(itemID)
    print(bot.name:upper().." Drop item ["..itemID.."]")
    bot.auto_collect = false
    bot.object_collect_delay = 60000
    if nei_storage_seed:upper() == blockWorld:upper() then
        bot:warp(nei_storage_seed, nei_door_seed)
        sleep(2000)
    else
        warps(nei_storage_seed, nei_door_seed)
    end
    if bot:isInWorld(nei_storage_seed:upper()) then
        ye = bot.y
        for _, tile in pairs(getTiles()) do
            reconnect(nei_storage_seed, nei_door_seed)
            if tile.y == ye and tile.x > bot.x and tile.x <= 99 then
                if tileDrop(tile.x, tile.y, findItem(itemID)) then
                    bot:findPath(tile.x-1, tile.y)
                    bot:setDirection(false)
                    sleep(100)
                    bot:drop(itemID, findItem(itemID))
                    sleep(500)
                    while findItem(itemID) > 0 and getTile(bot.x+1, bot.y).fg == 0 do
                        bot:moveRight()
                        sleep(100)
                        bot:drop(itemID, findItem(itemID))
                        sleep(500)
                        reconnect(nei_storage_seed, nei_door_seed)
                    end
                end
            end
            if findItem(itemID) == 0 then
                break
            end
        end
        callWebhook(nil, gscanFloat(seedID), nil, nil)
    end
end

function dropGoodItem(itemID)
    print(bot.name:upper().." Drop item ["..itemID.."]")
    bot.auto_collect = false
    warps(nei_world_whitelist:upper(), nei_door_whitelist)
    if bot:isInWorld(nei_world_whitelist:upper()) then
        ye = bot.y
        for _, tile in pairs(getTiles()) do
            reconnect(nei_world_whitelist, nei_door_whitelist)
            if tile.y == ye and tile.x > bot.x and tile.x <= 99 then
                if tileDrop(tile.x, tile.y, findItem(itemID)) then
                    bot:findPath(tile.x-1, tile.y)
                    bot:setDirection(false)
                    sleep(100)
                    bot:drop(itemID, findItem(itemID))
                    sleep(500)
                    while findItem(itemID) > 0 and getTile(bot.x+1, bot.y).fg == 0 do
                        bot:moveRight()
                        sleep(100)
                        bot:drop(itemID, findItem(itemID))
                        sleep(500)
                        reconnect(nei_world_whitelist, nei_door_whitelist)
                    end
                end
            end
            if findItem(itemID) == 0 then
                break
            end
        end
    end
end

function takeBlockMain()
    print(bot.name:upper() .. " go to world block.")
    bot.auto_collect = false
    bot.object_collect_delay = 100
    for _, bWorld in pairs(nei_storage_block) do
        blockWorld = bWorld:upper()
        if not emptyWorld[blockWorld] then
            warps(blockWorld, nei_door_block)
            if not worldNuked then
                if bot:isInWorld(blockWorld:upper()) then
                    if gscanFloat(nei_itemid_block) > 0 then
                        takeItem(nei_itemid_block, 200)
                        sleep(100)
                        callWebhook(gscanFloat(nei_itemid_block), nil, nil, nil)
                    else
                        print(blockWorld.." block empty")
                        callEvent(blockWorld.." block empty")
                        emptyWorld[blockWorld] = true
                        if blockWorld == string.upper(nei_storage_block[#nei_storage_block]) and findItem(nei_itemid_block) == 0 then
                            print(blockWorld.." is the last world, "..bot.name:upper().." finish already.")
                            callEvent(blockWorld.." is the last world, "..bot.name:upper().." finish already.")
                            if findItem(seedID) > 0 then
                                dropItem(seedID)
                                sleep(200)
                            end
                            if terminateOption == 1 then
                                bot:stopScript()
                            elseif terminateOption == 2 then
                                bot.auto_reconnect = false
                                bot:disconnect()
                                bot:stopScript()
                            else
                                removeBot(bot.name)
                            end
                        end
                    end
                    if findItem(nei_itemid_block) > 0 then
                        break
                    end
                end
            end
        end
    end
end

function takeItem(itemID, amount)
    bot.auto_collect = false
    bot.object_collect_delay = 100
    warps(blockWorld, nei_door_block)
    for _, obj in pairs(getObjects()) do
        reconnect(blockWorld, nei_door_block)
        if obj.id == itemID then
            if #bot:getPath(math.floor(obj.x / 32),math.floor(obj.y / 32)) > 0 then
                bot:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                sleep(100)
            end
            bot:collectObject(obj.oid, 3)
            sleep(500)
            reconnect(blockWorld, nei_door_block)
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
        reconnect(blockWorld, nei_door_block)
    end
end

function trashJunk()
    for _, trash in pairs(nei_list_autotrash) do
        if findItem(trash) > 100 then
            bot:trash(trash, findItem(trash))
            sleep(1000)
        end
    end
end

function PNB()
    warps(pnbWorld, nei_door_pnb)
    if bot:isInWorld(pnbWorld:upper()) then

        print(bot.name:upper().." go to world "..bot:getWorld().name:upper())
        sleep(100)
        callEvent(bot.name:upper().." go to world ||"..bot:getWorld().name:upper().."||")
        sleep(100)
        callWebhook(nil, nil, nil, gscanFloat(112))
        sleep(100)

        if not bot:isInTile(nei_pnb_pos_x, nei_pnb_pos_y) and #bot:getPath(nei_pnb_pos_x, nei_pnb_pos_y) > 0 then
            bot:findPath(nei_pnb_pos_x, nei_pnb_pos_y)
            sleep(200)
        end

        if randomSkinColor then
            bot:setSkin(math.random(1,6))
            sleep(200)
        end
    
        if nei_autochat_setting then
            bot:say(nei_autochat_settingList[math.random(1, #nei_autochat_settingList)])
            sleep(1000)
            bot:say(nei_autochat_settingList[math.random(1, #nei_autochat_settingList)])
            sleep(1000)
        end
        
        bot.auto_collect = nei_autocollect_setting
        bot.object_collect_delay = 150
        bot.ignore_gems = not nei_collect_gems

        if pnbMode:upper() == "UP" then
            while findItem(nei_itemid_block) > 0 and findItem(seedID) < 196 and bot:isInWorld(pnbWorld:upper()) and getTile(bot.x, bot.y).fg ~= 6 do
                
                for _,i in pairs(tileBreak) do
                    if getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).fg == 0 and getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).bg == 0 then
                        bot:place(bot.x + i, bot.y - 2, nei_itemid_block)
                        sleep(nei_delay_place)
                        reconnect(pnbWorld, nei_door_pnb, nei_pnb_pos_x, nei_pnb_pos_y)
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    while getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).fg ~= 0 or getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).bg ~= 0 do
                        bot:hit(bot.x + i, bot.y - 2)
                        if variationDelay then
                            sleep(math.random(nei_delay_punch - 10,nei_delay_punch + 10))
                        else
                            sleep(nei_delay_punch)
                        end
                        reconnect(pnbWorld, nei_door_pnb, nei_pnb_pos_x, nei_pnb_pos_y)
                    end
                end
        
            end
        else
            while findItem(nei_itemid_block) > 0 and findItem(seedID) < 196 and bot:isInWorld(pnbWorld:upper()) and getTile(bot.x, bot.y).fg ~= 6 do
                
                for _,i in pairs(tileBreak) do
                    if getTile(nei_pnb_pos_x + i, nei_pnb_pos_y + 2).fg == 0 and getTile(nei_pnb_pos_x + i, nei_pnb_pos_y + 2).bg == 0 then
                        bot:place(bot.x + i, bot.y + 2, nei_itemid_block)
                        sleep(nei_delay_place)
                        reconnect(pnbWorld, nei_door_pnb, nei_pnb_pos_x, nei_pnb_pos_y)
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    while getTile(nei_pnb_pos_x + i, nei_pnb_pos_y + 2).fg ~= 0 or getTile(nei_pnb_pos_x + i, nei_pnb_pos_y + 2).bg ~= 0 do
                        bot:hit(bot.x + i, bot.y + 2)
                        if variationDelay then
                            sleep(math.random(nei_delay_punch - 10,nei_delay_punch + 10))
                        else
                            sleep(nei_delay_punch)
                        end
                        reconnect(pnbWorld, nei_door_pnb, nei_pnb_pos_x, nei_pnb_pos_y)
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
        print(bot.name:upper().." Tutorial World: "..worldTutor)
        callEvent(bot.name:upper().." Tutorial World: "..worldTutor)
        unlistenEvents()
    end
end

function checkTutorial()
    worldTutor = ""
    while not bot:isInWorld() do
        bot:warp(randomWorld[math.random(1, #randomWorld)])
        sleep(nei_delay_warp)
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

function PNBTutorial()
    warps(worldTutor, "")
    if not worldNuked then
        nei_pnb_pos_x, nei_pnb_pos_y = 50, 23
        if bot:isInWorld(worldTutor:upper()) and hasAccess(bot.x-1, bot.y) > 0 then
            print(bot.name:upper().." go to world "..bot:getWorld().name:upper())
            callEvent(bot.name:upper().." go to world ||"..bot:getWorld().name:upper().."||")
            if not bot:isInTile(nei_pnb_pos_x, nei_pnb_pos_y) and #bot:getPath(nei_pnb_pos_x, nei_pnb_pos_y) > 0 then
                bot:findPath(nei_pnb_pos_x, nei_pnb_pos_y)
                sleep(200)
            end

            if randomSkinColor then
                bot:setSkin(math.random(1,6))
                sleep(200)
            end
        
            if nei_autochat_setting then
                bot:say(nei_autochat_settingList[math.random(1, #nei_autochat_settingList)])
                sleep(1000)
                bot:say(nei_autochat_settingList[math.random(1, #nei_autochat_settingList)])
                sleep(1000)
            end
            
            bot.auto_collect = nei_autocollect_setting
            bot.object_collect_delay = 150
            bot.ignore_gems = not nei_collect_gems
            
            while findItem(nei_itemid_block) > 0 and findItem(seedID) < 196 and bot:isInWorld(worldTutor:upper()) and getTile(bot.x, bot.y).fg ~= 6 do
                
                for i,player in pairs(getPlayers()) do
                    if player.netid ~= getLocal().netid and player.name:upper() ~= whiteListOwner:upper() then
                        bot:say("/ban " .. player.name)
                        sleep(1000)
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    if getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).fg == 0 and getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).bg == 0 then
                        bot:place(bot.x + i, bot.y - 2, nei_itemid_block)
                        sleep(nei_delay_place)
                        reconnect(worldTutor, "", nei_pnb_pos_x, nei_pnb_pos_y)
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    while getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).fg ~= 0 or getTile(nei_pnb_pos_x + i, nei_pnb_pos_y - 2).bg ~= 0 do
                        bot:hit(bot.x + i, bot.y - 2)
                        if variationDelay then
                            sleep(math.random(nei_delay_punch - 10,nei_delay_punch + 10))
                        else
                            sleep(nei_delay_punch)
                        end
                        reconnect(worldTutor, "", nei_pnb_pos_x, nei_pnb_pos_y)
                    end
                end

            end
        end
    end
    if worldNuked then
        print(bot.name:upper().." world tutorial got nuked!")
        callAlert(bot.name:upper().." world tutorial got nuked!")
        PNBMain()
    end
end

function buyPacks()
    print(bot.name:upper().." will buy pack.")
    bot.auto_collect = false
    warps(packWorld, packDoorID)
    if bot:isInWorld() then
        availSlot = getBot():getInventory().slotcount - getBot():getInventory().itemcount
        while bot.gem_count >= packPrice and availSlot > 0 do
            bot:buy(packName:lower())
            sleep(2000)
            reconnect(packWorld, packDoorID)
            for _, itemz in pairs(packItemID) do
                if findItem(itemz) > 190 then
                    dropPack()
                    reconnect(packWorld, packDoorID)
                end
            end
        end
        dropPack()
    end
end

function dropPack()
    bot.auto_collect = false
    warps(packWorld, packDoorID)
    for _, pack in pairs(packItemID) do
        if findItem(pack) > 0 then
            bot:drop(pack, findItem(pack))
            sleep(500)
            reconnect(packWorld, packDoorID)
            while findItem(pack) > 0 do
                bot:moveRight()
                sleep(100)
                bot:drop(pack, findItem(pack))
                sleep(500)
                reconnect(packWorld, packDoorID)
            end
        end
    end
    callWebhook(nil, nil, scanPack(), nil)
end

function scanPack()
    local totalPack = 0
    for _, obj in pairs(getObjects()) do
        for _, pid in ipairs(packItemID) do
            if obj.id == pid then
                totalPack = totalPack + obj.count
            end
        end
    end
    return totalPack
end

function scanSeedGaia()
    return getTile(gaiaX, gaiaY):getExtra().item_count
end

function autoRemove()
    if bot.level >= removeOnLevel then
        print(bot.name:upper().." has reached maximum level and will remove")
        callAlert(bot.name:upper().." has reached maximum level and will remove")
        if findItem(nei_itemid_block) > 0 then
            dropItem(nei_itemid_block)
            sleep(200)
        end
        if findItem(seedID) > 0 then
            dropItem(seedID)
            sleep(200)
        end
        if autoBuyPack and bot.gem_count >= packPrice then
            buyPacks()
            sleep(200)
        end
        removeBot(bot.name)
    end
end

function scanGaut()
    for _, tile in pairs(getTiles()) do
        if tile.fg == gaiaID and hasAccess(tile.x, tile.y) > 0 then
            gaiaX, gaiaY = tile.x, tile.y
        end
        if tile.fg == utID and hasAccess(tile.x, tile.y) > 0 then
            utX, utY = tile.x, tile.y
        end
    end
end

function itemInGaia(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("The machine contains") then
        teks = varlist:get(1):getString()
        totalItemInGaia = tonumber(string.match(teks, "contains (%d+)"))
        gaiaReady = true
        unlistenEvents()
    end
end

function itemInUT(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("The machine contains") then
        teks = varlist:get(1):getString()
        totalitemInUT = tonumber(string.match(teks, "contains (%d+)"))
        utReady = true
        unlistenEvents()
    end
end

function retGaia()
    gaiaReady = false
    warps(pnbWorld, nei_door_pnb)
    if bot:isInWorld(pnbWorld:upper()) then
        if not bot:findPath(gaiaX, gaiaY-1) then
            bot:findPath(gaiaX, gaiaY+1)
        end
        sleep(100)
    
        if bot:isInTile(gaiaX, gaiaY-1) or bot:isInTile(gaiaX, gaiaY+1) and getTile(gaiaX, gaiaY).fg == gaiaID then
            addEvent(Event.variantlist, itemInGaia)
            bot:wrench(gaiaX, gaiaY)
            listenEvents(2)
            if gaiaReady then
                bot:sendPacket(2, "action|dialog_return\ndialog_name|itemsucker_seed\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
                sleep(1000)
                if totalItemInGaia > 200 then
                    bot:sendPacket(2, "action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nitemtoremove|200")
                    sleep(500)
                elseif totalItemInGaia > 0 then
                    bot:sendPacket(2, "action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..gaiaX.."|\ntiley|"..gaiaY.."|\nitemtoremove|"..totalItemInGaia)
                    sleep(500)
                end
            end
            removeEvent(Event.variantlist)
        end

    end
end

function retUt()
    utReady = false
    warps(pnbWorld, nei_door_pnb)
    if bot:isInWorld(pnbWorld:upper()) then
        if not bot:findPath(utX, utY-1) then
            bot:findPath(utX, utY+1)
        end
        sleep(100)
    
        if bot:isInTile(utX, utY-1) or bot:isInTile(utX, utY+1) and getTile(utX, utY).fg == utID then
            addEvent(Event.variantlist, itemInUT)
            bot:wrench(utX, utY)
            listenEvents(2)
            if utReady then
                bot:sendPacket(2, "action|dialog_return\ndialog_name|itemsucker_block\ntilex|"..utX.."|\ntiley|"..utY.."|\nbuttonClicked|retrieveitem\n\nchk_enablesucking|1")
                sleep(1000)
                if totalitemInUT > 200 then
                    bot:sendPacket(2, "action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..utX.."|\ntiley|"..utY.."|\nitemtoremove|200")
                    sleep(500)
                elseif totalitemInUT > 0 then
                    bot:sendPacket(2, "action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..utX.."|\ntiley|"..utY.."|\nitemtoremove|"..totalitemInUT)
                    sleep(500)
                end
            end
            removeEvent(Event.variantlist)
        end

    end
end

function dropGoods()
    for _, itemz in pairs(nei_whitelist_item) do
        if findItem(itemz) > nei_whitelist_drop_amount then
            dropGoodItem(itemz)
            sleep(200)
        end
    end
end

function PNBMain()
    for _, pnbW in pairs(nei_world_pnb) do
        pnbWorld = pnbW:upper()
        if not maxGemsWorld[pnbWorld] then
            warps(pnbWorld, nei_door_pnb)
            if not worldNuked then
                if bot:isInWorld(pnbWorld) then
                    if gscanFloat(112) <= maxGems then
                        while gscanFloat(112) <= maxGems do
                            trashJunk()
                            sleep(100)
                            scanGaut()
                            sleep(100)

                            if autoRemoveBot and bot.level >= removeOnLevel then
                                autoRemove()
                                sleep(100)
                            end

                            if nei_pickaxe_setting and findItem(98) == 0 then
                                autoWear(98)
                                sleep(100)
                            end
                    
                            if autoBuyPack and bot.gem_count >= minGems then
                                buyPacks()
                                sleep(100)
                            end
                            
                            if findItem(nei_itemid_block) < 196 then
                                takeBlockMain()
                                sleep(100)
                                dropGoods()
                            end
                            
                            if findItem(seedID) >= maxSeedInBP then
                                dropItem(seedID)
                                sleep(200)
                            end
                            
                            PNB()
                            sleep(100)

                            callWebhook(nil, nil, nil, gscanFloat(112))
                            sleep(100)
                            
                            if nei_retrieve_setting and getTile(gaiaX, gaiaY):getExtra().item_count >= nei_seed_retrieve_setting then
                                retGaia()
                                sleep(100)
                                retUt()
                                sleep(100)

                                if findItem(nei_itemid_block) < 196 then
                                    takeBlockMain()
                                    dropGoods()
                                    sleep(100)
                                end
                                
                                if findItem(seedID) > 0 then
                                    dropItem(seedID)
                                    sleep(200)
                                end

                                if nei_pickaxe_setting and findItem(98) == 0 then
                                    autoWear(98)
                                    sleep(100)
                                end
                        
                                if autoBuyPack and bot.gem_count >= minGems then
                                    buyPacks()
                                    sleep(100)
                                end
                            end

                            warps(pnbWorld, nei_door_pnb)
                        end
                    else
                        maxGemsWorld[pnbWorld] = true
                        if pnbWorld:upper() == string.upper(nei_world_pnb[#nei_world_pnb]) then
                            print(pnbWorld.." is the last world, "..bot.name:upper().." finish already.")
                            callAlert(pnbWorld.." is the last world, "..bot.name:upper().." finish already.")
                            if findItem(nei_itemid_block) > 0 then
                                dropItem(nei_itemid_block)
                            end
                            if findItem(seedID) > 0 then
                                dropItem(seedID)
                            end
                            if terminateOption == 1 then
                                bot:stopScript()
                            elseif terminateOption == 2 then
                                bot.auto_reconnect = false
                                bot:disconnect()
                                bot:stopScript()
                            else
                                removeBot(bot.name)
                            end
                        end
                    end
                end
            end
        end
    end
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

local jsonString = request("POST","http://game2.jagoanvps.cloud:5089/gt/loginlua?username="..nei_license.."&password=1009&mac="..getMachineGUID())

local responsePattern = '"response":"(.-)"'
local messagePattern = '"message":"(.-)"'

local response = jsonString:match(responsePattern)
local message = jsonString:match(messagePattern)

if response and message then
    -- Print values
    print("Status: " .. response)
    print("Message: " .. message)

    if response == "success" then
        sleep(delayOnExecute*botIndex-1)
    
        if pnbInTutorial then
            for i = 1,3 do
                if worldTutor == "" then
                    checkTutorial()
                    sleep(100)
                end
            end

            if worldTutor == "" then
                print(bot.name:upper().." Dont Have Tutorial World!")
                sleep(100)
                callEvent(bot.name:upper().." Dont Have Tutorial World!")
                sleep(100)
                noTutorWorld = true
            end

            if not noTutorWorld then
                while true do
                    trashJunk()
                    sleep(100)

                    if autoRemoveBot and bot.level >= removeOnLevel then
                        autoRemove()
                        sleep(100)
                    end
        
                    if nei_take_pickaxe and findItem(98) == 0 then
                        autoWear(98)
                        sleep(100)
                    end
        
                    if autoBuyPack and bot.gem_count >= minGems then
                        buyPacks()
                        sleep(100)
                    end
                
                    if findItem(nei_itemid_block) < 196 then
                        takeBlockMain()
                        sleep(100)
                        dropGoods()
                    end

                    if findItem(seedID) >= maxSeedInBP then
                        dropItem(seedID)
                        sleep(200)
                    end
        
                    PNBTutorial()
                    sleep(100)

                    callWebhook(nil, nil, nil, gscanFloat(112))
                    sleep(100)
                end
            end
        end

        if not pnbInTutorial or noTutorWorld then
            PNBMain()
        end

    else
        print("ERROR REGISTER")
    end
end
