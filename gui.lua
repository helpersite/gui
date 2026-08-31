-- ============================================================
-- Celestite UI Library v2.0
-- Alternate Cheat UI - Black & White Edition
-- Enhanced ColorPicker | Accurate Drag | Hex Input | Copy/Paste
-- ============================================================

-------------------------------------------------
-- CELESTITE UI LIBRARY (SWAPPED FROM TAKE.TXT)
-------------------------------------------------
local Library = {
    Config = { Font = "Proggy", FontSize = 12 },
    Flags = Flags or {},
    SetFlags = {},
    Theme = {
        Background = Color3.fromRGB(8, 8, 8),
        DarkBackground = Color3.fromRGB(4, 4, 4),
        Accent = Color3.fromRGB(255, 255, 255),
        Inline = Color3.fromRGB(40, 40, 40),
        Outline = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        InactiveText = Color3.fromRGB(160, 160, 160),
        SectionBackground = Color3.fromRGB(16, 16, 16)
    },
    Elements = { Toggles = {}, Sliders = {}, Sections = {}, Tabs = {}, SubTabs = {}, Windows = {}, Labels = {}, Dropdowns = {}, Outlines = {}, Inlines = {}, ColorPickers = {}, Buttons = {}, TextBoxes = {} },
    WatermarkObj = nil,
    KeyList = nil,
    MenuKeybind = Enum.KeyCode.RightControl,
    Font = nil,
    Registry = {},
    Keys = {}
}
Library.ChangeTheme = function(self, ...) return self:UpdateTheme(...) end
Library.InitSettings = function(self, ...) return true end
local library = Library
getgenv().Library = Library
getgenv().library = Library

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function decodeBase64(data)
    data = string.gsub(data, '[^'..b64chars..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b64chars:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local b64decode = base64_decode or (crypt and crypt.base64decode) or decodeBase64

local function IsWithin(obj, input)
    local pos = obj.AbsolutePosition
    local size = obj.AbsoluteSize
    local mPos = input.Position
    return mPos.X >= pos.X and mPos.X <= pos.X + size.X and mPos.Y >= pos.Y and mPos.Y <= pos.Y + size.Y
end

local LoadedFonts = {}

local function LoadFonts()
    local fonts = {
        {"Proggy", "https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Proggy.txt"},
        {"Verdana", "https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Verdana.txt"},
        {"VerdanaBold", "https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Verdana%20Bold.txt"},
        {"Tahoma", "https://raw.githubusercontent.com/OxygenClub/Random-LUAS/main/Tahoma.txt"}
    }
    
    for _, f in pairs(fonts) do
        local name, url = f[1], f[2]
        local success, err = pcall(function()
            local ttf_path = name .. ".ttf"
            local json_path = name .. ".json"
            
            if not isfile(ttf_path) then 
                writefile(ttf_path, b64decode(game:HttpGet(url))) 
            end
            
            if not isfile(json_path) then
                local data = { 
                    name = name, 
                    faces = { 
                        { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(ttf_path) } 
                    } 
                }
                writefile(json_path, HttpService:JSONEncode(data))
            end
            
            LoadedFonts[name] = Font.new(getcustomasset(json_path), Enum.FontWeight.Regular)
        end)
        if not success then pcall(function() warn("Failed to load font " .. name) end) end
    end
end
LoadFonts()

local function GetFont() 
    return LoadedFonts[Library.Config.Font] or Font.fromEnum(Enum.Font.Code) 
end

Library.Font = Font.fromEnum(Enum.Font.Code)
Library.Registry = {}
Library.Keys = {
    ["Unknown"] = "Unknown",
    ["MouseButton1"] = "M1", ["MouseButton2"] = "M2", ["MouseButton3"] = "M3",
    ["Backspace"] = "Back", ["Tab"] = "Tab", ["Return"] = "Ent", ["Pause"] = "Pse",
    ["Escape"] = "Esc", ["Space"] = "Spc", ["QuotedDouble"] = "\"", ["Hash"] = "#",
    ["Dollar"] = "$", ["Percent"] = "%", ["Ampersand"] = "&", ["Quote"] = "'",
    ["LeftParenthesis"] = "(", ["RightParenthesis"] = ")", ["Asterisk"] = "*",
    ["Plus"] = "+", ["Comma"] = ",", ["Minus"] = "-", ["Period"] = ".", ["Slash"] = "/",
    ["Colon"] = ":", ["Semicolon"] = ";", ["LessThan"] = "<", ["GreaterThan"] = ">",
    ["Question"] = "?", ["Equals"] = "=", ["At"] = "@", ["LeftBracket"] = "[",
    ["RightBracket"] = "]", ["BackSlash"] = "\\", ["Caret"] = "^", ["Underscore"] = "_",
    ["Backquote"] = "`", ["LeftCurly"] = "{", ["Pipe"] = "|", ["RightCurly"] = "}",
    ["Tilde"] = "~", ["Delete"] = "Del", ["End"] = "End", ["Home"] = "Hm",
    ["Insert"] = "Ins", ["PageUp"] = "PgU", ["PageDown"] = "PgD",
    ["KeypadZero"] = "Num0", ["KeypadOne"] = "Num1", ["KeypadTwo"] = "Num2",
    ["KeypadThree"] = "Num3", ["KeypadFour"] = "Num4", ["KeypadFive"] = "Num5",
    ["KeypadSix"] = "Num6", ["KeypadSeven"] = "Num7", ["KeypadEight"] = "Num8",
    ["KeypadNine"] = "Num9", ["KeypadPeriod"] = "Num.", ["KeypadDivide"] = "Num/",
    ["KeypadMultiply"] = "Num*", ["KeypadMinus"] = "Num-", ["KeypadPlus"] = "Num+",
    ["KeypadEnter"] = "NumEnt", ["RightShift"] = "RShift", ["LeftShift"] = "LShift",
    ["RightControl"] = "RCtrl", ["LeftControl"] = "LCtrl", ["LeftAlt"] = "LAlt", ["RightAlt"] = "RAlt"
}

local function GetKeyName(k)
    if not k then return "None" end
    local name = typeof(k) == "EnumItem" and k.Name or tostring(k):gsub("Enum.UserInputType.", ""):gsub("Enum.KeyCode.", "")
    if Library.Keys[name] then return Library.Keys[name] end
    return name:gsub(" ", "")
end

UserInputService.InputBegan:Connect(function(input, gpe)
    local cur = (input.UserInputType == Enum.UserInputType.Keyboard) and input.KeyCode or input.UserInputType
    for _, bind in pairs(Library.Registry) do
        if bind.Binding then
            if cur ~= Enum.KeyCode.Unknown then
                if cur == Enum.UserInputType.MouseButton1 and tick() - bind.Started < 0.1 then continue end
                bind.Binding = false
                bind.Key = cur
                if bind.Label then
                    bind.Label.TextColor3 = Library.Theme.Text
                    bind.Label.Text = GetKeyName(cur)
                end
                if bind.Callback then bind.Callback(cur) end
            end
        elseif cur == bind.Key then
            if not gpe or (cur ~= Enum.UserInputType.MouseButton1 and cur ~= Enum.UserInputType.MouseButton2) then
                if bind.OnTrigger then bind.OnTrigger() end
            end
        end
    end
end)

Library.Theme = {
    Background = Color3.fromRGB(8, 8, 8),
    DarkBackground = Color3.fromRGB(4, 4, 4),
    Accent = Color3.fromRGB(255, 255, 255),
    Inline = Color3.fromRGB(35, 35, 35),
    Outline = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    InactiveText = Color3.fromRGB(120, 120, 120),
    SectionBackground = Color3.fromRGB(16, 16, 16)
}

Library.Elements = { Toggles = {}, Sliders = {}, Sections = {}, Tabs = {}, SubTabs = {}, Windows = {}, Labels = {}, Dropdowns = {}, Outlines = {}, Inlines = {}, ColorPickers = {}, Buttons = {}, TextBoxes = {} }
Library.Flags = {}

function Library:UpdateTheme()
    for _, win in pairs(Library.Elements.Windows) do 
        if win.Main then win.Main.BackgroundColor3 = Library.Theme.DarkBackground end
        if win.TitleBar then win.TitleBar.BackgroundColor3 = Library.Theme.Background end
        if win.Content then win.Content.BackgroundColor3 = Library.Theme.Background end
        if win.AccentLine then win.AccentLine.BackgroundColor3 = Library.Theme.Accent end
    end
    for _, sec in pairs(Library.Elements.Sections) do 
        if sec.Frame then sec.Frame.BackgroundColor3 = Library.Theme.DarkBackground end
        if sec.Header then sec.Header.TextColor3 = Library.Theme.Text end
    end
    for _, tog in pairs(Library.Elements.Toggles) do 
        if tog.Box then tog.Box.BackgroundColor3 = tog.GetState() and Library.Theme.Accent or Library.Theme.SectionBackground end
        if tog.Label then tog.Label.TextColor3 = tog.GetState() and Library.Theme.Text or Library.Theme.InactiveText end
    end
    for _, sli in pairs(Library.Elements.Sliders) do 
        if sli.Fill then sli.Fill.BackgroundColor3 = Library.Theme.Accent end
        if sli.Label then sli.Label.TextColor3 = Library.Theme.Text end
        if sli.Value then sli.Value.TextColor3 = Library.Theme.Text end
        if sli.Back then sli.Back.BackgroundColor3 = Library.Theme.SectionBackground end
    end
    for _, drop in pairs(Library.Elements.Dropdowns) do
        if drop.Box then drop.Box.BackgroundColor3 = Library.Theme.SectionBackground end
        if drop.Label then drop.Label.TextColor3 = Library.Theme.Text end
        if drop.ValueLabel then drop.ValueLabel.TextColor3 = Library.Theme.Text end
        if drop.Arrow then drop.Arrow.TextColor3 = Library.Theme.Text end
        if drop.Container then drop.Container.BackgroundColor3 = Library.Theme.DarkBackground end
        if drop.UpdateList then
            drop.UpdateList()
        end
    end
    for _, cp in pairs(Library.Elements.ColorPickers) do
        if cp.Frame then cp.Frame.BackgroundColor3 = Library.Theme.SectionBackground end
        if cp.Picker then cp.Picker.BackgroundColor3 = Library.Theme.DarkBackground end
    end
    for _, tab in pairs(Library.Elements.Tabs) do 
        if tab.Accent then tab.Accent.BackgroundColor3 = Library.Theme.Accent end
        if tab.Button then
            Tween(tab.Button, {TextColor3 = tab.IsActive() and Library.Theme.Text or Library.Theme.InactiveText})
        end
    end
    for _, st in pairs(Library.Elements.SubTabs or {}) do
        if st.Accent then st.Accent.BackgroundColor3 = Library.Theme.Accent end
        if st.Button then
            local active = st.IsActive and st.IsActive()
            Tween(st.Button, {TextColor3 = active and Library.Theme.Text or Library.Theme.InactiveText})
        end
        if st.Update then pcall(st.Update) end
    end
    for _, lab in pairs(Library.Elements.Labels) do
        lab.TextColor3 = Library.Theme.Text
    end
    for _, btn in pairs(Library.Elements.Buttons) do
        if type(btn) == "table" and btn.Box then
            btn.Box.BackgroundColor3 = Library.Theme.SectionBackground
            if btn.IsActive and btn.IsActive() then
                btn.Label.TextColor3 = Library.Theme.Accent
            else
                btn.Label.TextColor3 = Library.Theme.Text
            end
        else
            btn.BackgroundColor3 = Library.Theme.SectionBackground
        end
    end
    for _, txt in pairs(Library.Elements.TextBoxes) do
        if txt.Box then txt.Box.BackgroundColor3 = Library.Theme.SectionBackground end
        if txt.Input then txt.Input.TextColor3 = Library.Theme.Text end
    end
    for _, out in pairs(Library.Elements.Outlines) do out.Color = Library.Theme.Outline end
    for _, inl in pairs(Library.Elements.Inlines) do inl.Color = Library.Theme.Inline end
    
    if Library.WatermarkObj and Library.WatermarkObj.Frame then
        Library.WatermarkObj.Frame.BackgroundColor3 = Library.Theme.DarkBackground
        if Library.WatermarkObj.Label then Library.WatermarkObj.Label.TextColor3 = Library.Theme.Text end
        if Library.WatermarkObj.Accent then Library.WatermarkObj.Accent.BackgroundColor3 = Library.Theme.Accent end
    end
    if Library.KeyList and Library.KeyList.Frame then
        Library.KeyList.Frame.BackgroundColor3 = Library.Theme.DarkBackground
        if Library.KeyList.Header then Library.KeyList.Header.TextColor3 = Library.Theme.Text end
        if Library.KeyList.Accent then Library.KeyList.Accent.BackgroundColor3 = Library.Theme.Accent end
    end
    Library:SyncThemeToFeatures()
end

function Library:SyncThemeToFeatures()
    if not (Library.Flags["SyncThemeToFeatures"] or (Flags and Flags["SyncThemeToFeatures"])) then return end
    local accent = Library.Theme.Accent
    local F = Library.Flags
    
    -- ESP colors
    F["ESP_BoxInlineColor"] = accent
    F["ESP_BoxFillColor1"] = accent
    F["ESP_NameInlineColor"] = accent
    F["ESP_DistanceInlineColor"] = accent
    F["ESP_HealthTextInlineColor"] = accent
    F["ESP_ArmorBarInlineColor"] = accent
    F["ESP_TracerColor"] = accent
    F["ESP_WeaponColor"] = accent
    F["ESP_ToolIconColor"] = accent
    F["ESP_FlagsColor"] = accent
    F["ESP_HealthBarTopColor"] = accent
    
    -- Chams colors
    F["ChamsFillColor"] = accent
    F["ChamsGradientA"] = accent
    F["ToolChamsColor"] = accent
    
    -- FOV colors
    F["FOVColor"] = accent
    F["FOVFillColor"] = accent
    F["SilentFOVColor"] = accent
    F["SilentFOVFillColor"] = accent
    
    -- Tracers & Global C table
    F["c_ttrace"] = accent
    if C then
        C.TargetTracer = accent
        C.Fog = accent
    end
    
    -- Weather / World
    F["c_rain"] = accent
    F["c_cherry_fog"] = accent
    F["c_fog"] = accent
    F["c_mat"] = accent
    
    if Flags and Flags ~= F then
        for k, v in pairs(F) do Flags[k] = v end
    end
    
    pcall(function()
        local a = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
        if a then a.Color = accent end
    end)
    
    for _, cp in pairs(Library.Elements.ColorPickers) do
        if cp.SetPreview then pcall(cp.SetPreview, accent) end
    end
    
    pcall(function() if updateESPVisibility then updateESPVisibility() end end)
    pcall(function() if updateChams then updateChams() end end)
    pcall(function() if updateAimbotFOVVis then updateAimbotFOVVis() end end)
    pcall(function() if updateSilentFOVVis then updateSilentFOVVis() end end)
    pcall(function() if _W and _W.refreshRain then _W.refreshRain() end end)
    pcall(function() if _W and _W.refreshSnow then _W.refreshSnow() end end)
    pcall(function() if updateMaterialChanger then updateMaterialChanger() end end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CelestiteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = (gethui and gethui()) or CoreGui

Library.Holder = { Instance = ScreenGui }

local function AddOutline(inst)
    local out = Instance.new("UIStroke")
    out.Name = "Outline"
    out.Color = Library.Theme.Outline
    out.Thickness = 1
    out.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    out.Parent = inst
    table.insert(Library.Elements.Outlines, out)
    return out
end

local function AddInlineOutline(inst, inlineColor, outlineColor)
    if outlineColor then
        local out = Instance.new("UIStroke")
        out.Name = "Outline"
        out.Color = outlineColor or Library.Theme.Outline
        out.Thickness = 1
        out.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        out.Parent = inst
        table.insert(Library.Elements.Outlines, out)
    end

    local inner = Instance.new("Frame")
    inner.Name = "InlineBorder"
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.new(0, 1, 0, 1)
    inner.BackgroundTransparency = 1
    inner.BorderSizePixel = 0
    inner.ZIndex = inst.ZIndex
    inner.Parent = inst
    
    local inl = Instance.new("UIStroke")
    inl.Name = "Inline"
    inl.Color = inlineColor or Library.Theme.Inline
    inl.Thickness = 1
    inl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    inl.Parent = inner
    table.insert(Library.Elements.Inlines, inl)
    return inl
end

local function ApplyCelestiteStyle(inst)
    AddOutline(inst)
    AddInlineOutline(inst)
end

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Size = UDim2.new(0, 250, 1, -40)
NotifHolder.Position = UDim2.new(0, 10, 0, 10)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.Padding = UDim.new(0, 5)
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.Parent = NotifHolder

function Library:Notification(opts)
    local text = opts.Text or "Notification"
    local duration = opts.Duration or 5
    
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 24)
    Holder.BackgroundColor3 = Library.Theme.DarkBackground
    Holder.BorderSizePixel = 0
    Holder.Parent = NotifHolder
    Holder.Position = UDim2.new(-1.2, 0, 0, 0)
    
    AddOutline(Holder)
    AddInlineOutline(Holder)
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 2, 1, 0)
    Accent.BackgroundColor3 = Library.Theme.Accent
    Accent.BorderSizePixel = 0
    Accent.ZIndex = 5
    Accent.Parent = Holder
    
    local TLabel = Instance.new("TextLabel")
    TLabel.Text = text
    TLabel.Size = UDim2.new(1, -15, 1, 0)
    TLabel.Position = UDim2.new(0, 10, 0, 0)
    TLabel.BackgroundTransparency = 1
    TLabel.TextColor3 = Library.Theme.Text
    TLabel.FontFace = GetFont()
    TLabel.TextSize = Library.Config.FontSize
    TLabel.TextXAlignment = Enum.TextXAlignment.Left
    TLabel.Parent = Holder
    TLabel.TextStrokeTransparency = 0
    TLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    TLabel.ZIndex = 5
    
    Tween(Holder, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    task.delay(duration, function()
        Tween(Holder, {Position = UDim2.new(-1.2, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Holder:Destroy()
    end)
end

function Library:Notify(text, duration)
    return self:Notification({ Text = tostring(text or ""), Duration = duration or 3 })
end

function Library:Log(text)
    pcall(function() print("[alternate] " .. tostring(text or "")) end)
end

function Library:Unload()
    pcall(function() ScreenGui:Destroy() end)
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    if class == "TextLabel" or class == "TextButton" or class == "TextBox" then
        inst.TextSize = Library.Config.FontSize
        inst.FontFace = GetFont()
    end
    for k, v in pairs(props or {}) do 
        if k == "FontFace" then inst.FontFace = GetFont()
        elseif k == "TextSize" then inst.TextSize = v
        elseif k == "Parent" then
        else inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    for _, c in pairs(children or {}) do c.Parent = inst end
    return inst
end

local function attachGlowAnimation(accentFrame)
    if not accentFrame then return end
    accentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local grad = accentFrame:FindFirstChild("GlowGradient") or Instance.new("UIGradient")
    grad.Name = "GlowGradient"
    
    local function updateGradientColors()
        local base = Library.Theme.Accent or Color3.fromRGB(255, 170, 0)
        local h, s, v = Color3.toHSV(base)
        local light = Color3.fromHSV(h, math.clamp(s * 0.7, 0, 1), math.clamp(v * 1.25, 0, 1))
        local bright = Color3.fromHSV(h, math.clamp(s * 0.3, 0, 1), 1)
        local dark = Color3.fromHSV(h, math.clamp(s * 1.1, 0, 1), math.clamp(v * 0.65, 0, 1))
        
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, dark),
            ColorSequenceKeypoint.new(0.35, light),
            ColorSequenceKeypoint.new(0.5, bright),
            ColorSequenceKeypoint.new(0.65, light),
            ColorSequenceKeypoint.new(1, dark),
        })
    end
    updateGradientColors()
    grad.Parent = accentFrame
    
    accentFrame:GetPropertyChangedSignal("BackgroundColor3"):Connect(updateGradientColors)
    
    if not accentFrame:FindFirstChild("_glowRunning") then
        local flag = Instance.new("BoolValue")
        flag.Name = "_glowRunning"
        flag.Parent = accentFrame
        task.spawn(function()
            local conn
            conn = game:GetService("RunService").RenderStepped:Connect(function()
                if not accentFrame or not accentFrame.Parent then
                    if conn then conn:Disconnect() end
                    return
                end
                updateGradientColors()
                grad.Offset = Vector2.new((tick() * 0.4) % 2 - 1, 0)
            end)
        end)
    end
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Library:Watermark(text)
    local WatermarkObj = {}
    local Frame = Create("Frame", {
        Name = "Watermark",
        Size = UDim2.new(0, 0, 0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Library.Theme.DarkBackground,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 100
    })
    AddOutline(Frame)
    AddInlineOutline(Frame)
    
    local Accent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = Frame
    })
    attachGlowAnimation(Accent)
    
    local Label = Create("TextLabel", {
        Text = text or "alternate",
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        FontFace = GetFont(),
        TextSize = Library.Config.FontSize,
        TextColor3 = Library.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 102,
        Parent = Frame,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0,0,0)
    })
    Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = Label })
    
    MakeDraggable(Frame, Label)
    MakeDraggable(Frame, Frame)

    WatermarkObj.Frame = Frame
    WatermarkObj.Label = Label
    WatermarkObj.Accent = Accent

    function WatermarkObj:SetText(t) Label.Text = tostring(t) end
    function WatermarkObj:SetVisibility(v) Frame.Visible = v end
    return WatermarkObj
end

function Library:KeybindList()
    local KeyListObj = {}
    local Frame = Create("Frame", {
        Name = "KeybindList",
        Size = UDim2.new(0, 150, 0, 24),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Library.Theme.DarkBackground,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 100,
        Visible = true
    })
    AddOutline(Frame)
    AddInlineOutline(Frame)
    
    local Accent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = Frame
    })
    attachGlowAnimation(Accent)
    
    local Header = Create("TextLabel", {
        Text = "Keybinds",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        FontFace = GetFont(),
        TextSize = Library.Config.FontSize,
        TextColor3 = Library.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 102,
        Parent = Frame,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0,0,0)
    })
    
    MakeDraggable(Frame, Header)
    MakeDraggable(Frame, Frame)

    KeyListObj.Frame = Frame
    KeyListObj.Header = Header
    KeyListObj.Accent = Accent

    function KeyListObj:SetVisibility(v) Frame.Visible = v end
    return KeyListObj
end

function Library:Window(title, size)
    local Window = { Tabs = {} }
    local Main = Create("Frame", { Name = "CelestiteWindow", Size = size or UDim2.new(0, 640, 0, 520), Position = UDim2.new(0.5, -320, 0.5, -260), BackgroundColor3 = Library.Theme.DarkBackground, BorderSizePixel = 0, Parent = ScreenGui, ClipsDescendants = false })
    AddInlineOutline(Main, Library.Theme.Inline, Library.Theme.Outline)
    local AccentLine = Create("Frame", { Name = "AccentLine", Size = UDim2.new(1, -2, 0, 2), Position = UDim2.new(0, 1, 0, 1), BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, ZIndex = 10, Parent = Main })
    attachGlowAnimation(AccentLine)
    local TitleBar = Create("Frame", { Name = "TitleBar", Size = UDim2.new(1, -4, 0, 26), Position = UDim2.new(0, 2, 0, 3), BackgroundColor3 = Library.Theme.Background, BorderSizePixel = 0, ZIndex = 2, Parent = Main })
    AddInlineOutline(TitleBar, Library.Theme.Inline, Library.Theme.Outline)
    Create("TextLabel", { Name = "Title", Text = title or "Celestite", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = TitleBar, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
    
    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 90, 0, 0), BackgroundTransparency = 1, ZIndex = 2, Parent = TitleBar })
    Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12), Parent = TabBar })
    Create("UIPadding", { PaddingRight = UDim.new(0, 12), Parent = TabBar })
    
    local ContentArea = Create("Frame", { Name = "Content", Size = UDim2.new(1, -4, 1, -35), Position = UDim2.new(0, 2, 0, 33), BackgroundColor3 = Library.Theme.Background, BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 2, Parent = Main })
    AddInlineOutline(ContentArea, Library.Theme.Inline, Library.Theme.Outline)
    table.insert(Library.Elements.Windows, { Main = Main, TitleBar = TitleBar, Content = ContentArea, AccentLine = AccentLine })
    
    function Window:SetVisible(v) Main.Visible = v end

    MakeDraggable(Main, TitleBar)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and (input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert) then
            Main.Visible = not Main.Visible
        end
    end)

    function Window:Tab(name)
        local Tab = { SubPages = {}, CurrentSubPage = nil }
        local TabButton = Create("TextButton", { Name = name, Text = name, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.InactiveText, AutoButtonColor = false, ZIndex = 3, Parent = TabBar, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
        Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = TabButton })
        local TabAccent = Create("Frame", { Name = "Accent", Size = UDim2.new(0, 0, 0, 1), Position = UDim2.new(0.5, 0, 0.5, 8), BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, ZIndex = 4, Parent = TabButton })
        
        local TabPage = Create("Frame", { Name = name .. "_Page", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = ContentArea })
        
        local SubTabBar = Create("Frame", { Name = "SubTabBar", Size = UDim2.new(1, -12, 0, 24), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, ZIndex = 4, Visible = false, Parent = TabPage })
        Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = SubTabBar })

        local DefaultLeftColumn = Create("ScrollingFrame", {
            Name = "Left",
            Size = UDim2.new(0.5, -8, 1, -12),
            Position = UDim2.new(0, 6, 0, 6),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 3,
            Parent = TabPage,
            ClipsDescendants = true
        })
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = DefaultLeftColumn})
        Create("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = DefaultLeftColumn})

        local DefaultRightColumn = Create("ScrollingFrame", {
            Name = "Right",
            Size = UDim2.new(0.5, -8, 1, -12),
            Position = UDim2.new(0.5, 4, 0, 6),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 3,
            Parent = TabPage,
            ClipsDescendants = true
        })
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = DefaultRightColumn})
        Create("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = DefaultRightColumn})
        
        Tab.PageFrame = TabPage
        Tab.LeftColumn = DefaultLeftColumn
        Tab.RightColumn = DefaultRightColumn
        Tab.SubTabBar = SubTabBar
        
        function Tab:SubPage(subOpts)
            local subName = type(subOpts) == "table" and (subOpts.Name or subOpts.name) or tostring(subOpts or "SubPage")
            SubTabBar.Visible = true
            DefaultLeftColumn.Visible = false
            DefaultRightColumn.Visible = false

            local SubContainer = Create("Frame", { Name = subName .. "_SubContainer", Size = UDim2.new(1, 0, 1, -30), Position = UDim2.new(0, 0, 0, 30), BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = TabPage })
            
            local SubLeftColumn = Create("ScrollingFrame", {
                Name = "Left",
                Size = UDim2.new(0.5, -8, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Theme.Accent,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ZIndex = 3,
                Parent = SubContainer,
                ClipsDescendants = true
            })
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = SubLeftColumn})
            Create("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = SubLeftColumn})

            local SubRightColumn = Create("ScrollingFrame", {
                Name = "Right",
                Size = UDim2.new(0.5, -8, 1, 0),
                Position = UDim2.new(0.5, 4, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Theme.Accent,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ZIndex = 3,
                Parent = SubContainer,
                ClipsDescendants = true
            })
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = SubRightColumn})
            Create("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = SubRightColumn})

            local SubButton = Create("TextButton", { Name = subName .. "_SubBtn", Text = subName, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.InactiveText, AutoButtonColor = false, ZIndex = 5, Parent = SubTabBar, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
            Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = SubButton })
            local SubAccent = Create("Frame", { Name = "Accent", Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0.5, 0, 1, -2), BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, ZIndex = 6, Parent = SubButton })

            local SubObj = {
                Name = subName,
                Container = SubContainer,
                LeftColumn = SubLeftColumn,
                RightColumn = SubRightColumn,
                Button = SubButton,
                Accent = SubAccent
            }

            local function ActivateSub()
                for _, s in ipairs(Tab.SubPages) do
                    s.Container.Visible = false
                    Tween(s.Button, {TextColor3 = Library.Theme.InactiveText})
                    Tween(s.Accent, {Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0.5, 0, 1, -2)})
                end
                SubContainer.Visible = true
                Tab.CurrentSubPage = SubObj
                Tween(SubButton, {TextColor3 = Library.Theme.Text})
                Tween(SubAccent, {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2)})
            end

            SubButton.MouseButton1Click:Connect(ActivateSub)
            table.insert(Tab.SubPages, SubObj)
            table.insert(Library.Elements.SubTabs, {
                Button = SubButton,
                Accent = SubAccent,
                IsActive = function() return Tab.CurrentSubPage == SubObj end,
                Update = function()
                    local active = (Tab.CurrentSubPage == SubObj)
                    SubButton.TextColor3 = active and Library.Theme.Text or Library.Theme.InactiveText
                    SubAccent.BackgroundColor3 = Library.Theme.Accent
                    SubLeftColumn.ScrollBarImageColor3 = Library.Theme.Accent
                    SubRightColumn.ScrollBarImageColor3 = Library.Theme.Accent
                end
            })
            if #Tab.SubPages == 1 then ActivateSub() end

            function SubObj:Section(sectionName, side)
                return Tab:Section(sectionName, side, SubObj)
            end
            SubObj.AddSection = function(self, s, side) return self:Section(s, side) end
            SubObj.Configs = function(self, s, side) return self:Section(s or "Configs", side or "Left") end
            SubObj.Themes = function(self, s, side) return self:Section(s or "Themes", side or "Right") end

            return SubObj
        end
        Tab.SubTab = Tab.SubPage
        Tab.AddSubTab = Tab.SubPage

        local function Activate() 
            for _, t in pairs(Window.Tabs) do 
                t.Page.Visible = false; 
                Tween(t.Button, {TextColor3 = Library.Theme.InactiveText}); 
                Tween(t.Accent, {Size = UDim2.new(0, 0, 0, 1), Position = UDim2.new(0.5, 0, 0.5, 8)})
            end
            TabPage.Visible = true; 
            Tween(TabButton, {TextColor3 = Library.Theme.Text}); 
            Tween(TabAccent, {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 8)})
        end
        TabButton.MouseButton1Click:Connect(Activate)
        table.insert(Window.Tabs, {Button = TabButton, Page = TabPage, Accent = TabAccent})
        table.insert(Library.Elements.Tabs, { Accent = TabAccent, Button = TabButton, IsActive = function() return TabPage.Visible end })
        if #Window.Tabs == 1 then Activate() end

        function Tab:Section(sectionName, side, subObj)
            local Section = {}
            local nameStr = type(sectionName) == "table" and (sectionName.Name or sectionName.name or "Section") or tostring(sectionName or "Section")
            local sideVal = side or (type(sectionName) == "table" and (sectionName.Side or sectionName.side)) or "Left"
            if type(sideVal) == "number" then sideVal = (sideVal == 1 and "Left" or "Right") end
            local sideStr = tostring(sideVal):lower()

            local parentLeft = subObj and subObj.LeftColumn or DefaultLeftColumn
            local parentRight = subObj and subObj.RightColumn or DefaultRightColumn
            local parent = (sideStr == "right") and parentRight or parentLeft

            local SectionFrame = Create("Frame", { Name = nameStr, Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Library.Theme.DarkBackground, BorderSizePixel = 0, ZIndex = 4, Parent = parent, ClipsDescendants = false })
            AddInlineOutline(SectionFrame)
            local Header = Create("TextLabel", { Name = "Header", Text = nameStr, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, Parent = SectionFrame, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
            table.insert(Library.Elements.Sections, { Frame = SectionFrame, Header = Header })
            local ElementList = Create("Frame", { Name = "Elements", Size = UDim2.new(1, -12, 0, 0), Position = UDim2.new(0, 6, 0, 23), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 5, Parent = SectionFrame, ClipsDescendants = false })
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = ElementList})
            Create("UIPadding", {PaddingBottom = UDim.new(0, 9), Parent = ElementList})
            
            function Section:SetVisibility(state)
                SectionFrame.Visible = (state == true)
            end

            function Section:Button(opts)
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Box = Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Background, ZIndex = 7, Parent = Holder })
                ApplyCelestiteStyle(Box)
                local Label = Create("TextLabel", { Text = opts.Name or "Button", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8, Parent = Box, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local isActive = false
                table.insert(Library.Elements.Buttons, { Box = Box, Label = Label, IsActive = function() return isActive end })
                local btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 9, Parent = Box })
                btn.MouseButton1Click:Connect(function()
                    Tween(Box, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.1)
                    task.wait(0.1)
                    Tween(Box, {BackgroundColor3 = Library.Theme.SectionBackground}, 0.1)
                    if opts.Callback then opts.Callback() end
                end)
                local function updateState(state)
                    isActive = state
                    if isActive then
                        Label.TextColor3 = Library.Theme.Accent
                        if not string.find(Label.Text, "%[ON%]") then
                            Label.Text = Label.Text .. " [ON]"
                        end
                    else
                        Label.TextColor3 = Library.Theme.Text
                        Label.Text = tostring(opts.Name or "Button")
                    end
                end
                return { Holder = Holder, SetText = function(t) Label.Text = t end, SetVisibility = function(s) Holder.Visible = (s == true) end, SetState = updateState }
            end

            function Section:Label(opts)
                local text = type(opts) == "table" and (opts.Name or opts.Text or "Label") or tostring(opts or "")
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Label = Create("TextLabel", { Text = text, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local Obj = {
                    SetText = function(t) Label.Text = tostring(t) end,
                    set = function(t) Label.Text = tostring(t) end,
                    Set = function(t) Label.Text = tostring(t) end,
                    SetVisibility = function(s) Holder.Visible = (s == true) end
                }
                function Obj:Keybind(kopts) return Obj end
                return Obj
            end

            function Section:Keybind(opts)
                local flag = opts.Flag or opts.Name
                local defaultKey = opts.Key or opts.Default or Enum.KeyCode.Unknown
                local mode = opts.Mode or "Toggle"
                local bind = { Key = defaultKey, Binding = false, Started = 0, Label = nil, OnTrigger = function() end, Callback = opts.Callback }
                if flag then
                    if type(Library.Flags[flag]) == "table" then
                        Library.Flags[flag].Key = defaultKey
                        Library.Flags[flag].key = defaultKey
                    else
                        Library.Flags[flag] = { Key = defaultKey, key = defaultKey, mode = mode, Toggled = false, active = false }
                    end
                end
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Label = Create("TextLabel", { Text = opts.Name or "Keybind", Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                
                local KeyLabel = Create("TextLabel", { Text = GetKeyName(bind.Key), Size = UDim2.new(0, 45, 1, 0), Position = UDim2.new(1, -45, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 8, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                bind.Label = KeyLabel
                table.insert(Library.Elements.Labels, KeyLabel)
                
                local BindBtn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 9, Parent = KeyLabel })
                BindBtn.MouseButton1Click:Connect(function()
                    if bind.Binding then return end
                    bind.Binding = true
                    bind.Started = tick()
                    KeyLabel.Text = "?"
                    KeyLabel.TextColor3 = Library.Theme.Accent
                end)
                UserInputService.InputBegan:Connect(function(input)
                    if bind.Binding and (tick() - bind.Started) > 0.01 then
                        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                            bind.Binding = false
                            bind.Key = (input.UserInputType == Enum.UserInputType.Keyboard) and input.KeyCode or input.UserInputType
                            KeyLabel.Text = GetKeyName(bind.Key)
                            KeyLabel.TextColor3 = Library.Theme.Text
                            if flag then
                                if type(Library.Flags[flag]) == "table" then
                                    Library.Flags[flag].Key = bind.Key
                                    Library.Flags[flag].key = bind.Key
                                else
                                    Library.Flags[flag] = { Key = bind.Key, key = bind.Key, mode = mode, Toggled = false, active = false }
                                end
                            end
                            if opts.Callback then opts.Callback(bind.Key) end
                        end
                    end
                end)
                table.insert(Library.Registry, bind)
                local Obj = { SetVisibility = function(s) Holder.Visible = (s == true) end }
                return Obj
            end

            function Section:TextBox(opts)
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Label = Create("TextLabel", { Text = opts.Name or "Text Box", Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local Box = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 16), BackgroundColor3 = Library.Theme.Background, ZIndex = 7, Parent = Holder })
                ApplyCelestiteStyle(Box)
                local Input = Create("TextBox", { Text = opts.Default or "", PlaceholderText = opts.Placeholder or "...", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8, Parent = Box, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.TextBoxes, { Box = Box, Input = Input })
                Input.FocusLost:Connect(function()
                    if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = Input.Text end
                    if opts.Callback then opts.Callback(Input.Text) end
                end)
                local Obj = { GetText = function() return Input.Text end, SetText = function(t) Input.Text = t; if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = t end end, Set = function(t) Input.Text = t; if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = t end end, SetVisibility = function(s) Holder.Visible = (s == true) end }
                if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = opts.Default or "" end
                return Obj
            end
            Section.Textbox = Section.TextBox

            function Section:ColorPicker(opts)
                local h, s, v = 0, 1, 1
                local color = opts.Default or opts.color or Color3.fromHSV(h, s, v)
                h, s, v = Color3.toHSV(color)
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Label = Create("TextLabel", { Text = opts.Name or "Color Picker", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local CPHolder = Create("Frame", { Size = UDim2.new(0, 18, 0, 10), Position = UDim2.new(1, -18, 0, 3), BackgroundColor3 = color, ZIndex = 7, Parent = Holder })
                ApplyCelestiteStyle(CPHolder)
                local CPBtn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 8, Parent = CPHolder })
                local Picker = Create("Frame", { Size = UDim2.new(0, 160, 0, 140), BackgroundColor3 = Library.Theme.DarkBackground, Visible = false, ZIndex = 300, Parent = ScreenGui })
                AddInlineOutline(Picker)
                table.insert(Library.Elements.ColorPickers, { Frame = Holder, Picker = Picker, SetPreview = function(c) CPHolder.BackgroundColor3 = c end })
                local HueSlider = Create("Frame", { Size = UDim2.new(0, 12, 0, 120), Position = UDim2.new(1, -22, 0, 10), ZIndex = 301, Parent = Picker, Active = true })
                ApplyCelestiteStyle(HueSlider)
                local HueBtn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 305, Parent = HueSlider })
                Create("UIGradient", { Rotation = 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}), Parent = HueSlider })
                local HueMarker = Create("Frame", { Size = UDim2.new(1, 4, 0, 2), Position = UDim2.new(0, -2, h, 0), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 302, Parent = HueSlider })
                local SVBox = Create("Frame", { Size = UDim2.new(0, 120, 0, 120), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 301, Parent = Picker, Active = true })
                ApplyCelestiteStyle(SVBox)
                local SVBtn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 305, Parent = SVBox })
                local SatGradient = Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 302, Parent = SVBox, BackgroundTransparency = 0 })
                Create("UIGradient", { Color = ColorSequence.new(Color3.new(1,1,1)), Transparency = NumberSequence.new(0, 1), Parent = SatGradient })
                local ValGradient = Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0), ZIndex = 303, Parent = SVBox, BackgroundTransparency = 0 })
                Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(0,0,0)), Transparency = NumberSequence.new(1, 0), Parent = ValGradient })
                local Marker = Create("Frame", { Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(s, -2, 1-v, -2), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 304, Parent = SVBox })
                Create("UIStroke", { Color = Color3.new(0,0,0), Thickness = 1, Parent = Marker })
                local sS, sH = false, false; local pickerConn, renderConn
                local function UpdatePos() local pos = CPHolder.AbsolutePosition; Picker.Position = UDim2.new(0, pos.X + 25, 0, pos.Y) end
                local function ClosePicker() Picker.Visible = false; if pickerConn then pickerConn:Disconnect(); pickerConn = nil end; if renderConn then renderConn:Disconnect(); renderConn = nil end end
                CPBtn.MouseButton1Click:Connect(function() 
                    if Picker.Visible then ClosePicker() else UpdatePos(); Picker.Visible = true; renderConn = game:GetService("RunService").RenderStepped:Connect(UpdatePos); pickerConn = UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then if not IsWithin(Picker, input) and not IsWithin(CPHolder, input) then ClosePicker() end end end) end 
                end)
                local function Set(color)
                    h, s, v = color:ToHSV()
                    CPHolder.BackgroundColor3 = color
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    Marker.Position = UDim2.new(s, -2, 1-v, -2)
                    HueMarker.Position = UDim2.new(0, -2, h, 0)
                    if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = color end
                    if opts.Callback then opts.Callback(color) end
                end
                local CPObj = { Set = Set, Get = function() return Color3.fromHSV(h, s, v) end, SetVisibility = function(st) Holder.Visible = (st == true); if not st and Picker then ClosePicker() end end }
                if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = color end
                SVBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sS = true end end)
                HueBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sH = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sS = false; sH = false end end)
                UserInputService.InputChanged:Connect(function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseMovement then 
                        if sS then 
                            local relX = math.clamp((i.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            local relY = math.clamp((i.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            s, v = relX, 1 - relY
                            Marker.Position = UDim2.new(s, -2, 1-v, -2)
                            local newClr = Color3.fromHSV(h, s, v)
                            if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = newClr end
                            if opts.Callback then opts.Callback(newClr) end
                            CPHolder.BackgroundColor3 = newClr
                        elseif sH then 
                            h = math.clamp((i.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                            HueMarker.Position = UDim2.new(0, -2, h, 0)
                            SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                            local newClr = Color3.fromHSV(h, s, v)
                            if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = newClr end
                            if opts.Callback then opts.Callback(newClr) end
                            CPHolder.BackgroundColor3 = newClr
                        end 
                    end 
                end)
                return CPObj
            end
            Section.Colorpicker = Section.ColorPicker

            function Section:Toggle(opts)
                local state = opts.Default or false
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Box = Create("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0.5, -5), BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(50, 50, 50), BorderSizePixel = 0, ZIndex = 7, Parent = Holder })
                ApplyCelestiteStyle(Box)
                local Label = Create("TextLabel", { Text = opts.Name or "Toggle", Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = state and Library.Theme.Text or Library.Theme.InactiveText, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local RightSide = Create("Frame", { Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, ZIndex = 8, Parent = Holder })
                Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = RightSide })
                local function Set(v)
                    state = v
                    if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = state end
                    Tween(Box, {BackgroundColor3 = state and Library.Theme.Accent or Color3.fromRGB(50, 50, 50)})
                    Tween(Label, {TextColor3 = state and Library.Theme.Text or Library.Theme.InactiveText})
                    if opts.Callback then opts.Callback(state) end
                    if triggerDependencies then triggerDependencies() end
                end
                local function ToggleState() state = not state; Set(state) end
                local btn = Create("TextButton", { Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = "", TextTransparency = 1, ZIndex = 9, Parent = Holder })
                btn.MouseButton1Click:Connect(ToggleState)
                local ToggleObj = { GetState = function() return state end, Get = function() return state end, Set = Set, SetVisibility = function(s) Holder.Visible = (s == true) end }
                table.insert(Library.Elements.Toggles, { Box = Box, Label = Label, GetState = function() return state end })
                if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = state end
                if opts.Callback then
                    local initCallback = opts.Callback
                    task.spawn(function()
                        task.wait(0.05)
                        pcall(initCallback, state)
                    end)
                end
                
                function ToggleObj:Keybind(kopts)
                    local flag = kopts.Flag
                    local defaultKey = kopts.Key or kopts.Default or Enum.KeyCode.X
                    local bind = { Key = defaultKey, Binding = false, Started = 0, Label = nil, OnTrigger = ToggleState, Callback = kopts.Callback }
                    if flag then
                        if type(Library.Flags[flag]) == "table" then
                            Library.Flags[flag].Key = defaultKey
                            Library.Flags[flag].key = defaultKey
                        else
                            Library.Flags[flag] = { Key = defaultKey, key = defaultKey, mode = "Toggle", Toggled = false, active = false }
                        end
                    end
                    local Label = Create("TextLabel", { Text = GetKeyName(bind.Key), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 9, Parent = RightSide, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                    bind.Label = Label; table.insert(Library.Elements.Labels, Label)
                    local BindBtn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 11, Parent = bind.Label })
                    BindBtn.MouseButton1Click:Connect(function() if bind.Binding then return end; bind.Binding = true; bind.Started = tick(); bind.Label.Text = "?"; bind.Label.TextColor3 = Library.Theme.Accent end)
                    UserInputService.InputBegan:Connect(function(input)
                        if bind.Binding and (tick() - bind.Started) > 0.01 then
                            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                                bind.Binding = false
                                bind.Key = (input.UserInputType == Enum.UserInputType.Keyboard) and input.KeyCode or input.UserInputType
                                bind.Label.Text = GetKeyName(bind.Key)
                                bind.Label.TextColor3 = Library.Theme.Text
                                if flag then
                                    if type(Library.Flags[flag]) == "table" then
                                        Library.Flags[flag].Key = bind.Key
                                        Library.Flags[flag].key = bind.Key
                                    else
                                        Library.Flags[flag] = { Key = bind.Key, key = bind.Key, mode = "Toggle", Toggled = false, active = false }
                                    end
                                end
                                if bind.Callback then bind.Callback(bind.Key) end
                            end
                        end
                    end)
                    table.insert(Library.Registry, bind)
                    return ToggleObj
                end

                function ToggleObj:ColorPicker(copts)
                    local h, s, v = 0, 1, 1
                    local color = copts.Default or copts.color or Color3.fromHSV(h, s, v)
                    h, s, v = Color3.toHSV(color)

                    -- Color preview swatch (on the toggle row)
                    local CPHolder = Create("Frame", {
                        Size = UDim2.new(0, 18, 0, 10),
                        BackgroundColor3 = color,
                        ZIndex = 10,
                        Parent = RightSide
                    })
                    ApplyCelestiteStyle(CPHolder)
                    local CPBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        ZIndex = 11,
                        Parent = CPHolder
                    })
                    table.insert(Library.Elements.ColorPickers, {
                        Frame = CPHolder,
                        SetPreview = function(c) CPHolder.BackgroundColor3 = c end
                    })

                    -- Picker window (200w x 210h)
                    local Picker = Create("Frame", {
                        Size = UDim2.new(0, 206, 0, 218),
                        BackgroundColor3 = Library.Theme.DarkBackground,
                        Visible = false,
                        ZIndex = 5000,
                        Parent = ScreenGui,
                        ClipsDescendants = false
                    })
                    AddInlineOutline(Picker, Library.Theme.Inline, Library.Theme.Outline)

                    -- SV box (big square)
                    local SVBox = Create("Frame", {
                        Size = UDim2.new(0, 160, 0, 160),
                        Position = UDim2.new(0, 6, 0, 6),
                        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                        ZIndex = 5001,
                        Parent = Picker
                    })
                    ApplyCelestiteStyle(SVBox)
                    -- White saturation gradient
                    local SatGrad = Create("Frame", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.new(1,1,1),
                        ZIndex = 5002,
                        Parent = SVBox
                    })
                    Create("UIGradient", {
                        Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
                        Transparency = NumberSequence.new(0, 1),
                        Parent = SatGrad
                    })
                    -- Black value gradient
                    local ValGrad = Create("Frame", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.new(0,0,0),
                        ZIndex = 5003,
                        Parent = SVBox
                    })
                    Create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
                        Transparency = NumberSequence.new(1, 0),
                        Parent = ValGrad
                    })
                    -- SV cursor
                    local SVMarker = Create("Frame", {
                        Size = UDim2.new(0, 8, 0, 8),
                        Position = UDim2.new(s, -4, 1-v, -4),
                        BackgroundColor3 = Color3.new(1,1,1),
                        ZIndex = 5006,
                        Parent = SVBox,
                        BorderSizePixel = 0
                    })
                    Create("UIStroke", { Color = Color3.new(0,0,0), Thickness = 1.5, Parent = SVMarker })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SVMarker })

                    -- Hue bar (vertical, right of SV)
                    local HueBar = Create("Frame", {
                        Size = UDim2.new(0, 14, 0, 160),
                        Position = UDim2.new(0, 172, 0, 6),
                        ZIndex = 5001,
                        Parent = Picker
                    })
                    ApplyCelestiteStyle(HueBar)
                    Create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                            ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                            ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                        }),
                        Parent = HueBar
                    })
                    local HueMarker = Create("Frame", {
                        Size = UDim2.new(1, 4, 0, 4),
                        Position = UDim2.new(0, -2, h, -2),
                        BackgroundColor3 = Color3.new(1,1,1),
                        ZIndex = 5006,
                        BorderSizePixel = 0,
                        Parent = HueBar
                    })
                    Create("UIStroke", { Color = Color3.new(0,0,0), Thickness = 1, Parent = HueMarker })

                    -- Hex input row
                    local HexRow = Create("Frame", {
                        Size = UDim2.new(0, 192, 0, 18),
                        Position = UDim2.new(0, 6, 0, 172),
                        BackgroundTransparency = 1,
                        ZIndex = 5001,
                        Parent = Picker
                    })
                    local HexLabel = Create("TextLabel", {
                        Text = "#",
                        Size = UDim2.new(0, 14, 1, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = Library.Theme.Text,
                        FontFace = true,
                        TextSize = Library.Config.FontSize,
                        ZIndex = 5002,
                        Parent = HexRow,
                        TextStrokeTransparency = 0,
                        TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    })
                    local HexBox = Create("TextBox", {
                        Size = UDim2.new(0, 120, 1, 0),
                        Position = UDim2.new(0, 14, 0, 0),
                        BackgroundColor3 = Library.Theme.SectionBackground,
                        TextColor3 = Library.Theme.Text,
                        Text = string.format("%02X%02X%02X", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)),
                        FontFace = true,
                        TextSize = Library.Config.FontSize,
                        PlaceholderText = "FFFFFF",
                        ClearTextOnFocus = false,
                        ZIndex = 5002,
                        Parent = HexRow
                    })
                    AddInlineOutline(HexBox, Library.Theme.Inline, Library.Theme.Outline)
                    -- Copy button
                    local CopyBtn = Create("TextButton", {
                        Size = UDim2.new(0, 28, 1, 0),
                        Position = UDim2.new(0, 136, 0, 0),
                        BackgroundColor3 = Library.Theme.SectionBackground,
                        Text = "cpy",
                        TextColor3 = Library.Theme.Text,
                        FontFace = true,
                        TextSize = Library.Config.FontSize - 1,
                        ZIndex = 5002,
                        Parent = HexRow
                    })
                    AddInlineOutline(CopyBtn, Library.Theme.Inline, Library.Theme.Outline)
                    -- Paste button
                    local PasteBtn = Create("TextButton", {
                        Size = UDim2.new(0, 28, 1, 0),
                        Position = UDim2.new(0, 166, 0, 0),
                        BackgroundColor3 = Library.Theme.SectionBackground,
                        Text = "pst",
                        TextColor3 = Library.Theme.Text,
                        FontFace = true,
                        TextSize = Library.Config.FontSize - 1,
                        ZIndex = 5002,
                        Parent = HexRow
                    })
                    AddInlineOutline(PasteBtn, Library.Theme.Inline, Library.Theme.Outline)

                    -- Preview row
                    local PreviewRow = Create("Frame", {
                        Size = UDim2.new(0, 192, 0, 14),
                        Position = UDim2.new(0, 6, 0, 196),
                        BackgroundTransparency = 1,
                        ZIndex = 5001,
                        Parent = Picker
                    })
                    local OldPreview = Create("Frame", {
                        Size = UDim2.new(0, 93, 1, 0),
                        BackgroundColor3 = color,
                        ZIndex = 5002,
                        Parent = PreviewRow
                    })
                    AddInlineOutline(OldPreview)
                    local NewPreview = Create("Frame", {
                        Size = UDim2.new(0, 93, 1, 0),
                        Position = UDim2.new(0, 99, 0, 0),
                        BackgroundColor3 = color,
                        ZIndex = 5002,
                        Parent = PreviewRow
                    })
                    AddInlineOutline(NewPreview)

                    -- Picker state
                    local pickerConn, renderConn
                    local draggingSV, draggingH = false, false

                    local function colorToHex(c)
                        return string.format("%02X%02X%02X",
                            math.floor(c.R * 255 + 0.5),
                            math.floor(c.G * 255 + 0.5),
                            math.floor(c.B * 255 + 0.5))
                    end

                    local function hexToColor(hex)
                        hex = hex:gsub("#", ""):upper()
                        if #hex == 6 then
                            local r = tonumber(hex:sub(1,2), 16)
                            local g = tonumber(hex:sub(3,4), 16)
                            local b = tonumber(hex:sub(5,6), 16)
                            if r and g and b then
                                return Color3.fromRGB(r, g, b)
                            end
                        end
                        return nil
                    end

                    local function updatePickerColor()
                        color = Color3.fromHSV(h, s, v)
                        CPHolder.BackgroundColor3 = color
                        NewPreview.BackgroundColor3 = color
                        SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        SVMarker.Position = UDim2.new(s, -4, 1-v, -4)
                        HueMarker.Position = UDim2.new(0, -2, h, -2)
                        HexBox.Text = colorToHex(color)
                        if copts.Flag then Library.Flags[copts.Flag] = color end
                        if copts.Callback then pcall(copts.Callback, color) end
                    end

                    -- SV drag
                    SVBox.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSV = true
                            local relX = math.clamp((i.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            local relY = math.clamp((i.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            s, v = relX, 1 - relY
                            updatePickerColor()
                        end
                    end)
                    HueBar.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingH = true
                            h = math.clamp((i.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            updatePickerColor()
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement then
                            if draggingSV then
                                local relX = math.clamp((i.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                                local relY = math.clamp((i.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                                s, v = relX, 1 - relY
                                updatePickerColor()
                            elseif draggingH then
                                h = math.clamp((i.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                                updatePickerColor()
                            end
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSV = false
                            draggingH = false
                        end
                    end)

                    -- Hex input apply on enter/focus lost
                    HexBox.FocusLost:Connect(function()
                        local c = hexToColor(HexBox.Text)
                        if c then
                            h, s, v = Color3.toHSV(c)
                            updatePickerColor()
                        else
                            HexBox.Text = colorToHex(color)
                        end
                    end)

                    -- Copy / Paste
                    CopyBtn.MouseButton1Click:Connect(function()
                        pcall(function() setclipboard(colorToHex(color)) end)
                    end)
                    PasteBtn.MouseButton1Click:Connect(function()
                        local ok, clip = pcall(function() return getclipboard() end)
                        if ok and clip then
                            local c = hexToColor(tostring(clip))
                            if c then
                                h, s, v = Color3.toHSV(c)
                                updatePickerColor()
                            end
                        end
                    end)

                    local function UpdatePickerPosition()
                        local pos = CPHolder.AbsolutePosition
                        local screenSize = ScreenGui.AbsoluteSize
                        local pickerW, pickerH = 206, 218
                        local px = pos.X + 26
                        local py = pos.Y - 10
                        if px + pickerW > screenSize.X then px = pos.X - pickerW - 4 end
                        if py + pickerH > screenSize.Y then py = screenSize.Y - pickerH - 4 end
                        if py < 0 then py = 4 end
                        Picker.Position = UDim2.new(0, px, 0, py)
                    end

                    local function ClosePicker()
                        Picker.Visible = false
                        if pickerConn then pickerConn:Disconnect(); pickerConn = nil end
                        if renderConn then renderConn:Disconnect(); renderConn = nil end
                        OldPreview.BackgroundColor3 = color
                    end

                    CPBtn.MouseButton1Click:Connect(function()
                        if Picker.Visible then
                            ClosePicker()
                        else
                            OldPreview.BackgroundColor3 = color
                            UpdatePickerPosition()
                            Picker.Visible = true
                            renderConn = game:GetService("RunService").RenderStepped:Connect(UpdatePickerPosition)
                            pickerConn = UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    if not IsWithin(Picker, input) and not IsWithin(CPHolder, input) then
                                        ClosePicker()
                                    end
                                end
                            end)
                        end
                    end)

                    if copts.Flag then Library.Flags[copts.Flag] = color end
                    return ToggleObj
                end
                ToggleObj.Colorpicker = ToggleObj.ColorPicker
                
                return ToggleObj
            end

            function Section:Slider(opts)
                local min, max = opts.Min or 0, opts.Max or 100
                local val = opts.Default or min; local sliding = false
                local Holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Value = Create("TextLabel", { Text = tostring(val), Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Value)
                local Label = Create("TextLabel", { Text = opts.Name or "Slider", Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local SliderBack = Create("Frame", { Name = "SliderBack", Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 16), BackgroundColor3 = Library.Theme.SectionBackground, BorderSizePixel = 0, ZIndex = 7, Parent = Holder })
                AddInlineOutline(SliderBack)
                local SliderFill = Create("Frame", { Name = "Fill", Size = UDim2.new((val - min) / (max - min), 0, 1, 0), BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, ZIndex = 8, Parent = SliderBack })
                
                table.insert(Library.Elements.Sliders, { Fill = SliderFill, Label = Label, Value = Value, Back = SliderBack })
                local btn = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", TextTransparency = 1, ZIndex = 10, Parent = SliderBack })
                local function update(input)
                    local pct = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + (max - min) * pct)
                    if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = val end
                    SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                    Value.Text = tostring(val)
                    if opts.Callback then opts.Callback(val) end
                    if triggerDependencies then triggerDependencies() end
                end
                local function Set(v)
                    val = v
                    if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = val end
                    SliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    Value.Text = tostring(val)
                    if opts.Callback then opts.Callback(val) end
                    if triggerDependencies then triggerDependencies() end
                end
                btn.MouseButton1Down:Connect(function() sliding = true end); UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
                local Obj = { Get = function() return val end, Set = Set, SetVisibility = function(s) Holder.Visible = (s == true) end }
                if opts.Flag or opts.Name then Library.Flags[opts.Flag or opts.Name] = val end
                return Obj
            end

            function Section:Dropdown(opts)
                local optionsList = opts.Options or opts.Content or opts.Items or {}
                local dropped = false
                local selected = nil
                local selectedSet = {}
                if opts.Multi then
                    selected = {}
                    if type(opts.Default) == "table" then
                        for _, item in ipairs(opts.Default) do
                            selectedSet[item] = true
                            table.insert(selected, item)
                        end
                    elseif opts.Default ~= nil then
                        selected = { opts.Default }
                        selectedSet[opts.Default] = true
                    end
                else
                    selected = opts.Default or optionsList[1] or "None"
                end

                local function formatSelected()
                    if opts.Multi then
                        if type(selected) ~= "table" then
                            return "None"
                        end
                        if #selected == 0 then
                            return "None"
                        end
                        local strList = {}
                        for _, item in ipairs(selected) do
                            table.insert(strList, tostring(item))
                        end
                        return table.concat(strList, ", ")
                    end
                    return tostring(selected)
                end

                local Holder = Create("Frame", { Name = "DropdownHolder", Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, ZIndex = 6, Parent = ElementList })
                local Label = Create("TextLabel", { Text = opts.Name or "Dropdown", Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7, Parent = Holder, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Label)
                local Box = Create("Frame", { Name = "DropdownBox", Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 15), BackgroundColor3 = Library.Theme.SectionBackground, BorderSizePixel = 0, ZIndex = 7, Parent = Holder })
                ApplyCelestiteStyle(Box)
                local ValueLabel = Create("TextLabel", { Text = formatSelected(), Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 6, 0, 0), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 8, Parent = Box, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, ValueLabel)
                local Arrow = Create("TextLabel", { Text = "v", Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, -1), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 8, Parent = Box, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                table.insert(Library.Elements.Labels, Arrow)
                local Button = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 9, Parent = Box })
                
                local DropContainer = Create("Frame", { Name = "DropContainer", BackgroundColor3 = Library.Theme.DarkBackground, BorderSizePixel = 0, Visible = false, ZIndex = 5000, Parent = ScreenGui, ClipsDescendants = true })
                AddOutline(DropContainer)
                AddInlineOutline(DropContainer)
                
                local OptionHolder = Create("ScrollingFrame", { Name = "Options", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5001, Parent = DropContainer, ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y })
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = OptionHolder })
                
                local function updateFlag()
                    if opts.Flag or opts.Name then
                        if opts.Multi then
                            local copy = {}
                            for _, v in ipairs(selected) do
                                table.insert(copy, v)
                            end
                            Library.Flags[opts.Flag or opts.Name] = copy
                        else
                            Library.Flags[opts.Flag or opts.Name] = selected
                        end
                    end
                end

                local function UpdateList(new)
                    if new then optionsList = new end
                    OptionHolder:ClearAllChildren()
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = OptionHolder })
                    
                    if #optionsList == 0 then
                        Create("TextLabel", { Text = "None", Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = Library.Theme.InactiveText, ZIndex = 5005, Parent = OptionHolder, TextXAlignment = Enum.TextXAlignment.Center })
                    else
                        for _, option in ipairs(optionsList) do
                            local optionText = tostring(option)
                            local isSelected = opts.Multi and selectedSet[option] or (not opts.Multi and tostring(option) == tostring(selected))
                            local optBtn = Create("TextButton", { Text = optionText, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, FontFace = true, TextSize = Library.Config.FontSize, TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.Text, BorderSizePixel = 0, ZIndex = 5005, Parent = OptionHolder, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
                            Create("UIPadding", { PaddingLeft = UDim.new(0, 6), Parent = optBtn })
                            optBtn.MouseButton1Click:Connect(function() 
                                if opts.Multi then
                                    if selectedSet[option] then
                                        selectedSet[option] = nil
                                        for i = #selected, 1, -1 do
                                            if selected[i] == option then table.remove(selected, i) end
                                        end
                                    else
                                        selectedSet[option] = true
                                        table.insert(selected, option)
                                    end
                                    updateFlag()
                                    ValueLabel.Text = formatSelected()
                                    if opts.Callback then opts.Callback(selected) end
                                    if triggerDependencies then triggerDependencies() end
                                    UpdateList()
                                else
                                    selected = option
                                    updateFlag()
                                    ValueLabel.Text = tostring(option)
                                    dropped = false
                                    DropContainer.Visible = false
                                    Arrow.Text = "v"
                                    Arrow.Position = UDim2.new(1, -20, 0, -1)
                                    if opts.Callback then opts.Callback(option) end
                                    if triggerDependencies then triggerDependencies() end
                                    UpdateList()
                                end
                            end)
                        end
                    end
                    
                    local h = math.clamp(#optionsList * 18, 18, 200)
                    if #optionsList == 0 then h = 18 end
                    DropContainer.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, h)
                end

                table.insert(Library.Elements.Dropdowns, {
                    Box = Box,
                    Label = Label,
                    ValueLabel = ValueLabel,
                    Arrow = Arrow,
                    Container = DropContainer,
                    OptionHolder = OptionHolder,
                    UpdateList = UpdateList
                })
                
                Button.MouseButton1Click:Connect(function()
                    dropped = not dropped
                    if dropped then
                        if opts.OnOpen then opts.OnOpen() end
                        task.defer(function()
                            UpdateList()
                            DropContainer.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y + 20)
                            DropContainer.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, DropContainer.Size.Y.Offset)
                            DropContainer.Visible = true
                            Arrow.Text = "^"
                            Arrow.Position = UDim2.new(1, -20, 0, 2)
                        end)
                    else
                        DropContainer.Visible = false
                        Arrow.Text = "v"
                        Arrow.Position = UDim2.new(1, -20, 0, -1)
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dropped then
                        if not IsWithin(DropContainer, input) and not IsWithin(Box, input) then
                            dropped = false; DropContainer.Visible = false; Arrow.Text = "v"; Arrow.Position = UDim2.new(1, -20, 0, -1)
                        end
                    end
                end)
                
                local Obj = { 
                    Get = function()
                        if opts.Multi then
                            local copy = {}
                            for _, v in ipairs(selected) do table.insert(copy, v) end
                            return copy
                        end
                        return selected
                    end, 
                    Set = function(v)
                        if opts.Multi then
                            selected = {}
                            selectedSet = {}
                            if type(v) == "table" then
                                for _, item in ipairs(v) do
                                    if item ~= nil then
                                        selectedSet[item] = true
                                        table.insert(selected, item)
                                    end
                                end
                            elseif v ~= nil then
                                selected = { v }
                                selectedSet[v] = true
                            end
                        else
                            selected = v
                        end
                        updateFlag()
                        ValueLabel.Text = formatSelected()
                        UpdateList()
                        if triggerDependencies then triggerDependencies() end
                    end,
                    Refresh = function(new) UpdateList(new) end,
                    SetVisibility = function(s) 
                        Holder.Visible = (s == true)
                        if not s and dropped then
                            dropped = false
                            DropContainer.Visible = false
                            Arrow.Text = "v"
                            Arrow.Position = UDim2.new(1, -20, 0, -1)
                        end
                    end
                }
                updateFlag()
                return Obj
            end
            return Section
        end

        function Tab:Themes(side)
            local ThemeSection = Tab:Section("Theme Settings", side or "Right")
            local ThemeDir = "alternate/themes"
            pcall(function() if not isfolder("alternate") then makefolder("alternate") end end)
            pcall(function() if not isfolder(ThemeDir) then makefolder(ThemeDir) end end)

            ThemeSection:ColorPicker({ Name = "Accent Color", Default = Library.Theme.Accent, Callback = function(c) Library.Theme.Accent = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Background Color", Default = Library.Theme.Background, Callback = function(c) Library.Theme.Background = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Dark Background", Default = Library.Theme.DarkBackground, Callback = function(c) Library.Theme.DarkBackground = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Text Color", Default = Library.Theme.Text, Callback = function(c) Library.Theme.Text = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Inactive Text", Default = Library.Theme.InactiveText, Callback = function(c) Library.Theme.InactiveText = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Outline Color", Default = Library.Theme.Outline, Callback = function(c) Library.Theme.Outline = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Inline Color", Default = Library.Theme.Inline, Callback = function(c) Library.Theme.Inline = c; Library:UpdateTheme() end })
            ThemeSection:ColorPicker({ Name = "Section Background", Default = Library.Theme.SectionBackground, Callback = function(c) Library.Theme.SectionBackground = c; Library:UpdateTheme() end })

            ThemeSection:Toggle({ Name = "Sync Theme To Features", Flag = "SyncThemeToFeatures", Default = false, Callback = function() Library:SyncThemeToFeatures() end })

            local ThemePresets = {
                ["Default Orange"] = { Accent = Color3.fromRGB(255, 170, 0), Background = Color3.fromRGB(15, 15, 15), DarkBackground = Color3.fromRGB(22, 22, 22), Text = Color3.fromRGB(255, 255, 255), InactiveText = Color3.fromRGB(165, 165, 165), Outline = Color3.fromRGB(0, 0, 0), Inline = Color3.fromRGB(45, 45, 45), SectionBackground = Color3.fromRGB(22, 22, 22) },
                ["Purple Haze"] = { Accent = Color3.fromRGB(160, 32, 240), Background = Color3.fromRGB(14, 12, 18), DarkBackground = Color3.fromRGB(20, 18, 26), Text = Color3.fromRGB(240, 240, 250), InactiveText = Color3.fromRGB(140, 130, 160), Outline = Color3.fromRGB(0, 0, 0), Inline = Color3.fromRGB(40, 35, 50), SectionBackground = Color3.fromRGB(22, 20, 28) },
                ["Cyanide"] = { Accent = Color3.fromRGB(0, 220, 255), Background = Color3.fromRGB(10, 15, 20), DarkBackground = Color3.fromRGB(16, 22, 28), Text = Color3.fromRGB(240, 255, 255), InactiveText = Color3.fromRGB(120, 150, 160), Outline = Color3.fromRGB(0, 0, 0), Inline = Color3.fromRGB(30, 45, 55), SectionBackground = Color3.fromRGB(16, 22, 28) },
                ["Crimson"] = { Accent = Color3.fromRGB(255, 40, 60), Background = Color3.fromRGB(18, 10, 12), DarkBackground = Color3.fromRGB(26, 16, 18), Text = Color3.fromRGB(255, 240, 240), InactiveText = Color3.fromRGB(160, 120, 125), Outline = Color3.fromRGB(0, 0, 0), Inline = Color3.fromRGB(50, 30, 35), SectionBackground = Color3.fromRGB(24, 16, 18) },
            }

            local presetList = {"Default Orange", "Purple Haze", "Cyanide", "Crimson"}
            local PresetDropdown = ThemeSection:Dropdown({ Name = "Theme Presets", Options = presetList, Default = "Default Orange" })
            ThemeSection:Button({ Name = "Apply Preset", Callback = function()
                local sel = PresetDropdown:Get()
                local preset = ThemePresets[sel]
                if preset then
                    for k, clr in pairs(preset) do Library.Theme[k] = clr end
                    Library:UpdateTheme()
                end
            end })

            local themeNameInput = ""
            ThemeSection:TextBox({ Name = "Theme Name", Placeholder = "CustomTheme...", Callback = function(v) themeNameInput = v end })
            local ThemeList = ThemeSection:Dropdown({ Name = "Custom Themes", Options = {} })
            
            local function refreshThemes()
                local names = {}
                pcall(function()
                    if isfolder(ThemeDir) then
                        for _, file in ipairs(listfiles(ThemeDir)) do
                            local n = file:match("([^/\\]+)$") or file
                            n = n:gsub("%.json$", ""):gsub("%.JSON$", "")
                            table.insert(names, n)
                        end
                    end
                end)
                ThemeList:Refresh(names)
            end
            ThemeList.OnOpen = refreshThemes

            ThemeSection:Button({ Name = "Export Theme", Callback = function()
                if themeNameInput == "" then return end
                local data = {}
                for k, v in pairs(Library.Theme) do data[k] = {v.R * 255, v.G * 255, v.B * 255} end
                pcall(function()
                    writefile(ThemeDir .. "/" .. themeNameInput .. ".json", HttpService:JSONEncode(data))
                end)
                refreshThemes()
            end })

            ThemeSection:Button({ Name = "Import Theme", Callback = function()
                local sel = ThemeList:Get()
                if not sel or sel == "" then return end
                pcall(function()
                    local raw = readfile(ThemeDir .. "/" .. sel .. ".json")
                    local data = HttpService:JSONDecode(raw)
                    for k, clr in pairs(data) do
                        if Library.Theme[k] and type(clr) == "table" then
                            Library.Theme[k] = Color3.fromRGB(clr[1], clr[2], clr[3])
                        end
                    end
                    Library:UpdateTheme()
                end)
            end })

            task.spawn(function()
                task.wait(0.2)
                refreshThemes()
            end)

            return ThemeSection
        end

        function Tab:Configs(side)
            local ConfigSection = Tab:Section("Configuration", side or "Left")
            local ConfigDir = "alternate/configs"
            pcall(function() if not isfolder("alternate") then makefolder("alternate") end end)
            pcall(function() if not isfolder(ConfigDir) then makefolder(ConfigDir) end end)

            local ConfigName = ""
            local NameBox = ConfigSection:TextBox({ Name = "Config Name", Placeholder = "...", Callback = function(v) ConfigName = v end })
            local ConfigList = ConfigSection:Dropdown({ Name = "Saved Configs", Options = {} })
            
            local function Refresh()
                local names = {}
                pcall(function()
                    local files = listfiles(ConfigDir)
                    for _, file in pairs(files) do
                        local name = file:match("([^/\\]+)$") or file
                        name = name:gsub("%.json$", ""):gsub("%.JSON$", ""):gsub("%.cfg$", "")
                        names[#names + 1] = name
                    end
                end)
                ConfigList:Refresh(names)
            end
            
            ConfigList.OnOpen = Refresh

            ConfigSection:Button({ Name = "Save Config", Callback = function()
                if ConfigName == "" then 
                    Library:Notification({ Text = "Enter a config name", Duration = 3 })
                    return 
                end
                local data = { Theme = {}, Flags = {} }
                for k, v in pairs(Library.Theme) do data.Theme[k] = {v.R * 255, v.G * 255, v.B * 255} end
                for k, v in pairs(Library.Flags) do
                    local val = (v.Get and v.Get()) or (v.GetState and v.GetState()) or (v.GetText and v.GetText())
                    if typeof(val) == "Color3" then val = {val.R * 255, val.G * 255, val.B * 255} end
                    data.Flags[k] = val
                end
                local success, err = pcall(function()
                    writefile(ConfigDir .. "/" .. ConfigName .. ".json", game:GetService("HttpService"):JSONEncode(data))
                end)
                if success then
                    Refresh()
                    Library:Notification({ Text = "Saved config: " .. ConfigName, Duration = 3 })
                else
                    Library:Notification({ Text = "Error saving config", Duration = 5 })
                end
            end })
            
            ConfigSection:Button({ Name = "Load Config", Callback = function()
                local selected = ConfigList:Get()
                if not selected or selected == "" then return end
                local path = ConfigDir .. "/" .. selected .. ".json"
                local success, err = pcall(function()
                    local data = game:GetService("HttpService"):JSONDecode(readfile(path))
                    for k, v in pairs(data.Theme or {}) do if Library.Theme[k] then Library.Theme[k] = Color3.fromRGB(v[1], v[2], v[3]) end end
                    Library:UpdateTheme()
                    for k, v in pairs(data.Flags or {}) do
                        if Library.Flags[k] then
                            local val = v
                            if type(val) == "table" and #val == 3 then val = Color3.fromRGB(val[1], val[2], val[3]) end
                            if type(Library.Flags[k]) == "table" and Library.Flags[k].Set then
                                Library.Flags[k].Set(val)
                            else
                                Library.Flags[k] = val
                            end
                        end
                    end
                end)
                if success then
                    Library:Notification({ Text = "Loaded config: " .. selected, Duration = 3 })
                else
                    Library:Notification({ Text = "Error loading config", Duration = 5 })
                end
            end })

            ConfigSection:Button({ Name = "Delete Config", Callback = function()
                local selected = ConfigList:Get()
                if not selected or selected == "" then return end
                pcall(function() delfile(ConfigDir .. "/" .. selected .. ".json") end)
                Refresh()
            end })

            task.spawn(function()
                Refresh()
                task.wait(0.5)
                Refresh()
            end)
            
            return ConfigSection
        end

        return Tab
    end
    
    task.delay(0.2, function() Library:UpdateTheme() end)
    return Window
end

-------------------------------------------------
-- INITIALIZE CELESTITE WINDOW & TABS
-------------------------------------------------
Library:Notify("loading alternate...", 3)

MainWindow = Library:Window("alternate", UDim2.new(0, 650, 0, 520))

local Watermark = Library:Watermark("alternate")
local KeybindList = Library:KeybindList()
Library.WatermarkObj = Watermark
Library.KeyList = KeybindList

local CombatTab = MainWindow:Tab("Combat")
local PlayerTab = MainWindow:Tab("Player")
local VisualsTab = MainWindow:Tab("Visuals")
local PlayersTab = MainWindow:Tab("Players")
local SettingsTab = MainWindow:Tab("Settings")

isDaTrack = table.find({72815132775027, 75159825516372, 90724401598574}, game.PlaceId) ~= nil
isHoodCustoms = table.find({9825515356, 11241892119, 80567999110374, 138995385694035}, game.PlaceId) ~= nil

-- Real SubTabs under main tabs
local AimbotSubPage = CombatTab:SubPage("Aimbot")
local SilentAimSubPage = CombatTab:SubPage("Silent Aim")

local MovementSubPage = PlayerTab:SubPage("Movement")
local AvatarSubPage = PlayerTab:SubPage("Avatar")

local ESPSubPage = VisualsTab:SubPage("ESP")
local ChamsSubPage = VisualsTab:SubPage("Chams")
local WorldSubPage = VisualsTab:SubPage("World")
local SkinsSubPage
if isHoodCustoms or isDaTrack then
    SkinsSubPage = VisualsTab:SubPage("Skins")
end

local MenuSec = SettingsTab:Section("Menu Settings", "Left")

MenuSec:Keybind({
    Name = "Menu Keybind",
    Flag = "MenuKeybind",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        if key then
            Library.MenuKeybind = tostring(key)
        end
    end
})

MenuSec:Toggle({
    Name = "Show Watermark",
    Flag = "ShowWatermark",
    Default = true,
    Callback = function(val)
        if Watermark and Watermark.SetVisibility then Watermark:SetVisibility(val) end
    end
})

MenuSec:Toggle({
    Name = "Show Keybind List",
    Flag = "ShowKeybindList",
    Default = true,
    Callback = function(val)
        if KeybindList and KeybindList.SetVisibility then KeybindList:SetVisibility(val) end
    end
})

MenuSec:Toggle({
    Name = "UserSync Enabled",
    Flag = "UserSyncEnabled",
    Default = (loadUserSyncPref and loadUserSyncPref()) or false,
    Callback = function(val)
        if saveUserSyncPref then saveUserSyncPref(val) end
    end
})

MenuSec:Button({
    Name = "Unload Script",
    Callback = function()
        if getgenv().UnloadAlternate then
            pcall(getgenv().UnloadAlternate)
        elseif Library and Library.Unload then
            pcall(Library.Unload, Library)
        end
    end
})

MenuSec:Button({
    Name = "Rejoin Server",
    Callback = function()
        pcall(function()
            local ts = game:GetService("TeleportService")
            local p = game.Players.LocalPlayer
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
        end)
    end
})

SettingsTab:Configs("Left")
SettingsTab:Themes("Right")

-- Dummy page structures for legacy compatibility
local CombatPage = CombatTab
local PlayerPage = PlayerTab
local VisualsPage = VisualsTab
local PlayersPage = PlayersTab
local SettingsPage = SettingsTab

SkinsTab1 = nil
SkinsTab2 = nil

local function hasKorblox(player)
    local char = player.Character
    if not char then return false end
    
    if char:FindFirstChild("Left Leg") and char["Left Leg"]:FindFirstChild("KorbloxGeneral") then return true end
    for _, item in ipairs(char:GetChildren()) do
        if item.Name:lower():find("korblox") then return true end
        for _, child in ipairs(item:GetChildren()) do
            if child.Name:lower():find("korblox") then return true end
        end
    end
    return false
end

local function hasHeadless(player)
    local char = player.Character
    if not char then return false end
    
    local head = char:FindFirstChild("Head")
    if not head then return false end
    
    if head.Size.X < 0.5 or head.Size.Y < 0.5 or head.Size.Z < 0.5 then return true end
    if head:FindFirstChild("face") and head.face.Texture == "" then return true end
    
    for _, item in ipairs(char:GetChildren()) do
        if item.Name:lower():find("headless") then return true end
    end
    return false
end

-------------------------------------------------
-- CELESTITE PLAYERLIST IMPLEMENTATION
-------------------------------------------------
local PlayerlistSec = PlayersTab:Section("Player List", "Left")
local ActionsSec = PlayersTab:Section("Actions", "Right")
PlayerInfoSec = PlayersTab:Section("Player Info", "Right")

_infoLabels = {
    _player = PlayerInfoSec:Label({ Name = "Player: None" }),
    _hp = PlayerInfoSec:Label({ Name = "HP: ?" }),
    _dist = PlayerInfoSec:Label({ Name = "Distance: 0m" }),
    _status = PlayerInfoSec:Label({ Name = "Status: Unknown" })
}

local PlayerlistObj = {}
local actionButtons = {}
local playerBtnMap = {}
local playerTagsMap = {}
local playerListCallback = nil

local function updatePlayerTags(player)
    if not player or not playerBtnMap[player] then return end
    local tags = {}
    if _lockedTargets and _lockedTargets[player] then table.insert(tags, "[T]") end
    if _plWhitelistLocal and _plWhitelistLocal[player] then table.insert(tags, "[W]") end
    if _playerIgnoreWallCheck and _playerIgnoreWallCheck[player] then table.insert(tags, "[IW]") end
    if _playerIgnoreDeadCheck and _playerIgnoreDeadCheck[player] then table.insert(tags, "[ID]") end
    if _playerIgnoreTeamCheck and _playerIgnoreTeamCheck[player] then table.insert(tags, "[IT]") end
    if _spectatingPlayer == player then table.insert(tags, "[S]") end
    
    if hasKorblox(player) then table.insert(tags, "[Korblox]") end
    if hasHeadless(player) then table.insert(tags, "[Headless]") end
    local isAlternate = false
    local userSync = _userSyncPlayers and _userSyncPlayers[player.Name]
    if userSync then
        if userSync.Enabled then isAlternate = true end
        if userSync.SkinSummary then
            table.insert(tags, "[" .. tostring(userSync.SkinSummary) .. "]")
        end
    end
    local tagsStr = table.concat(tags, " ")
    local fullText = player.Name .. (tagsStr ~= "" and (" " .. tagsStr) or "")
    playerTagsMap[player] = fullText
    if playerBtnMap[player] and playerBtnMap[player].SetText then
        playerBtnMap[player].SetText(fullText)
    end
end

function refreshPlayerList()
    for p, btn in pairs(playerBtnMap) do
        pcall(function() if btn and btn.Holder then btn.Holder:Destroy() end end)
    end
    playerBtnMap = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= lp then
            local btn = PlayerlistSec:Button({
                Name = p.Name,
                Callback = function()
                    _selectedPlayer = p
                    if _infoLabels._player then _infoLabels._player.set("Player: " .. p.Name) end
                    if playerListCallback then playerListCallback(p, "Select") end
                end
            })
            playerBtnMap[p] = btn
            updatePlayerTags(p)
        end
    end
end

local actionNames = {"Target", "Whitelist", "Ignore Wall", "Ignore Dead", "Ignore Team", "Spectate", "Teleport"}
for _, act in ipairs(actionNames) do
    actionButtons[act] = ActionsSec:Button({
        Name = act,
        Callback = function()
            if _selectedPlayer and playerListCallback then
                playerListCallback(_selectedPlayer, act)
            end
        end
    })
end

function PlayerlistObj:SetButtonState(btnName, boolState)
    local btn = actionButtons[btnName]
    if not btn then return end
    local text = btnName
    if boolState then
        text = btnName .. " [ON]"
    end
    if btn.SetText then btn:SetText(text) end
    if btn.SetState then btn:SetState(boolState) end
end

function PlayerlistObj:UpdatePlayerTags(playerName, tagsStr, isAlternate)
    for p, btn in pairs(playerBtnMap) do
        if p.Name == playerName then
            updatePlayerTags(p)
            break
        end
    end
end

Playerlist = PlayerlistObj

playerListCallback = function(player, action)
    if player == game.Players.LocalPlayer then return end
    if not player then _selectedPlayer = nil; return end
    _selectedPlayer = player
    if action == "Select" then
        local isTarget = (_lockedTargets and _lockedTargets[player] == true)
        local isWhitelisted = (_plWhitelistLocal and _plWhitelistLocal[player] == true)
        local isIgnoreWall = (_playerIgnoreWallCheck and _playerIgnoreWallCheck[player] == true)
        local isIgnoreDead = (_playerIgnoreDeadCheck and _playerIgnoreDeadCheck[player] == true)
        local isIgnoreTeam = (_playerIgnoreTeamCheck and _playerIgnoreTeamCheck[player] == true)
        local isSpectating = (_spectatingPlayer == player)
        Playerlist:SetButtonState("Target", isTarget)
        Playerlist:SetButtonState("Whitelist", isWhitelisted)
        Playerlist:SetButtonState("Ignore Wall", isIgnoreWall)
        Playerlist:SetButtonState("Ignore Dead", isIgnoreDead)
        Playerlist:SetButtonState("Ignore Team", isIgnoreTeam)
        Playerlist:SetButtonState("Spectate", isSpectating)
    elseif action == "Target" then
        if not _lockedTargets then _lockedTargets = {} end
        if _lockedTargets[player] then
            _lockedTargets[player] = nil
            if lockedAimTarget and lockedAimTarget.Parent == player.Character then lockedAimTarget = nil end
            if _lastAimbotTargetPlayer == player then _lastAimbotTargetPlayer = nil end
        else
            _lockedTargets[player] = true
            if player.Character then
                lockedAimTarget = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChildOfClass("HumanoidRootPart")
            end
        end
        Playerlist:SetButtonState("Target", _lockedTargets[player] == true)
        updatePlayerTags(player)
    elseif action == "Whitelist" then
        if not _plWhitelistLocal then _plWhitelistLocal = {} end
        _plWhitelistLocal[player] = not _plWhitelistLocal[player] and true or nil
        Playerlist:SetButtonState("Whitelist", _plWhitelistLocal[player] == true)
        updatePlayerTags(player)
    elseif action == "Ignore Wall" then
        if not _playerIgnoreWallCheck then _playerIgnoreWallCheck = {} end
        _playerIgnoreWallCheck[player] = not _playerIgnoreWallCheck[player] and true or nil
        Playerlist:SetButtonState("Ignore Wall", _playerIgnoreWallCheck[player] == true)
        updatePlayerTags(player)
    elseif action == "Ignore Dead" then
        if not _playerIgnoreDeadCheck then _playerIgnoreDeadCheck = {} end
        _playerIgnoreDeadCheck[player] = not _playerIgnoreDeadCheck[player] and true or nil
        Playerlist:SetButtonState("Ignore Dead", _playerIgnoreDeadCheck[player] == true)
        updatePlayerTags(player)
    elseif action == "Ignore Team" then
        if not _playerIgnoreTeamCheck then _playerIgnoreTeamCheck = {} end
        _playerIgnoreTeamCheck[player] = not _playerIgnoreTeamCheck[player] and true or nil
        Playerlist:SetButtonState("Ignore Team", _playerIgnoreTeamCheck[player] == true)
        updatePlayerTags(player)
    elseif action == "Spectate" then
        if _spectatingPlayer == player then
            _spectatingPlayer = nil
            local myHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if myHum then workspace.CurrentCamera.CameraSubject = myHum end
        else
            _spectatingPlayer = player
            local targetChar = player.Character
            local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health > 0 then
                workspace.CurrentCamera.CameraSubject = targetHum
            end
        end
        Playerlist:SetButtonState("Spectate", _spectatingPlayer == player)
        updatePlayerTags(player)
    elseif action == "Teleport" then
        pcall(function()
            local localChar = game.Players.LocalPlayer.Character
            local targetChar = player.Character
            if localChar and targetChar then
                local localHrp = localChar:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                if localHrp and targetHrp then
                    localHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end)
    end
end

Flags = Library.Flags

_sectionCache = _sectionCache or {}

_dependencyUpdates = _dependencyUpdates or {}
local function triggerDependencies()
    for _, fn in ipairs(_dependencyUpdates) do
        pcall(fn)
    end
end

local function registerDependency(w, opts)
    if opts and opts.Dependency then
        local dep = opts.Dependency
        local deps = (type(dep[1]) == "table") and dep or {dep}
        
        local function updateVisibility()
            local visible = true
            for _, d in ipairs(deps) do
                local flag = d.Flag or d[1]
                local expectedValue = d.Value
                if expectedValue == nil and d[2] ~= nil then expectedValue = d[2] end
                if expectedValue == nil then expectedValue = true end
                local val = Flags[flag]
                if type(val) == "table" then
                    if val.Toggled ~= nil then val = val.Toggled
                    elseif val.active ~= nil then val = val.active
                    end
                end
                if val == nil then val = false end
                if val ~= expectedValue then visible = false; break end
            end
            if w and w.SetVisibility then w:SetVisibility(visible) end
        end
        
        table.insert(_dependencyUpdates, updateVisibility)
        task.spawn(function()
            task.wait(0.05)
            updateVisibility()
        end)
    end
end

local tabMapping = {
    ["Aimbot"]                  = {tab = AimbotSubPage,     side = "Left"},
    ["FOV Settings"]            = {tab = AimbotSubPage,     side = "Left"},
    ["Aimbot Settings"]         = {tab = AimbotSubPage,     side = "Right"},
    ["Humanization"]            = {tab = AimbotSubPage,     side = "Right"},
    ["Arsenal"]                 = {tab = AimbotSubPage,     side = "Left"},
    ["Arsenal Settings"]        = {tab = AimbotSubPage,     side = "Right"},
    ["Silent"]                  = {tab = SilentAimSubPage,  side = "Left"},
    ["Silent Settings"]         = {tab = SilentAimSubPage,  side = "Right"},
    ["ESP"]                     = {tab = ESPSubPage,        side = "Left"},
    ["ESP Settings"]            = {tab = ESPSubPage,        side = "Right"},
    ["Chams"]                   = {tab = ChamsSubPage,      side = "Left"},
    ["Chams Settings"]          = {tab = ChamsSubPage,      side = "Right"},
    ["Skins"]                   = {tab = SkinsSubPage,      side = "Left"},
    ["Weapon Skins"]            = {tab = SkinsSubPage,      side = "Left"},
    ["Skin Actions"]            = {tab = SkinsSubPage,      side = "Right"},
    ["Effects & Customization"] = {tab = WorldSubPage,      side = "Right"},
    ["Lighting"]                = {tab = WorldSubPage,      side = "Left"},
    ["Weather"]                 = {tab = WorldSubPage,      side = "Left"},
    ["Skybox"]                  = {tab = WorldSubPage,      side = "Right"},
    ["Atmosphere"]              = {tab = WorldSubPage,      side = "Right"},
    ["Materials"]               = {tab = WorldSubPage,      side = "Right"},
    ["Misc"]                    = {tab = MovementSubPage,   side = "Right"},
    ["Movement"]                = {tab = MovementSubPage,   side = "Left"},
    ["Avatar"]                  = {tab = AvatarSubPage,     side = "Left"},
    ["Animation"]               = {tab = AvatarSubPage,     side = "Right"},
    ["MiscRight"]               = {tab = MovementSubPage,   side = "Right"},
    ["All Players"]             = {tab = PlayersTab,        side = "Left"},
    ["Player List"]             = {tab = PlayersTab,        side = "Left"},
    ["Player Info"]             = {tab = PlayersTab,        side = "Right"},
    ["Actions"]                 = {tab = PlayersTab,        side = "Right"},
    ["Configs"]                 = {tab = SettingsTab,       side = "Left"},
    ["Settings"]                = {tab = SettingsTab,       side = "Right"},
    ["Menu"]                    = {tab = SettingsTab,       side = "Right"},
    ["Notifications"]           = {tab = SettingsTab,       side = "Right"},
    ["Themes"]                  = {tab = SettingsTab,       side = "Right"},
    ["Theme"]                   = {tab = SettingsTab,       side = "Right"},
}

wrapSection = function(secName, side)
    local secNameStr = type(secName) == "table" and (secName.Name or secName.name or "Section") or tostring(secName or "Section")
    local sideVal = side or (type(secName) == "table" and (secName.Side or secName.side)) or "Left"
    if type(sideVal) == "number" then sideVal = sideVal == 1 and "Left" or "Right" end

    local m = tabMapping[secNameStr] or {tab = CombatTab, side = sideVal}
    local targetTab = m.tab
    if not targetTab then
        local dummyWrapper = {}
        function dummyWrapper:SetVisibility() end
        function dummyWrapper:Toggle(opts) return { SetVisibility = function() end, Keybind = function() return { SetVisibility = function() end } end, Colorpicker = function() return { SetVisibility = function() end } end } end
        function dummyWrapper:Slider() return { SetVisibility = function() end } end
        function dummyWrapper:Dropdown() return { SetVisibility = function() end, Get = function() return "" end, Refresh = function() end } end
        function dummyWrapper:Button() return { SetVisibility = function() end } end
        function dummyWrapper:Label() return { SetVisibility = function() end } end
        function dummyWrapper:TextBox() return { SetVisibility = function() end } end
        function dummyWrapper:Keybind() return { SetVisibility = function() end } end
        function dummyWrapper:Colorpicker() return { SetVisibility = function() end } end
        dummyWrapper.ColorPicker = dummyWrapper.Colorpicker
        return dummyWrapper
    end
    local targetSide = m.side or sideVal
    local cacheKey = tostring(secNameStr) .. "|" .. tostring(targetTab) .. "|" .. tostring(targetSide)
    if _sectionCache[cacheKey] then return _sectionCache[cacheKey] end

    local sec
    if secNameStr == "Player List" then sec = PlayerlistSec
    elseif secNameStr == "Actions" then sec = ActionsSec
    elseif secNameStr == "Player Info" then sec = PlayerInfoSec
    else sec = targetTab:Section(secNameStr, targetSide)
    end

    local wrapper = { items = sec }
    
    function wrapper:SetVisibility(state)
        pcall(function()
            if sec and sec.SetVisibility then
                sec:SetVisibility(state)
            end
        end)
    end

    function wrapper:Toggle(opts)
        if opts.Flag and Flags[opts.Flag] == nil then
            Flags[opts.Flag] = opts.Default or false
        end
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end

        local t = sec:Toggle({
            Name = opts.Name,
            Flag = opts.Flag,
            Default = opts.Default,
            Callback = opts.Callback
        })

        local w = { __ui = t }
        function w:SetVisibility(state) pcall(function() if t and t.SetVisibility then t.SetVisibility(state) end end) end
        function w:Keybind(kopts)
            local flag = kopts.Flag
            local defaultKey = kopts.Key or kopts.Default or Enum.KeyCode.Unknown
            local mode = kopts.Mode or "Toggle"
            if flag then
                Flags[flag] = { Key = defaultKey, key = defaultKey, mode = mode, Toggled = false, active = false }
            end
            local userKoptsCallback = kopts.Callback
            kopts.Callback = function(state)
                if flag and Flags[flag] then
                    Flags[flag].Toggled = state
                    Flags[flag].active = state
                end
                if userKoptsCallback then pcall(userKoptsCallback, state) end
                triggerDependencies()
            end
            t:Keybind({ Flag = flag, Default = defaultKey, Mode = mode, Callback = kopts.Callback })
            return w
        end
        function w:Colorpicker(copts)
            local userCoptsCallback = copts.Callback
            copts.Callback = function(val)
                if copts.Flag then Flags[copts.Flag] = val end
                if userCoptsCallback then pcall(userCoptsCallback, val) end
                triggerDependencies()
            end
            t:ColorPicker({ Name = copts.Name or "Color", Flag = copts.Flag, Default = copts.Default or copts.color, Callback = copts.Callback })
            return w
        end
        w.ColorPicker = w.Colorpicker
        registerDependency(w, opts)
        return w
    end

    function wrapper:Slider(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local s = sec:Slider({
            Name = opts.Name,
            Flag = opts.Flag,
            Min = opts.Min,
            Max = opts.Max,
            Default = opts.Default,
            Callback = opts.Callback,
        })
        local w = { __ui = s }
        function w:SetVisibility(state) pcall(function() if s and s.SetVisibility then s.SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Dropdown(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local items = opts.Options or opts.Content or opts.Items or {}
        local d = sec:Dropdown({
            Name = opts.Name,
            Flag = opts.Flag,
            Options = items,
            Default = opts.Default,
            Multi = opts.Multi,
            Callback = opts.Callback
        })
        local w = { __ui = d }
        function w:SetVisibility(state) pcall(function() if d and d.SetVisibility then d.SetVisibility(state) end end) end
        function w:Refresh(newItems) pcall(function() if d and d.Refresh then d:Refresh(newItems) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Colorpicker(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local c = sec:ColorPicker({
            Name = opts.Name or "Colorpicker",
            Flag = opts.Flag,
            Default = opts.Default or opts.color,
            Callback = opts.Callback
        })
        local w = { __ui = c }
        function w:SetVisibility(state) pcall(function() if c and c.SetVisibility then c:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end
    wrapper.ColorPicker = wrapper.Colorpicker

    function wrapper:Keybind(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local k = sec:Keybind({
            Name = opts.Name,
            Flag = opts.Flag,
            Default = opts.Key or opts.Default,
            Callback = opts.Callback
        })
        local w = { __ui = k }
        function w:SetVisibility(state) pcall(function() if k and k.SetVisibility then k:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Button(opts)
        local b = sec:Button(opts)
        local w = { __ui = b, items = b }
        function w:SetVisibility(state) pcall(function() if b and b.SetVisibility then b:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Label(opts)
        local l = sec:Label(opts)
        local w = { __ui = l }
        function w:SetVisibility(state) pcall(function() if l and l.SetVisibility then l:SetVisibility(state) end end) end
        function w:Keybind(kopts) return w end
        w.set = function(text) pcall(function() if l and (l.SetText or l.set) then (l.SetText or l.set)(l, text) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Textbox(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local t = sec:TextBox({
            Name = opts.Name,
            Flag = opts.Flag,
            Default = opts.Default,
            Placeholder = opts.Placeholder or opts.Name,
            Callback = opts.Callback
        })
        local w = { __ui = t }
        function w:SetVisibility(state) pcall(function() if t and t.SetVisibility then t.SetVisibility(state) end end) end
        w.set = function(text) if opts.Flag and Flags then Flags[opts.Flag] = text end end
        registerDependency(w, opts)
        return w
    end
    wrapper.TextBox = wrapper.Textbox

    _sectionCache[cacheKey] = wrapper
    return wrapper
end

-- Expose globals for script.txt to access
getgenv().Library = Library
getgenv().library = Library
getgenv().MainWindow = MainWindow
getgenv().wrapSection = wrapSection
getgenv()._sectionCache = _sectionCache
getgenv()._dependencyUpdates = _dependencyUpdates

-- Return the library so it can be used via loadstring
return Library
