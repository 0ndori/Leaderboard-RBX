local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetOrderedDataStore("(YOURVARIABLE)")

local LeaderboardPart = script.Parent.Parent.Parent
local RefreshRate = 5

local function RefreshLeaderboard()
    -- Update DataStore for each player
    for _, Player in pairs(game.Players:GetPlayers()) do
        DataStore:SetAsync(Player.UserId, Player.leaderstats.(YOURVARIABLE).Value)
    end

    -- Fetch and update leaderboard
    local Success, Error = pcall(function()
        local Data = RebirthDataStore:GetSortedAsync(false, 10)  -- Get top 10 players
        local RebirthPage = Data:GetCurrentPage()

        for Rank, SavedData in ipairs(RebirthPage) do
            local Username = game.Players:GetNameFromUserIdAsync(tonumber(SavedData.key))
            local Rebirths = SavedData.value

            if Rebirths then
                local NewSample = script.Parent.Sample:Clone()
                NewSample.Visible = true
                NewSample.Parent = LeaderboardPart.SurfaceGui.PlayerHolder
                NewSample.Name = Username

                NewSample.RankLabel.Text = "#" .. Rank
                NewSample.NameLabel.Text = Username
                NewSample.(VARIABLE)Label.Text = (VARIABLE)
            end
        end
    end)

    -- Handle errors incase
    if not Success then
        warn("Failed to update leaderboard: " .. Error)
    end
end

-- loop to refresh the leaderboard
while true do
    -- Remove old frames
    for _, Frame in pairs(LeaderboardPart.SurfaceGui.PlayerHolder:GetChildren()) do
        if Frame.Name ~= "Sample" and Frame:IsA("Frame") then
            Frame:Destroy()
        end
    end

    -- Refresh the leaderboard
    RefreshLeaderboard()

    -- Wait for the next update (rate can be changed in the local refreshrate above simply switch the number 5 (the number represent the seconds before refresh)
    wait(RefreshRate)
end
