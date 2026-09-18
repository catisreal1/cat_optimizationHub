
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "Optimization Hub | Ping & FPS Boost",
   LoadingTitle = "Đang khởi động hệ thống...",
   LoadingSubtitle = "by Scripter",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "OptHub",
      FileName = "Config"
   },
   KeySystem = false,
})


local MainTab = Window:CreateTab("Tối ưu hóa", 4483362458)

MainTab:CreateSection("Hiệu năng & Đồ họa (FPS Boost)")


MainTab:CreateToggle({
   Name = "Siêu tối ưu đồ họa (Tắt Shadow, Water, Particle)",
   CurrentValue = false,
   Flag = "FPSBoostToggle",
   Callback = function(Value)
      local Lighting = game:GetService("Lighting")
      local Workspace = game:GetService("Workspace")
      local Terrain = Workspace:FindFirstChildOfClass("Terrain")
      
      if Value then
         pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 1
            for _, v in ipairs(Lighting:GetChildren()) do
               if v:IsA("PostEffect") or v:IsA("Sky") then
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
               if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Trail") then
                  obj.Enabled = false
               elseif obj:IsA("Decal") or obj:IsA("Texture") then
                  obj.Transparency = 1
               end
            end
         end)
         Rayfield:Notify({Title = "Thành công", Content = "Đã bật chế độ max tối ưu FPS!", Duration = 3})
      else
         Rayfield:Notify({Title = "Thông báo", Content = "Hãy join lại game để khôi phục đồ họa mặc định.", Duration = 3})
      end
   end,
})

MainTab:CreateSection("Mạng & Kết nối (WiFi / Ping)")

MainTab:CreateButton({
   Name = "Tối ưu hóa nhịp gửi gói tin (Network Fix)",
   Callback = function()
      pcall(function()
         settings():GetService("NetworkSettings").IncomingReplicationLag = 0
      end)
      Rayfield:Notify({
         Title = "Network Optimized",
         Content = "Đã ép xung tần số phản hồi gói tin client!",
         Duration = 3,
      })
   end,
})

MainTab:CreateSection("Tiện ích hệ thống")

local GC = getconnections or get_signal_connections
MainTab:CreateToggle({
   Name = "Chống tự động thoát (Anti-AFK)",
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
         Rayfield:Notify({Title = "Anti-AFK", Content = "Đã bật chế độ chống AFK thành công!", Duration = 3})
      else
         if _G.AntiAFKConnection then
            _G.AntiAFKConnection:Disconnect()
            _G.AntiAFKConnection = nil
         end
         Rayfield:Notify({Title = "Anti-AFK", Content = "Đã tắt chống AFK.", Duration = 3})
      end
   end,
})


MainTab:CreateButton({
   Name = "Dọn dẹp rác bộ nhớ (Clean RAM)",
   Callback = function()
      pcall(function()
         collectgarbage("collect")
      end)
      Rayfield:Notify({
         Title = "Đã dọn dẹp",
         Content = "Đã giải phóng bộ nhớ tạm cho máy!",
         Duration = 3,
      })
   end,
})


Rayfield:LoadConfiguration()
Rayfield:Notify({
   Title = "Hub Loaded!",
   Content = "done.",
   Duration = 5,
})