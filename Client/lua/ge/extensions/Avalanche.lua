local M = {} --metatable
local objectsToReset = {}
local trackPrefabObj
local trackPrefabName

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function AVloadHomes(data)
	jbeamNames = jsonDecode(data)
	print(dump(jbeamNames) .. dump(getOwnMap()))
	for ID, veh in pairs(getOwnMap()) do 
		if contains(jbeamNames, veh["jbeam"]) then
			be:getObjectByID(ID):queueLuaCommand("recovery.loadHome()")
		end
	end
end

function AVSetObjectsToReset(data)
	objectsToReset = jsonDecode(data)
end

function AVRemoveTrack()
	print("AVRemoveTrack")
	removePrefab(trackPrefabName)
	extensions['util_trackBuilder_splineTrack'].removeTrack()
end

function AVSpawnTrack(name)
	print("AVSpawnTrack")
	trackPrefabName   = name
	trackPrefabObj    = spawnPrefab(trackPrefabName, "art/" .. name .. ".prefab.json", '0 0 0', '0 0 1', '1 1 1')
	extensions['util_trackBuilder_splineTrack'].load(jsonReadFile("art/" .. name .. ".json"), true, nil, nil, true, false)
end

function onAvalancheResetTrigger(data)
	print(dump(data))
	if data.event ~= "enter" then return end
	for ID, veh in pairs(getOwnMap()) do
		print(ID .. " : " .. dump(veh))
		print(dump(objectsToReset))
		if ID ~= data.subjectID then return end
		if not contains(objectsToReset, veh["jbeam"]) then return end
		be:getObjectByID(ID):queueLuaCommand("recovery.loadHome()")
	end
end

if MPGameNetwork then AddEventHandler("AVSpawnTrack", AVSpawnTrack) end
if MPGameNetwork then AddEventHandler("AVRemoveTrack", AVRemoveTrack) end
if MPGameNetwork then AddEventHandler("AVloadHomes", AVloadHomes) end
if MPGameNetwork then AddEventHandler("AVSetObjectsToReset", AVSetObjectsToReset) end

M.AVloadHomes = AVloadHomes
M.AVSpawnTrack = AVSpawnTrack
M.AVRemoveTrack = AVRemoveTrack
M.AVSetObjectsToReset = AVSetObjectsToReset
M.onAvalancheResetTrigger = onAvalancheResetTrigger

return M --return the metatable	