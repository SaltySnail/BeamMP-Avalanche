local track = ""
local possibleTracks = {}
local carNames = {"rocks", "Puck", "steel_coil", "tirestacks", "ball", "blockwall", "engine_props"}

--A chat message was sent
--The sender's ID, the sender's name, and the chat message
function onChatMessage(player_id, player_name, message)
	print("chatMessage: " .. message)
	if string.find(message, "/avalanche ") then
		message = string.gsub(message, "/avalanche ", "")
		print(message)
		if string.find(message, "track %S") then
			MP.TriggerClientEvent(-1, "AVRemoveTrack", "nil")
			track = string.sub(message,7,10000)
			MP.TriggerClientEvent(-1, "AVSpawnTrack", track)
		elseif string.find(message, "list tracks") then
			MP.SendChatMessage(player_id, "Tracks: " .. Util.JsonEncode(possibleTracks))
		elseif string.find(message, "stop") then
			MP.TriggerClientEvent(-1, "AVRemoveTrack", "nil")
			track = ""
		end
		return 1
	end
end

function onPlayerJoin(playerID)
	MP.TriggerClientEvent(playerID, "AVSetObjectsToReset", Util.JsonEncode(carNames))
	if track ~= "" then
		MP.TriggerClientEvent(playerID, "AVSpawnTrack", track)
	end
end

function onInit() 
	MP.RegisterEvent("onChatMessage", "onChatMessage")
	MP.RegisterEvent("onPlayerJoin", "onPlayerJoin")
	
	local file = io.open("Resources/Server/Avalanche/trackNames.json", "r")
	if not file then 
		print("trackNames.json not found")
		return
	end
	possibleTracks = Util.JsonDecode(file:read("*a"))
	file:close()
	print("--------------------Avalanche loaded------------------------")

end