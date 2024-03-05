bot = getBot()
function pshell2(desc)
  wh = Webhook.new(webhookBal)
  wh.username = NamaBotWebhok
  wh.avatar_url = ProfilBotWebhook
  wh.embed1.use = true
  wh.embed1.title = "DONATION LOGS"
  wh.embed1.footer.text = os.date("!%d %B, %Y at %I:%M %p", os.time() + 7 * 60 * 60)
  wh.embed1.description = desc
  wh.embed1.color = ColorBotWebhook
  wh:send()
end

addEvent(Event.variantlist, function(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" and variant:get(1):getString():find("into the Donation Box") then
        local message = variant:get(1):getString()
		if message:find("into the Donation Box") and (message:find("World Lock") or message:find("Diamond Lock") or message:find("Blue Gem Lock")) then
			if not (message:find("OID") or message:find("CP") or message:find("PL") or message:find("CT") or message:find("SB") or message:find("MSG") or message:find("BC")) then
       			if message:find("World Lock") then
					player = message:match("%[+%p+w+%w+"):sub(6)
					jumlah = message:match("s+%s+%p+%d+"):sub(5)
					paymentTypes = "WorldLock <:WL:1151151006856532058>"
				elseif message:find("Diamond Lock") then
					player = message:match("%[+%p+w+%w+"):sub(6)
					jumlah = message:match("s+%s+%p+%d+"):sub(5)
					paymentTypes = "DiamondLock <a:shinydl:1190166079700475954>"
				elseif message:find("Blue Gem Lock") then
					player = message:match("%[+%p+w+%w+"):sub(6)
					jumlah = message:match("s+%s+%p+%d+"):sub(5)
					paymentTypes = "BlueGemLock <a:shinybgl:1190166261259321466>"
        		end
				pshell2("**[<:Bot:1170169208273903677>] GrowID: " .. player .. " \n[<a:Balance:1172725658330353674>] Amount: " .. jumlah .. " " .. paymentTypes .. " **")
				bot:say("Succesfully Deposit!")
			else
				bot:say("Mau Ngapain Banh?!")
			end
		end
    elseif variant:get(0):getString() == "OnConsoleMessage" and variant:get(1):getString():find("`5<`(.+)`` entered") then
		local message = variant:get(1):getString()
		if not message:find("OID") then
			bot:say("`1Welcome `" .. message:gsub("`", ""):match("<(.+) entered") .. " `3To `#".. World)
		end
    end
end)

pshell2("DONATION LOG ONLINE!")
while true do
	if bot.status ~= 1 then
		bot:connect()
		unlistenEvents()
		sleep(30000)
	else
		if bot:isInWorld(World) then
			listenEvents(30)
		else
			unlistenEvents()
			bot:warp(World)
			sleep(5000)
		end
	end
end
