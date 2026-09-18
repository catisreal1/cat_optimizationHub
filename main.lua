local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Optimization Hub v0.8 | cat_isreal",
   LoadingTitle = " ",
   LoadingSubtitle = "by cat_isreal",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "OptHub",
      FileName = "Config"
   },
   KeySystem = false,
})

local FPSTab = Window:CreateTab("FPS Boost", 4483362458)
local NetworkTab = Window:CreateTab("Mạng & Ping", 4483362458)
local UtilityTab = Window:CreateTab("Tiện ích", 4483362458)

FPSTab:CreateSection("potato gra")

FPSTab:CreateToggle({
   Name = "Ultimate Potato (Xóa mọi thứ?)",
   CurrentValue = false,
   Flag = "UltimatePotatoToggle",
   Callback = function(Value)
      local Workspace = game:GetService("Workspace")
      local Lighting = game:GetService("Lighting")
      local Players = game:GetService("Players")
      local Terrain = Workspace:FindFirstChildOfClass("Terrain")
      
      if Value then
         pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
            Lighting.ClockTime = 12
            Lighting.Technology = Enum.Technology.Compatibility

            for _, v in ipairs(Lighting:GetChildren()) do
               if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                  v:Destroy()
               end
            end

            if Terrain then
               Terrain.WaterWaveSize = 0
               Terrain.WaterWaveSpeed = 0
               Terrain.WaterReflectance = 0
               Terrain.WaterTransparency = 1
               pcall(function()
                  sethiddenproperty(Terrain, "Decoration", false)
               end)
            end

            local function stripPart(part)
               if part:IsA("BasePart") then
                  part.CastShadow = false
                  part.Material = Enum.Material.SmoothPlastic
                  part.Reflectance = 0
                  part.Color = Color3.fromRGB(150, 150, 150)
               elseif part:IsA("Decal") or part:IsA("Texture") then
                  part.Transparency = 1
               elseif part:IsA("ParticleEmitter") or part:IsA("Fire") or part:IsA("Smoke") or part:IsA("Sparkles") or part:IsA("Trail") or part:IsA("Beam") then
                  part.Enabled = false
                  part.Parent = nil
               end
            end

            for _, descendant in ipairs(Workspace:GetDescendants()) do
               stripPart(descendant)
            end
            Workspace.DescendantAdded:Connect(stripPart)

            local function optimizeCharacter(char)
               char.DescendantAdded:Connect(function(child)
                  if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Beam") or child:IsA("Highlight") then
                     task.defer(function()
                        if child and child.Parent then
                           child:Destroy()
                        end
                     end)
                  end
               end)
            end

            for _, player in ipairs(Players:GetPlayers()) do
               if player.Character then
                  optimizeCharacter(player.Character)
               end
               player.CharacterAdded:Connect(optimizeCharacter)
            end

            Players.PlayerAdded:Connect(function(player)
               player.CharacterAdded:Connect(optimizeCharacter)
            end)

            local userSettings = UserSettings():GetService("UserGameSettings")
            userSettings.SavedQualityLevel = Enum.SavedQualityLevel.Level1
            userSettings.GraphicsQualityLevel = 1
         end)
         Rayfield:Notify({Title = "Ultimate Potato", Content = "sài đc mà nếu cần gì thì góp í thêm", Duration = 3})
      else
         Rayfield:Notify({Title = "Thông báo", Content = "Hãy join lại game để khôi phục đồ họa gốc.", Duration = 3})
      end
   end,
})

NetworkTab:CreateSection("Trực quan thông số")

local StatsLabel = NetworkTab:CreateLabel("Đang tải thông số...")

task.spawn(function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    while true do
        pcall(function()
            local fps = math.round(1 / RunService.RenderStepped:Wait())
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            StatsLabel:Set("FPS thực tế: " .. fps .. " | Ping: " .. ping .. " ms")
        end)
        task.wait(1)
    end
end)

NetworkTab:CreateSection("Tối ưu kết nối")

NetworkTab:CreateButton({
   Name = "Tối ưu gửi gói tin (Network Fix)",
   Callback = function()
      pcall(function()
         settings():GetService("NetworkSettings").IncomingReplicationLag = 0
      end)
      Rayfield:Notify({
         Title = "Network Optimized",
         Content = "Đã ép gói tin!",
         Duration = 3,
      })
   end,
})

-- [MỤC TIỆN ÍCH & ESP]
UtilityTab:CreateSection("ESP Player (Nhìn xuyên tường)")

UtilityTab:CreateToggle({
   Name = "Bật ESP Highlight",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      _G.ESPEnabled = Value
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer

      local function applyESP(character)
         if not character then return end
         local rootPart = character:WaitForChild("HumanoidRootPart", 5)
         if not rootPart then return end

         if _G.ESPEnabled then
            if not character:FindFirstChild("OptHubESP") then
               local highlight = Instance.new("Highlight")
               highlight.Name = "OptHubESP"
               highlight.Adornee = character
               highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Màu đỏ nổi bật
               highlight.FillTransparency = 0.5
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.OutlineTransparency = 0
               highlight.Parent = character
            end
         else
            local existingHighlight = character:FindFirstChild("OptHubESP")
            if existingHighlight then
               existingHighlight:Destroy()
            end
         end
      end

      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer then
            if player.Character then
               applyESP(player.Character)
            end
            player.CharacterAdded:Connect(function(char)
               if _G.ESPEnabled then
                  applyESP(char)
               end
            end)
         end
      end

      if not _G.ESPConnection and _G.ESPEnabled then
         _G.ESPConnection = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(char)
               if _G.ESPEnabled then
                  applyESP(char)
               end
            end)
         end)
      end

      if Value then
         Rayfield:Notify({Title = "ESP", Content = "Đã bật nhìn xuyên tường!", Duration = 3})
      else
         for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("OptHubESP") then
               player.Character.OptHubESP:Destroy()
            end
         end
         Rayfield:Notify({Title = "ESP", Content = "Đã tắt ESP.", Duration = 3})
      end
   end,
})

UtilityTab:CreateSection("Anti-AFK & RAM")

UtilityTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFKToggle",
   Callback = function(Value)
      local VirtualUser = game:GetService("VirtualUser")
      local LocalPlayer = game:GetService("Players").LocalPlayer
      
      if Value then
         _G.AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
         end)
         Rayfield:Notify({Title = "Anti-AFK", Content = "Đã bật anti AFK", Duration = 3})
      else
         if _G.AntiAFKConnection then
            _G.AntiAFKConnection:Disconnect()
            _G.AntiAFKConnection = nil
         end
         Rayfield:Notify({Title = "Anti-AFK", Content = "Đã tắt AFK.", Duration = 3})
      end
   end,
})

UtilityTab:CreateButton({
   Name = "Clean RAM",
   Callback = function()
      pcall(function()
         collectgarbage("collect")
      end)
      Rayfield:Notify({
         Title = "Đã dọn dẹp",
         Content = "k bt sài đc hay k nx",
         Duration = 3,
      })
   end,
})

Rayfield:LoadConfiguration()
Rayfield:Notify({
   Title = "Hub v0.8 Loaded!",
   Content = "done",
   Duration = 5,
})