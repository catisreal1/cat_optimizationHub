local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Optimization Hub",
   LoadingTitle = "load Hub ",
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

FPSTab:CreateSection(" Potato gra ")

FPSTab:CreateToggle({
   Name = "Bật Potato Graphics (Xóa vật thể rác, giảm tải tối đa)",
   CurrentValue = false,
   Flag = "PotatoToggle",
   Callback = function(Value)
      local Lighting = game:GetService("Lighting")
      local Workspace = game:GetService("Workspace")
      local Terrain = Workspace:FindFirstChildOfClass("Terrain")
      
      if Value then
         pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 0
            for _, v in ipairs(Lighting:GetChildren()) do
               if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                  v.Enabled = false
               end
            end
            
            if Terrain then
               Terrain.WaterWaveSize = 0
               Terrain.WaterWaveTransparency = 1
               Terrain.WaterTransparency = 0
            end
            
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
               if obj:IsA("BasePart") then
                  obj.Material = Enum.Material.SmoothPlastic
                  obj.Reflectance = 0
                  if obj.Transparency < 0.1 and obj.Size.Magnitude < 3 then
                     obj.Transparency = 0.5
                  end
               elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("Beam") then
                  obj.Enabled = false
               elseif obj:IsA("Decal") or obj:IsA("Texture") then
                  obj.Transparency = 1
               end
            end
         end)
         Rayfield:Notify({Title = "Potato Mode", Content = "xong r giờ chs đi lag thì góp í thêm", Duration = 3})
      else
         Rayfield:Notify({Title = "Thông báo", Content = "Hãy join lại game để khôi phục đồ họa gốc.", Duration = 3})
      end
   end,
})

NetworkTab:CreateSection("Trực quan thông số")

local StatsLabel = NetworkTab:CreateLabel("Đang tải in4")

task.spawn(function()
    while true do
        pcall(function()
            local fps = math.round(1 / game:GetService("RunService").RenderStepped:Wait())
            local ping = math.round(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            StatsLabel:Set("FPS hiện tại: " .. fps + 5 .. " | Ping hiện tại: " .. ping .. " ms")
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
         Content = "k bt chc là ổn để ép mấy cái gói tin cho client!",
         Duration = 3,
      })
   end,
})

UtilityTab:CreateSection("anti afk")

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
         Rayfield:Notify({Title = "Anti-AFK", Content = "Đã bật anti AFK thành công!", Duration = 3})
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
   Name = "Dọn dẹp rác bộ nhớ (Clean RAM)",
   Callback = function()
      pcall(function()
         collectgarbage("collect")
      end)
      Rayfield:Notify({
         Title = "Đã dọn dẹp",
         Content = "dọn ram r k bt có đc hay k!",
         Duration = 3,
      })
   end,
})

Rayfield:LoadConfiguration()
Rayfield:Notify({
   Title = "Hub v0.3 Loaded!",
   Content = "done",
   Duration = 5,
})