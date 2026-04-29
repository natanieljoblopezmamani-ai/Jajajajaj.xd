-- ============================================================
--  RP ULTIMATE FULL  |  TACTICAL EDITION  v2.0
--  Visual overhaul — lógica 100% original preservada
-- ============================================================

local TextChatService  = game:GetService("TextChatService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Paleta táctica centralizada
local C = {
    bg         = Color3.fromRGB(8,  10, 12),
    panel      = Color3.fromRGB(14, 17, 21),
    surface    = Color3.fromRGB(20, 24, 30),
    surfaceAlt = Color3.fromRGB(26, 31, 38),
    border     = Color3.fromRGB(52, 73, 94),
    accent     = Color3.fromRGB(0,  188, 140),
    accentDim  = Color3.fromRGB(0,  120, 90),
    danger     = Color3.fromRGB(220, 50, 50),
    dangerDim  = Color3.fromRGB(140, 30, 30),
    combat     = Color3.fromRGB(120, 40, 220),
    combatDim  = Color3.fromRGB(70,  20, 140),
    aim        = Color3.fromRGB(30,  80, 60),
    aimHover   = Color3.fromRGB(0,  140, 100),
    shoot      = Color3.fromRGB(100, 20, 20),
    shootHover = Color3.fromRGB(200, 40, 40),
    textPrime  = Color3.fromRGB(220, 230, 240),
    textDim    = Color3.fromRGB(120, 140, 160),
    textAccent = Color3.fromRGB(0,  210, 160),
    lock_on    = Color3.fromRGB(0,  220, 100),
    lock_off   = Color3.fromRGB(220, 50,  50),
}

local TI_fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_med    = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_slow   = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- Utilidad: tween limpio
local function tw(obj, props, info)
    TweenService:Create(obj, info or TI_fast, props):Play()
end

-- Utilidad: hover genérico (color BG)
local function hoverColor(btn, normal, hover)
    btn.MouseEnter:Connect(function()  tw(btn, {BackgroundColor3 = hover}) end)
    btn.MouseLeave:Connect(function()  tw(btn, {BackgroundColor3 = normal}) end)
    btn.MouseButton1Down:Connect(function() tw(btn, {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.85}) end)
    btn.MouseButton1Up:Connect(function()   tw(btn, {BackgroundColor3 = hover}) end)
end

-- Utilidad: UICorner rápido
local function corner(parent, px)
    local u = Instance.new("UICorner", parent)
    u.CornerRadius = UDim.new(0, px or 4)
    return u
end

-- Utilidad: UIStroke rápido
local function stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or C.border
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    return s
end

-- Utilidad: label decorativo (línea divisora)
local function divider(parent, yPos)
    local d = Instance.new("Frame", parent)
    d.Size = UDim2.new(1, -20, 0, 1)
    d.Position = UDim2.new(0, 10, 0, yPos)
    d.BackgroundColor3 = C.border
    d.BackgroundTransparency = 0.6
    d.BorderSizePixel = 0
    return d
end

-- ============================================================
-- SCREENGUÍ
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RP_Ultimate_Full"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- 1. CONTROL FLOTANTE Y CANDADO
-- ============================================================
local Control = Instance.new("TextButton", ScreenGui)
Control.Size     = UDim2.new(0, 42, 0, 42)
Control.Position = UDim2.new(0, 14, 0, 200)
Control.BackgroundColor3 = C.surface
Control.Text     = "RP"
Control.TextColor3  = C.textAccent
Control.TextSize = 13
Control.Font     = Enum.Font.GothamBold
Control.Draggable = true
Control.BorderSizePixel = 0
corner(Control, 8)
stroke(Control, C.accent, 1.5, 0.2)

-- Brillo sutil en el botón de control
local ctrlGlow = Instance.new("ImageLabel", Control)
ctrlGlow.Size = UDim2.new(1.6, 0, 1.6, 0)
ctrlGlow.Position = UDim2.new(-0.3, 0, -0.3, 0)
ctrlGlow.BackgroundTransparency = 1
ctrlGlow.Image = "rbxassetid://5028857084" -- radial gradient (Roblox stock)
ctrlGlow.ImageColor3 = C.accent
ctrlGlow.ImageTransparency = 0.88
ctrlGlow.ZIndex = 0

hoverColor(Control, C.surface, C.surfaceAlt)

-- Indicador candado (reposicionado, más limpio)
local Lock = Instance.new("Frame", Control)
Lock.Size     = UDim2.new(0, 8, 0, 8)
Lock.Position = UDim2.new(1, -5, 0, -3)
Lock.BackgroundColor3 = C.lock_on
Lock.BorderSizePixel  = 0
corner(Lock, 4)

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
Main.Size     = UDim2.new(0, 460, 0, 360)
Main.Position = UDim2.new(0.5, -230, 0.5, -180)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel  = 0
Main.Visible  = false
Main.Active   = true
Main.Draggable = true
Main.BackgroundTransparency = 0.04
corner(Main, 10)
stroke(Main, C.border, 1.5, 0.1)

-- Barra de título decorativa
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = C.surface
TitleBar.BorderSizePixel = 0
corner(TitleBar, 10)

-- Fijar esquinas inferiores de la barra
local TitleBarFix = Instance.new("Frame", TitleBar)
TitleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarFix.BackgroundColor3 = C.surface
TitleBarFix.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "◈  TACTICAL RP SYSTEM  ◈"
TitleLabel.TextColor3 = C.textAccent
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleAccentLine = Instance.new("Frame", Main)
TitleAccentLine.Size = UDim2.new(1, 0, 0, 1)
TitleAccentLine.Position = UDim2.new(0, 0, 0, 36)
TitleAccentLine.BackgroundColor3 = C.accent
TitleAccentLine.BackgroundTransparency = 0.5
TitleAccentLine.BorderSizePixel = 0

-- ============================================================
-- BARRA DE BÚSQUEDA
-- ============================================================
local SearchBar = Instance.new("TextBox", Main)
SearchBar.Size     = UDim2.new(0, 285, 0, 28)
SearchBar.Position = UDim2.new(0, 68, 0, 46)
SearchBar.BackgroundColor3 = C.surface
SearchBar.BorderSizePixel  = 0
SearchBar.PlaceholderText  = "  🔍  BUSCADOR UNIVERSAL..."
SearchBar.PlaceholderColor3 = C.textDim
SearchBar.Text = ""
SearchBar.TextColor3 = C.textPrime
SearchBar.TextSize = 12
SearchBar.Font = Enum.Font.Gotham
SearchBar.ClearTextOnFocus = false
corner(SearchBar, 6)
stroke(SearchBar, C.border, 1, 0.4)

local ClearSearch = Instance.new("TextButton", Main)
ClearSearch.Size     = UDim2.new(0, 68, 0, 28)
ClearSearch.Position = UDim2.new(0, 360, 0, 46)
ClearSearch.Text     = "✕  LIMPIAR"
ClearSearch.TextSize = 10
ClearSearch.Font     = Enum.Font.GothamBold
ClearSearch.BackgroundColor3 = C.dangerDim
ClearSearch.TextColor3 = Color3.fromRGB(255, 120, 120)
ClearSearch.BorderSizePixel = 0
corner(ClearSearch, 6)
hoverColor(ClearSearch, C.dangerDim, C.danger)

-- ============================================================
-- INPUTS: VÍCTIMA / ARMA
-- ============================================================
local function makeInput(parent, size, pos, placeholder)
    local tb = Instance.new("TextBox", parent)
    tb.Size = size; tb.Position = pos
    tb.BackgroundColor3 = C.surface
    tb.BorderSizePixel  = 0
    tb.PlaceholderText  = placeholder
    tb.PlaceholderColor3 = C.textDim
    tb.Text = ""
    tb.TextColor3 = C.textAccent
    tb.TextSize   = 11
    tb.Font       = Enum.Font.GothamSemibold
    tb.ClearTextOnFocus = false
    corner(tb, 6)
    stroke(tb, C.accentDim, 1, 0.3)
    -- Focus glow
    tb.Focused:Connect(function()  tw(tb, {BackgroundColor3 = Color3.fromRGB(16, 26, 22)}, TI_fast) end)
    tb.FocusLost:Connect(function() tw(tb, {BackgroundColor3 = C.surface}, TI_fast) end)
    return tb
end

local victimaInput = makeInput(Main,
    UDim2.new(0, 176, 0, 28),
    UDim2.new(0, 68,  0, 82),
    "  👤  A QUIÉN?")

local balasInput = makeInput(Main,
    UDim2.new(0, 176, 0, 28),
    UDim2.new(0, 252, 0, 82),
    "  🔫  CON QUÉ?")

-- ============================================================
-- SCROLL PRINCIPAL
-- ============================================================
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size     = UDim2.new(0, 376, 0, 240)
Scroll.Position = UDim2.new(0, 68, 0, 118)
Scroll.BackgroundColor3 = C.panel
Scroll.BorderSizePixel  = 0
Scroll.CanvasSize = UDim2.new(0, 0, 120, 0)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = C.accent
corner(Scroll, 8)

local scrollLayout = Instance.new("UIListLayout", Scroll)
scrollLayout.Padding = UDim.new(0, 6)

local scrollPad = Instance.new("UIPadding", Scroll)
scrollPad.PaddingLeft   = UDim.new(0, 6)
scrollPad.PaddingRight  = UDim.new(0, 6)
scrollPad.PaddingTop    = UDim.new(0, 6)
scrollPad.PaddingBottom = UDim.new(0, 6)

-- ============================================================
-- 3. LÓGICA DE CHAT (SIN CAMBIOS)
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
-- 4. CREADOR DE BLOQUES — visual renovado, lógica idéntica
-- ============================================================
local function crearBloque(texto, esCombate)
    -- Contenedor principal del bloque
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -2, 0, 82)
    f.BackgroundColor3 = C.surfaceAlt
    f.BorderSizePixel  = 0
    f.Name = texto
    corner(f, 7)
    stroke(f, C.border, 1, 0.5)

    -- Cabecera del bloque
    local header = Instance.new("Frame", f)
    header.Size = UDim2.new(1, 0, 0, 24)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = C.surface
    header.BorderSizePixel  = 0
    corner(header, 7)
    -- Fix esquinas inferiores header
    local hFix = Instance.new("Frame", header)
    hFix.Size = UDim2.new(1,0,0.5,0); hFix.Position = UDim2.new(0,0,0.5,0)
    hFix.BackgroundColor3 = C.surface; hFix.BorderSizePixel = 0

    -- Indicador de color lateral
    local indicator = Instance.new("Frame", header)
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.BackgroundColor3 = esCombate and C.combat or C.accent
    indicator.BorderSizePixel  = 0
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 3)

    local l = Instance.new("TextLabel", header)
    l.Size = UDim2.new(1, -12, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = texto:upper()
    l.TextColor3 = esCombate and Color3.fromRGB(190, 140, 255) or C.textAccent
    l.TextSize   = 10
    l.Font       = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left

    -- Zona de botones
    if not esCombate then
        -- APUNTAR
        local b1 = Instance.new("TextButton", f)
        b1.Size = UDim2.new(0.5, -4, 0, 50)
        b1.Position = UDim2.new(0, 2, 0, 28)
        b1.Text = "🎯  APUNTAR"
        b1.TextSize = 11
        b1.Font = Enum.Font.GothamSemibold
        b1.BackgroundColor3 = C.aim
        b1.TextColor3 = Color3.fromRGB(140, 255, 200)
        b1.BorderSizePixel = 0
        corner(b1, 6)
        hoverColor(b1, C.aim, C.aimHover)
        b1.MouseButton1Click:Connect(function() Procesar(texto, "apuntar") end)

        -- DISPARAR
        local b2 = Instance.new("TextButton", f)
        b2.Size = UDim2.new(0.5, -4, 0, 50)
        b2.Position = UDim2.new(0.5, 2, 0, 28)
        b2.Text = "💥  DISPARAR"
        b2.TextSize = 11
        b2.Font = Enum.Font.GothamSemibold
        b2.BackgroundColor3 = C.shoot
        b2.TextColor3 = Color3.fromRGB(255, 140, 140)
        b2.BorderSizePixel = 0
        corner(b2, 6)
        hoverColor(b2, C.shoot, C.shootHover)
        b2.MouseButton1Click:Connect(function() Procesar(texto, "disparar") end)
    else
        -- EJECUTAR (combate)
        local b3 = Instance.new("TextButton", f)
        b3.Size = UDim2.new(1, -4, 0, 50)
        b3.Position = UDim2.new(0, 2, 0, 28)
        b3.Text = "👊  EJECUTAR"
        b3.TextSize = 11
        b3.Font = Enum.Font.GothamSemibold
        b3.BackgroundColor3 = C.combatDim
        b3.TextColor3 = Color3.fromRGB(190, 140, 255)
        b3.BorderSizePixel = 0
        corner(b3, 6)
        hoverColor(b3, C.combatDim, C.combat)
        b3.MouseButton1Click:Connect(function() Procesar(texto, "combate") end)
    end
end

-- ============================================================
-- 5. DATABASE — sin cambios
-- ============================================================
local database = {
    ["👤"] = {"hombro derecho", "hombro izquierdo", "brazo derecho", "brazo izquierdo", "antebrazo derecho", "antebrazo izquierdo", "codo derecho", "codo izquierdo", "muñeca derecha", "muñeca izquierdo", "mano derecha", "mano izquierda", "dedos mano der", "dedos mano izq", "pecho superior", "pecho inferior", "abdomen", "ingle", "muslo derecho", "muslo izquierdo", "rodilla derecha", "rodilla izquierda", "pantorrilla derecha", "pantorrilla izquierda", "tobillo derecho", "tobillo izquierdo", "pie derecho", "pie izquierdo", "costilla flotante der", "costilla flotante izq", "clavicula der", "clavicula izq", "esternon", "ombligo"},
    ["🥷"] = {"frente", "ojo derecho", "ojo izquierdo", "mandibula", "mejilla der", "mejilla izq", "oreja der", "oreja izq", "nuca", "cuello frontal", "cuello lateral der", "cuello lateral izq", "traquea", "nuez de adan", "sien derecha", "sien izquierda"},
    ["🛡️"] = {"placa pectoral chaleco", "placa dorsal chaleco", "kevlar lateral der", "kevlar lateral izq", "hombro con proteccion der", "hombro con proteccion izq", "casco (visera)", "casco (nuca)", "casco (lateral)", "axila derecha", "axila izquierda", "ingle (proteccion)"},
    ["🚗"] = {"llanta del der", "llanta del izq", "llanta tras der", "llanta tras izq", "motor", "radiador", "bateria", "alternador", "tanque de gas", "parabrisas", "medallon trasero", "ventanilla cond", "ventanilla copiloto", "pilar A", "pilar B", "bloque motor", "manguera frenos", "disco de freno", "amortiguador", "faro delantero der", "faro delantero izq", "calavera trasera"},
    ["💎"] = {"cristal blindado N3", "puerta blindada", "junta de puerta", "bisagra superior", "bisagra inferior", "mirilla tactica", "motor parte baja", "neumatico run-flat"},
    ["🥋"] = {"golpea nariz", "golpea higado", "golpea bazo", "golpea plexo solar", "gancho al menton", "patada baja muslo", "patea espinilla", "barrida de pierna", "luxa muñeca der", "luxa muñeca izq", "llave de brazo der", "llave de brazo izq", "estrangulacion trasera", "presiona nuca contra suelo", "tuerce dedos mano", "derribo tacleada"}
}

-- ============================================================
-- BUSCADOR + FILTROS — lógica original intacta
-- ============================================================
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBar.Text:lower()
    for _, c in pairs(Scroll:GetChildren()) do
        if c:IsA("Frame") then
            c.Visible = (q == "" or c.Name:lower():find(q)) and true or false
        end
    end
end)

ClearSearch.MouseButton1Click:Connect(function()
    SearchBar.Text = ""
end)

for cat, lista in pairs(database) do
    for _, v in pairs(lista) do
        crearBloque(v, cat == "🥋")
    end
end

-- ============================================================
-- BOTONES DE CATEGORÍA — barra lateral renovada
-- ============================================================
local emos = {"👤", "🥷", "🛡️", "🚗", "💎", "🥋"}

-- Contenedor de la barra lateral
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 52, 0, #emos * 50)
Sidebar.Position = UDim2.new(0, 8, 0, 46)
Sidebar.BackgroundColor3 = C.surface
Sidebar.BorderSizePixel  = 0
corner(Sidebar, 8)
stroke(Sidebar, C.border, 1, 0.5)

local sideLayout = Instance.new("UIListLayout", Sidebar)
sideLayout.Padding = UDim.new(0, 2)
local sidePad = Instance.new("UIPadding", Sidebar)
sidePad.PaddingTop = UDim.new(0, 4)
sidePad.PaddingBottom = UDim.new(0, 4)
sidePad.PaddingLeft = UDim.new(0, 4)
sidePad.PaddingRight = UDim.new(0, 4)

for i, emo in ipairs(emos) do
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 44)
    b.Text = emo
    b.TextSize = 22
    b.BackgroundColor3 = C.surfaceAlt
    b.BorderSizePixel  = 0
    corner(b, 6)

    -- Tooltip lateral
    local tip = Instance.new("TextLabel", b)
    tip.Size = UDim2.new(0, 0, 0, 20)
    tip.Position = UDim2.new(1, 6, 0.5, -10)
    tip.BackgroundColor3 = C.surface
    tip.TextColor3 = C.textAccent
    tip.TextSize = 9
    tip.Font = Enum.Font.GothamBold
    tip.Text = emo
    tip.BackgroundTransparency = 0.1
    tip.Visible = false
    corner(tip, 4)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundColor3 = C.panel})
        tw(b, {TextTransparency = 0})
    end)
    b.MouseLeave:Connect(function()
        tw(b, {BackgroundColor3 = C.surfaceAlt})
    end)

    b.MouseButton1Click:Connect(function()
        -- Flash de selección
        tw(b, {BackgroundColor3 = C.accentDim}, TI_fast)
        task.delay(0.15, function() tw(b, {BackgroundColor3 = C.surfaceAlt}) end)

        SearchBar.Text = ""
        for _, c in pairs(Scroll:GetChildren()) do
            if c:IsA("Frame") then c.Visible = false end
        end
        for _, accion in pairs(database[emo]) do
            if Scroll:FindFirstChild(accion) then
                Scroll[accion].Visible = true
            end
        end
        -- Reset scroll al top
        Scroll.CanvasPosition = Vector2.new(0, 0)
    end)
end

-- ============================================================
-- OPEN / CLOSE con fade-in táctica
-- ============================================================
Control.MouseButton1Click:Connect(function()
    if not Main.Visible then
        Main.Visible = true
        Main.BackgroundTransparency = 1
        tw(Main, {BackgroundTransparency = 0.04}, TI_slow)
    else
        tw(Main, {BackgroundTransparency = 1}, TI_med)
        task.delay(0.22, function() Main.Visible = false end)
    end
end)

