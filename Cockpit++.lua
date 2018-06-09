----------------------------------------------------------------------------------
--
--                          []                         []
--                          ||   ___     ___     ___   ||
--                          ||  /   \   /| |\   /   \  ||
--                          || |  O  |__|| ||__|  O  | ||
--                          ||  \___/--/^^^^^\--\___/  ||
--                      __  ||________|       |________||  __
--   .-----------------/  \-++--------|   .   |--------++-/  \-----------------.
--  /.---------________|  |___________\__(*)__/___________|  |________---------.\
--            |    |   '$$'   |                       |   '$$'   |    |
--           (o)  (o)        (o)                     (o)        (o)  (o)
--
-- Because we all love the BBBBBBBBRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRTTTTTTTTTTTTTT
--
-- AsciiArt A-10 Thunderbolt II from: Mike Whaley, Georgia Tech, 
-- source: http://xcski.com/~ptomblin/planes.txt
----------------------------------------------------------------------------------







----------------------------------------------------------------------------------
--Pilot, please edit only these three lines
----------------------------------------------------------------------------------
 -- PUT YOUR ANDROID IP(S) in the next line, you will find the Android IP in the app, going in 'settings':
local clientIP={"192.168.2.81"}--, "192.168.0.14", "192.168.0.20", "192.168.0.22"} 
--Several Android devices, for only 1 device enter: local clientIP={"192.168.0.10"}


--Editable but not mandatory, put them in the app
local DCS_PORT = 14801
local ANDROID_PORT = 14800
----------------------------------------------------------------------------------























----------------------------------------------------------------------------------
--Developers, if you know what you are doing, feel free to change things here
----------------------------------------------------------------------------------
local version = 3
local log_file = nil
local lengthIPTable = 0
local ipUsed = 1
local DELAY = 5
local POSITION = 0

local HEAD_MSG = "Cockpit++"
local msgOut =""

local prevLuaExportStart = LuaExportStart

function LuaExportStart()

	if prevLuaExportStart then
        prevLuaExportStart()
    end
	
	lengthIPTable = table.getn(clientIP)

	log_file = io.open(lfs.writedir().."/Logs/Cockpit++_Logger.log", "w")
	
	log_file:write("Opening file")
	log_file:write("\n")

	package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
  	package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
 	
 	socket = require("socket")
 	udp = socket.udp()
	udp:setsockname("*", DCS_PORT)
	udp:setoption('broadcast', true)
	udp:settimeout(0)
end


local RELEASE = 0
local TYPEBUTTON = 0
local DEVICE = 0
local COMMAND = 0
local VALUE = 0

local prevLuaExportBeforeNextFrame = LuaExportBeforeNextFrame

function LuaExportBeforeNextFrame()

	if prevLuaExportBeforeNextFrame then
        prevLuaExportBeforeNextFrame()
    end
	
	if RELEASE == 1 then
		RELEASE = 0
		GetDevice(DEVICE):performClickableAction(COMMAND,1*0)
		
	else
		data, ip, port = udp:receivefrom()
		
		if data then
	  
			local dataArray = string.gmatch(data, '([^,]+)')

			if dataArray(1)==HEAD_MSG then

				TYPEBUTTON = dataArray(2)
				DEVICE = dataArray(3)
				COMMAND = dataArray(4)
				VALUE = dataArray(5)
				
				if TYPEBUTTON == "1" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "2" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "3" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "4" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "5" then
						RELEASE = 1
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "6" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "7" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
			end    
		end
	end

	
end

local prevLuaExportAfterNextFrame = LuaExportAfterNextFrame

function LuaExportAfterNextFrame()

	if prevLuaExportAfterNextFrame then
        prevLuaExportAfterNextFrame()
	end
	
	POSITION = POSITION + 1

	if(POSITION == DELAY) then
		local selfData = LoGetSelfData()
		if selfData then
		
			currentAircraft = selfData["Name"]
        
			msgOut = HEAD_MSG..","..version..","..currentAircraft ..","
			
			
			if currentAircraft == "A-10C" and GetDevice(0) ~= 0 then
     		local MainPanel = GetDevice(0)
     		vvi = MainPanel:get_argument_value(12)
				
				hsi_course = MainPanel:get_argument_value(47)
				hsi_power_off_flag =  MainPanel:get_argument_value(40)
				hsi_range_flag =  MainPanel:get_argument_value(32)
				hsi_bearing_flag =  MainPanel:get_argument_value(46)
				hsi_hdg =  MainPanel:get_argument_value(34)
				hsi_bearing1 =  MainPanel:get_argument_value(33)
				hsi_bearing2 =  MainPanel:get_argument_value(35)
				hsi_hdg_bug =  MainPanel:get_argument_value(36)
				hsi_cc_a =  MainPanel:get_argument_value(37)
				hsi_cc_b =  MainPanel:get_argument_value(39) 
				hsi_rc_a =  MainPanel:get_argument_value(28)
				hsi_rc_b =  MainPanel:get_argument_value(29)
				hsi_rc_c =  MainPanel:get_argument_value(30)
				hsi_rc_d =  MainPanel:get_argument_value(31)
				hsi_deviation =  MainPanel:get_argument_value(41)
				hsi_tofrom1 =  MainPanel:get_argument_value(42)
				hsi_tofrom2 =  MainPanel:get_argument_value(43)
				
				hsi = hsi_course .. ";" ..  hsi_power_off_flag .. ";" ..  hsi_range_flag .. ";" ..  hsi_bearing_flag .. ";" ..  hsi_hdg .. ";" ..  hsi_bearing1 .. ";" ..  hsi_bearing2 .. ";" ..  hsi_hdg_bug .. ";" ..  hsi_cc_a .. ";" ..  hsi_cc_b .. ";" .. hsi_rc_a  .. ";" ..  hsi_rc_b .. ";" ..  hsi_rc_c  .. ";" ..  hsi_rc_d .. ";" ..  hsi_deviation  .. ";" ..  hsi_tofrom1 .. ";" ..  hsi_tofrom2
     		msgOut = msgOut .. vvi .. "," .. hsi .." \n"
				--msgOut(0) Cockpit++ (header)
				--msgOut(1) lua version
				--msgOut(2) aircraft identifier
				--msgOut(3) vvi
				--msgOut(4) hsi ; separated
				
				--[[ HSI table :
					0 = hsi_course
					1 = hsi_power_off_flag
					2 = hsi_range_flag
					3 = hsi_bearing_flag
					4 = hsi_hdg
					5 = hsi_bearing1
					6 = hsi_bearing2
					7 = hsi_hdg_bug
					8 = hsi_cc_a
					9 = hsi_cc_b
					10 = hsi_rc_a
					11 = hsi_rc_b
					12 = hsi_rc_c
					13 = hsi_rc_d
					14 = hsi_deviation
					15 = hsi_tofrom1
					16 = hsi_tofrom2
				]]--
			elseif currentAircraft == "M-2000C" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
  
				pca = MainPanel:get_argument_value(234) ..";".. MainPanel:get_argument_value(463) ..";".. MainPanel:get_argument_value(249) ..";".. MainPanel:get_argument_value(248) ..";".. MainPanel:get_argument_value(236) ..";".. MainPanel:get_argument_value(238) ..";".. MainPanel:get_argument_value(240) ..";".. MainPanel:get_argument_value(242) ..";".. MainPanel:get_argument_value(244) ..";".. MainPanel:get_argument_value(246) ..";".. MainPanel:get_argument_value(247) ..";".. MainPanel:get_argument_value(251) ..";".. MainPanel:get_argument_value(252) ..";".. MainPanel:get_argument_value(254) ..";".. MainPanel:get_argument_value(255) ..";".. MainPanel:get_argument_value(257) ..";".. MainPanel:get_argument_value(258) ..";".. MainPanel:get_argument_value(260) ..";".. MainPanel:get_argument_value(261) ..";".. MainPanel:get_argument_value(263) ..";".. MainPanel:get_argument_value(264)

				ppa = MainPanel:get_argument_value(276) ..";".. MainPanel:get_argument_value(265) ..";".. MainPanel:get_argument_value(277) ..";".. MainPanel:get_argument_value(278) ..";".. MainPanel:get_argument_value(275) ..";".. MainPanel:get_argument_value(267) ..";".. MainPanel:get_argument_value(268) ..";".. MainPanel:get_argument_value(270) ..";".. MainPanel:get_argument_value(271) ..";".. MainPanel:get_argument_value(273) ..";".. MainPanel:get_argument_value(274) ..";".. MainPanel:get_argument_value(280) ..";".. MainPanel:get_argument_value(281)
				
				local insdata = "";
				for line in string.gmatch(list_indication(10), "[^%s]+") do
					insdata = insdata.."\n"..line:sub(-25)	
				end
				
				ins = MainPanel:get_argument_value(669) ..";".. MainPanel:get_argument_value(670) ..";".. MainPanel:get_argument_value(671) ..";".. MainPanel:get_argument_value(564) ..";".. MainPanel:get_argument_value(565) ..";".. MainPanel:get_argument_value(566) ..";".. MainPanel:get_argument_value(567) ..";".. MainPanel:get_argument_value(568) ..";".. MainPanel:get_argument_value(569) ..";".. MainPanel:get_argument_value(574) ..";".. MainPanel:get_argument_value(575) ..";".. MainPanel:get_argument_value(571) ..";".. MainPanel:get_argument_value(668) ..";".. MainPanel:get_argument_value(573) ..";".. MainPanel:get_argument_value(577) ..";".. MainPanel:get_argument_value(579)..";".. MainPanel:get_argument_value(581)..";".. MainPanel:get_argument_value(583)..";".. MainPanel:get_argument_value(595)..";".. MainPanel:get_argument_value(597)

				ins_knob = MainPanel:get_argument_value(627)..";".. MainPanel:get_argument_value(629)
				
				msgOut = msgOut..list_indication(6)..","..list_indication(7)..","..pca..","..list_indication(8)..","..ppa..","..insdata..","..list_indication(11)..","..ins..","..ins_knob..",".." \n"

			elseif currentAircraft == "F-15C" and LoGetTWSInfo() then
				local result_of_LoGetTWSInfo = LoGetTWSInfo()
				if result_of_LoGetTWSInfo then
					local data =""
					local allSpots =""
					local spot =""
					local name =""
					for k,emitter_table in pairs (result_of_LoGetTWSInfo.Emitters) do
						name = LoGetNameByType(emitter_table.Type.level1,emitter_table.Type.level2,emitter_table.Type.level3,emitter_table.Type.level4)
						if name == nil or name == '' then
							name = "UK"
						end
						spot = name .. ":" .. emitter_table.Power .. ":" .. emitter_table.Azimuth .. ":" .. emitter_table.Priority .. ":" .. emitter_table.SignalType .. ":" .. emitter_table.Type.level1 .. ":" .. emitter_table.Type.level2 .. ":" .. emitter_table.Type.level3 .. ":" .. emitter_table.Type.level4
						allSpots = allSpots .. ";" .. spot
					end
					data = result_of_LoGetTWSInfo.Mode .. ",".. allSpots	
					msgOut = msgOut..data
				end
				
			elseif currentAircraft == "UH-1H" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				armament_panel = MainPanel:get_argument_value(252) ..";".. MainPanel:get_argument_value(253) ..";".. MainPanel:get_argument_value(256) ..";".. MainPanel:get_argument_value(257) ..";".. MainPanel:get_argument_value(258) ..";".. MainPanel:get_argument_value(259) ..";".. MainPanel:get_argument_value(260)
				msgOut = msgOut..armament_panel..",".." \n"
		
				
			elseif currentAircraft == "AV8BNA" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				msgOut = msgOut..MainPanel:get_argument_value(487) ..";".. MainPanel:get_argument_value(488) ..",".." \n"
		
			end
			
				
			--log_file:write("\n")
			--log_file:write(msgOut)
			--log_file:write("\n")
			--Sending data to device
			udp:sendto(msgOut, clientIP[ipUsed], ANDROID_PORT)
			
			--To alternate data transmission between several devices
			if ipUsed == lengthIPTable then
				ipUsed = 1
			else
				ipUsed = ipUsed + 1
			end
		end
		POSITION = 0
	end
end

local prevLuaExportStop = LuaExportStop

function LuaExportStop()

	if prevLuaExportStop then
        prevLuaExportStop()
    end
	
   if log_file then
   	log_file:write("Closing log file...")
   	log_file:close()
   	log_file = nil
   end
end




----------------------------------------------------------------------------------
--
--
--     _         Spitfire
--   |   \       Murray "Moray" Lalor
--  | |    \
-- |  |     \                               __---___
-- |  |      \ _____________---------------^      | ^\
--  | | =======--_               ___     \________|__*^--------------__________
--   ^-____                    /  _  \    Capt. Moray  #######     ********  | \
--        * -----_______      (  (_)  )                ###                  _ -'
--                      -------\____ /                                __ - '
--                                   -----======________:----------- '
--
--
-- source: http://xcski.com/~ptomblin/planes.txt