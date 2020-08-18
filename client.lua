local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

fullname = 'null'
SikkoEvDatamiz = 'vevo'
EvDatamiz = 'vevo'

ESX = nil

NedirLanBenimHexim = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(1000)
	vevocheck()
	
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Citizen.Wait(5000)
    vevocheck()
end)

RegisterNetEvent('vevo:evkontrol')
AddEventHandler('vevo:evkontrol', function()
    vevocheck()
end)

RegisterNetEvent('vevo:atteleport')
AddEventHandler('vevo:atteleport', function(konum)
	ESX.Game.Teleport(PlayerPedId(), konum)
end)

function vevocheck()
	
	local naber = GetPlayerServerId(PlayerId())
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		fullname = data.firstname..' '..data.lastname
	end, naber)
	
	SikkoEvDatamiz = nil
	EvDatamiz = {}
	
	ESX.TriggerServerCallback('beyefendi:hexkontrol', function(responsev2)
		NedirLanBenimHexim = responsev2
	end)
	
	ESX.TriggerServerCallback('beyefendi:rutinkontrol', function(response)
		SikkoEvDatamiz = response
	end)
	
	Citizen.Wait(1000)
	
	for key, House in ipairs(SikkoEvDatamiz) do
		
		if House.owner == NedirLanBenimHexim then
			table.insert(EvDatamiz, {
				["myhouse"] = 1,
				["id"] = House.id,
				["owner"] = House.owner,
				["name"] = House.name,
				["daily_price"] = House.daily_price,
				["weekly_price"] = House.weekly_price,
				["login_coords"] = json.decode(House.login_coords),
				["logout_coords"] = json.decode(House.logout_coords),
				["dolap_coords"] = json.decode(House.dolap_coords),
				["blip_rengi"] = House.blip_rengi,
				["kalan_gun"] = House.kalan_gun,
			})
		else
			table.insert(EvDatamiz, {
				["id"] = House.id,
				["owner"] = House.owner,
				["name"] = House.name,
				["daily_price"] = House.daily_price,
				["weekly_price"] = House.weekly_price,
				["login_coords"] = json.decode(House.login_coords),
				["logout_coords"] = json.decode(House.logout_coords),
				["dolap_coords"] = json.decode(House.dolap_coords),
				["blip_rengi"] = House.blip_rengi,
				["kalan_gun"] = House.kalan_gun,
			})
		end
		
	end
	
	hoplabakalim()
	
end			

function hoplabakalim()

	Citizen.CreateThread(function()
		
		for key, HouseData in ipairs(EvDatamiz) do
						
			local key = AddBlipForCoord(HouseData.login_coords.x, HouseData.login_coords.y, HouseData.login_coords.z)

			SetBlipSprite(key, 369)
			SetBlipDisplay(key, 4)
			SetBlipScale (key, 0.7)
			SetBlipColour(key, HouseData.blip_rengi)
			SetBlipAsShortRange(key, true)
			BeginTextCommandSetBlipName("STRING")
			if HouseData.name == 'Kiralık Ev' then
				AddTextComponentString(HouseData.name..'-'..HouseData.id)
			else
				AddTextComponentString(HouseData.name)
			end
			EndTextCommandSetBlipName(key)
			
		end
		
		while true do
			Citizen.Wait(0)
			
			letSleep = true
			local coords = GetEntityCoords(GetPlayerPed(-1))
			
			for key, HouseData in ipairs(EvDatamiz) do
			
				local login_uzaklik = GetDistanceBetweenCoords(coords, HouseData.login_coords.x, HouseData.login_coords.y, HouseData.login_coords.z, true)
				local logout_uzaklik = GetDistanceBetweenCoords(coords, HouseData.logout_coords.x, HouseData.logout_coords.y, HouseData.logout_coords.z, true)
								
				if login_uzaklik < 15.0 then
					
					letSleep = false
					DrawScriptMarker({["type"] = 6,["pos"] = vector3(HouseData.login_coords.x, HouseData.login_coords.y, HouseData.login_coords.z),["r"] = 45,["g"] = 121,["b"] = 226,["sizeX"] = 1.5,["sizeY"] = 1.5,["sizeZ"] = 1.5})
					
					if login_uzaklik <= 1.5 and not acti then
						drawTxt('~w~Eve Girmek Için ~b~E~w~ Bas.')
						if IsControlJustReleased(0, 38) then
							vevomenudeyizknk(HouseData)
						end
					elseif login_uzaklik >= 1.5 and acti then
						ESX.UI.Menu.CloseAll()
						acti = false
					end
					
				end
				
				
				if logout_uzaklik < 15.0 then
					
					letSleep = false
					DrawScriptMarker({["type"] = 6,["pos"] = vector3(HouseData.logout_coords.x, HouseData.logout_coords.y, HouseData.logout_coords.z),["r"] = 45,["g"] = 121,["b"] = 226,["sizeX"] = 1.5,["sizeY"] = 1.5,["sizeZ"] = 1.5})
					
					if logout_uzaklik <= 1.5 then
						drawTxt('~w~Evden Çıkmak Için ~b~E~w~ Bas.')
						if IsControlJustReleased(0, 38) then
							ESX.Game.Teleport(PlayerPedId(), HouseData.login_coords)
						end
					end
					
				end
				
				if HouseData.myhouse then
				
					local dolap_uzaklik = GetDistanceBetweenCoords(coords, HouseData.dolap_coords.x, HouseData.dolap_coords.y, HouseData.dolap_coords.z, true)

					if dolap_uzaklik < 10.0 then
					
						letSleep = false
						DrawScriptMarker({["type"] = 6,["pos"] = vector3(HouseData.dolap_coords.x, HouseData.dolap_coords.y, HouseData.dolap_coords.z),["r"] = 255,["g"] = 0,["b"] = 0,["sizeX"] = 1.0,["sizeY"] = 1.0,["sizeZ"] = 1.0})
						
						if dolap_uzaklik <= 1.1 and not acti then
							drawTxt('~w~Dolaba Ulasmak Için ~r~E~w~ Bas.')
							if IsControlJustReleased(0, 38) then
								SexStarting(HouseData)
							end
						end
					
					end
					
				end
				
			end
			
			if letSleep then
				Citizen.Wait(1000)
			end
		
		end
		
	end)
	
end

acti = false
timeout = false

function vevomenudeyizknk(veri)
	
	-- print(json.encode(veri))
	
	acti = true
	
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	
	if veri.myhouse then
		table.insert(elements, {label = 'Evime Gir',  value = 'evimegir'})
	elseif veri.owner == 'kiralik' then
		-- table.insert(elements, {label = 'Evi Yürüyerek Gez',  value = 'yuruyerekgez'})
		table.insert(elements, {label = 'Evi Kamerayla Gez',  value = 'kameraylagez'})
		table.insert(elements, {label = '1 Günlük - $'..veri.daily_price,  value = 'gunlukal'})
		table.insert(elements, {label = '7 Günlük - $'..veri.weekly_price,  value = 'haftalikal'})
	else
		table.insert(elements, {label = 'Eve Girme İsteği Gönder',  value = 'girmeistegi'})
	end
	
	if veri.name == 'Kiralık Ev' then
		mytitle = 'Ev: '..veri.name..'-'..veri.id
	else
		mytitle = 'Ev: '..veri.name
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'housev1', {
		title    = mytitle,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
				
		if data.current.value == 'evimegir' then
			ESX.Game.Teleport(PlayerPedId(), veri.logout_coords)
			menu.close()
			acti = false
		elseif data.current.value == 'yuruyerekgez' then
			ESX.Game.Teleport(PlayerPedId(), veri.logout_coords)
			menu.close()
			acti = false
		elseif data.current.value == 'kameraylagez' then
		
			ESX.TriggerServerCallback('vevo_sudabozulma:telkontrol', function(response)
				if response then
					ExecuteCommand("e telefon")
					TriggerEvent('vevo:evkamerasi', veri.id)
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Telefonun yok!', length = 5000})
				end
			end)
			
		elseif data.current.value == 'gunlukal' then
			
			menu.close()
			
			-- TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'İşlemler yapılıyor, lütfen bekle!', length = 5000})
			
			ESX.TriggerServerCallback('vevo:evial', function(response)
				if response then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = veri.name..' isimli evi 1 günlüğüne bankandan $'..veri.daily_price..' ödeyerek kiraladın!', length = 5000})
					TriggerServerEvent('vevo:evkontrolbaslat')
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanda yeterli para yok!', length = 5000})
				end
			end, veri.id, veri.daily_price, 'daily')
			
			acti = false
			
		elseif data.current.value == 'haftalikal' then
		
			menu.close()
			
			-- TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'İşlemler yapılıyor, lütfen bekle!', length = 5000})
			
			ESX.TriggerServerCallback('vevo:evial', function(response)
				if response then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = veri.name..' isimli evi 7 günlüğüne bankandan $'..veri.weekly_price..' ödeyerek kiraladın!', length = 5000})
					TriggerServerEvent('vevo:evkontrolbaslat')
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanda yeterli para yok!', length = 5000})
				end
			end, veri.id, veri.daily_price, 'weekly')
			
			acti = false
			
		elseif data.current.value == "girmeistegi" then
			if not timeout then
			
				ESX.TriggerServerCallback('vevo:evdemi', function(response)
					if response then
						
						menu.close()
						acti = false
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'İstek başarıyla gönderildi.', length = 5000})
						timeout = true
						Citizen.CreateThread(function ()
							Citizen.Wait(17000)
							timeout = false
						end)
						
					else
					
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Ev sahibi şehirde değil!', length = 5000})
					
					end
				end, veri.name, veri.owner, fullname, veri.logout_coords)
				
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Biraz yavaşla! Zaten istek gönderdin!', length = 5000})
			end
		end

	end, function(data, menu)
		menu.close()
		acti = false
	end)

end

RegisterNetEvent('vevo:misafirvar')
AddEventHandler('vevo:misafirvar', function(gelmekisteyenismi, evismi, gelmekisteyenid, konum)

    Goster = true
	Sonuclandi = false
	Citizen.CreateThread(function ()
		Citizen.Wait(15000)
		if not Sonuclandi then
			Goster = false
			TriggerServerEvent('vevo:islem', 'timeout', gelmekisteyenid, konum)
		end
	end)
	
	Citizen.CreateThread(function ()
		while Goster do
			Citizen.Wait(0)
			drawTxt('~r~'..gelmekisteyenismi..' ~w~adlı kisi ~g~'..evismi..' ~w~isimli evinize gelmek istiyor.')
			ESX.ShowHelpNotification("Onaylamak için ~INPUT_PICKUP~ ve Red etmek için ~INPUT_VEH_HEADLIGHT~ basmalısınız.")
			
			if IsControlJustPressed(0, Keys['E']) then
				TriggerServerEvent('vevo:islem', 'onay', gelmekisteyenid, konum)
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = gelmekisteyenismi..' adlı kişi evinize girdi.', length = 5000})
				Sonuclandi = true
				Goster = false
			elseif IsControlJustPressed(0, Keys['H']) then
				TriggerServerEvent('vevo:islem', 'red', gelmekisteyenid, konum)
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = gelmekisteyenismi..' adlı kişi evinize giremedi.', length = 5000})
				Sonuclandi = true
				Goster = false
			end
			
		end
	end)
	
						
end)

function SexStarting(veri)
	
	acti = true
	
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	
	table.insert(elements, {label = 'Depo',  value = 'depo'})
	table.insert(elements, {label = 'Kayıtlı Kıyafetlerim',  value = 'kiyafet'})
	table.insert(elements, {label = 'Ev Detayları',  value = 'detaylar'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'housev2', {
		title    = 'Ev: '..veri.name,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		
		if data.current.value == 'depo' then
			menu.close()
			TriggerEvent("disc-inventoryhud:stash", "EV-"..veri.id.."")
			acti = false
		elseif data.current.value == 'kiyafet' then
			menu.close()
			
			ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerDressing', function(dressing)

			  local elements = {}

			  for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			  end

			  ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'dresss',
				{
				  title    = 'Kayıtlı Kıyafetlerim',
				  align    = 'top-left',
				  elements = elements,
				},
				function(data, menu)

				  TriggerEvent('skinchanger:getSkin', function(skin)

					ESX.TriggerServerCallback('esx_eden_clotheshop:getPlayerOutfit', function(clothes)

					  TriggerEvent('skinchanger:loadClothes', skin, clothes)
					  TriggerEvent('esx_skin:setLastSkin', skin)

					  TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					  end)
					  
					  exports['mythic_notify']:DoHudText('success', 'Kombini kullandın.')

					end, data.current.value)

				  end)

				end,
				function(data, menu)
				  menu.close()
				  acti = false
				  SexStarting(veri)
				end
			  )

			end)
			
		elseif data.current.value == 'detaylar' then
			
			menu.close()
			Detaylar(veri)
			
		end

	end, function(data, menu)
		menu.close()
		acti = false
	end)
	
end

function Detaylar(veri)
	
	acti = true
	
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	
	table.insert(elements, {label = 'Sahibi: <span style="color: #ff3f3f">'..veri.owner,  value = 'owner'})
	table.insert(elements, {label = 'İsim: <span style="color: #8e54c4">'..veri.name,  value = 'isim'})
	table.insert(elements, {label = 'Günlük Fiyatı: <span style="color: green">$'..veri.daily_price,  value = 'daily_price'})
	table.insert(elements, {label = 'Haftalık Fiyatı: <span style="color: green">$'..veri.weekly_price,  value = 'weekly_price'})
	table.insert(elements, {label = 'Blip Rengi: <span style="color: #e047db">'..veri.blip_rengi,  value = 'blip_rengi'})
	table.insert(elements, {label = 'Kalan Gün: <span style="color: #dae060">'..veri.kalan_gun,  value = 'kalan_gun'})
	table.insert(elements, {label = '<span style="color: #000000"> ====================',  value = 'kalan_gun'})
	table.insert(elements, {label = 'İsmi Değiştir',  value = 'ismidegistir'})
	table.insert(elements, {label = 'Blip Rengini Değiştir',  value = 'bliprenginidegistir'})
	table.insert(elements, {label = '1 Gün Uzat',  value = '1gunuzat'})
	table.insert(elements, {label = '7 Gün Uzat',  value = '7gunuzat'})
	table.insert(elements, {label = 'Evi Yanındakine Ver',  value = 'yanindakinever'})
	table.insert(elements, {label = 'Güvenlik Kameralarının CD\'si',  value = 'cd'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'housev3', {
		title    = 'Ev: '..veri.name,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		
		if data.current.value == 'ismidegistir' then
			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'isimv1', {
				title = 'Yeni İsim Ne Olsun?'
			}, function(data2, menu2)
				local isim = tostring(data2.value)

				if isim == 'nil' then
					ESX.ShowNotification('Geçersiz İsim!')
				else
					menu2.close()
					
					ESX.TriggerServerCallback('vevo:evislemleri', function(response)
						if response then
							veri.name = isim
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Başarılı bir şekilde ev ismi '..isim..' oldu. Res sonrası herkeste gözükecektir.', length = 5000})
							-- TriggerServerEvent('vevo:evkontrolbaslat')
							menu.close()
							Detaylar(veri)
						end
					end, veri.id, isim, 'isim')
					
				end
			end, function(data2, menu2)
				menu2.close()
				Detaylar(veri)
			end)
			
		elseif data.current.value == 'bliprenginidegistir' then
		
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'isimv1', {
				title = 'Yeni Renk Ne Olsun? (Numaratik)'
			}, function(data2, menu2)
				local renk_number = tonumber(data2.value)

				if renk_number == nil then
					ESX.ShowNotification('Geçersiz Numara!')
				else
					menu2.close()
					
					ESX.TriggerServerCallback('vevo:evislemleri', function(response)
						if response then
							veri.blip_rengi = renk_number
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Başarılı bir şekilde blip rengi '..renk_number..' oldu. Res sonrası herkeste gözükecektir.', length = 5000})
							--TriggerServerEvent('vevo:evkontrolbaslat')
							menu.close()
							Detaylar(veri)
						end
					end, veri.id, renk_number, 'blip')
					
				end
			end, function(data2, menu2)
				menu2.close()
				Detaylar(veri)
			end)
		
		elseif data.current.value == '1gunuzat' then
		
			ESX.TriggerServerCallback('vevo:evislemleri', function(response)
				if response then

					veri.kalan_gun = veri.kalan_gun + 1
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Başarılı bir şekilde 1 gün uzattınız!', length = 5000})
					--TriggerServerEvent('vevo:evkontrolbaslat')
					menu.close()
					Detaylar(veri)
					
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanda yeteri kadar para yok!', length = 5000})
				end
			end, veri.id, veri, 'daily_renting')
			
		elseif data.current.value == '7gunuzat' then
		
			ESX.TriggerServerCallback('vevo:evislemleri', function(response)
				if response then

					veri.kalan_gun = veri.kalan_gun + 7
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Başarılı bir şekilde 7 gün uzattınız!', length = 5000})
					--TriggerServerEvent('vevo:evkontrolbaslat')
					menu.close()
					Detaylar(veri)
				
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bankanda yeteri kadar para yok!', length = 5000})
				end
			end, veri.id, veri, 'weekly_renting')
		
		elseif data.current.value == 'yanindakinever' then
		
			local player, distance = ESX.Game.GetClosestPlayer()
			
			if distance ~= -1 and distance <= 3.0 then
				
				menu.close()
				acti = false
				
				hello = GetPlayerServerId(player)
				
				ESX.TriggerServerCallback('vevo:evislemleri', function(response)
					if response then
						TriggerServerEvent('vevo:evkontrolbaslat')
					end
				end, veri.id, hello, 'devret')
				
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Yakınında oyuncu yok!', length = 5000})
			end
		elseif data.current.value == 'cd' then
			ESX.TriggerServerCallback('vevo_sudabozulma:telkontrol', function(response)
				if response then
					menu.close()
					acti = false
					ExecuteCommand("e telefon")
					TriggerEvent('vevo:evkamerasi', veri.id)
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Telefonun yok!', length = 5000})
				end
			end)
		
		end

	end, function(data, menu)
		menu.close()
		acti = false
		SexStarting(veri)
	end)
	
end


-- Started | Functions of Vevo --

function drawTxt(text)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(1.0, 1.0)
	SetTextCentre(1)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5, 0.93)
end

DrawScriptMarker = function(markerData)
	DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

function Draw3DText2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = 0.9
   
    if onScreen then
        SetTextScale(0.0*scale, 0.25*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(0, 0, 0, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.030+ factor, 0.03, 41, 11, 41, 100)
    end
end

-- Finished | Functions of Vevo --