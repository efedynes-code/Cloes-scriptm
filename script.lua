local R=loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
local W=R:CreateWindow({Name="CLOES v15",LoadingTitle="Cloes",LoadingSubtitle="By Cloes",ConfigurationSaving={Enabled=true,FolderName="C15",FileName="CH"},KeySystem=false})
local P=game.Players.LocalPlayer
local C=P.Character or P.CharacterAdded:Wait()
local H=C:WaitForChild("Humanoid")
local RT=C:WaitForChild("HumanoidRootPart")
local U=game:GetService("UserInputService")
local R2=game:GetService("RunService")
local CM=workspace.CurrentCamera
local LT=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local PL=game:GetService("Players")
P.CharacterAdded:Connect(function(c) C=c;H=c:WaitForChild("Humanoid");RT=c:WaitForChild("HumanoidRootPart") end)
local function GR() return RT or (C and C:FindFirstChild("HumanoidRootPart")) end
local function CN(s) return s:lower():gsub("[%s_%-%.%,]","") end
local function FE(...)
    local ns={...};local o={}
    for _,c in ipairs({RS,workspace}) do
        if c then for _,v in pairs(c:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local l=v.Name:lower()
                for _,n in ipairs(ns) do if l:find(n:lower()) then table.insert(o,v);break end end
            end
        end end
    end
    return o
end
local function FA(e,...) for _,x in ipairs(e) do pcall(function() if x:IsA("RemoteEvent") then x:FireServer(...) elseif x:IsA("RemoteFunction") then x:InvokeServer(...) end end) end end
local function TP(k,y)
    y=y or 5; local r=GR(); if not r then return false end
    k=CN(k); local b,bd=nil,math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:FindFirstAncestorOfClass("Tool") then
            if CN(v.Name):find(k) then local d=(v.Position-r.Position).Magnitude; if d<bd then bd=d;b=v end end
        end
    end
    if not b then for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and CN(v.Name):find(k) then
            local p=v:FindFirstChildWhichIsA("BasePart") or v.PrimaryPart; if p then b=p;break end
        end
    end end
    if b then r.CFrame=CFrame.new(b.Position+Vector3.new(0,y,0));return true end
    return false
end

local S=W:CreateTab("🛡️ Stealth",4483362458)
S:CreateToggle({Name="Anti-Cheat Bypass",CurrentValue=false,Flag="ACB",Callback=function(v)
    if v then local ok,m=pcall(function() return getrawmetatable(game) end)
        if ok and m and m.__namecall then
            local o=m.__namecall
            pcall(function() setreadonly(m,false) end)
            m.__namecall=newcclosure(function(s,...) local k=getnamecallmethod(); if k=="Kick" or k=="Ban" then return nil end; return o(s,...) end)
            pcall(function() setreadonly(m,true) end)
            R:Notify({Title="Stealth",Content="Bypass aktif.",Duration=3})
        end
    end
end})
S:CreateToggle({Name="Speed Randomizer",CurrentValue=false,Flag="SR",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(2); if H.WalkSpeed>16 then H.WalkSpeed=H.WalkSpeed+math.random(-3,3) end end end) end
end})
S:CreateToggle({Name="Anti-Void",CurrentValue=false,Flag="AV",Callback=function(v)
    if v then R2.Stepped:Connect(function() local r=GR(); if r and r.Position.Y<-50 then r.CFrame=CFrame.new(0,50,0) end end) end
end})
S:CreateButton({Name="Remove Kick Events",Callback=function()
    for _,x in pairs(RS:GetDescendants()) do if x:IsA("RemoteEvent") and (x.Name:lower():find("kick") or x.Name:lower():find("ban")) then pcall(function() x:Destroy() end) end end
end})
S:CreateButton({Name="Debug Listele",Callback=function()
    for _,x in pairs(workspace:GetChildren()) do print(x.ClassName.." | "..x.Name) end
    for _,x in pairs(RS:GetChildren()) do print(x.ClassName.." | "..x.Name) end
end})

local U2=W:CreateTab("🌐 Universal",4483362458)
U2:CreateSection("Fly")
local FS=50;local FL=false;local FC,FB,FV
U2:CreateInput({Name="Fly Hızı",CurrentValue="50",PlaceholderText="150",RemoveTextAfterFocusLost=false,Flag="FI",Callback=function(t) local n=tonumber(t);if n then FS=n end end})
U2:CreateToggle({Name="Fly",CurrentValue=false,Flag="FLY",Callback=function(v)
    FL=v
    if v then
        if not RT then return end
        FB=Instance.new("BodyGyro",RT);FB.P=9e4;FB.maxTorque=Vector3.new(9e9,9e9,9e9);FB.cframe=RT.CFrame
        FV=Instance.new("BodyVelocity",RT);FV.velocity=Vector3.new(0,0,0);FV.maxForce=Vector3.new(9e9,9e9,9e9)
        local cm;pcall(function() cm=require(P.PlayerScripts:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end)
        FC=R2.RenderStepped:Connect(function()
            if not FL or not RT then return end
            local c=CM.CFrame;local d=Vector3.new(0,0,0)
            if U:IsKeyDown(Enum.KeyCode.W) then d+=c.LookVector end
            if U:IsKeyDown(Enum.KeyCode.S) then d-=c.LookVector end
            if U:IsKeyDown(Enum.KeyCode.A) then d-=c.RightVector end
            if U:IsKeyDown(Enum.KeyCode.D) then d+=c.RightVector end
            if U:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.new(0,1,0) end
            if U:IsKeyDown(Enum.KeyCode.LeftControl) then d-=Vector3.new(0,1,0) end
            if cm then local m=cm:GetMoveVector();if m.Magnitude>0 then d+=c.LookVector*m.Z;d+=c.RightVector*m.X end end
            if d.Magnitude>0 then FV.velocity=d.Unit*FS else FV.velocity=Vector3.new(0,0,0) end
            FB.cframe=c
        end)
    else
        if FC then FC:Disconnect() end
        if FB then FB:Destroy() end
        if FV then FV:Destroy() end
    end
end})
U2:CreateSection("Movement")
U2:CreateSlider({Name="WalkSpeed",Range={16,500},Increment=1,Suffix="Speed",CurrentValue=16,Flag="US",Callback=function(v) H.WalkSpeed=v end})
U2:CreateSlider({Name="JumpPower",Range={50,500},Increment=1,Suffix="JP",CurrentValue=50,Flag="UJ",Callback=function(v) H.UseJumpPower=true;H.JumpPower=v end})
U2:CreateToggle({Name="ESP",CurrentValue=false,Flag="UE",Callback=function(v)
    if v then for _,p in pairs(PL:GetPlayers()) do if p~=P and p.Character then
        local h=Instance.new("Highlight");h.Name="CE";h.Parent=p.Character
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor=Color3.fromRGB(255,0,0);h.OutlineColor=Color3.fromRGB(255,255,255);h.FillTransparency=0.5
    end end else for _,p in pairs(PL:GetPlayers()) do if p.Character then local e=p.Character:FindFirstChild("CE");if e then e:Destroy() end end end end
end})
U2:CreateToggle({Name="Fullbright",CurrentValue=false,Flag="FB2",Callback=function(v)
    if v then LT.Ambient=Color3.fromRGB(255,255,255);LT.Brightness=2;LT.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else LT.Ambient=Color3.fromRGB(0,0,0);LT.Brightness=1;LT.OutdoorAmbient=Color3.fromRGB(0,0,0) end
end})
U2:CreateSection("Fling")
local FSP=200
U2:CreateInput({Name="Fling Hızı",CurrentValue="200",PlaceholderText="300",RemoveTextAfterFocusLost=false,Flag="FSP",Callback=function(t) local n=tonumber(t);if n then FSP=n end end})
U2:CreateButton({Name="🔥 FLING ALL",Callback=function()
    task.spawn(function()
        local r=GR();if not r then return end
        for _,p in pairs(PL:GetPlayers()) do
            if p~=P and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local t=p.Character.HumanoidRootPart
                r.CFrame=t.CFrame+Vector3.new(0,2,0);task.wait(0.05)
                local bv=Instance.new("BodyVelocity",r);bv.MaxForce=Vector3.new(9e9,9e9,9e9)
                bv.Velocity=Vector3.new(math.random(-FSP,FSP),math.random(50,FSP),math.random(-FSP,FSP))
                local bg=Instance.new("BodyGyro",r);bg.P=9e4;bg.MaxTorque=Vector3.new(9e9,9e9,9e9);bg.CFrame=CFrame.new(r.Position,t.Position)
                task.wait(0.3);bv:Destroy();bg:Destroy()
            end
        end
        R:Notify({Title="Fling",Content="Herkes fırlatıldı.",Duration=3})
    end)
end})

local M=W:CreateTab("🔪 MM2",4483362458)
M:CreateToggle({Name="Gun ESP",CurrentValue=false,Flag="GE",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.3)
        for _,p in pairs(PL:GetPlayers()) do
            if p~=P and p.Character then
                local has=p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") or (p.Backpack and (p.Backpack:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Revolver")))
                local ex=p.Character:FindFirstChild("CGE")
                if has and not ex then local h=Instance.new("Highlight");h.Name="CGE";h.Parent=p.Character
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillColor=Color3.fromRGB(255,230,0);h.OutlineColor=Color3.fromRGB(255,255,0)
                elseif not has and ex then ex:Destroy() end
            end
        end
    end end) end
end})
M:CreateToggle({Name="Auto Pickup Gun",CurrentValue=false,Flag="AP",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.2)
        for _,x in pairs(workspace:GetDescendants()) do
            if (x:IsA("BasePart") or x:IsA("MeshPart")) and (x.Name:lower():find("gun") or x.Name:lower():find("revolver")) then
                if not x:FindFirstAncestorOfClass("Tool") then
                    local r=GR();if r and (x.Position-r.Position).Magnitude<300 then r.CFrame=x.CFrame+Vector3.new(0,3,0);task.wait(0.15) end
                end
            end
        end
    end end) end
end})
M:CreateToggle({Name="Auto Shout Murder + Aimbot",CurrentValue=false,Flag="ASM",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.2)
        local isS=C:FindFirstChild("Gun") or C:FindFirstChild("Revolver") or (P.Backpack and (P.Backpack:FindFirstChild("Gun") or P.Backpack:FindFirstChild("Revolver")))
        if isS then
            local m=nil
            for _,p in pairs(PL:GetPlayers()) do
                if p~=P and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife"))) then m=p;break end
            end
            if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
                local r=GR();local t=m.Character.HumanoidRootPart
                if r then r.CFrame=t.CFrame*CFrame.new(0,8,5)
                    local bv=Instance.new("BodyVelocity",r);bv.MaxForce=Vector3.new(9e9,9e9,9e9);bv.Velocity=Vector3.new(0,0,0);bv.P=1250
                    CM.CFrame=CFrame.new(CM.CFrame.Position,t.Position)
                    local tl=C:FindFirstChildOfClass("Tool");if tl then pcall(function() tl:Activate() end) end
                    task.wait(0.1);bv:Destroy()
                end
            end
        end
    end end) end
end})
M:CreateToggle({Name="Wall Shots",CurrentValue=false,Flag="WS",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.15)
        if C:FindFirstChild("Gun") or C:FindFirstChild("Revolver") then
            for _,p in pairs(PL:GetPlayers()) do
                if p~=P and p.Character and (p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife"))) and p.Character:FindFirstChild("Head") then
                    CM.CFrame=CFrame.new(CM.CFrame.Position,p.Character.Head.Position)
                    local t=C:FindFirstChildOfClass("Tool");if t then pcall(function() t:Activate() end) end
                    break
                end
            end
        end
    end end) end
end})
M:CreateButton({Name="Current Map",Callback=function() TP("teleport") or TP("map") end})
M:CreateButton({Name="Lobby",Callback=function() if not TP("lobby") then for _,x in pairs(workspace:GetDescendants()) do if x:IsA("SpawnLocation") then local r=GR();if r then r.CFrame=x.CFrame+Vector3.new(0,5,0);break end end end end end})
M:CreateButton({Name="Gun'a Işınlan",Callback=function() TP("gun",3) or TP("revolver",3) end})

local A=W:CreateTab("🔫 Arsenal",4483362458)
local AA=false
A:CreateToggle({Name="Silent Aimbot",CurrentValue=false,Flag="AA",Callback=function(v) AA=v end})
local ok2,mt2=pcall(function() return getrawmetatable(game) end)
if ok2 and mt2 then
    local oi=mt2.__index;pcall(function() setreadonly(mt2,false) end)
    mt2.__index=newcclosure(function(s,k)
        if AA and k=="Hit" and s==P:GetMouse() then
            local c,d=nil,math.huge
            for _,p in pairs(PL:GetPlayers()) do
                if p~=P and p.Character and p.Character:FindFirstChild("Head") then
                    local dd=(p.Character.Head.Position-CM.CFrame.Position).Magnitude
                    if dd<d then d=dd;c=p.Character.Head end
                end
            end
            if c then return CFrame.new(c.Position) end
        end
        return oi(s,k)
    end)
    pcall(function() setreadonly(mt2,true) end)
end
A:CreateToggle({Name="Rapid Fire",CurrentValue=false,Flag="ARF",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.03);local t=C:FindFirstChildOfClass("Tool");if t then pcall(function() t:Activate() end) end end end) end
end})
A:CreateSlider({Name="WalkSpeed",Range={16,200},Increment=1,Suffix="Speed",CurrentValue=16,Flag="AS",Callback=function(v) H.WalkSpeed=v end})

local D=W:CreateTab("🏙️ Da Hood",4483362458)
D:CreateSlider({Name="WalkSpeed",Range={16,200},Increment=1,Suffix="Speed",CurrentValue=16,Flag="DS",Callback=function(v) H.WalkSpeed=v end})
D:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="IJ",Callback=function(v) if v then U.JumpRequest:Connect(function() H:ChangeState(Enum.HumanoidStateType.Jumping) end) end end})
local NC=false
D:CreateToggle({Name="Noclip",CurrentValue=false,Flag="NC",Callback=function(v)
    NC=v
    if v then R2.Stepped:Connect(function() if NC and C then for _,x in pairs(C:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide=false end end end end) end
end})
D:CreateToggle({Name="Kill Aura",CurrentValue=false,Flag="KA",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.2)
        local r=GR()
        if r then for _,p in pairs(PL:GetPlayers()) do
            if p~=P and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character.HumanoidRootPart.Position-r.Position).Magnitude<20 then
                local t=C:FindFirstChildOfClass("Tool");if t then pcall(function() t:Activate() end) end
            end
        end end
    end end) end
end})
D:CreateButton({Name="Bank'a Işınlan",Callback=function() TP("bank",5) end})

local B=W:CreateTab("🍇 Blox Fruits",4483362458)
local BI={"Starter Island","Marine Fortress","Middle Town","Jungle","Pirate Village","Desert","Frozen Village","Colosseum","Prison","Magma Village","Underwater City","Fountain City","Skylands","Upper Skylands","Cursed Ship","Ice Castle","Forgotten Island","Mansion","Haunted Castle","Hydra Island","Great Tree","Castle on the Sea","Floating Turtle","Kingdom of Rose"}
local SI="Starter Island"
B:CreateDropdown({Name="Ada Seç ▼",Options=BI,CurrentOption={"Starter Island"},MultipleOptions=false,Flag="BI2",Callback=function(o) SI=type(o)=="table" and o[1] or o end})
B:CreateToggle({Name="Auto Farm",CurrentValue=false,Flag="BF",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.4)
        local r=GR()
        if r then for _,x in pairs(workspace:GetDescendants()) do
            if x:IsA("Model") and x:FindFirstChild("Humanoid") and x:FindFirstChild("HumanoidRootPart") and x.Name~=P.Name and (x.HumanoidRootPart.Position-r.Position).Magnitude<500 then
                r.CFrame=x.HumanoidRootPart.CFrame+Vector3.new(0,5,0);task.wait(0.05)
                local t=C:FindFirstChildOfClass("Tool");if t then pcall(function() t:Activate() end) end
            end
        end end
    end end) end
end})
B:CreateButton({Name="Seçili Adaya Işınlan",Callback=function() TP(SI,10) end})

local P2=W:CreateTab("🐾 Pet Sim 99",4483362458)
local PI={"Spawn","Grasslands","Desert","Volcano","Winter","Fantasy","Rainbow","Tech World","Cat World","Dog World","Pixel World","Heaven","Hell","Candy Land","Cyber City","Pirate Cove"}
local SPI="Spawn"
P2:CreateDropdown({Name="Ada Seç ▼",Options=PI,CurrentOption={"Spawn"},MultipleOptions=false,Flag="PI2",Callback=function(o) SPI=type(o)=="table" and o[1] or o end})
P2:CreateToggle({Name="Auto Farm",CurrentValue=false,Flag="PF",Callback=function(v)
    if v then task.spawn(function() while v do task.wait(0.3)
        local r=GR()
        if r then for _,x in pairs(workspace:GetDescendants()) do
            if x:IsA("BasePart") then local n=x.Name:lower()
                if n:find("coin") or n:find("breakable") or n:find("chest") or n:find("diamond") then
                    if (x.Position-r.Position).Magnitude<500 then r.CFrame=x.CFrame+Vector3.new(0,3,0);task.wait(0.05) end
                end
            end
        end end
    end end) end
end})
P2:CreateButton({Name="Seçili Adaya Işınlan",Callback=function() TP(SPI,10) end})
P2:CreateButton({Name="Auto Hatch Eggs",Callback=function() task.spawn(function() local r=GR();if r then for _,x in pairs(workspace:GetDescendants()) do if x:IsA("BasePart") and x.Name:lower():find("egg") then r.CFrame=x.CFrame+Vector3.new(0,3,0);task.wait(0.3) end end end end) end})

local L=W:CreateTab("💪 Muscle Legends",4483362458)
local ME={dambil=FE("dambil","dumbbell"),sinav=FE("sinav","pushup","push"),mekik=FE("mekik","situp","sit"),rebirth=FE("rebirth","rebi"),punch=FE("punch","hit","attack"),sell=FE("sell")}
L:CreateToggle({Name="Auto Dambil",CurrentValue=false,Flag="AD",Callback=function(v) if v then task.spawn(function() while v do task.wait(0.8);if #ME.dambil>0 then FA(ME.dambil,true) else pcall(function() RS.Events.Dambil:FireServer(true) end) end end end) end end})
L:CreateToggle({Name="Auto Sinav",CurrentValue=false,Flag="ASV",Callback=function(v) if v then task.spawn(function() while v do task.wait(0.8);if #ME.sinav>0 then FA(ME.sinav,true) else pcall(function() RS.Events.Sinav:FireServer(true) end) end end end) end end})
L:CreateToggle({Name="Auto Mekik",CurrentValue=false,Flag="AM",Callback=function(v) if v then task.spawn(function() while v do task.wait(0.8);if #ME.mekik>0 then FA(ME.mekik,true) else pcall(function() RS.Events.Mekik:FireServer(true) end) end end end) end end})
L:CreateToggle({Name="Auto Rebirth",CurrentValue=false,Flag="AR",Callback=function(v) if v then task.spawn(function() while v do task.wait(3);if #ME.rebirth>0 then FA(ME.rebirth) else pcall(function() RS.Events.Rebirth:FireServer() end) end end end) end end})
L:CreateToggle({Name="Auto Punch",CurrentValue=false,Flag="AP2",Callback=function(v) if v then task.spawn(function() while v do task.wait(0.1);if #ME.punch>0 then FA(ME.punch) end;local t=C:FindFirstChildOfClass("Tool");if t then pcall(function() t:Activate() end) end end end) end end})
L:CreateSlider({Name="WalkSpeed",Range={16,300},Increment=1,Suffix="Speed",CurrentValue=16,Flag="LS",Callback=function(v) H.WalkSpeed=v end})
L:CreateSlider({Name="JumpPower",Range={50,300},Increment=1,Suffix="JP",CurrentValue=50,Flag="LJ",Callback=function(v) H.UseJumpPower=true;H.JumpPower=v end})

W:CreateTab("ℹ️ About",4483362458):CreateParagraph({Title="CLOES v15",Content="By Cloes"})
R:Notify({Title="CLOES v15",Content="Yüklendi.",Duration=5,Image=4483362458})
print("=== CLOES v15 ===")
