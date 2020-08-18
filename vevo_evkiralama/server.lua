ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DISCORD_WEBHOOK = ""
local DISCORD_NAME = "Vevo'nun Kölesi"
local DISCORD_IMAGE = "https://cdn.discordapp.com/attachments/677985295928655885/708860434022924338/73ec697e-f857-443f-b895-0b8f8aee499b.jpg" -- default is FiveM logo

function sendToDiscord(name, message, color)
  local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
            ["text"] = os.date('!%Y-%m-%d - %H:%M:%S') .. " & Made by Vevo",
            },
        }
    }
  PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('beyefendi:rutinkontrol', function(source, cb)
	
	MySQL.Async.fetchAll('SELECT * FROM vevo_evkiralama',
    {}, function(result)
		
		local HousesData = {}
		
		for key, HouseData in ipairs(result) do
			table.insert(HousesData, {
				["id"] = HouseData.id,
				["owner"] = HouseData.owner,
				["name"] = HouseData.name,
				["daily_price"] = HouseData.daily_price,
				["weekly_price"] = HouseData.weekly_price,
				["login_coords"] = HouseData.login_coords,
				["logout_coords"] = HouseData.logout_coords,
				["dolap_coords"] = HouseData.dolap_coords,
				["blip_rengi"] = HouseData.blip_rengi,
				["kalan_gun"] = HouseData.kalan_gun,
			})
		end
		
		cb(HousesData)
		
    end)
	
	
end)

RegisterServerEvent('vevo:evkontrolbaslat')
AddEventHandler('vevo:evkontrolbaslat', function()
	
	--local xPlayer = ESX.GetPlayerFromId(source)
	--TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Ev verilerini güncelliyoruz. Lütfen bekle!', length = 2000})
	
	local xPlayers = ESX.GetPlayers()
	
	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('vevo:evkontrol', xPlayers[i])
	end
	
end)

ESX.RegisterServerCallback('vevo:evial', function(source, cb, id, price, islem)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount("bank").money >= price then
		
		xPlayer.removeAccountMoney("bank", price)
		if islem == 'daily' then
			MySQL.Sync.execute('UPDATE vevo_evkiralama SET owner = @owner, kalan_gun = @kalan_gun WHERE id = @id', {
				['@owner'] = xPlayer.identifier,
				['@id'] = id,
				['@kalan_gun'] = 1,
			})
			
			--sendToDiscord("Ev Kiralama", "ID: **"..xPlayer.source.."**\nIdentifier: **"..xPlayer.identifier.."**\nMeslek: **"..xPlayer.job.name.."** \nİsim: **" .. xPlayer.name .. "**\nÜcret: **"..price.."**\nGün: **1** \nEv ID: **"..id.."**\nşeklinde **ev** kiraladı.", 16711680)

		elseif islem == 'weekly' then
			MySQL.Sync.execute('UPDATE vevo_evkiralama SET owner = @owner, kalan_gun = @kalan_gun WHERE id = @id', {
				['@owner'] = xPlayer.identifier,
				['@id'] = id,
				['@kalan_gun'] = 7,
			})
			
			--sendToDiscord("Ev Kiralama", "ID: **"..xPlayer.source.."**\nIdentifier: **"..xPlayer.identifier.."**\nMeslek: **"..xPlayer.job.name.."** \nİsim: **" .. xPlayer.name .. "**\nÜcret: **"..price.."**\nGün: **7** \nEv ID: **"..id.."**\nşeklinde **ev** kiraladı.", 16711680)
			
		end
		
		cb(true)
		
	else
		cb(false)
	end
	
end)

ESX.RegisterServerCallback('beyefendi:hexkontrol', function(source, cb)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	
	cb(xPlayer.identifier)
	
end)

ESX.RegisterServerCallback('vevo:evislemleri', function(source, cb, id, yenideger, islem)
	
	if islem == 'isim' then
		MySQL.Sync.execute('UPDATE vevo_evkiralama SET name = @name WHERE id = @id', {
			['@name'] = yenideger,
			['@id'] = id,
		})
		cb(true)
	elseif islem == 'blip' then
		MySQL.Sync.execute('UPDATE vevo_evkiralama SET blip_rengi = @blip_rengi WHERE id = @id', {
			['@blip_rengi'] = yenideger,
			['@id'] = id,
		})
		cb(true)
	elseif islem == 'daily_renting' then
	
		local xPlayer = ESX.GetPlayerFromId(source)
		
		if xPlayer.getAccount("bank").money >= yenideger.daily_price then
			
			xPlayer.removeAccountMoney("bank", yenideger.daily_price)
			
			MySQL.Sync.execute('UPDATE vevo_evkiralama SET kalan_gun = @kalan_gun WHERE id = @id', {
				['@id'] = id,
				['@kalan_gun'] = yenideger.kalan_gun+1,
			})
			
			--sendToDiscord("Ev Uzatma", "ID: **"..xPlayer.source.."**\nIdentifier: **"..xPlayer.identifier.."**\nMeslek: **"..xPlayer.job.name.."** \nİsim: **" .. xPlayer.name .. "**\nÜcret: **"..yenideger.daily_price.."**\nGün: **+1** \nEv ID: **"..id.."**\nşeklinde **evin kirasını** uzattı.", 16711680)
			
			cb(true)
			
		else
			cb(false)
		end
		
	elseif islem == 'weekly_renting' then
	
		local xPlayer = ESX.GetPlayerFromId(source)
		
		if xPlayer.getAccount("bank").money >= yenideger.weekly_price then
			
			xPlayer.removeAccountMoney("bank", yenideger.weekly_price)
			
			MySQL.Sync.execute('UPDATE vevo_evkiralama SET kalan_gun = @kalan_gun WHERE id = @id', {
				['@id'] = id,
				['@kalan_gun'] = yenideger.kalan_gun+7,
			})
			
			--sendToDiscord("Ev Uzatma", "ID: **"..xPlayer.source.."**\nIdentifier: **"..xPlayer.identifier.."**\nMeslek: **"..xPlayer.job.name.."** \nİsim: **" .. xPlayer.name .. "**\nÜcret: **"..yenideger.weekly_price.."**\nGün: **+1** \nEv ID: **"..id.."**\nşeklinde **evin kirasını** uzattı.", 16711680)
			
			cb(true)
			
		else
			cb(false)
		end
	
	elseif islem == 'devret' then
		
		local xPlayer = ESX.GetPlayerFromId(source)
		local yPlayer = ESX.GetPlayerFromId(yenideger)
		
		MySQL.Sync.execute('UPDATE vevo_evkiralama SET owner = @owner WHERE id = @id', {
			['@id'] = id,
			['@owner'] = yPlayer.identifier,
		})
		
		TriggerClientEvent('mythic_notify:client:SendAlert', yPlayer.source, { type = 'inform', text = xPlayer.name..' isimli kişi size evini devretti!', length = 10000})
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = yPlayer.name..' isimli kişiye evinizi devrettiniz.', length = 10000})
		
		cb(true)
		
	end
	
end)

ESX.RegisterServerCallback('vevo:evdemi', function(source, cb, evismi, evsahibi, isminiz, konum)

	local yPlayer = ESX.GetPlayerFromIdentifier(evsahibi)
	
	if yPlayer then
		cb(true)
		TriggerClientEvent('vevo:misafirvar', yPlayer.source, isminiz, evismi, source, konum)
	else
		cb(false)
	end
	
end)

RegisterServerEvent('vevo:islem')
AddEventHandler('vevo:islem', function(islem, gelmekisteyenid, konum)
	
	
	if islem == 'onay' then
		TriggerClientEvent('mythic_notify:client:SendAlert', gelmekisteyenid, { type = 'inform', text = 'Ev sahibi eve gelmenizi onayladı.', length = 10000})
		TriggerClientEvent('vevo:atteleport', gelmekisteyenid, konum)
	elseif islem == 'red' then
		TriggerClientEvent('mythic_notify:client:SendAlert', gelmekisteyenid, { type = 'inform', text = 'Ev sahibi eve gelmenizi istemiyor.', length = 10000})
	elseif islem == 'timeout' then
		TriggerClientEvent('mythic_notify:client:SendAlert', gelmekisteyenid, { type = 'inform', text = 'Ev sahibi cevap vermiyor.', length = 10000})
	end
	
end)

function OneDayDeleteVevo(d, h, m)
	
	
	MySQL.Async.fetchAll("SELECT * FROM vevo_evkiralama WHERE owner != 'kiralik'", {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)
			
			-- message player if connected
			if xPlayer then
				vevogun = result[i].kalan_gun-1
				if vevogun > 0 then
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = result[i].name..' isimli kiralık evinin kalan günü: '..vevogun, length = 20000})
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = result[i].name..' isimli kiralık evinin kira süresi doldu!', length = 20000})
				end
			end
			
			MySQL.Sync.execute('UPDATE vevo_evkiralama SET kalan_gun = @kalan_gun WHERE kalan_gun > 0 AND id = @id', {
				['@id'] = result[i].id,
				['@kalan_gun'] = result[i].kalan_gun-1
			})
			
			MySQL.Sync.execute("UPDATE vevo_evkiralama SET owner = 'kiralik', name = 'Kiralık Ev', blip_rengi = 1 WHERE kalan_gun = 0 AND id = @id", {
				['@id'] = result[i].id,
			})
			
		end
	end)
	
	Citizen.Wait(5000)
	
	local xPlayers = ESX.GetPlayers()
	
	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('vevo:evkontrol', xPlayers[i])
	end
	
end

TriggerEvent('cron:runAt', 23, 44, OneDayDeleteVevo)