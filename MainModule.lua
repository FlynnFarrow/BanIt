-- // METADATA
-- Creator: Ty_Scripts
-- Date created: 2/26/2021 16:00 UTC-5
-- More info: -- link --

-- // VARIABLES

local serverBanTable = {} 

local Players = game:GetService("Players")
local DSS = game:GetService("DataStoreService")
local banStore = DSS:GetDataStore("BanStore")

local success, data = pcall(function()
	return banStore:GetAsync("Bans")
end)

if success and not data then
	data = {}
elseif not success then
	warn("DataStore failed. Try turning on Studio Access to API Services.")
end

-- // FUNCTIONS

local function saveData()
	local suc, err = pcall(function()
		return banStore:SetAsync("Bans", data)
	end)
	if not suc and err then
		warn(err)
	elseif suc then
		print("BanIt | Successfully saved")
	end
end

Players.PlayerAdded:Connect(function(plr)
	if table.find(data, plr.UserId) then
		plr:Kick("Banned from the game!")
	end
end)

-- // MODULE

local BanIt = {}

function BanIt.ServerBan(plrUser, reason)
	local plr = plrUser.UserId
	table.insert(serverBanTable, plr)
	plrUser:Kick(reason or "Banned from the server!")
end

function BanIt.Ban(plrUser, reason)
	local plr = plrUser.UserId
	table.insert(data, plr)
	saveData()
	plrUser:Kick(reason or "Banned from the game!")
end

return BanIt
