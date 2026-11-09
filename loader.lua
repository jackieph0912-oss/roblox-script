-- Roblox Studio > ServerScriptService
-- One key can be claimed by exactly one Roblox UserId.
-- DataStore MUST be enabled in Studio API Services for Studio testing.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local STORE = DataStoreService:GetDataStore("AppleFarmSingleUseKeys_v1")
local VALID_KEYS = {
    ["kjZzYz4Bnee6prJX"] = true,
    ["KoBd63iyUzQvPtyO"] = true,
    ["o96Vl9L5TTgGz9Bo"] = true,
    ["GrDilD2RPAyqFgxJ"] = true,
    ["rBxzUH1MDKlukDdy"] = true,
}

local remote = ReplicatedStorage:FindFirstChild("AppleFarmRedeemKey")
if not remote then
    remote = Instance.new("RemoteFunction")
    remote.Name = "AppleFarmRedeemKey"
    remote.Parent = ReplicatedStorage
end

local lastAttempt = {}
remote.OnServerInvoke = function(player, rawKey)
    if type(rawKey) ~= "string" or #rawKey > 100 then
        return false, "Invalid key"
    end
    local key = rawKey:match("^%s*(.-)%s*$")
    if not VALID_KEYS[key] then
        return false, "Invalid key"
    end

    local now = os.clock()
    if lastAttempt[player.UserId] and now - lastAttempt[player.UserId] < 1 then
        return false, "Please wait before retrying"
    end
    lastAttempt[player.UserId] = now

    local ok, record = pcall(function()
        return STORE:UpdateAsync("redeemed_" .. key, function(old)
            if old ~= nil then return old end
            return {
                userId = player.UserId,
                claimedAt = os.time(),
            }
        end)
    end)
    if not ok then
        warn("AppleFarm key datastore error:", record)
        return false, "Server verification unavailable"
    end
    if record and record.userId == player.UserId then
        return true, "Access granted"
    end
    return false, "Key already used by another player"
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
    lastAttempt[player.UserId] = nil
end)
