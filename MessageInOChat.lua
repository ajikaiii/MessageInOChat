script_name("MessageInOChat")
script_author("by_AJIKAIII")
script_version(2.0)


local inicfg = require 'inicfg'
require "lib.sampfuncs"
require 'lib.moonloader'
--local message = require 'lib.samp.events'
local res,message = pcall(require,'lib.samp.events')
assert(res,'SAMPEV not found')
local message = require "lib.samp.events"

local imgui = require 'imgui'
local vkeys = require 'vkeys'
local fa = require 'fAwesome5'

local encoding = require 'encoding'


local ts = os.clock()
local idMessage = 0
local checkOtkat = 900 --900--время в секундах, через которое производится проверка отката в /o чат (сколько секунд откат)
local fCheckOtkat = os.clock()

local openMenu = false

--print(res,'SAMPEV not found')
--[[
local Timer = false
local textPm
local aidi = 0

function SaveLogChatInO()
  sampSendChat("/pm " .. aidi .." Привет, дом 10кк. Отвечу позже...")
	wait(2000)
	sampSendChat("/showhinfo " .. aidi .."")
  --Дата, время os.date("%c")
  --сохранение в логи
  local file = io.open('moonloader/log/FromChatOInPmLog.txt', 'a')
  --file:write("\n [" .. dt[0] .. "/" .. dt[1] .. "/" .. dt[2] .. "]" .. textPm)
  file:write("\n" .. os.date("%c") .. "  " .. textPm)
  file:close()
end
]]

local fMessage = false
local sent = false
local second = '150' --'150'

local Array
local buff = imgui.ImBuffer(1024)
local time = imgui.ImBuffer(2)

local togooc = false

function newArray (size, value)
		value = value or 0
		local arr = {}
		for i=1, size do
				arr[i] = value
		end
		return arr
end

local string_meta = getmetatable('')

function string_meta:__index( key )
    local val = string[ key ]
    if ( val ) then
        return val
    elseif ( tonumber( key ) ) then
        return self:sub( key, key )
    else
        error( "attempt to index a string value with bad key ('" .. tostring( key ) .. "' is not part of the string library)", 2 )
    end
end

function oedit()
	show_main_window.v = not show_main_window.v
	imgui.Process = show_main_window.v
end

function OpenFile(arg)
	local ip, port = sampGetCurrentServerAddress()
	local serverIpString = string.format("%s:%d", ip, port)
	local _,myid = sampGetPlayerIdByCharHandle(playerPed)
	mynick = sampGetPlayerNickname(myid)

	if not doesDirectoryExist("moonloader/config/MessageInOChat/"..ip) then createDirectory("moonloader/config/MessageInOChat/"..ip) end
	local patchFile = "moonloader/config/MessageInOChat/"..ip.."/"..mynick

	  --file:write("\n [" .. dt[0] .. "/" .. dt[1] .. "/" .. dt[2] .. "]" .. textPm)

	encoding.default = 'UTF-8'
	u8 = encoding.CP1251

	if arg == 1 then
		local file = io.open(patchFile..'.txt', 'r+')
		if file == nil then
			--io.close(file)
			file = io.open(patchFile..'.txt', 'w')
			file = io.open(patchFile..'.txt', 'r+')
		end
		buff.v= file:read('*a')
		--file:write("lol\nlol\n")

	  Data = inicfg.load(nil, "MessageInOChat")
	  if Data  ~= nil then
	  else
	    Data = inicfg.load({Settings = {text = "К. маты по 310к"},}, "MessageInOChat")
	    --sampAddChatMessage(Data.Settings.minut,0x04FDD7)
	    inicfg.save(Data, "MessageInOChat")
	  end
		file:close()
	elseif arg == 2 then
		file = io.open(patchFile..'.txt', 'w')
		file:write(buff.v)
		file:close()
	end

	local ctr = 0
	for _ in io.lines(patchFile..'.txt') do
		ctr = ctr + 1
	end
	Array = newArray(ctr)

	local line = ""
	local i = 0
	for line in io.lines(patchFile..'.txt') do
		Array[i] = u8(line)
		i = i + 1
	end
	encoding.default = 'CP1251'
	u8 = encoding.UTF8
end

local textO = {
	--"Набор в Yakuza Mafia [4 lvl, знание устава]. К. маты по 310к"
}

show_main_window = imgui.ImBool(false)

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
	repeat
      wait(0)
  until sampIsLocalPlayerSpawned()
	sampRegisterChatCommand("oedit", oedit)
  sampAddChatMessage(string.format("Script {F6DB6A}%s {FF9900}loaded. Author: {F6DB6A}AJIKAIII{FF9900}. Использование: {F6DB6A}/oedit",thisScript().name), 0xFF9900)
	print(string.format("Script {F6DB6A}%s {FF9900}loaded. Author: {F6DB6A}AJIKAIII{FF9900}. Использование: {F6DB6A}/oedit",thisScript().name))
	wait(500)
	OpenFile(1)
	--wait(35000)
	ts = os.clock() - second
	fCheckOtkat = os.clock() - checkOtkat

--[[
	if Array[0] ~= nil then
		sent = true
		repeat
			if string.sub(Array[idMessage], 0, 2) ~= "//" then

				sampSendChat('/o ' .. Array[idMessage])
				wait(1000)
				sampSendChat('/o ' .. Array[idMessage])
				ts = os.clock()
				print('ID сообщения '..idMessage+1)
				fMessage = true
			end
			idMessage = idMessage + 1
			if idMessage > #Array-1 then
				idMessage = 0
				fMessage = true
			end
		until fMessage == true
		wait(500)
		sent = false
	end
]]

  while true do
		wait(0)
		if os.clock() - ts > second+1 and Array[0] ~= nil then
			--repeat
				if string.sub(Array[idMessage], 0, 2) ~= "//" then
					if togooc == false then
						sent = true
						--if sent ~= true then
						--sampSendChat('/c ' .. Array[idMessage])
						sampSendChat('/o ' .. Array[idMessage])
						wait(500)
						if os.clock() - fCheckOtkat > checkOtkat+2 and sent == true then
							sampSendChat('/o ' .. Array[idMessage])
							fCheckOtkat = os.clock()
						end
						--else
							--sampSendChat('/c ' .. Array[idMessage])
							--sampAddChatMessage('{FF9900}' .. Array[idMessage])
							--wait(1500)
							--sampSendChat('/c ' .. Array[idMessage])
							--`sampAddChatMessage('{FF9900}' .. Array[idMessage])
						--end
						ts = os.clock()
						print('ID сообщения '..idMessage+1)
						--fMessage = true
						wait(500)
						sent = false
					else
						if os.clock() - fCheckOtkat > checkOtkat+2 then
							--print("yes")
							sampSendChat('/o ' .. Array[idMessage])
							wait(1500)
							togooc = false
						end
					end
				end
				idMessage = idMessage + 1
				if idMessage > #Array-1 then
					idMessage = 0
					--fMessage = true
				end
			--until fMessage == true
		end
		imgui.Process = show_main_window.v
		if show_main_window.v == false and openMenu == true then
			OpenFile(2)
			sampAddChatMessage('{E0FFFF}Объявления в /o чат. {00FF00}Сохранено')
			openMenu = false
		end
  end
end


function message.onServerMessage(color, text)
	--lua_thread.create(function() if not isSampLoaded() or not isSampfuncsLoaded() then return end
	--while not isSampAvailable() do wait(100) end
	--sampAddChatMessage("{FF9900} текст")
	if sent then
		--sampAddChatMessage("{FF9900} да")
		if string.find(text,"Анти(%-)флуд %((%d+).+%)") then
			--sampAddChatMessage("{FF9900} далее")
		  second = string.match(text,"Анти%-флуд %((%d+).+%)")
		  print(second)
		  sent = false
		end
	end
	if string.find(text,"Общий чат недоступен") then
		--print("Недоступен")
		togooc = true
		fCheckOtkat = os.clock()
	elseif string.find(text,"Общий чат был выключен") then
		--print("Выключен")
		togooc = true
		fCheckOtkat = os.clock()
	elseif string.find(text,"Общий чат снова включен") then
		--print("Снова включен")
		togooc = false
	end
  --end)
end

function imgui.OnDrawFrame()
    if show_main_window.v then

				encoding.default = 'CP1251'
				u8 = encoding.UTF8
				openMenu = true

        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 205), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Объявления в /o чат', show_main_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
				--imgui.SameLine(22)
        --imgui.BeginChild("line",imgui.ImVec2(500, 200), true)

				imgui.Text(u8'Введите объявления, которые будут выводиться в /o чат. Каждое объявление с новой строки.\nСколько строк, столько и будет выводиться объявлений попеременно в /o чат с интервалом 2 мин.\nМожно закрыть строку, чтобы она не выводилась в /o чат, поставив // перед строкой')

        imgui.InputTextMultiline('##bufftext', buff, imgui.ImVec2(580, 100))
        --imgui.EndChild()

				if imgui.Button(u8'Сохранить') then
					OpenFile(2)
					sampAddChatMessage('{E0FFFF}Объявления в /o чат. {00FF00}Сохранено')
				end
				--imgui.PushItemWidth(50)
				--imgui.InputText('ddd', time)
				--imgui.PopItemWidth()
        imgui.End()

		end
end

function update()
	local checkVersion = downloadFile("https://raw.githubusercontent.com/Kotovasya/Checker-Captrures/master/Version.ini",
		"config\\MessageInOChat\\Version.ini")
	if checkVersion then
		local ini = inicfg.load({}, "/MessageInOChat/Version")
		os.remove(getWorkingDirectory() .. "/config/MessageInOChat/Version.ini")
		if type(ini) == 'table' and type(ini.Script) == 'table' and ini.Script.Version > tonumber(thisScript().version) then
			sampAddChatMessage(string.format("{FF7F00}[MessageInOChat]:{ffffff} Обнаружена новая версия скрипта, пробуем обновиться...")
				, 0xFF7F00)
			local script = downloadFile("https://raw.githubusercontent.com/Kotovasya/Checker-Captrures/master/CheckerCaptures.lua"
				, "CheckerCaptures.lua")
			if script then
				return true
			else
				sampAddChatMessage(string.format("{FF7F00}[Checker Captures]:{ffffff} Не удалось скачать новую версию :(")
					, 0xFF7F00)
				return false
			end
		else
			return false
		end
	else
		return false
	end
end
