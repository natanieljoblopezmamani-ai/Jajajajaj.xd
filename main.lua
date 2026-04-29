-- ============================================================
--  RP ULTIMATE FULL  |  TACTICAL EDITION  v3.0
--  Visual overhaul + nuevas categorías y sistemas
-- ============================================================

local TextChatService  = game:GetService("TextChatService")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- ============================================================
-- PALETA TÁCTICA CENTRALIZADA
-- ============================================================
local C = {
    bg         = Color3.fromRGB(8,  10, 12),
    panel      = Color3.fromRGB(14, 17, 21),
    surface    = Color3.fromRGB(20, 24, 30),
    surfaceAlt = Color3.fromRGB(26, 31, 38),
    border     = Color3.fromRGB(52, 73, 94),
    accent     = Color3.fromRGB(0,  188, 140),
    accentDim  = Color3.fromRGB(0,  100, 75),
    danger     = Color3.fromRGB(220, 50,  50),
    dangerDim  = Color3.fromRGB(100, 22, 22),
    combat     = Color3.fromRGB(130, 50, 230),
    combatDim  = Color3.fromRGB(65,  20, 120),
    aim        = Color3.fromRGB(20,  70, 50),
    aimHover   = Color3.fromRGB(0,  140, 100),
    shoot      = Color3.fromRGB(90,  18, 18),
    shootHover = Color3.fromRGB(190, 40, 40),
    medical    = Color3.fromRGB(180, 30, 60),
    medicalDim = Color3.fromRGB(80,  10, 25),
    signal     = Color3.fromRGB(200, 140, 0),
    signalDim  = Color3.fromRGB(90,  60,  0),
    script_c   = Color3.fromRGB(0,  120, 200),
    scriptDim  = Color3.fromRGB(0,   50, 100),
    armory     = Color3.fromRGB(160, 90,  20),
    armoryDim  = Color3.fromRGB(70,  38,  8),
    textPrime  = Color3.fromRGB(220, 230, 240),
    textDim    = Color3.fromRGB(100, 120, 145),
    textAccent = Color3.fromRGB(0,  210, 160),
    lock_on    = Color3.fromRGB(0,  210, 100),
    lock_off   = Color3.fromRGB(220, 50,  50),
}

local TI_fast  = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_med   = TweenInfo.new(0.22, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_slow  = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local function tw(obj, props, info)
    TweenService:Create(obj, info or TI_fast, props):Play()
end

local function corner(parent, px)
    local u = Instance.new("UICorner", parent)
    u.CornerRadius = UDim.new(0, px or 4)
    return u
end

local function stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color       = color     or C.border
    s.Thickness   = thickness or 1
    s.Transparency = trans    or 0
    return s
end

local function hoverColor(btn, normal, hover)
    btn.MouseEnter:Connect(function()
        tw(btn, {BackgroundColor3 = hover})
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, {BackgroundColor3 = normal})
    end)
    btn.MouseButton1Down:Connect(function()
        tw(btn, {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.82})
    end)
    btn.MouseButton1Up:Connect(function()
        tw(btn, {BackgroundColor3 = hover, BackgroundTransparency = 0})
    end)
end

local function makeInput(parent, size, pos, placeholder)
    local tb = Instance.new("TextBox", parent)
    tb.Size = size; tb.Position = pos
    tb.BackgroundColor3  = C.surface
    tb.BorderSizePixel   = 0
    tb.PlaceholderText   = placeholder
    tb.PlaceholderColor3 = C.textDim
    tb.Text = ""
    tb.TextColor3 = C.textAccent
    tb.TextSize   = 11
    tb.Font       = Enum.Font.GothamSemibold
    tb.ClearTextOnFocus = false
    corner(tb, 6)
    stroke(tb, C.accentDim, 1, 0.3)
    tb.Focused:Connect(function()   tw(tb, {BackgroundColor3 = Color3.fromRGB(14,26,22)}, TI_fast) end)
    tb.FocusLost:Connect(function() tw(tb, {BackgroundColor3 = C.surface}, TI_fast) end)
    return tb
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name   = "RP_Ultimate_Full"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn   = false

-- ============================================================
-- 1. CONTROL FLOTANTE
-- ============================================================
local Control = Instance.new("TextButton", ScreenGui)
Control.Size     = UDim2.new(0, 44, 0, 44)
Control.Position = UDim2.new(0, 14, 0, 200)
Control.BackgroundColor3 = C.surface
Control.Text     = "RP"
Control.TextColor3  = C.textAccent
Control.TextSize = 13
Control.Font     = Enum.Font.GothamBold
Control.Draggable = true
Control.BorderSizePixel = 0
corner(Control, 9)
stroke(Control, C.accent, 1.5, 0.15)
hoverColor(Control, C.surface, C.surfaceAlt)

local Lock = Instance.new("Frame", Control)
Lock.Size     = UDim2.new(0, 9, 0, 9)
Lock.Position = UDim2.new(1, -5, 0, -3)
Lock.BackgroundColor3 = C.lock_on
Lock.BorderSizePixel  = 0
corner(Lock, 5)

local movible = true
Control.MouseButton2Click:Connect(function()
    movible = not movible
    Control.Draggable = movible
    tw(Lock, {BackgroundColor3 = movible and C.lock_on or C.lock_off}, TI_med)
end)

-- ============================================================
-- 2. GUI PRINCIPAL
-- ============================================================
local Main = Instance.new("Frame", ScreenGui)
Main.Size     = UDim2.new(0, 480, 0, 380)
Main.Position = UDim2.new(0.5, -240, 0.5, -190)
Main.BackgroundColor3 = C.bg
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel  = 0
Main.Visible  = false
Main.Active   = true
Main.Draggable = true
corner(Main, 10)
stroke(Main, C.border, 1.5, 0.08)

-- Barra de título
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = C.surface
TitleBar.BorderSizePixel  = 0
corner(TitleBar, 10)
local tFix = Instance.new("Frame", TitleBar)
tFix.Size = UDim2.new(1,0,0.5,0); tFix.Position = UDim2.new(0,0,0.5,0)
tFix.BackgroundColor3 = C.surface; tFix.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "◈  TACTICAL RP SYSTEM  v3.0  ◈"
TitleLabel.TextColor3 = C.textAccent
TitleLabel.TextSize   = 11
TitleLabel.Font       = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Línea accent bajo la barra
local AccentLine = Instance.new("Frame", Main)
AccentLine.Size = UDim2.new(1, 0, 0, 1)
AccentLine.Position = UDim2.new(0, 0, 0, 38)
AccentLine.BackgroundColor3 = C.accent
AccentLine.BackgroundTransparency = 0.45
AccentLine.BorderSizePixel = 0

-- ── BOTÓN CANDADO (táctil) ──────────────────────────────────
local LockBtn = Instance.new("TextButton", TitleBar)
LockBtn.Size = UDim2.new(0, 30, 0, 26)
LockBtn.Position = UDim2.new(1, -92, 0, 6)
LockBtn.Text     = "🔓"
LockBtn.TextSize = 14
LockBtn.BackgroundColor3 = C.surfaceAlt
LockBtn.TextColor3 = C.lock_on
LockBtn.BorderSizePixel = 0
corner(LockBtn, 5)
hoverColor(LockBtn, C.surfaceAlt, C.panel)

local mainMovible = true
LockBtn.MouseButton1Click:Connect(function()
    mainMovible = not mainMovible
    Main.Draggable = mainMovible
    LockBtn.Text = mainMovible and "🔓" or "🔒"
    tw(LockBtn, {TextColor3 = mainMovible and C.lock_on or C.lock_off}, TI_med)
end)

-- ── BOTÓN MINIMIZAR ─────────────────────────────────────────
local minimized = false
local fullHeight = 380
local miniHeight = 38

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 6)
MinBtn.Text     = "▼"
MinBtn.TextSize = 11
MinBtn.Font     = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = C.surfaceAlt
MinBtn.TextColor3 = C.textDim
MinBtn.BorderSizePixel = 0
corner(MinBtn, 5)
hoverColor(MinBtn, C.surfaceAlt, C.panel)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local target = minimized and miniHeight or fullHeight
    tw(Main, {Size = UDim2.new(0, 480, 0, target)}, TI_slow)
    MinBtn.Text = minimized and "▲" or "▼"
end)

-- ── BOTÓN CERRAR ────────────────────────────────────────────
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 6)
CloseBtn.Text     = "✕"
CloseBtn.TextSize = 13
CloseBtn.Font     = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = C.dangerDim
CloseBtn.TextColor3 = Color3.fromRGB(255, 110, 110)
CloseBtn.BorderSizePixel = 0
corner(CloseBtn, 5)
hoverColor(CloseBtn, C.dangerDim, C.danger)
CloseBtn.MouseButton1Click:Connect(function()
    tw(Main, {BackgroundTransparency = 1}, TI_med)
    task.delay(0.22, function() Main.Visible = false end)
end)

-- ============================================================
-- INPUTS GLOBALES
-- ============================================================
local victimaInput = makeInput(Main,
    UDim2.new(0, 185, 0, 28), UDim2.new(0, 68, 0, 48),  "  👤  A QUIÉN?")
local balasInput = makeInput(Main,
    UDim2.new(0, 185, 0, 28), UDim2.new(0, 262, 0, 48), "  🔫  CON QUÉ?")

-- ============================================================
-- BARRA DE BÚSQUEDA
-- ============================================================
local SearchBar = Instance.new("TextBox", Main)
SearchBar.Size     = UDim2.new(0, 296, 0, 28)
SearchBar.Position = UDim2.new(0, 68, 0, 84)
SearchBar.BackgroundColor3  = C.surface
SearchBar.BorderSizePixel   = 0
SearchBar.PlaceholderText   = "  🔍  BUSCADOR UNIVERSAL..."
SearchBar.PlaceholderColor3 = C.textDim
SearchBar.Text      = ""
SearchBar.TextColor3 = C.textPrime
SearchBar.TextSize   = 11
SearchBar.Font       = Enum.Font.Gotham
SearchBar.ClearTextOnFocus = false
corner(SearchBar, 6)
stroke(SearchBar, C.border, 1, 0.4)

local ClearSearch = Instance.new("TextButton", Main)
ClearSearch.Size     = UDim2.new(0, 70, 0, 28)
ClearSearch.Position = UDim2.new(0, 370, 0, 84)
ClearSearch.Text     = "✕ LIMPIAR"
ClearSearch.TextSize = 10
ClearSearch.Font     = Enum.Font.GothamBold
ClearSearch.BackgroundColor3 = C.dangerDim
ClearSearch.TextColor3 = Color3.fromRGB(255, 120, 120)
ClearSearch.BorderSizePixel = 0
corner(ClearSearch, 6)
hoverColor(ClearSearch, C.dangerDim, C.danger)
ClearSearch.MouseButton1Click:Connect(function() SearchBar.Text = "" end)

-- ============================================================
-- SCROLL PRINCIPAL
-- ============================================================
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size     = UDim2.new(0, 392, 0, 228)
Scroll.Position = UDim2.new(0, 68, 0, 120)
Scroll.BackgroundColor3 = C.panel
Scroll.BorderSizePixel  = 0
Scroll.CanvasSize = UDim2.new(0, 0, 120, 0)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = C.accent
corner(Scroll, 8)
local scrollLayout = Instance.new("UIListLayout", Scroll)
scrollLayout.Padding = UDim.new(0, 6)
local scrollPad = Instance.new("UIPadding", Scroll)
scrollPad.PaddingLeft  = UDim.new(0, 6); scrollPad.PaddingRight  = UDim.new(0, 6)
scrollPad.PaddingTop   = UDim.new(0, 6); scrollPad.PaddingBottom = UDim.new(0, 6)

-- ============================================================
-- 3. LÓGICA DE CHAT
-- ============================================================
local function EnviarAlChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

local function Procesar(parte, tipo)
    local vic = victimaInput.Text ~= "" and victimaInput.Text or "objetivo"
    local bal = balasInput.Text ~= "" and balasInput.Text or "munición"
    local verbos = {"Dispara", "Percuta", "Acciona", "Detona", "Descarga", "Abre fuego con"}
    if tipo == "apuntar" then
        EnviarAlChat("-apunta a " .. parte .. " de " .. vic .. "-")
    elseif tipo == "disparar" then
        EnviarAlChat("-" .. verbos[math.random(#verbos)] .. " 1 bala (" .. bal .. ") al " .. parte .. " de " .. vic .. "-")
    else
        EnviarAlChat("-" .. parte .. " de " .. vic .. "-")
    end
end

-- ============================================================
-- 4. CREADOR DE BLOQUES
-- ============================================================
local function crearBloque(texto, tipo, accentColor)
    local esCombate = (tipo == "combate")
    local bgColor   = accentColor or (esCombate and C.combatDim or C.surfaceAlt)
    local hdrColor  = esCombate and C.combat or (accentColor or C.accent)

    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -2, 0, 82)
    f.BackgroundColor3 = C.surfaceAlt
    f.BorderSizePixel  = 0
    f.Name = texto
    corner(f, 7)
    stroke(f, C.border, 1, 0.55)

    local header = Instance.new("Frame", f)
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundColor3 = C.surface
    header.BorderSizePixel  = 0
    corner(header, 7)
    local hFix = Instance.new("Frame", header)
    hFix.Size = UDim2.new(1,0,0.5,0); hFix.Position = UDim2.new(0,0,0.5,0)
    hFix.BackgroundColor3 = C.surface; hFix.BorderSizePixel = 0

    local ind = Instance.new("Frame", header)
    ind.Size = UDim2.new(0, 3, 1, 0)
    ind.BackgroundColor3 = hdrColor
    ind.BorderSizePixel  = 0
    corner(ind, 3)

    local l = Instance.new("TextLabel", header)
    l.Size = UDim2.new(1, -12, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = texto:upper()
    l.TextColor3 = esCombate and Color3.fromRGB(190,140,255) or C.textAccent
    l.TextSize   = 10
    l.Font       = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left

    if not esCombate then
        local b1 = Instance.new("TextButton", f)
        b1.Size = UDim2.new(0.5,-4,0,50); b1.Position = UDim2.new(0,2,0,28)
        b1.Text = "🎯  APUNTAR"; b1.TextSize = 11; b1.Font = Enum.Font.GothamSemibold
        b1.BackgroundColor3 = C.aim; b1.TextColor3 = Color3.fromRGB(140,255,200); b1.BorderSizePixel = 0
        corner(b1, 6); hoverColor(b1, C.aim, C.aimHover)
        b1.MouseButton1Click:Connect(function() Procesar(texto, "apuntar") end)

        local b2 = Instance.new("TextButton", f)
        b2.Size = UDim2.new(0.5,-4,0,50); b2.Position = UDim2.new(0.5,2,0,28)
        b2.Text = "💥  DISPARAR"; b2.TextSize = 11; b2.Font = Enum.Font.GothamSemibold
        b2.BackgroundColor3 = C.shoot; b2.TextColor3 = Color3.fromRGB(255,140,140); b2.BorderSizePixel = 0
        corner(b2, 6); hoverColor(b2, C.shoot, C.shootHover)
        b2.MouseButton1Click:Connect(function() Procesar(texto, "disparar") end)
    else
        local b3 = Instance.new("TextButton", f)
        b3.Size = UDim2.new(1,-4,0,50); b3.Position = UDim2.new(0,2,0,28)
        b3.Text = "👊  EJECUTAR"; b3.TextSize = 11; b3.Font = Enum.Font.GothamSemibold
        b3.BackgroundColor3 = C.combatDim; b3.TextColor3 = Color3.fromRGB(190,140,255); b3.BorderSizePixel = 0
        corner(b3, 6); hoverColor(b3, C.combatDim, C.combat)
        b3.MouseButton1Click:Connect(function() Procesar(texto, "combate") end)
    end
end

-- ============================================================
-- MINI-GUI DE TEXTO (para Scripts / 2do chat)
-- ============================================================
local function crearMiniChat(titulo, prefijo, sufijo)
    prefijo = prefijo or ""
    sufijo  = sufijo  or ""

    local gui = Instance.new("Frame", ScreenGui)
    gui.Size     = UDim2.new(0, 320, 0, 110)
    gui.Position = UDim2.new(0.5, -160, 1, -130)
    gui.BackgroundColor3 = C.panel
    gui.BorderSizePixel  = 0
    gui.Active   = true
    gui.Draggable = true
    gui.Visible  = true
    corner(gui, 10)
    stroke(gui, C.script_c, 1.5, 0.15)

    -- Barra de título
    local bar = Instance.new("Frame", gui)
    bar.Size = UDim2.new(1,0,0,28)
    bar.BackgroundColor3 = C.surface; bar.BorderSizePixel = 0
    corner(bar, 10)
    local bFix = Instance.new("Frame", bar)
    bFix.Size = UDim2.new(1,0,0.5,0); bFix.Position = UDim2.new(0,0,0.5,0)
    bFix.BackgroundColor3 = C.surface; bFix.BorderSizePixel = 0

    local barTitle = Instance.new("TextLabel", bar)
    barTitle.Size = UDim2.new(1,-30,1,0); barTitle.Position = UDim2.new(0,10,0,0)
    barTitle.BackgroundTransparency = 1
    barTitle.Text = "◈  " .. titulo
    barTitle.TextColor3 = Color3.fromRGB(100,180,255)
    barTitle.TextSize = 10; barTitle.Font = Enum.Font.GothamBold
    barTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Botón cerrar de la mini-GUI
    local closeG = Instance.new("TextButton", bar)
    closeG.Size = UDim2.new(0,22,0,20); closeG.Position = UDim2.new(1,-24,0,4)
    closeG.Text = "✕"; closeG.TextSize = 11; closeG.Font = Enum.Font.GothamBold
    closeG.BackgroundColor3 = C.dangerDim; closeG.TextColor3 = Color3.fromRGB(255,100,100)
    closeG.BorderSizePixel = 0; corner(closeG, 4)
    hoverColor(closeG, C.dangerDim, C.danger)
    closeG.MouseButton1Click:Connect(function()
        tw(gui, {BackgroundTransparency = 1}, TI_med)
        task.delay(0.22, function() gui:Destroy() end)
    end)

    -- Input de texto
    local input = Instance.new("TextBox", gui)
    input.Size = UDim2.new(1,-12,0,40); input.Position = UDim2.new(0,6,0,34)
    input.BackgroundColor3 = C.surface; input.BorderSizePixel = 0
    input.PlaceholderText = "  Escribe aquí... (no va al chat)"
    input.PlaceholderColor3 = C.textDim
    input.Text = ""; input.TextColor3 = C.textPrime
    input.TextSize = 12; input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.MultiLine = false; input.TextXAlignment = Enum.TextXAlignment.Left
    corner(input, 6); stroke(input, C.script_c, 1, 0.4)

    -- Botón enviar
    local send = Instance.new("TextButton", gui)
    send.Size = UDim2.new(1,-12,0,26); send.Position = UDim2.new(0,6,0,80)
    send.Text = "  ➤  ENVIAR"
    send.TextSize = 11; send.Font = Enum.Font.GothamBold
    send.BackgroundColor3 = C.scriptDim; send.TextColor3 = Color3.fromRGB(100,180,255)
    send.BorderSizePixel = 0; corner(send, 6)
    hoverColor(send, C.scriptDim, C.script_c)

    send.MouseButton1Click:Connect(function()
        local msg = input.Text
        if msg ~= "" then
            local final = prefijo .. msg .. sufijo
            EnviarAlChat(final)
            input.Text = ""  -- auto-borrar tras enviar
        end
    end)

    -- También enviar con Enter
    input.FocusLost:Connect(function(enter)
        if enter and input.Text ~= "" then
            local final = prefijo .. input.Text .. sufijo
            EnviarAlChat(final)
            input.Text = ""
        end
    end)

    -- Fade in de entrada
    gui.BackgroundTransparency = 1
    tw(gui, {BackgroundTransparency = 0}, TI_slow)
end

-- ============================================================
-- CREADOR DE BOTÓN DE SCRIPT
-- ============================================================
local function crearBloqueScript(nombre, titulo, prefijo, sufijo)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1,-2,0,60)
    f.BackgroundColor3 = C.surfaceAlt; f.BorderSizePixel = 0
    f.Name = nombre
    corner(f, 7); stroke(f, C.border, 1, 0.55)

    local ind = Instance.new("Frame", f)
    ind.Size = UDim2.new(0,3,1,0); ind.BackgroundColor3 = C.script_c; ind.BorderSizePixel = 0
    corner(ind, 3)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-90,1,0); lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = nombre:upper(); lbl.TextColor3 = Color3.fromRGB(100,180,255)
    lbl.TextSize = 10; lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0,80,0,38); btn.Position = UDim2.new(1,-84,0,11)
    btn.Text = "▶ ABRIR"; btn.TextSize = 10; btn.Font = Enum.Font.GothamBold
    bt
