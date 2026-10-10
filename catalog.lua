wait(2)
if game.PlaceId ~= 7041939546 then return end

-- ============================================================
-- BLACKOUT GUI v7 | RED EDITION
-- Panel 1: VISUALS  — Box ESP + Name ESP (all black)
-- Panel 2: UTILITY  — Steal Outfit / TP to Random / TP to Player
-- Panel 3: THEME    — color theme picker
-- ============================================================

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Workspace          = game:GetService("Workspace")
local Lighting           = game:GetService("Lighting")
local LocalPlayer        = Players.LocalPlayer

-- ============================================================
-- THEME TABLE (RED default)
-- ============================================================
local THEMES = {
    RED    = { accent = Color3.fromRGB(230, 30, 45),   dim = Color3.fromRGB(120, 15, 22),   border = Color3.fromRGB(34, 20, 22) },
    PURPLE = { accent = Color3.fromRGB(175, 90, 255),  dim = Color3.fromRGB(80, 40, 120),   border = Color3.fromRGB(40, 24, 55) },
    BLUE   = { accent = Color3.fromRGB(65, 130, 255),  dim = Color3.fromRGB(30, 60, 120),   border = Color3.fromRGB(22, 30, 48) },
    GREEN  = { accent = Color3.fromRGB(65, 220, 125),  dim = Color3.fromRGB(30, 110, 60),   border = Color3.fromRGB(20, 40, 28) },
    ORANGE = { accent = Color3.fromRGB(245, 130, 30),  dim = Color3.fromRGB(120, 60, 15),   border = Color3.fromRGB(45, 28, 15) },
    PINK   = { accent = Color3.fromRGB(255, 90, 180),  dim = Color3.fromRGB(130, 40, 90),   border = Color3.fromRGB(45, 22, 35) },
    WHITE  = { accent = Color3.fromRGB(235, 235, 235), dim = Color3.fromRGB(120, 120, 120), border = Color3.fromRGB(40, 40, 45) },
}
local currentTheme = "RED"

-- ============================================================
-- COLORS (mutable globals so ApplyTheme can update them)
-- ============================================================
local BG          = Color3.fromRGB(6, 6, 7)
local BG_ITEM     = Color3.fromRGB(13, 13, 15)
local BG_HOVER    = Color3.fromRGB(22, 14, 16)
local BORDER      = THEMES.RED.border
local ACCENT      = THEMES.RED.accent
local ACCENT_DIM  = THEMES.RED.dim
local TEXT        = Color3.fromRGB(255, 255, 255)
local TEXT_DIM    = Color3.fromRGB(170, 170, 178)
local TEXT_ON     = THEMES.RED.accent

-- Track every themed element so we can recolor on theme change
local ThemedElements = {
    windows = {}, toggles = {}, buttons = {}, dropdowns = {}, sections = {},
}

-- ============================================================
-- ROOT
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackoutGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- LOADING SPLASH SCREEN
-- ============================================================
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "BlackoutLoader"
LoadGui.ResetOnSpawn = false
LoadGui.IgnoreGuiInset = true
LoadGui.DisplayOrder = 999
LoadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LoadBG = Instance.new("Frame")
LoadBG.Size = UDim2.new(1, 0, 1, 0)
LoadBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadBG.BorderSizePixel = 0
LoadBG.BackgroundTransparency = 1
LoadBG.Parent = LoadGui

local LoadCenter = Instance.new("Frame")
LoadCenter.Size = UDim2.new(0, 400, 0, 160)
LoadCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadCenter.AnchorPoint = Vector2.new(0.5, 0.5)
LoadCenter.BackgroundTransparency = 1
LoadCenter.Parent = LoadBG

local LogoLbl = Instance.new("TextLabel")
LogoLbl.Size = UDim2.new(1, 0, 0, 70)
LogoLbl.BackgroundTransparency = 1
LogoLbl.Text = ""
LogoLbl.Font = Enum.Font.Code
LogoLbl.TextSize = 48
LogoLbl.TextColor3 = THEMES.RED.accent
LogoLbl.TextTransparency = 1
LogoLbl.TextStrokeTransparency = 1
LogoLbl.TextStrokeColor3 = Color3.fromRGB(255, 90, 100)
LogoLbl.Parent = LoadCenter

local SubLbl = Instance.new("TextLabel")
SubLbl.Size = UDim2.new(1, 0, 0, 20)
SubLbl.Position = UDim2.new(0, 0, 0, 76)
SubLbl.BackgroundTransparency = 1
SubLbl.Text = "LOADING // PLEASE WAIT"
SubLbl.Font = Enum.Font.Code
SubLbl.TextSize = 12
SubLbl.TextColor3 = THEMES.RED.dim
SubLbl.TextTransparency = 1
SubLbl.Parent = LoadCenter

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 320, 0, 4)
BarBg.Position = UDim2.new(0.5, -160, 0, 112)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 15, 18)
BarBg.BorderSizePixel = 0
BarBg.BackgroundTransparency = 1
BarBg.Parent = LoadCenter
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = THEMES.RED.accent
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

local BarGlow = Instance.new("UIStroke")
BarGlow.Color = Color3.fromRGB(255, 90, 100)
BarGlow.Thickness = 1
BarGlow.Transparency = 0.4
BarGlow.Parent = BarFill

local PctLbl = Instance.new("TextLabel")
PctLbl.Size = UDim2.new(1, 0, 0, 14)
PctLbl.Position = UDim2.new(0, 0, 0, 122)
PctLbl.BackgroundTransparency = 1
PctLbl.Text = "0%"
PctLbl.Font = Enum.Font.Code
PctLbl.TextSize = 10
PctLbl.TextColor3 = TEXT_DIM
PctLbl.TextTransparency = 1
PctLbl.Parent = LoadCenter

local Scanlines = Instance.new("Frame")
Scanlines.Size = UDim2.new(1, 0, 1, 0)
Scanlines.BackgroundTransparency = 1
Scanlines.Parent = LoadBG

for i = 0, 60 do
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0, i * 14)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.97
    Line.BorderSizePixel = 0
    Line.Parent = Scanlines
end

local function RunLoadingSequence()
    TweenService:Create(LoadBG, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
    task.wait(0.1)

    local text = "BLACKOUT"
    LogoLbl.Text = ""
    TweenService:Create(LogoLbl, TweenInfo.new(0.3), {TextTransparency = 0, TextStrokeTransparency = 0.4}):Play()
    TweenService:Create(SubLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(BarBg,  TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(PctLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    for i = 1, #text do
        LogoLbl.Text = string.sub(text, 1, i)
        task.wait(0.04)
    end

    for _ = 1, 3 do
        LogoLbl.TextColor3 = Color3.fromRGB(255, 200, 200)
        task.wait(0.05)
        LogoLbl.TextColor3 = THEMES.RED.accent
        task.wait(0.05)
    end

    local steps = 40
    for i = 0, steps do
        local pct = i / steps
        BarFill.Size = UDim2.new(pct, 0, 1, 0)
        PctLbl.Text = math.floor(pct * 100) .. "%"
        task.wait(1.0 / steps)
    end

    task.wait(0.15)

    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(LogoLbl, fadeInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(SubLbl, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(BarBg,  fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(PctLbl, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarGlow, fadeInfo, {Transparency = 1}):Play()

    local bgTween = TweenService:Create(LoadBG, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    bgTween:Play()
    bgTween.Completed:Wait()
    task.wait(0.05)

    LoadGui:Destroy()
end

-- ============================================================
-- DROPDOWN SYSTEM (shared layer + menu)
-- ============================================================
local DropdownLayer = Instance.new("Frame")
DropdownLayer.Size = UDim2.fromScale(1, 1)
DropdownLayer.BackgroundTransparency = 1
DropdownLayer.BorderSizePixel = 0
DropdownLayer.Visible = false
DropdownLayer.ZIndex = 5000
DropdownLayer.Parent = ScreenGui

local DropdownMenu = Instance.new("Frame")
DropdownMenu.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.Visible = false
DropdownMenu.ZIndex = 5001
DropdownMenu.Parent = DropdownLayer
Instance.new("UICorner", DropdownMenu).CornerRadius = UDim.new(0, 5)
local DStroke = Instance.new("UIStroke", DropdownMenu)
DStroke.Color = ACCENT_DIM
DStroke.Thickness = 1

local DropdownScroll = Instance.new("ScrollingFrame")
DropdownScroll.Position = UDim2.fromOffset(4, 4)
DropdownScroll.Size = UDim2.new(1, -8, 1, -8)
DropdownScroll.BackgroundTransparency = 1
DropdownScroll.BorderSizePixel = 0
DropdownScroll.ScrollBarThickness = 3
DropdownScroll.ScrollBarImageColor3 = ACCENT
DropdownScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownScroll.ZIndex = 5002
DropdownScroll.Parent = DropdownMenu

local DropdownList = Instance.new("UIListLayout")
DropdownList.Padding = UDim.new(0, 3)
DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
DropdownList.Parent = DropdownScroll

local activeDropdown = nil

local function closeDropdown()
    activeDropdown = nil
    DropdownMenu.Visible = false
    DropdownLayer.Visible = false
    for _, child in ipairs(DropdownScroll:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

DropdownLayer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        closeDropdown()
    end
end)

-- ============================================================
-- THEME APPLIER
-- ============================================================
local ApplyTheme
ApplyTheme = function(name)
    local t = THEMES[name]
    if not t then return end
    currentTheme = name
    ACCENT     = t.accent
    ACCENT_DIM = t.dim
    BORDER     = t.border
    TEXT_ON    = t.accent

    for _, w in ipairs(ThemedElements.windows) do
        if w.mainStroke then w.mainStroke.Color = BORDER end
        if w.glow then w.glow.BackgroundColor3 = ACCENT end
        if w.divider then w.divider.BackgroundColor3 = BORDER end
        if w.titleDot then w.titleDot.BackgroundColor3 = ACCENT end
        if w.scroll then w.scroll.ScrollBarImageColor3 = ACCENT_DIM end
    end

    for _, tog in ipairs(ThemedElements.toggles) do
        if tog.render then pcall(tog.render) end
    end

    for _, b in ipairs(ThemedElements.buttons) do
        if b.stroke then b.stroke.Color = BORDER end
        if b.bar then b.bar.BackgroundColor3 = BORDER end
        if b.label then b.label.TextColor3 = TEXT end
    end

    for _, d in ipairs(ThemedElements.dropdowns) do
        if d.stroke then d.stroke.Color = BORDER end
        if d.bar then d.bar.BackgroundColor3 = BORDER end
        if d.valueTxt then d.valueTxt.TextColor3 = TEXT_ON end
    end

    for _, s in ipairs(ThemedElements.sections) do
        if s then s.TextColor3 = ACCENT_DIM end
    end

    if DStroke then DStroke.Color = ACCENT_DIM end
    if DropdownScroll then DropdownScroll.ScrollBarImageColor3 = ACCENT end
end

-- ============================================================
-- WINDOW BUILDER
-- ============================================================
local AllWindows = {}

local function CreateWindow(title, posX, posY)
    local Win = {}
    local WIDTH = 230

    local Main = Instance.new("Frame")
    Main.Name = title
    Main.Size = UDim2.new(0, WIDTH, 0, 0)
    Main.Position = UDim2.new(0, posX, 0, posY)
    Main.BackgroundColor3 = BG
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = BORDER
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, 0, 0, 1)
    Glow.BackgroundColor3 = ACCENT
    Glow.BorderSizePixel = 0
    Glow.Parent = Main
    local GlowGrad = Instance.new("UIGradient")
    GlowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    GlowGrad.Parent = Glow

    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = BG
    Header.Text = ""
    Header.AutoButtonColor = false
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local TitleDot = Instance.new("Frame")
    TitleDot.Size = UDim2.new(0, 5, 0, 5)
    TitleDot.Position = UDim2.new(0, 11, 0.5, -2)
    TitleDot.BackgroundColor3 = ACCENT
    TitleDot.BorderSizePixel = 0
    TitleDot.Parent = Header
    Instance.new("UICorner", TitleDot).CornerRadius = UDim.new(1, 0)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -50, 1, 0)
    TitleLbl.Position = UDim2.new(0, 22, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = TEXT
    TitleLbl.Font = Enum.Font.Code
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    MinimizeBtn.Position = UDim2.new(1, -28, 0.5, -11)
    MinimizeBtn.BackgroundColor3 = BG_ITEM
    MinimizeBtn.Text = "–"
    MinimizeBtn.TextColor3 = TEXT_DIM
    MinimizeBtn.Font = Enum.Font.Code
    MinimizeBtn.TextSize = 14
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Parent = Header
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 3)

    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {TextColor3 = ACCENT}):Play()
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {TextColor3 = TEXT_DIM}):Play()
    end)

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -16, 0, 1)
    Divider.Position = UDim2.new(0, 8, 0, 30)
    Divider.BackgroundColor3 = BORDER
    Divider.BorderSizePixel = 0
    Divider.Parent = Main

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = "Scroll"
    Scroll.Size = UDim2.new(1, 0, 0, 0)
    Scroll.Position = UDim2.new(0, 0, 0, 31)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = ACCENT_DIM
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    Scroll.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 3)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Scroll

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0, 6)
    Pad.PaddingBottom = UDim.new(0, 8)
    Pad.PaddingLeft = UDim.new(0, 7)
    Pad.PaddingRight = UDim.new(0, 7)
    Pad.Parent = Scroll

    table.insert(ThemedElements.windows, {
        main = Main, mainStroke = MainStroke, glow = Glow,
        divider = Divider, titleDot = TitleDot, scroll = Scroll,
    })

    local function CreateSection(text)
        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, 0, 0, 16)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = "── " .. string.upper(text)
        Lbl.TextColor3 = ACCENT_DIM
        Lbl.Font = Enum.Font.Code
        Lbl.TextSize = 9
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Scroll
        table.insert(ThemedElements.sections, Lbl)
        return Lbl
    end

    local function CreateToggle(name, defaultState, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 24)
        Btn.BackgroundColor3 = BG_ITEM
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.BorderSizePixel = 0
        Btn.Parent = Scroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 3)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = BORDER
        Stroke.Thickness = 1
        Stroke.Parent = Btn

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0, 2, 0, 12)
        Bar.Position = UDim2.new(0, 0, 0.5, -6)
        Bar.BackgroundColor3 = BORDER
        Bar.BorderSizePixel = 0
        Bar.Parent = Btn
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 13, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = string.upper(name)
        Label.TextColor3 = TEXT
        Label.Font = Enum.Font.Code
        Label.TextSize = 10
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Btn

        local StatusTxt = Instance.new("TextLabel")
        StatusTxt.Size = UDim2.new(0, 30, 1, 0)
        StatusTxt.Position = UDim2.new(1, -36, 0, 0)
        StatusTxt.BackgroundTransparency = 1
        StatusTxt.Text = "OFF"
        StatusTxt.TextColor3 = TEXT_DIM
        StatusTxt.Font = Enum.Font.Code
        StatusTxt.TextSize = 10
        StatusTxt.TextXAlignment = Enum.TextXAlignment.Right
        StatusTxt.Parent = Btn

        local state = defaultState or false

        local function Render(animate)
            local tColor  = state and ACCENT or BORDER
            local tText   = state and TEXT_ON or TEXT
            local tStatus = state and "ON" or "OFF"
            local tStatC  = state and ACCENT or TEXT_DIM
            local tBg     = state and Color3.fromRGB(20, 10, 12) or BG_ITEM
            if animate then
                TweenService:Create(Bar,   TweenInfo.new(0.15), {BackgroundColor3 = tColor}):Play()
                TweenService:Create(Stroke,TweenInfo.new(0.15), {Color = tColor}):Play()
                TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = tText}):Play()
                TweenService:Create(Btn,   TweenInfo.new(0.15), {BackgroundColor3 = tBg}):Play()
            else
                Bar.BackgroundColor3  = tColor
                Stroke.Color          = tColor
                Label.TextColor3      = tText
                Btn.BackgroundColor3  = tBg
            end
            StatusTxt.Text = tStatus
            StatusTxt.TextColor3 = tStatC
        end

        Render(false)

        Btn.MouseEnter:Connect(function()
            if not state then
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_HOVER}):Play()
            end
        end)
        Btn.MouseLeave:Connect(function()
            if not state then
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_ITEM}):Play()
            end
        end)

        Btn.MouseButton1Click:Connect(function()
            state = not state
            Render(true)
            if callback then
                local ok, err = pcall(callback, state)
                if not ok then warn("[Blackout] " .. tostring(err)) end
            end
        end)

        table.insert(ThemedElements.toggles, {
            btn = Btn, stroke = Stroke, bar = Bar, label = Label, statusTxt = StatusTxt,
            render = function() Render(false) end,
        })

        return Btn
    end

    local function CreateButton(name, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 24)
        Btn.BackgroundColor3 = BG_ITEM
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.BorderSizePixel = 0
        Btn.Parent = Scroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 3)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = BORDER
        Stroke.Thickness = 1
        Stroke.Parent = Btn

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0, 2, 0, 12)
        Bar.Position = UDim2.new(0, 0, 0.5, -6)
        Bar.BackgroundColor3 = BORDER
        Bar.BorderSizePixel = 0
        Bar.Parent = Btn
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.Position = UDim2.new(0, 13, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = string.upper(name)
        Label.TextColor3 = TEXT
        Label.Font = Enum.Font.Code
        Label.TextSize = 10
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Btn

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_HOVER}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = ACCENT}):Play()
            TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_ITEM}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = BORDER}):Play()
            TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundColor3 = BORDER}):Play()
        end)

        Btn.MouseButton1Click:Connect(function()
            Bar.BackgroundColor3 = TEXT_ON
            Label.TextColor3 = TEXT_ON
            task.delay(0.15, function()
                Bar.BackgroundColor3 = ACCENT
                Label.TextColor3 = TEXT
            end)
            if callback then
                local ok, err = pcall(callback)
                if not ok then warn("[Blackout] " .. tostring(err)) end
            end
        end)

        table.insert(ThemedElements.buttons, { btn = Btn, stroke = Stroke, bar = Bar, label = Label })

        return Btn
    end

    local function CreateTextBox(placeholder, submitCallback)
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(1, 0, 0, 24)
        Box.BackgroundColor3 = BG_ITEM
        Box.BorderSizePixel = 0
        Box.Parent = Scroll
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 3)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = BORDER
        Stroke.Thickness = 1
        Stroke.Parent = Box

        local BoxBar = Instance.new("Frame")
        BoxBar.Size = UDim2.new(0, 2, 0, 12)
        BoxBar.Position = UDim2.new(0, 0, 0.5, -6)
        BoxBar.BackgroundColor3 = BORDER
        BoxBar.BorderSizePixel = 0
        BoxBar.Parent = Box
        Instance.new("UICorner", BoxBar).CornerRadius = UDim.new(1, 0)

        local TxtBox = Instance.new("TextBox")
        TxtBox.Size = UDim2.new(1, -14, 1, 0)
        TxtBox.Position = UDim2.new(0, 12, 0, 0)
        TxtBox.BackgroundTransparency = 1
        TxtBox.Text = ""
        TxtBox.PlaceholderText = placeholder
        TxtBox.PlaceholderColor3 = TEXT_DIM
        TxtBox.TextColor3 = TEXT
        TxtBox.Font = Enum.Font.Code
        TxtBox.TextSize = 10
        TxtBox.TextXAlignment = Enum.TextXAlignment.Left
        TxtBox.ClearTextOnFocus = false
        TxtBox.Parent = Box

        TxtBox.Focused:Connect(function()
            TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = ACCENT}):Play()
            TweenService:Create(BoxBar, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT}):Play()
        end)
        TxtBox.FocusLost:Connect(function(enterPressed)
            TweenService:Create(Stroke, TweenInfo.new(0.1), {Color = BORDER}):Play()
            TweenService:Create(BoxBar, TweenInfo.new(0.1), {BackgroundColor3 = BORDER}):Play()
            if enterPressed and submitCallback then
                local ok, err = pcall(submitCallback, TxtBox.Text)
                if not ok then warn("[Blackout] " .. tostring(err)) end
            end
        end)

        return TxtBox
    end

    -- NEW: CreateDropdown (needed for the theme panel)
    local function CreateDropdown(label, value, options, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 24)
        Btn.BackgroundColor3 = BG_ITEM
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.BorderSizePixel = 0
        Btn.Parent = Scroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 3)

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = BORDER
        Stroke.Thickness = 1
        Stroke.Parent = Btn

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0, 2, 0, 12)
        Bar.Position = UDim2.new(0, 0, 0.5, -6)
        Bar.BackgroundColor3 = BORDER
        Bar.BorderSizePixel = 0
        Bar.Parent = Btn
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0, 13, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = string.upper(label)
        Label.TextColor3 = TEXT
        Label.Font = Enum.Font.Code
        Label.TextSize = 10
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Btn

        local ValueTxt = Instance.new("TextLabel")
        ValueTxt.Size = UDim2.new(0.4, 0, 1, 0)
        ValueTxt.Position = UDim2.new(0.55, 0, 0, 0)
        ValueTxt.BackgroundTransparency = 1
        ValueTxt.Text = tostring(value)
        ValueTxt.TextColor3 = TEXT_ON
        ValueTxt.Font = Enum.Font.Code
        ValueTxt.TextSize = 10
        ValueTxt.TextXAlignment = Enum.TextXAlignment.Right
        ValueTxt.Parent = Btn

        local currentValue = value

        local function updateValue(v)
            currentValue = v
            ValueTxt.Text = tostring(v)
            if callback then
                local ok, err = pcall(callback, v)
                if not ok then warn("[Blackout] " .. tostring(err)) end
            end
        end

        local function openMenu()
            closeDropdown()
            activeDropdown = Btn
            DropdownLayer.Visible = true
            local absPos = Btn.AbsolutePosition
            local absSize = Btn.AbsoluteSize
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            local menuWidth = math.max(absSize.X, 180)
            local rowHeight = 26
            local menuHeight = math.min(#options, 7) * rowHeight + 10
            local x = absPos.X
            if x + menuWidth > viewport.X - 8 then x = viewport.X - menuWidth - 8 end            local y = absPos.Y + absSize.Y + 5
            if y + menuHeight > viewport.Y - 8 then y = absPos.Y - menuHeight - 5 end
            if y < 8 then y = 8 end
            DropdownMenu.Position = UDim2.fromOffset(x, y)
            DropdownMenu.Size = UDim2.fromOffset(menuWidth, menuHeight)
            DropdownMenu.Visible = true
            for i, opt in ipairs(options) do
                local o = Instance.new("TextButton")
                o.Size = UDim2.new(1, -2, 0, 23)
                o.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                o.BorderSizePixel = 0
                o.AutoButtonColor = false
                o.Text = "  " .. tostring(opt)
                o.TextColor3 = (opt == currentValue) and ACCENT or TEXT
                o.Font = Enum.Font.Code
                o.TextSize = 10
                o.TextXAlignment = Enum.TextXAlignment.Left
                o.LayoutOrder = i
                o.ZIndex = 5003
                o.Parent = DropdownScroll
                Instance.new("UICorner", o).CornerRadius = UDim.new(0, 3)
                o.MouseEnter:Connect(function()
                    TweenService:Create(o, TweenInfo.new(0.1), {BackgroundColor3 = BG_HOVER}):Play()
                end)
                o.MouseLeave:Connect(function()
                    TweenService:Create(o, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(16, 16, 20)}):Play()
                end)
                o.MouseButton1Click:Connect(function()
                    updateValue(opt)
                    closeDropdown()
                end)
            end
        end

        Btn.MouseButton1Click:Connect(openMenu)
        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_HOVER}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_ITEM}):Play()
        end)

        table.insert(ThemedElements.dropdowns, { btn = Btn, stroke = Stroke, bar = Bar, label = Label, valueTxt = ValueTxt })

        return {
            Button = Btn,
            SetValue = function(v) currentValue = v; ValueTxt.Text = tostring(v) end,
            GetValue = function() return currentValue end,
            SetVisible = function(v) Btn.Visible = v end
        }
    end

    do
        local dragging, startPos, startInput
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startInput = input.Position
                startPos = Main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - startInput
                Main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
                if activeDropdown then closeDropdown() end
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local minimized = false
    local MAX_CONTENT_HEIGHT = 340

    local function UpdateSize()
        local targetHeight
        if minimized then
            targetHeight = 31
        else
            local contentH = Layout.AbsoluteContentSize.Y + 16
            if contentH > MAX_CONTENT_HEIGHT then contentH = MAX_CONTENT_HEIGHT end
            targetHeight = 31 + contentH
            Scroll.Size = UDim2.new(1, 0, 0, contentH)
            Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 16)
        end
        TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, WIDTH, 0, targetHeight)}):Play()
    end

    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        MinimizeBtn.Text = minimized and "+" or "–"
        UpdateSize()
    end)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not minimized then UpdateSize() end
    end)

    task.defer(function()
        task.wait(0.05)
        UpdateSize()
    end)

    Win.CreateSection = CreateSection
    Win.CreateToggle = CreateToggle
    Win.CreateButton = CreateButton
    Win.CreateTextBox = CreateTextBox
    Win.CreateDropdown = CreateDropdown
    Win.Main = Main
    table.insert(AllWindows, Main)
    return Win
end

-- ============================================================
-- BOX ESP (BLACK)
-- ============================================================
local function StartBoxESP()
    getgenv().BoxESPObjects = {}
    local Camera = workspace.CurrentCamera

    local function CreateBoxESP(plr)
        if plr == LocalPlayer then return end
        if getgenv().BoxESPObjects[plr] then
            getgenv().BoxESPObjects[plr]:Destroy()
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "BoxESP_" .. plr.Name
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 0
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        local box = Instance.new("Frame")
        box.Name = "Box"
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.Visible = false
        box.Parent = gui

        local outline = Instance.new("UIStroke")
        outline.Color = Color3.fromRGB(0, 0, 0)
        outline.Thickness = 1.5
        outline.Transparency = 0
        outline.Parent = box

        getgenv().BoxESPObjects[plr] = gui
    end

    local function RemoveBoxESP(plr)
        if getgenv().BoxESPObjects[plr] then
            getgenv().BoxESPObjects[plr]:Destroy()
            getgenv().BoxESPObjects[plr] = nil
        end
    end

    local function UpdateBoxESP()
        for plr, gui in pairs(getgenv().BoxESPObjects) do
            local box = gui and gui:FindFirstChild("Box")
            if not box then continue end

            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")

            if not hrp or not head then
                box.Visible = false
                continue
            end

            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local feetPos, feetOnScreen = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

            if not headOnScreen or not feetOnScreen or headPos.Z <= 0 then
                box.Visible = false
                continue
            end

            local height = math.abs(headPos.Y - feetPos.Y) * 1.1
            local width = height * 0.7
            local x = headPos.X - width / 2
            local y = headPos.Y

            box.Size = UDim2.new(0, width, 0, height)
            box.Position = UDim2.new(0, x, 0, y)
            box.Visible = true
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then CreateBoxESP(plr) end
    end

    getgenv().BoxESPPlayerAdded = Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer then CreateBoxESP(plr) end
    end)

    getgenv().BoxESPPlayerRemoving = Players.PlayerRemoving:Connect(RemoveBoxESP)

    getgenv().BoxESPRenderConnection = RunService.RenderStepped:Connect(UpdateBoxESP)
end

local function StopBoxESP()
    if getgenv().BoxESPRenderConnection then
        getgenv().BoxESPRenderConnection:Disconnect()
        getgenv().BoxESPRenderConnection = nil
    end
    if getgenv().BoxESPPlayerAdded then
        getgenv().BoxESPPlayerAdded:Disconnect()
        getgenv().BoxESPPlayerAdded = nil
    end
    if getgenv().BoxESPPlayerRemoving then
        getgenv().BoxESPPlayerRemoving:Disconnect()
        getgenv().BoxESPPlayerRemoving = nil
    end
    if getgenv().BoxESPObjects then
        for _, gui in pairs(getgenv().BoxESPObjects) do
            if gui then pcall(function() gui:Destroy() end) end
        end
        getgenv().BoxESPObjects = {}
    end
end

-- ============================================================
-- NAME ESP (ALL BLACK)
-- ============================================================
local function StartNameESP()
    getgenv().NameESPObjects = {}
    getgenv().NameESPConnections = {}

    local function CreateNameESP(plr)
        if plr == LocalPlayer or not plr.Character then return end
        local head = plr.Character:FindFirstChild("Head")
        if not head then return end
        if getgenv().NameESPObjects[plr] then getgenv().NameESPObjects[plr]:Destroy() end

        local esp = Instance.new("BillboardGui")
        esp.Size = UDim2.new(0, 200, 0, 40)
        esp.AlwaysOnTop = true
        esp.StudsOffset = Vector3.new(0, 2.5, 0)
        esp.Adornee = head
        esp.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextSize = 14
        label.Font = Enum.Font.ArialBold
        label.TextColor3 = Color3.fromRGB(0, 0, 0)
        local suffix = plr.DisplayName ~= plr.Name and " (" .. plr.DisplayName .. ")" or ""
        label.Text = plr.Name .. suffix
        label.Parent = esp

        getgenv().NameESPObjects[plr] = esp
    end

    local function Setup(plr)
        if plr == LocalPlayer then return end
        if plr.Character then CreateNameESP(plr) end
        getgenv().NameESPConnections[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.5); CreateNameESP(plr)
        end)
    end

    for _, plr in ipairs(Players:GetPlayers()) do Setup(plr) end

    getgenv().NameESPPlayerAdded = Players.PlayerAdded:Connect(Setup)
    getgenv().NameESPPlayerRemoving = Players.PlayerRemoving:Connect(function(plr)
        if getgenv().NameESPObjects[plr] then
            getgenv().NameESPObjects[plr]:Destroy()
            getgenv().NameESPObjects[plr] = nil
        end
        if getgenv().NameESPConnections[plr] then
            getgenv().NameESPConnections[plr]:Disconnect()
            getgenv().NameESPConnections[plr] = nil
        end
    end)

    getgenv().NameESPRefreshLoop = task.spawn(function()
        while getgenv().NameESPActive do
            task.wait(2)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and not getgenv().NameESPObjects[plr] then
                    CreateNameESP(plr)
                end
            end
        end
    end)
end

local function StopNameESP()
    for _, n in ipairs({"NameESPPlayerAdded","NameESPPlayerRemoving"}) do
        local c = getgenv()[n]
        if c then c:Disconnect(); getgenv()[n] = nil end
    end
    if getgenv().NameESPRefreshLoop then
        task.cancel(getgenv().NameESPRefreshLoop)
        getgenv().NameESPRefreshLoop = nil
    end
    if getgenv().NameESPConnections then
        for _, c in pairs(getgenv().NameESPConnections) do if c then c:Disconnect() end end
        getgenv().NameESPConnections = {}
    end
    if getgenv().NameESPObjects then
        for _, o in pairs(getgenv().NameESPObjects) do if o then pcall(function() o:Destroy() end) end end
        getgenv().NameESPObjects = {}
    end
end

-- ============================================================
-- TELEPORT HELPERS
-- ============================================================
local function TpToRandomPlayer()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local candidates = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                table.insert(candidates, targetHRP)
            end
        end
    end

    if #candidates == 0 then return end
    local target = candidates[math.random(1, #candidates)]
    hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
end

local function FindPlayerByPartialName(query)
    if not query or query == "" then return nil end
    query = string.lower(string.gsub(query, "^%s*(.-)%s*$", "%1"))

    local bestPlr, bestScore
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local name = string.lower(plr.Name)
            local display = string.lower(plr.DisplayName)
            local score

            if name == query or display == query then
                score = 1000
            elseif string.sub(name, 1, #query) == query then
                score = 500 - #name
            elseif string.sub(display, 1, #query) == query then
                score = 400 - #display
            elseif string.find(name, query, 1, true) then
                score = 300 - #name
            elseif string.find(display, query, 1, true) then
                score = 200 - #display
            end

            if score and (not bestScore or score > bestScore) then
                bestScore = score
                bestPlr = plr
            end
        end
    end
    return bestPlr
end

local function TpToPlayerByName(query)
    local plr = FindPlayerByPartialName(query)
    if not plr then
        warn("[Blackout] No player found matching: " .. tostring(query))
        return
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local targetChar = plr.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetHRP then
        warn("[Blackout] Target has no character to TP to")
        return
    end
    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
end

-- ============================================================
-- AVATAR STEALER (toggleable)
-- ============================================================
local AvatarStealer = {}
AvatarStealer.Active = false
AvatarStealer.Connections = {}

function AvatarStealer:Inject()
    local players = game:GetService("Players")
    local rs = game:GetService("ReplicatedStorage")
    local lp = players.LocalPlayer

    local function uh()
        local e = rs:FindFirstChild("Events")
        if e then
            local r = e:FindFirstChild("CatalogGuiRemote")
            if r then return r end
        end
        local r = rs:FindFirstChild("CatalogGuiRemote")
        if r then return r end
        for _, d in ipairs(rs:GetDescendants()) do
            if d.Name == "CatalogGuiRemote" and (d:IsA("RemoteFunction") or d:IsA("RemoteEvent")) then
                return d
            end
        end
    end

    local function ins()
        local e = rs:FindFirstChild("Events")
        if e then
            local r = e:FindFirstChild("ClientInspectHumanoidDescription")
            if r then return r end
        end
        local r = rs:FindFirstChild("ClientInspectHumanoidDescription")
        if r then return r end
        for _, d in ipairs(rs:GetDescendants()) do
            if d.Name == "ClientInspectHumanoidDescription" then
                return r
            end
        end
    end

    local rem = uh()

    local function sf()
        local g = lp:FindFirstChild("PlayerGui")
        local v = g and g:FindFirstChild("ViewPlayer")
        local m = v and v:FindFirstChild("Main") and v.Main:FindFirstChild("Menu")
        return m and m:FindFirstChild("ScrollingFrame")
    end

    local function rgb(c)
        if typeof(c) ~= "Color3" then
            return {r = 255, g = 255, b = 255, IsRGBTable = true}
        end
        return {r = c.R * 255, g = c.G * 255, b = c.B * 255, IsRGBTable = true}
    end

    local function dict(d)
        local p = {
            HatAccessory = d.HatAccessory or "",
            HairAccessory = d.HairAccessory or "",
            FaceAccessory = d.FaceAccessory or "",
            BackAccessory = d.BackAccessory or "",
            FrontAccessory = d.FrontAccessory or "",
            NeckAccessory = d.NeckAccessory or "",
            ShouldersAccessory = d.ShouldersAccessory or "",
            WaistAccessory = d.WaistAccessory or "",
            Face = d.Face or 0,
            Head = d.Head or 0,
            Torso = d.Torso or 0,
            LeftArm = d.LeftArm or 0,
            RightArm = d.RightArm or 0,
            LeftLeg = d.LeftLeg or 0,
            RightLeg = d.RightLeg or 0,
            Shirt = d.Shirt or 0,
            Pants = d.Pants or 0,
            GraphicTShirt = d.GraphicTShirt or 0,
            HeadColor = rgb(d.HeadColor),
            TorsoColor = rgb(d.TorsoColor),
            LeftArmColor = rgb(d.LeftArmColor),
            RightArmColor = rgb(d.RightArmColor),
            LeftLegColor = rgb(d.LeftLegColor),
            RightLegColor = rgb(d.RightLegColor),
            HeightScale = d.HeightScale or 1,
            WidthScale = d.WidthScale or 1,
            DepthScale = d.DepthScale or 1,
            HeadScale = d.HeadScale or 1,
            BodyTypeScale = d.BodyTypeScale or 0,
            ProportionScale = d.ProportionScale or 0,
            ClimbAnimation = d.ClimbAnimation or 0,
            FallAnimation = d.FallAnimation or 0,
            IdleAnimation = d.IdleAnimation or 0,
            JumpAnimation = d.JumpAnimation or 0,
            MoodAnimation = d.MoodAnimation or 0,
            RunAnimation = d.RunAnimation or 0,
            SwimAnimation = d.SwimAnimation or 0,
            WalkAnimation = d.WalkAnimation or 0,
            MakeupItems = {},
            AccessoryRefinements = {},
            LayeredAccessories = {},
            StaticFacialAnimation = false,
        }
        pcall(function()
            local a = d:GetAccessories(true)
            if type(a) ~= "table" then return end
            local o = {}
            for _, x in ipairs(a) do
                if type(x) == "table" and x.AssetId then
                    o[#o + 1] = {
                        AssetId = x.AssetId,
                        AccessoryType = tostring(x.AccessoryType or ""),
                        Order = x.Order,
                        Puffiness = x.Puffiness,
                    }
                end
            end
            p.LayeredAccessories = o
        end)
        return p
    end

    local function ser(m, d)
        if type(m) == "table" and type(m.ToDictionary) == "function" then
            local ok, t = pcall(m.ToDictionary, m, d)
            if ok and type(t) == "table" then return t end
        end
        return dict(d)
    end

    local function descfrom(plr)
        if not plr then return end
        local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if h then
            local ok, live = pcall(function()
                return h:GetAppliedDescription()
            end)
            if ok and live and live:IsA("HumanoidDescription") then
                return live, h.RigType
            end
        end
        local ok, d = pcall(function()
            return players:GetHumanoidDescriptionFromUserId(plr.UserId)
        end)
        if ok and d and d:IsA("HumanoidDescription") then
            return d, Enum.HumanoidRigType.R15
        end
    end

    local function grab(s)
        local w = s:FindFirstChild("WearOutfit")
        local plr, mod, desc, rig

        if w and getconnections and getupvalues then
            local c = getconnections(w.Activated)
            local f = c[1] and c[1].Function
            if type(f) ~= "function" then
                c = getconnections(w.MouseButton1Click)
                f = c[1] and c[1].Function
            end
            if type(f) == "function" then
                local u = getupvalues(f)
                plr, mod, desc, rig = u[2], u[3], u[4], u[5]
                for _, v in pairs(u) do
                    if typeof(v) == "Instance" and v:IsA("Player") then
                        plr = v
                    elseif typeof(v) == "Instance" and v:IsA("HumanoidDescription") then
                        desc = v
                    elseif type(v) == "table" and type(v.ToDictionary) == "function" then
                        mod = v
                    elseif typeof(v) == "EnumItem" and v.EnumType == Enum.HumanoidRigType then
                        rig = v
                    end
                end
            end
        end

        if typeof(plr) ~= "Instance" or not plr:IsA("Player") then
            return
        end

        local live, lrig = descfrom(plr)
        if live then
            desc, rig = live, lrig
        end

        if typeof(desc) ~= "Instance" or not desc:IsA("HumanoidDescription") then
            return
        end

        return plr, mod, desc, typeof(rig) == "EnumItem" and rig or Enum.HumanoidRigType.R15
    end

    local function go(d, m, r)
        rem = rem or uh()
        if not rem then return end
        local p = {
            Action = "CreateAndWearHumanoidDescription",
            Properties = ser(m, d),
            RigType = r or Enum.HumanoidRigType.R15,
        }
        pcall(function()
            if rem:IsA("RemoteFunction") then
                rem:InvokeServer(p)
            else
                rem:FireServer(p)
            end
        end)
    end

    local function view(plr, d)
        if not plr or not d then return end
        local title = "@" .. plr.Name .. "'s Current Outfit"
        local payload = {
            HumanoidDescription = d,
            Title = title,
        }

        local ev = ins()
        if ev then
            pcall(function()
                if ev:IsA("BindableEvent") then
                    ev:Fire(payload)
                elseif ev.Fire then
                    ev:Fire(payload)
                end
            end)
            pcall(function()
                if ev:IsA("BindableEvent") then
                    ev:Fire(d, title)
                elseif ev.Fire then
                    ev:Fire(d, title)
                end
            end)
            return
        end

        local vb = sf() and sf():FindFirstChild("ViewOutfit")
        if vb and getconnections then
            for _, c in ipairs(getconnections(vb.Activated)) do
                pcall(function()
                    if c.Function then c.Function() end
                end)
            end
            for _, c in ipairs(getconnections(vb.MouseButton1Click)) do
                pcall(function()
                    if c.Function then c.Function() end
                end)
            end
        end
    end

    local function ok()
        local s = sf()
        if not s then return false end
        local v = s:FindFirstChild("ViewOutfit")
        local w = s:FindFirstChild("WearOutfit")
        if not v or not w then return false end

        for _, n in ipairs({"StealOutfit", "ForceViewOutfit"}) do
            local o = s:FindFirstChild(n)
            if o then o:Destroy() end
        end

        local fv = v:Clone()
        fv.Name = "ForceViewOutfit"
        fv.Text = "Force View Outfit"
        fv.LayoutOrder = v.LayoutOrder + 1
        fv.Parent = s
        fv.Activated:Connect(function()
            if not AvatarStealer.Active then return end
            local plr, _, d = grab(s)
            if not plr then return end
            view(plr, d)
        end)

        local st = w:Clone()
        st.Name = "StealOutfit"
        st.Text = "Steal Outfit"
        st.LayoutOrder = w.LayoutOrder + 1
        st.Parent = s
        st.Activated:Connect(function()
            if not AvatarStealer.Active then return end
            local plr, m, d, r = grab(s)
            if plr then go(d, m, r) end
        end)

        return true
    end

    local s = sf()
    if s then
        for _, n in ipairs({"StealOutfit", "ForceViewOutfit"}) do
            local o = s:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end

    local pollConn
    pollConn = task.spawn(function()
        for _ = 1, 60 do
            if not AvatarStealer.Active then return end
            if ok() then break end
            task.wait(1)
        end
    end)
    table.insert(AvatarStealer.Connections, pollConn)

    local guiConn = lp.PlayerGui.ChildAdded:Connect(function(c)
        if not AvatarStealer.Active then return end
        if c.Name == "ViewPlayer" then
            task.wait(0.3)
            if AvatarStealer.Active then ok() end
        end
    end)
    table.insert(AvatarStealer.Connections, guiConn)
end

function AvatarStealer:Start()
    if self.Active then return end
    self.Active = true
    self.Connections = {}
    self:Inject()
end

function AvatarStealer:Stop()
    self.Active = false
    for _, c in ipairs(self.Connections) do
        if typeof(c) == "RBXScriptConnection" then
            pcall(function() c:Disconnect() end)
        elseif type(c) == "thread" then
            pcall(function() task.cancel(c) end)
        end
    end
    self.Connections = {}

    local g = LocalPlayer:FindFirstChild("PlayerGui")
    local v = g and g:FindFirstChild("ViewPlayer")
    local m = v and v:FindFirstChild("Main") and v.Main:FindFirstChild("Menu")
    local s = m and m:FindFirstChild("ScrollingFrame")
    if s then
        for _, n in ipairs({"StealOutfit", "ForceViewOutfit"}) do
            local o = s:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end
end

-- ============================================================
-- RUN LOADER, THEN BUILD PANELS
-- ============================================================
RunLoadingSequence()

-- ============================================================
-- PANEL 1 — VISUALS
-- ============================================================
local VisualsPanel = CreateWindow("BLACKOUT // VISUALS", 20, 20)

VisualsPanel.CreateSection("esp")
VisualsPanel.CreateToggle("Box ESP", false, function(s)
    getgenv().BoxESPActive = s
    if s then StartBoxESP() else StopBoxESP() end
end)
VisualsPanel.CreateToggle("Name ESP", false, function(s)
    getgenv().NameESPActive = s
    if s then StartNameESP() else StopNameESP() end
end)

-- ============================================================
-- PANEL 2 — UTILITY
-- ============================================================
local UtilityPanel = CreateWindow("BLACKOUT // UTILITY", 260, 20)

UtilityPanel.CreateSection("avatar")
UtilityPanel.CreateToggle("Steal Outfit (View Player)", false, function(s)
    if s then AvatarStealer:Start() else AvatarStealer:Stop() end
end)
UtilityPanel.CreateButton("TP to Random", function()
    TpToRandomPlayer()
end)

UtilityPanel.CreateSection("teleport")
UtilityPanel.CreateTextBox("Player name (partial)...", function(text)
    TpToPlayerByName(text)
end)

-- ============================================================
-- PANEL 3 — THEME  (far right, small)
-- ============================================================
local ThemePanel = CreateWindow("BLACKOUT // THEME", 500, 20)

ThemePanel.CreateSection("theme")
ThemePanel.CreateDropdown("THEME COLOR", "RED",
    {"RED", "PURPLE", "BLUE", "GREEN", "ORANGE", "PINK", "WHITE"}, function(v)
    ApplyTheme(v)
end)

-- Apply RED once everything exists so all elements are properly synced.
ApplyTheme("RED")

-- ============================================================
-- OPEN BY DEFAULT
-- ============================================================
ScreenGui.Enabled = true

-- ============================================================
-- KEYBIND — RightShift toggles GUI
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("[Blackout] Loaded. RightShift = toggle GUI")
