local bots = getBot() 
local logs = bots:getLog() 
local inventory = bots:getInventory()
for _,data in pairs(getBots()) do
    if bots.name:upper() == data.name:upper() then
        index_client = _
    end
end
local count_door = 0
for _ in pairs(door_setting) do
    count_door = count_door + 1
end
LuciferClient['client'] = LuciferClient[index_client]
local total_world = LuciferClient['client'].total_world 
local world_total = 0
local total_lock = total_world 
local total_jammer = total_world 
local total_entrance = total_world * 2
local total_door = count_door * total_world
local total_platform = count_door * total_world

bots.move_interval = 100
bots.move_range = 8
bots.collect_range = 3
bots.collect_interval = 100
bots.legit_mode = false 
bots.auto_collect = false 
local door_plat = {}
for index, data in pairs(door_setting) do
    table.insert(
        door_plat,
        {
            doorId = tostring(index),
            door = { x = data.x - 1, y = data.y - 1 },
            plat = { x = data.x - 1, y = data.y + 0 }
        }
    )
end

function log(text)
    local file = io.open(file_name .. '.txt','a')
    file:write(text.."\n")
    file:close()
    sleep(50)
end

function Random(banyak_huruf)
    local char = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    local hasil = {}
    for i = 1,banyak_huruf do
        local index = math.random(#char)
        hasil[i] = char:sub(index , index)
    end
    return table.concat(hasil)
end

function warp(world,id)
    while not bots:isInWorld(world:upper()) do
        bots:warp(world:upper())
        sleep(5000)
    end
    if id and bots:isInWorld(world:upper()) then
        while bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32),math.floor(bots:getWorld():getLocal().posy / 32)).fg == 6 do
            bots:warp(world,id)
            sleep(2500)
        end
    end
end

function scanfloat(id)
    local count = 0
    for __,_ in pairs(bots:getWorld():getObjects()) do
        if _.id == id then
            count = count + _.count 
        end
    end
    return count 
end

function performCollect(x,y,id)
    local packet = GameUpdatePacket.new()
    packet.type = 11
    packet.int_data = id
	packet.pos_x = x
	packet.pos_y = y
	bots:sendRaw(packet)
end

function collectItem(id)
    for _,obj in pairs(bots:getWorld():getObjects()) do
        if obj.id == id then
            if math.abs(bots:getWorld():getLocal().posx - obj.x) < 100 and math.abs(bots:getWorld():getLocal().posy - obj.y) < 100 then
                performCollect(obj.x,obj.y,obj.oid)
                sleep(50)
            end
        end
    end
end

function cekLock()
    local List_Lock = {202,204,206,242,1796,7188,9640,4802,5814,8470,5980,2950,5260,4482,2408,10410,11550,11586}
    for _,lock in pairs(List_Lock) do
        for _,tile in pairs(bots:getWorld():getTiles()) do
            if tile.fg == lock then
                return true 
            end
        end
    end
    return false 
end

function takefloat(id)
    if bots:isInWorld() then
        for _,obj in pairs(bots:getWorld():getObjects()) do
            if obj.id == id then
                if getInfo(bots:getWorld():getTile(math.floor(obj.x / 32),math.floor(obj.y / 32)).fg).collision_type == 0 then
                    while not bots:isInTile(math.floor(obj.x / 32),math.floor(obj.y / 32)) do
                        reconnect() 
                        bots:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                        sleep(100)
                    end
                    collectItem(id)
                    sleep(100)
                    if bots:getInventory():getItemCount(id) > 0 then
                        break 
                    end
                end
            end
        end
    end
end

function reconnect()
    if bots.status ~= BotStatus['online'] then
        while bots.status == 8 do
            sleep(60000)
            bots:connect()
        end
        bots.auto_reconnect = false 
        repeat
            bots:connect()
            sleep(10000)
        until bots.status == BotStatus['online'] or bots.status == BotStatus['account_banned'] or bots.status == BotStatus['wrong_password'] or bots.status == BotStatus['captcha_requested']
        if bots.status == BotStatus['online'] then
            bots.auto_reconnect = false 
        end
    end
end

function takeMaterial()
    local s_name,s_door = string.match(storage_material,'(.-):(.+)')
    sleep(10000 * (index_client - 1))
    bots.auto_collect = false 
    warp(s_name,s_door)
    if bots:isInWorld(s_name:upper()) then
        if bots:getInventory():getItemCount(material_setting.lock) < total_lock then
            if scanfloat(material_setting.lock) < total_lock then
                print('Lock are not enought!')
                error('Lock are not enought!')
            else
                takefloat(material_setting.lock)
            end
        end
        while bots:getInventory():getItemCount(material_setting.lock) > total_lock do
            bots:drop(material_setting.lock,(bots:getInventory():getItemCount(material_setting.lock) - total_lock))
            sleep(1000)
            if bots:getInventory():getItemCount(material_setting.lock) > total_lock then
                bots:moveTo(1,0)
                sleep(1000)
            end
        end

        if bots:getInventory():getItemCount(material_setting.door) < total_door then
            if scanfloat(material_setting.door) < total_door then
                print('Door are not enought!')
                error('Door are not enought!')
            else
                takefloat(material_setting.door)
            end
        end
        while bots:getInventory():getItemCount(material_setting.door) > total_door do
            bots:drop(material_setting.door,(bots:getInventory():getItemCount(material_setting.door) - total_door))
            sleep(1000)
            if bots:getInventory():getItemCount(material_setting.door) > total_door then
                bots:moveTo(1,0)
                sleep(1000)
            end
        end

        if bots:getInventory():getItemCount(material_setting.entrance) < total_entrance then
            if scanfloat(material_setting.entrance) < total_entrance then
                print('Entrance are not enought!')
                error('Entrance are not enought!')
            else
                takefloat(material_setting.entrance)
            end
        end
        while bots:getInventory():getItemCount(material_setting.entrance) > total_entrance do
            bots:drop(material_setting.entrance,(bots:getInventory():getItemCount(material_setting.entrance) - total_entrance))
            sleep(1000)
            if bots:getInventory():getItemCount(material_setting.entrance) > total_entrance then
                bots:moveTo(1,0)
                sleep(1000)
            end
        end

        if bots:getInventory():getItemCount(material_setting.jammer) < total_jammer then
            if scanfloat(material_setting.jammer) < total_jammer then
                print('Jammer are not enought!')
                error('Jammer are not enought!')
            else
                takefloat(material_setting.jammer)
            end
        end
        while bots:getInventory():getItemCount(material_setting.jammer) > total_jammer do
            bots:drop(material_setting.jammer,(bots:getInventory():getItemCount(material_setting.jammer) - total_jammer))
            sleep(1000)
            if bots:getInventory():getItemCount(material_setting.jammer) > total_jammer then
                bots:moveTo(1,0)
                sleep(1000)
            end
        end

        if bots:getInventory():getItemCount(material_setting.plat) < total_platform then
            if scanfloat(material_setting.plat) < total_platform then
                print('Platform are not enought!')
                error('Platform are not enought!')
            else
                takefloat(material_setting.plat)
            end
        end
        while bots:getInventory():getItemCount(material_setting.plat) > total_platform do
            bots:drop(material_setting.plat,(bots:getInventory():getItemCount(material_setting.plat) - total_platform))
            sleep(1000)
            if bots:getInventory():getItemCount(material_setting.plat) > total_platform then
                bots:moveTo(1,0)
                sleep(1000)
            end
        end
    end
end

function dropMaterial(drop_all)
    local s_name,s_door = string.match(storage_material,'(.-):(.+)')
    bots.auto_collect = false 
    warp(s_name,s_door)
    while bots:getInventory():getItemCount(material_setting.lock) > total_lock do
        bots:drop(material_setting.lock,(bots:getInventory():getItemCount(material_setting.lock) - total_lock))
        sleep(1000)
        if bots:getInventory():getItemCount(material_setting.lock) > total_lock then
            bots:moveTo(1,0)
            sleep(1000)
        end
    end
    while bots:getInventory():getItemCount(material_setting.door) > total_door do
        bots:drop(material_setting.door,(bots:getInventory():getItemCount(material_setting.door) - total_door))
        sleep(1000)
        if bots:getInventory():getItemCount(material_setting.door) > total_door then
            bots:moveTo(1,0)
            sleep(1000)
        end
    end
    while bots:getInventory():getItemCount(material_setting.entrance) > total_entrance do
        bots:drop(material_setting.entrance,(bots:getInventory():getItemCount(material_setting.entrance) - total_entrance))
        sleep(1000)
        if bots:getInventory():getItemCount(material_setting.entrance) > total_entrance then
            bots:moveTo(1,0)
            sleep(1000)
        end
    end
    while bots:getInventory():getItemCount(material_setting.jammer) > total_jammer do
        bots:drop(material_setting.jammer,(bots:getInventory():getItemCount(material_setting.jammer) - total_jammer))
        sleep(1000)
        if bots:getInventory():getItemCount(material_setting.jammer) > total_jammer then
            bots:moveTo(1,0)
            sleep(1000)
        end
    end
    while bots:getInventory():getItemCount(material_setting.plat) > total_platform do
        bots:drop(material_setting.plat,(bots:getInventory():getItemCount(material_setting.plat) - total_platform))
        sleep(1000)
        if bots:getInventory():getItemCount(material_setting.plat) > total_platform then
            bots:moveTo(1,0)
            sleep(1000)
        end
    end
end

function kerjaaa(world)
    warp(world)
    for _,data in pairs(door_plat) do
        if bots:getWorld():getTile(data.door.x,data.door.y).fg == 0 and getInfo(bots:getWorld():getTile(data.door.x,data.door.y).fg).collision_type == 0 then
            local path = { x = data.door.x,y = data.door.y }
            if path.x and path.y then
                while bots:isInWorld(world:upper()) and not bots:isInTile(path.x,path.y) do
                    bots:findPath(path.x,path.y)
                    sleep(100)
                    reconnect()
                end
                if bots:isInTile(path.x,path.y) then
                    while bots:getWorld():getTile(data.door.x,data.door.y).fg == 0 do
                        bots:place(data.door.x,data.door.y,material_setting.door)
                        sleep(180)
                        reconnect()
                    end
                    while bots:getWorld():getTile(data.plat.x,data.plat.y).fg == 0 do
                        bots:place(data.plat.x,data.plat.y,material_setting.plat)
                        sleep(180)
                        reconnect()
                    end
                    for i = 1,2 do
                        if bots:getWorld():getTile(data.door.x,data.door.y).fg == material_setting.door then
                            bots:wrench(data.door.x,data.door.y)
                            sleep(1100)
                            bots:sendPacket(2,"action|dialog_return\ndialog_name|door_edit\ntilex|" .. data.door.x .. "|\ntiley|" .. data.door.y .. "|\ndoor_name|\ndoor_target|\ndoor_id|" .. data.doorId .."\ncheckbox_locked|1")
                            sleep(1000)
                        end
                    end
                    log(world:upper().. ':' .. data.doorId)
                end
            end
        end
    end
end

takeMaterial()




while world_total < total_world do
    local world_ = Random(10)
    warp(world_)
    if bots:isInWorld(world_:upper()) then
        if not cekLock() then
            if  bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32),math.floor(bots:getWorld():getLocal().posy / 32) - 1).fg == 0 and
                bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) - 1,math.floor(bots:getWorld():getLocal().posy / 32) ).fg == 0 and 
                bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) ).fg == 0 and 
                bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) - 1 ).fg == 0 then
                while bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) - 1).fg == 0 do
                    bots:place(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) - 1,material_setting.jammer)
                    sleep(200)
                end
                while bots:getPing() > 100 do sleep(1000) end
                bots:hit(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) - 1)
                sleep(500)
                while bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32),math.floor(bots:getWorld():getLocal().posy / 32) - 1).fg == 0 do
                    bots:place(math.floor(bots:getWorld():getLocal().posx / 32),math.floor(bots:getWorld():getLocal().posy / 32) - 1,material_setting.lock)
                    sleep(200)
                end
                while bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) - 1,math.floor(bots:getWorld():getLocal().posy / 32)).fg == 0 do
                    bots:place(math.floor(bots:getWorld():getLocal().posx / 32) - 1,math.floor(bots:getWorld():getLocal().posy / 32),material_setting.entrance)
                    sleep(200)
                end
                while bots:getWorld():getTile(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32)).fg == 0 do
                    bots:place(math.floor(bots:getWorld():getLocal().posx / 32) + 1,math.floor(bots:getWorld():getLocal().posy / 32) ,material_setting.entrance)
                    sleep(200)
                end
                print(world_)
                kerjaaa(world_)
                world_total = world_total + 1
            end
        end
    end
end
