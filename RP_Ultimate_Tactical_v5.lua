-- ============================================================
--  RP ULTIMATE FULL  |  TACTICAL EDITION  v5.0
--  Autos: sin víctima forzada, conductor OPCIONAL, diagrama de auto
--  Combate: campo 2v1 OPCIONAL, AR-15 breve y profesional
-- ============================================================

local TextChatService  = game:GetService("TextChatService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ============================================================
-- PALETA
-- ============================================================
local C = {
    bg         = Color3.fromRGB(8,   10,  12),
    panel      = Color3.fromRGB(14,  17,  21),
    surface    = Color3.fromRGB(20,  24,  30),
    surfaceAlt = Color3.fromRGB(26,  31,  38),
    border     = Color3.fromRGB(52,  73,  94),
    accent     = Color3.fromRGB(0,  188, 140),
    accentDim  = Color3.fromRGB(0,  100,  75),
    danger     = Color3.fromRGB(220,  50,  50),
    dangerDim  = Color3.fromRGB(100,  22,  22),
    combat     = Color3.fromRGB(130,  50, 230),
    combatDim  = Color3.fromRGB(65,   20, 120),
    aim        = Color3.fromRGB(20,   70,  50),
    aimHover   = Color3.fromRGB(0,   140, 100),
    shoot      = Color3.fromRGB(90,   18,  18),
    shootHover = Color3.fromRGB(190,  40,  40),
    medical    = Color3.fromRGB(180,  30,  60),
    medicalDim = Color3.fromRGB(80,   10,  25),
    medHover   = Color3.fromRGB(220,  60,  90),
    signal     = Color3.fromRGB(200, 140,   0),
    signalDim  = Color3.fromRGB(90,   60,   0),
    signalHov  = Color3.fromRGB(240, 170,  20),
    script_c   = Color3.fromRGB(0,   120, 200),
    scriptDim  = Color3.fromRGB(0,    50, 100),
    scriptHov  = Color3.fromRGB(30,  160, 240),
    armory     = Color3.fromRGB(200, 120,  20),
    armoryDim  = Color3.fromRGB(80,   45,   8),
    armoryHov  = Color3.fromRGB(240, 160,  40),
    dot        = Color3.fromRGB(255,  60,  60),   -- punto en diagrama
    textPrime  = Color3.fromRGB(220, 230, 240),
    textDim    = Color3.fromRGB(100, 120, 145),
    textAccent = Color3.fromRGB(0,   210, 160),
    lock_on    = Color3.fromRGB(0,   210, 100),
    lock_off   = Color3.fromRGB(220,  50,  50),
}

local TI_fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_med  = TweenInfo.new(0.22, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_slow = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local function tw(o, p, i) TweenService:Create(o, i or TI_fast, p):Play() end

local function corner(p, px)
    local u = Instance.new("UICorner", p); u.CornerRadius = UDim.new(0, px or 4); return u
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.border; s.Thickness = th or 1; s.Transparency = tr or 0; return s
end

local function hoverBtn(btn, n, h)
    btn.MouseEnter:Connect(function()        tw(btn,{BackgroundColor3=h}) end)
    btn.MouseLeave:Connect(function()        tw(btn,{BackgroundColor3=n}) end)
    btn.MouseButton1Down:Connect(function()  tw(btn,{BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.82}) end)
    btn.MouseButton1Up:Connect(function()    tw(btn,{BackgroundColor3=h,BackgroundTransparency=0}) end)
end

local function mkInput(parent, sz, pos, ph)
    local tb = Instance.new("TextBox", parent)
    tb.Size=sz; tb.Position=pos; tb.BackgroundColor3=C.surface; tb.BorderSizePixel=0
    tb.PlaceholderText=ph; tb.PlaceholderColor3=C.textDim; tb.Text=""
    tb.TextColor3=C.textAccent; tb.TextSize=11; tb.Font=Enum.Font.GothamSemibold
    tb.ClearTextOnFocus=false
    corner(tb,6); stroke(tb,C.accentDim,1,0.3)
    tb.Focused:Connect(function()   tw(tb,{BackgroundColor3=Color3.fromRGB(14,26,22)}) end)
    tb.FocusLost:Connect(function() tw(tb,{BackgroundColor3=C.surface}) end)
    return tb
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local SG = Instance.new("ScreenGui")
SG.Parent          = game:GetService("CoreGui")
SG.Name            = "RP_Ultimate_Full"
SG.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
SG.ResetOnSpawn    = false
SG.IgnoreGuiInset  = true   -- evita desplazamiento accidental

-- ============================================================
-- MAPA DE POSICIONES CORPORALES (X%, Y% sobre el diagrama)
-- Diagrama: 60×140 px  — coords normalizadas 0-1
-- ============================================================
local bodyMap = {
    -- CABEZA
    ["frente"]              = {0.50, 0.04},
    ["sien derecha"]        = {0.34, 0.05},
    ["sien izquierda"]      = {0.66, 0.05},
    ["ojo derecho"]         = {0.40, 0.07},
    ["ojo izquierdo"]       = {0.60, 0.07},
    ["tabique nasal"]       = {0.50, 0.09},
    ["mejilla der"]         = {0.38, 0.10},
    ["mejilla izq"]         = {0.62, 0.10},
    ["pómulo der"]          = {0.37, 0.08},
    ["pómulo izq"]          = {0.63, 0.08},
    ["mandíbula"]           = {0.50, 0.13},
    ["labio superior"]      = {0.50, 0.11},
    ["labio inferior"]      = {0.50, 0.12},
    ["barbilla"]            = {0.50, 0.14},
    ["oreja der"]           = {0.31, 0.09},
    ["oreja izq"]           = {0.69, 0.09},
    ["arco superciliar der"]= {0.40, 0.06},
    ["arco superciliar izq"]= {0.60, 0.06},
    ["nuca"]                = {0.50, 0.08},
    ["nuez de adán"]        = {0.50, 0.17},
    ["tráquea"]             = {0.50, 0.18},
    ["cuello frontal"]      = {0.50, 0.16},
    ["cuello lateral der"]  = {0.40, 0.17},
    ["cuello lateral izq"]  = {0.60, 0.17},
    -- TORSO SUPERIOR
    ["clavícula der"]       = {0.37, 0.22},
    ["clavícula izq"]       = {0.63, 0.22},
    ["hombro derecho"]      = {0.27, 0.24},
    ["hombro izquierdo"]    = {0.73, 0.24},
    ["pecho superior"]      = {0.50, 0.26},
    ["pecho inferior"]      = {0.50, 0.31},
    ["esternón"]            = {0.50, 0.28},
    ["escápula der"]        = {0.35, 0.27},
    ["escápula izq"]        = {0.65, 0.27},
    ["placa pectoral chaleco"] = {0.50, 0.27},
    ["placa dorsal chaleco"]   = {0.50, 0.27},
    -- TORSO MEDIO/BAJO
    ["abdomen"]             = {0.50, 0.36},
    ["ombligo"]             = {0.50, 0.38},
    ["zona lumbar"]         = {0.50, 0.40},
    ["sacro"]               = {0.50, 0.43},
    ["ingle"]               = {0.50, 0.46},
    ["costilla flotante der"]= {0.38, 0.35},
    ["costilla flotante izq"]= {0.62, 0.35},
    -- BRAZOS
    ["brazo derecho"]       = {0.22, 0.31},
    ["brazo izquierdo"]     = {0.78, 0.31},
    ["bíceps der"]          = {0.21, 0.30},
    ["bíceps izq"]          = {0.79, 0.30},
    ["tríceps der"]         = {0.20, 0.32},
    ["tríceps izq"]         = {0.80, 0.32},
    ["codo derecho"]        = {0.19, 0.36},
    ["codo izquierdo"]      = {0.81, 0.36},
    ["antebrazo derecho"]   = {0.17, 0.40},
    ["antebrazo izquierdo"] = {0.83, 0.40},
    ["muñeca derecha"]      = {0.15, 0.44},
    ["muñeca izquierda"]    = {0.85, 0.44},
    ["mano derecha"]        = {0.14, 0.48},
    ["mano izquierda"]      = {0.86, 0.48},
    ["dedos mano der"]      = {0.13, 0.51},
    ["dedos mano izq"]      = {0.87, 0.51},
    -- PIERNAS
    ["muslo derecho"]       = {0.41, 0.54},
    ["muslo izquierdo"]     = {0.59, 0.54},
    ["cuádriceps der"]      = {0.40, 0.56},
    ["cuádriceps izq"]      = {0.60, 0.56},
    ["isquiotibial der"]    = {0.41, 0.58},
    ["isquiotibial izq"]    = {0.59, 0.58},
    ["rodilla derecha"]     = {0.41, 0.64},
    ["rodilla izquierda"]   = {0.59, 0.64},
    ["pantorrilla derecha"] = {0.40, 0.72},
    ["pantorrilla izquierda"]= {0.60, 0.72},
    ["tobillo derecho"]     = {0.40, 0.80},
    ["tobillo izquierdo"]   = {0.60, 0.80},
    ["pie derecho"]         = {0.39, 0.86},
    ["pie izquierdo"]       = {0.61, 0.86},
    -- PROTECCIONES (aproximadas)
    ["kevlar lateral der"]  = {0.33, 0.33},
    ["kevlar lateral izq"]  = {0.67, 0.33},
    ["axila derecha"]       = {0.30, 0.28},
    ["axila izquierda"]     = {0.70, 0.28},
    ["casco (visera)"]      = {0.50, 0.03},
    ["casco (nuca)"]        = {0.50, 0.06},
    ["casco (lateral)"]     = {0.36, 0.05},
    ["rodillera der"]       = {0.41, 0.64},
    ["rodillera izq"]       = {0.59, 0.64},
    ["codiera der"]         = {0.19, 0.36},
    ["codiera izq"]         = {0.81, 0.36},
}
-- Para zonas sin mapeo exacto usamos centro por defecto
local DEFAULT_DOT = {0.50, 0.30}

-- ============================================================
-- LÓGICA DE CHAT
-- ============================================================
local function EnviarAlChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    else
        local ok, rs = pcall(function()
            return game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents
                .SayMessageRequest
        end)
        if ok then rs:FireServer(msg, "All") end
    end
end

-- ============================================================
-- 1. BOTÓN FLOTANTE
-- ============================================================
local Control = Instance.new("TextButton", SG)
Control.Size             = UDim2.new(0,46,0,46)
Control.Position         = UDim2.new(0,14,0,200)
Control.BackgroundColor3 = C.surface
Control.Text             = "RP"
Control.TextColor3       = C.textAccent
Control.TextSize         = 13
Control.Font             = Enum.Font.GothamBold
Control.Draggable        = true
Control.BorderSizePixel  = 0
corner(Control, 9)
stroke(Control, C.accent, 1.5, 0.15)
hoverBtn(Control, C.surface, C.surfaceAlt)

-- Punto de estado candado
local LockDot = Instance.new("Frame", Control)
LockDot.Size             = UDim2.new(0,10,0,10)
LockDot.Position         = UDim2.new(1,-7,0,-3)
LockDot.BackgroundColor3 = C.lock_on
LockDot.BorderSizePixel  = 0
corner(LockDot, 5)

-- Icono de candado sobre el botón flotante
local LockIcon = Instance.new("TextLabel", Control)
LockIcon.Size             = UDim2.new(0,14,0,14)
LockIcon.Position         = UDim2.new(0,-4,1,-10)
LockIcon.BackgroundTransparency = 1
LockIcon.Text             = "🔓"
LockIcon.TextSize         = 10
LockIcon.Font             = Enum.Font.GothamBold
LockIcon.TextColor3       = C.lock_on

local ctrlMovible = true
Control.MouseButton2Click:Connect(function()
    ctrlMovible           = not ctrlMovible
    Control.Draggable     = ctrlMovible
    local col             = ctrlMovible and C.lock_on or C.lock_off
    tw(LockDot,  {BackgroundColor3 = col}, TI_med)
    tw(LockIcon, {TextColor3       = col}, TI_med)
    LockIcon.Text = ctrlMovible and "🔓" or "🔒"
end)

-- ============================================================
-- 2. MAIN FRAME  (ClipsDescendants = true para minimizar)
-- ============================================================
local FULL_H = 400
local MINI_H = 38

local Main = Instance.new("Frame", SG)
Main.Size                 = UDim2.new(0,500,0,FULL_H)
Main.Position             = UDim2.new(0.5,-250,0.5,-200)
Main.BackgroundColor3     = C.bg
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel      = 0
Main.Visible              = false
Main.Active               = true
Main.Draggable            = true
Main.ClipsDescendants     = true   -- ← clave para minimizar correcto
corner(Main, 10)
stroke(Main, C.border, 1.5, 0.08)

-- ── BARRA TÍTULO ──────────────────────────────────────────
local TBar = Instance.new("Frame", Main)
TBar.Size             = UDim2.new(1,0,0,MINI_H)
TBar.BackgroundColor3 = C.surface
TBar.BorderSizePixel  = 0
corner(TBar, 10)
local tbFix = Instance.new("Frame", TBar)
tbFix.Size=UDim2.new(1,0,0.5,0); tbFix.Position=UDim2.new(0,0,0.5,0)
tbFix.BackgroundColor3=C.surface; tbFix.BorderSizePixel=0

local TTitle = Instance.new("TextLabel", TBar)
TTitle.Size=UDim2.new(1,-140,1,0); TTitle.Position=UDim2.new(0,12,0,0)
TTitle.BackgroundTransparency=1; TTitle.Text="◈  TACTICAL RP SYSTEM  v4.0  ◈"
TTitle.TextColor3=C.textAccent; TTitle.TextSize=11; TTitle.Font=Enum.Font.GothamBold
TTitle.TextXAlignment=Enum.TextXAlignment.Left

-- Línea accent bajo la barra
local AccLine = Instance.new("Frame", Main)
AccLine.Size=UDim2.new(1,0,0,1); AccLine.Position=UDim2.new(0,0,0,MINI_H)
AccLine.BackgroundColor3=C.accent; AccLine.BackgroundTransparency=0.45; AccLine.BorderSizePixel=0

-- ── BOTONES BARRA TÍTULO ──────────────────────────────────
local function mkTitleBtn(xOff, txt, bg, tc)
    local b = Instance.new("TextButton", TBar)
    b.Size=UDim2.new(0,28,0,24); b.Position=UDim2.new(1,-xOff,0,7)
    b.Text=txt; b.TextSize=11; b.Font=Enum.Font.GothamBold
    b.BackgroundColor3=bg; b.TextColor3=tc; b.BorderSizePixel=0
    corner(b,5); return b
end

local CloseBtn = mkTitleBtn(32,  "✕",  C.dangerDim, Color3.fromRGB(255,110,110))
local MinBtn   = mkTitleBtn(64,  "▼",  C.surfaceAlt, C.textDim)
local LockBtn  = mkTitleBtn(96,  "🔓", C.surfaceAlt, C.lock_on)

hoverBtn(CloseBtn, C.dangerDim, C.danger)
hoverBtn(MinBtn,   C.surfaceAlt, C.panel)
hoverBtn(LockBtn,  C.surfaceAlt, C.panel)

CloseBtn.MouseButton1Click:Connect(function()
    tw(Main,{BackgroundTransparency=1},TI_med)
    task.delay(0.22,function() Main.Visible=false end)
end)

local minimized = false
local mainMovible = true

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(Main,{Size=UDim2.new(0,500,0,minimized and MINI_H or FULL_H)},TI_slow)
    MinBtn.Text = minimized and "▲" or "▼"
end)

LockBtn.MouseButton1Click:Connect(function()
    mainMovible = not mainMovible
    Main.Draggable = mainMovible
    LockBtn.Text = mainMovible and "🔓" or "🔒"
    tw(LockBtn,{TextColor3 = mainMovible and C.lock_on or C.lock_off},TI_med)
end)

-- ============================================================
-- INPUTS GLOBALES
-- ============================================================
local victimaInput = mkInput(Main, UDim2.new(0,192,0,26), UDim2.new(0,68,0,46), "  👤  A QUIÉN?")
local balasInput   = mkInput(Main, UDim2.new(0,192,0,26), UDim2.new(0,268,0,46), "  🔫  CON QUÉ?")

-- ============================================================
-- BARRA DE BÚSQUEDA
-- ============================================================
local SearchBar = Instance.new("TextBox", Main)
SearchBar.Size=UDim2.new(0,310,0,26); SearchBar.Position=UDim2.new(0,68,0,80)
SearchBar.BackgroundColor3=C.surface; SearchBar.BorderSizePixel=0
SearchBar.PlaceholderText="  🔍  BUSCADOR UNIVERSAL..."
SearchBar.PlaceholderColor3=C.textDim; SearchBar.Text=""
SearchBar.TextColor3=C.textPrime; SearchBar.TextSize=11; SearchBar.Font=Enum.Font.Gotham
SearchBar.ClearTextOnFocus=false
corner(SearchBar,6); stroke(SearchBar,C.border,1,0.4)

local ClearBtn = Instance.new("TextButton", Main)
ClearBtn.Size=UDim2.new(0,62,0,26); ClearBtn.Position=UDim2.new(0,384,0,80)
ClearBtn.Text="✕ LIMPIAR"; ClearBtn.TextSize=9; ClearBtn.Font=Enum.Font.GothamBold
ClearBtn.BackgroundColor3=C.dangerDim; ClearBtn.TextColor3=Color3.fromRGB(255,120,120)
ClearBtn.BorderSizePixel=0; corner(ClearBtn,6)
hoverBtn(ClearBtn,C.dangerDim,C.danger)
ClearBtn.MouseButton1Click:Connect(function() SearchBar.Text="" end)

-- ============================================================
-- SCROLL PRINCIPAL
-- ============================================================
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size=UDim2.new(0,400,0,256); Scroll.Position=UDim2.new(0,68,0,114)
Scroll.BackgroundColor3=C.panel; Scroll.BorderSizePixel=0
Scroll.CanvasSize=UDim2.new(0,0,0,0)   -- auto-calculado con UIListLayout
Scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Scroll.ScrollBarThickness=3; Scroll.ScrollBarImageColor3=C.accent
Scroll.ScrollingDirection=Enum.ScrollingDirection.Y
corner(Scroll,8)
local scLay=Instance.new("UIListLayout",Scroll); scLay.Padding=UDim.new(0,6)
scLay.SortOrder=Enum.SortOrder.LayoutOrder
local scPad=Instance.new("UIPadding",Scroll)
scPad.PaddingLeft=UDim.new(0,5); scPad.PaddingRight=UDim.new(0,5)
scPad.PaddingTop=UDim.new(0,5); scPad.PaddingBottom=UDim.new(0,5)

-- ============================================================
-- PROCESAR ACCIÓN
-- ============================================================
local function Procesar(parte, tipo, extraVic, extraBal)
    -- extraVic y extraBal son strings opcionales pasados por bloque
    local vic = (extraVic and extraVic ~= "") and extraVic
               or (victimaInput.Text ~= "" and victimaInput.Text or "objetivo")
    local bal = balasInput.Text ~= "" and balasInput.Text or "munición"
    local verbos = {"Dispara","Percuta","Acciona","Detona","Descarga","Abre fuego con"}
    if tipo=="apuntar" then
        EnviarAlChat("-apunta a " .. parte .. " de " .. vic .. "-")
    elseif tipo=="disparar" then
        EnviarAlChat("-" .. verbos[math.random(#verbos)] .. " 1 bala (" .. bal .. ") al " .. parte .. " de " .. vic .. "-")
    elseif tipo=="vehiculo_apuntar" then
        -- sin víctima forzada; conductor OPCIONAL
        local cond = (extraVic and extraVic ~= "") and (" del vehículo de "..extraVic) or ""
        EnviarAlChat("-apunta a la " .. parte .. cond .. "-")
    elseif tipo=="vehiculo_disparar" then
        local cond = (extraVic and extraVic ~= "") and (" del vehículo de "..extraVic) or ""
        EnviarAlChat("-" .. verbos[math.random(#verbos)] .. " 1 bala (" .. bal .. ") en la " .. parte .. cond .. "-")
    elseif tipo=="combate" then
        -- 2v1: extraVic = nombre del que se mete (opcional)
        local sufijo = (extraVic and extraVic ~= "") and (" [interviene "..extraVic.."]") or ""
        EnviarAlChat("-" .. parte .. " de " .. vic .. sufijo .. "-")
    else
        EnviarAlChat("-" .. parte .. " de " .. vic .. "-")
    end
end

-- ============================================================
-- DIAGRAMAS: CUERPO y AUTO
-- Panel único con dos vistas intercambiables
-- ============================================================
local DiagramPanel = Instance.new("Frame", Main)
DiagramPanel.Size=UDim2.new(0,96,0,186); DiagramPanel.Position=UDim2.new(1,-100,0,46)
DiagramPanel.BackgroundColor3=C.panel; DiagramPanel.BorderSizePixel=0; DiagramPanel.Visible=false
corner(DiagramPanel,8); stroke(DiagramPanel,C.border,1,0.4)

local DiagZoneTxt = Instance.new("TextLabel", DiagramPanel)
DiagZoneTxt.Size=UDim2.new(1,-4,0,14); DiagZoneTxt.Position=UDim2.new(0,2,1,-16)
DiagZoneTxt.BackgroundTransparency=1; DiagZoneTxt.TextWrapped=true
DiagZoneTxt.Text=""; DiagZoneTxt.TextColor3=C.dot; DiagZoneTxt.TextSize=7
DiagZoneTxt.Font=Enum.Font.GothamBold; DiagZoneTxt.TextXAlignment=Enum.TextXAlignment.Center

-- ── VISTA CUERPO ──────────────────────────────────────────
local BodyView = Instance.new("Frame", DiagramPanel)
BodyView.Size=UDim2.new(1,0,1,-16); BodyView.BackgroundTransparency=1; BodyView.BorderSizePixel=0

local function mkSil(parent,x,y,w,h,col)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(0,w,0,h); f.Position=UDim2.new(0,x,0,y)
    f.BackgroundColor3=col or C.surfaceAlt; f.BorderSizePixel=0; corner(f,3); return f
end
mkSil(BodyView,31,12,30,28,Color3.fromRGB(40,48,58))   -- cabeza
mkSil(BodyView,39,40,14,8, Color3.fromRGB(35,42,52))   -- cuello
mkSil(BodyView,22,48,48,54,Color3.fromRGB(40,48,58))   -- torso
mkSil(BodyView, 9,48,13,46,Color3.fromRGB(36,44,54))   -- brazo izq
mkSil(BodyView,70,48,13,46,Color3.fromRGB(36,44,54))   -- brazo der
mkSil(BodyView,22,102,21,66,Color3.fromRGB(40,48,58))  -- pierna izq
mkSil(BodyView,49,102,21,66,Color3.fromRGB(40,48,58))  -- pierna der

-- Punto corporal
local BodyDot  = Instance.new("Frame",BodyView)
BodyDot.Size=UDim2.new(0,9,0,9); BodyDot.BackgroundColor3=C.dot
BodyDot.BorderSizePixel=0; BodyDot.ZIndex=10; corner(BodyDot,5)
local BodyRing = Instance.new("Frame",BodyView)
BodyRing.Size=UDim2.new(0,15,0,15); BodyRing.BackgroundTransparency=1
BodyRing.BorderSizePixel=0; BodyRing.ZIndex=9; corner(BodyRing,8)
local bRS=Instance.new("UIStroke",BodyRing)
bRS.Color=C.dot; bRS.Thickness=1.5; bRS.Transparency=0.3

-- ── VISTA AUTO ────────────────────────────────────────────
-- Diagrama top-view de auto con frames
local CarView = Instance.new("Frame", DiagramPanel)
CarView.Size=UDim2.new(1,0,1,-16); CarView.BackgroundTransparency=1
CarView.BorderSizePixel=0; CarView.Visible=false

local function mkCar(parent,x,y,w,h,col,rad)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(0,w,0,h); f.Position=UDim2.new(0,x,0,y)
    f.BackgroundColor3=col; f.BorderSizePixel=0; corner(f,rad or 3); return f
end
-- Carrocería principal (top view)
mkCar(CarView,18, 8,56,148,Color3.fromRGB(38,46,56),8)   -- cuerpo
mkCar(CarView,24,18,44, 40,Color3.fromRGB(28,36,46),4)   -- parabrisas / capó
mkCar(CarView,24,108,44,30,Color3.fromRGB(28,36,46),4)   -- medallón / cajuela
-- Ruedas
mkCar(CarView, 4, 14,14,24,Color3.fromRGB(22,28,36),5)   -- rueda del izq
mkCar(CarView,74, 14,14,24,Color3.fromRGB(22,28,36),5)   -- rueda del der
mkCar(CarView, 4,116,14,24,Color3.fromRGB(22,28,36),5)   -- rueda tras izq
mkCar(CarView,74,116,14,24,Color3.fromRGB(22,28,36),5)   -- rueda tras der
-- Línea central del auto
mkCar(CarView,45, 8, 2,148,Color3.fromRGB(50,60,72),0)   -- eje central

-- Punto auto
local CarDot  = Instance.new("Frame",CarView)
CarDot.Size=UDim2.new(0,9,0,9); CarDot.BackgroundColor3=C.dot
CarDot.BorderSizePixel=0; CarDot.ZIndex=10; corner(CarDot,5)
local CarRing = Instance.new("Frame",CarView)
CarRing.Size=UDim2.new(0,15,0,15); CarRing.BackgroundTransparency=1
CarRing.BorderSizePixel=0; CarRing.ZIndex=9; corner(CarRing,8)
local cRS=Instance.new("UIStroke",CarRing)
cRS.Color=C.dot; cRS.Thickness=1.5; cRS.Transparency=0.3

-- Mapa posiciones auto (top-view, 92×170 canvas del CarView)
local carMap = {
    ["llanta del der"]      = {0.86, 0.14},
    ["llanta del izq"]      = {0.10, 0.14},
    ["llanta tras der"]     = {0.86, 0.78},
    ["llanta tras izq"]     = {0.10, 0.78},
    ["motor"]               = {0.50, 0.20},
    ["radiador"]            = {0.50, 0.10},
    ["batería"]             = {0.38, 0.22},
    ["alternador"]          = {0.62, 0.22},
    ["tanque de gas"]       = {0.50, 0.82},
    ["parabrisas"]          = {0.50, 0.28},
    ["medallón trasero"]    = {0.50, 0.76},
    ["ventanilla cond"]     = {0.22, 0.48},
    ["ventanilla copiloto"] = {0.78, 0.48},
    ["pilar A"]             = {0.22, 0.34},
    ["pilar B"]             = {0.22, 0.56},
    ["bloque motor"]        = {0.50, 0.18},
    ["manguera frenos"]     = {0.38, 0.62},
    ["disco de freno"]      = {0.12, 0.72},
    ["amortiguador"]        = {0.12, 0.28},
    ["faro delantero der"]  = {0.78, 0.08},
    ["faro delantero izq"]  = {0.22, 0.08},
    ["calavera trasera"]    = {0.50, 0.88},
    ["capó"]                = {0.50, 0.16},
    ["cajuela"]             = {0.50, 0.84},
    ["espejo retrovisor"]   = {0.18, 0.44},
    ["palanca de cambios"]  = {0.50, 0.52},
    ["volante"]             = {0.34, 0.42},
    ["pedal de freno"]      = {0.38, 0.50},
    ["asiento del conductor"]= {0.30, 0.46},
    ["cristal blindado N3"] = {0.50, 0.32},
    ["puerta blindada"]     = {0.15, 0.52},
    ["junta de puerta"]     = {0.18, 0.52},
    ["bisagra superior"]    = {0.18, 0.38},
    ["bisagra inferior"]    = {0.18, 0.62},
    ["mirilla táctica"]     = {0.22, 0.46},
    ["motor parte baja"]    = {0.50, 0.24},
    ["neumático run-flat"]  = {0.10, 0.14},
    ["placa de piso antiexplosión"]={0.50, 0.54},
    ["turret (base)"]       = {0.50, 0.50},
    ["turret (cañón)"]      = {0.50, 0.40},
    ["escotilla superior"]  = {0.50, 0.50},
}
local DEFAULT_CAR = {0.50, 0.50}

local function showDiagram(zona, esAuto)
    local W,H = 92,170
    if esAuto then
        BodyView.Visible=false; CarView.Visible=true
        local coord = carMap[zona:lower()] or DEFAULT_CAR
        local px,py = coord[1],coord[2]
        CarDot.Position  = UDim2.new(0,math.floor(px*W)-4,0,math.floor(py*H)-4)
        CarRing.Position = UDim2.new(0,math.floor(px*W)-7,0,math.floor(py*H)-7)
    else
        CarView.Visible=false; BodyView.Visible=true
        local coord = bodyMap[zona:lower()] or DEFAULT_DOT
        local px,py = coord[1],coord[2]
        BodyDot.Position  = UDim2.new(0,math.floor(px*W)-4,0,math.floor(py*H)-4)
        BodyRing.Position = UDim2.new(0,math.floor(px*W)-7,0,math.floor(py*H)-7)
    end
    DiagZoneTxt.Text = zona:upper()
    DiagramPanel.Visible = true
end

local function hideDiagram()
    DiagramPanel.Visible = false
end

-- ============================================================
-- CREADOR DE BLOQUES
-- ============================================================
local layoutOrder = 0

-- categorías de vehículo
local catVehiculo = {["🚗"]=true,["💎"]=true}

local function crearBloque(texto, tipo, catKey)
    layoutOrder = layoutOrder + 1
    local esCombate = (tipo=="combate")
    local isMedical = (tipo=="medical")
    local isSignal  = (tipo=="signal")
    local isVeh     = (tipo=="vehiculo")
    local esAuto    = isVeh  -- para diagrama

    local hdrCol =
        (esCombate and C.combat)   or
        (isMedical and C.medical)  or
        (isSignal  and C.signal)   or
        (isVeh     and Color3.fromRGB(80,140,200)) or
        C.accent

    -- Altura: vehículo y combate necesitan campo extra → más alto
    local blkH = (isVeh or esCombate) and 108 or 82

    local f = Instance.new("Frame", Scroll)
    f.Size=UDim2.new(1,-2,0,blkH); f.BackgroundColor3=C.surfaceAlt
    f.BorderSizePixel=0; f.Name=texto; f.LayoutOrder=layoutOrder
    corner(f,7); stroke(f,C.border,1,0.55)

    f.MouseEnter:Connect(function() showDiagram(texto, esAuto) end)
    f.MouseLeave:Connect(function() hideDiagram() end)

    -- Header
    local hdr=Instance.new("Frame",f)
    hdr.Size=UDim2.new(1,0,0,24); hdr.BackgroundColor3=C.surface; hdr.BorderSizePixel=0
    corner(hdr,7)
    local hFix=Instance.new("Frame",hdr); hFix.Size=UDim2.new(1,0,0.5,0)
    hFix.Position=UDim2.new(0,0,0.5,0); hFix.BackgroundColor3=C.surface; hFix.BorderSizePixel=0
    local ind=Instance.new("Frame",hdr); ind.Size=UDim2.new(0,3,1,0)
    ind.BackgroundColor3=hdrCol; ind.BorderSizePixel=0; corner(ind,3)
    local lbl=Instance.new("TextLabel",hdr)
    lbl.Size=UDim2.new(1,-12,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=texto:upper()
    lbl.TextColor3=hdrCol; lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextTruncate=Enum.TextTruncate.AtEnd

    -- ── BLOQUE VEHÍCULO ──────────────────────────────────────
    if isVeh then
        -- Campo opcional: nombre del conductor
        local condInput=Instance.new("TextBox",f)
        condInput.Size=UDim2.new(1,-6,0,20); condInput.Position=UDim2.new(0,3,0,26)
        condInput.BackgroundColor3=C.surface; condInput.BorderSizePixel=0
        condInput.PlaceholderText="  🚗 Conductor (opcional)"
        condInput.PlaceholderColor3=C.textDim; condInput.Text=""
        condInput.TextColor3=Color3.fromRGB(100,180,255); condInput.TextSize=9
        condInput.Font=Enum.Font.Gotham; condInput.ClearTextOnFocus=false
        corner(condInput,5); stroke(condInput,Color3.fromRGB(40,80,130),1,0.4)
        condInput.Focused:Connect(function()   tw(condInput,{BackgroundColor3=Color3.fromRGB(12,22,38)}) end)
        condInput.FocusLost:Connect(function() tw(condInput,{BackgroundColor3=C.surface}) end)

        local b1=Instance.new("TextButton",f)
        b1.Size=UDim2.new(0.5,-4,0,52); b1.Position=UDim2.new(0,2,0,50)
        b1.Text="🎯  APUNTAR"; b1.TextSize=10; b1.Font=Enum.Font.GothamSemibold
        b1.BackgroundColor3=C.aim; b1.TextColor3=Color3.fromRGB(140,255,200); b1.BorderSizePixel=0
        corner(b1,6); hoverBtn(b1,C.aim,C.aimHover)
        b1.MouseButton1Click:Connect(function()
            Procesar(texto,"vehiculo_apuntar",condInput.Text)
        end)

        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.new(0.5,-4,0,52); b2.Position=UDim2.new(0.5,2,0,50)
        b2.Text="💥  DISPARAR"; b2.TextSize=10; b2.Font=Enum.Font.GothamSemibold
        b2.BackgroundColor3=C.shoot; b2.TextColor3=Color3.fromRGB(255,140,140); b2.BorderSizePixel=0
        corner(b2,6); hoverBtn(b2,C.shoot,C.shootHover)
        b2.MouseButton1Click:Connect(function()
            Procesar(texto,"vehiculo_disparar",condInput.Text)
        end)

    -- ── BLOQUE COMBATE (con campo 2v1 opcional) ──────────────
    elseif esCombate then
        -- Campo opcional: quién se mete
        local meterInput=Instance.new("TextBox",f)
        meterInput.Size=UDim2.new(1,-6,0,20); meterInput.Position=UDim2.new(0,3,0,26)
        meterInput.BackgroundColor3=C.surface; meterInput.BorderSizePixel=0
        meterInput.PlaceholderText="  👊 Quién interviene (opcional)"
        meterInput.PlaceholderColor3=C.textDim; meterInput.Text=""
        meterInput.TextColor3=Color3.fromRGB(190,140,255); meterInput.TextSize=9
        meterInput.Font=Enum.Font.Gotham; meterInput.ClearTextOnFocus=false
        corner(meterInput,5); stroke(meterInput,Color3.fromRGB(80,30,120),1,0.4)
        meterInput.Focused:Connect(function()   tw(meterInput,{BackgroundColor3=Color3.fromRGB(20,10,36)}) end)
        meterInput.FocusLost:Connect(function() tw(meterInput,{BackgroundColor3=C.surface}) end)

        local b=Instance.new("TextButton",f)
        b.Size=UDim2.new(1,-4,0,52); b.Position=UDim2.new(0,2,0,50)
        b.Text="👊  EJECUTAR"; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
        b.BackgroundColor3=C.combatDim; b.TextColor3=Color3.fromRGB(190,140,255); b.BorderSizePixel=0
        corner(b,6); hoverBtn(b,C.combatDim,C.combat)
        b.MouseButton1Click:Connect(function()
            Procesar(texto,"combate",meterInput.Text)
        end)

    -- ── BLOQUES NORMALES (cuerpo, cabeza, blindaje, médico, señal) ──
    elseif isMedical then
        local b=Instance.new("TextButton",f)
        b.Size=UDim2.new(1,-4,0,50); b.Position=UDim2.new(0,2,0,28)
        b.Text="💊  APLICAR"; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
        b.BackgroundColor3=C.medicalDim; b.TextColor3=Color3.fromRGB(255,140,160); b.BorderSizePixel=0
        corner(b,6); hoverBtn(b,C.medicalDim,C.medHover)
        b.MouseButton1Click:Connect(function() Procesar(texto,"combate") end)

    elseif isSignal then
        local b=Instance.new("TextButton",f)
        b.Size=UDim2.new(1,-4,0,50); b.Position=UDim2.new(0,2,0,28)
        b.Text="🤟  SEÑALAR"; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
        b.BackgroundColor3=C.signalDim; b.TextColor3=Color3.fromRGB(255,220,100); b.BorderSizePixel=0
        corner(b,6); hoverBtn(b,C.signalDim,C.signalHov)
        b.MouseButton1Click:Connect(function() Procesar(texto,"combate") end)

    else
        -- Normal: apuntar + disparar (cuerpo, cabeza, blindaje)
        local b1=Instance.new("TextButton",f)
        b1.Size=UDim2.new(0.5,-4,0,50); b1.Position=UDim2.new(0,2,0,28)
        b1.Text="🎯  APUNTAR"; b1.TextSize=10; b1.Font=Enum.Font.GothamSemibold
        b1.BackgroundColor3=C.aim; b1.TextColor3=Color3.fromRGB(140,255,200); b1.BorderSizePixel=0
        corner(b1,6); hoverBtn(b1,C.aim,C.aimHover)
        b1.MouseButton1Click:Connect(function() Procesar(texto,"apuntar") end)
        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.new(0.5,-4,0,50); b2.Position=UDim2.new(0.5,2,0,28)
        b2.Text="💥  DISPARAR"; b2.TextSize=10; b2.Font=Enum.Font.GothamSemibold
        b2.BackgroundColor3=C.shoot; b2.TextColor3=Color3.fromRGB(255,140,140); b2.BorderSizePixel=0
        corner(b2,6); hoverBtn(b2,C.shoot,C.shootHover)
        b2.MouseButton1Click:Connect(function() Procesar(texto,"disparar") end)
    end

    return f
end

-- ============================================================
-- MINI-GUI DE TEXTO LIBRE
-- ============================================================
local function crearMiniChat(titulo, prefijo, sufijo)
    prefijo = prefijo or ""; sufijo = sufijo or ""
    local gui=Instance.new("Frame",SG)
    gui.Size=UDim2.new(0,320,0,115); gui.Position=UDim2.new(0.5,-160,1,-130)
    gui.BackgroundColor3=C.panel; gui.BorderSizePixel=0
    gui.Active=true; gui.Draggable=true; gui.Visible=true
    corner(gui,10); stroke(gui,C.script_c,1.5,0.15)

    local bar=Instance.new("Frame",gui); bar.Size=UDim2.new(1,0,0,28)
    bar.BackgroundColor3=C.surface; bar.BorderSizePixel=0; corner(bar,10)
    local bFix=Instance.new("Frame",bar); bFix.Size=UDim2.new(1,0,0.5,0)
    bFix.Position=UDim2.new(0,0,0.5,0); bFix.BackgroundColor3=C.surface; bFix.BorderSizePixel=0
    local bTit=Instance.new("TextLabel",bar)
    bTit.Size=UDim2.new(1,-32,1,0); bTit.Position=UDim2.new(0,10,0,0)
    bTit.BackgroundTransparency=1; bTit.Text="◈  "..titulo
    bTit.TextColor3=Color3.fromRGB(100,180,255); bTit.TextSize=10; bTit.Font=Enum.Font.GothamBold
    bTit.TextXAlignment=Enum.TextXAlignment.Left
    local cG=Instance.new("TextButton",bar)
    cG.Size=UDim2.new(0,22,0,20); cG.Position=UDim2.new(1,-24,0,4)
    cG.Text="✕"; cG.TextSize=11; cG.Font=Enum.Font.GothamBold
    cG.BackgroundColor3=C.dangerDim; cG.TextColor3=Color3.fromRGB(255,100,100); cG.BorderSizePixel=0
    corner(cG,4); hoverBtn(cG,C.dangerDim,C.danger)
    cG.MouseButton1Click:Connect(function()
        tw(gui,{BackgroundTransparency=1},TI_med)
        task.delay(0.22,function() gui:Destroy() end)
    end)

    local inp=Instance.new("TextBox",gui)
    inp.Size=UDim2.new(1,-10,0,40); inp.Position=UDim2.new(0,5,0,33)
    inp.BackgroundColor3=C.surface; inp.BorderSizePixel=0
    inp.PlaceholderText="  Escribe aquí..."; inp.PlaceholderColor3=C.textDim
    inp.Text=""; inp.TextColor3=C.textPrime; inp.TextSize=12; inp.Font=Enum.Font.Gotham
    inp.ClearTextOnFocus=false; inp.MultiLine=false; inp.TextXAlignment=Enum.TextXAlignment.Left
    corner(inp,6); stroke(inp,C.script_c,1,0.4)

    local snd=Instance.new("TextButton",gui)
    snd.Size=UDim2.new(1,-10,0,26); snd.Position=UDim2.new(0,5,0,78)
    snd.Text="  ➤  ENVIAR"; snd.TextSize=10; snd.Font=Enum.Font.GothamBold
    snd.BackgroundColor3=C.scriptDim; snd.TextColor3=Color3.fromRGB(100,180,255); snd.BorderSizePixel=0
    corner(snd,6); hoverBtn(snd,C.scriptDim,C.script_c)

    local function doSend()
        local msg=inp.Text
        if msg~="" then EnviarAlChat(prefijo..msg..sufijo); inp.Text="" end
    end
    snd.MouseButton1Click:Connect(doSend)
    inp.FocusLost:Connect(function(enter) if enter then doSend() end end)

    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)
end

-- bloque para categoría Scripts
local function crearBloqueScript(nombre,titulo,prefijo,sufijo)
    layoutOrder=layoutOrder+1
    local f=Instance.new("Frame",Scroll)
    f.Size=UDim2.new(1,-2,0,60); f.BackgroundColor3=C.surfaceAlt; f.BorderSizePixel=0
    f.Name=nombre; f.LayoutOrder=layoutOrder; corner(f,7); stroke(f,C.border,1,0.55)
    local ind=Instance.new("Frame",f); ind.Size=UDim2.new(0,3,1,0)
    ind.BackgroundColor3=C.script_c; ind.BorderSizePixel=0; corner(ind,3)
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,-95,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=nombre:upper()
    lbl.TextColor3=Color3.fromRGB(100,180,255); lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextWrapped=true
    local btn=Instance.new("TextButton",f)
    btn.Size=UDim2.new(0,82,0,38); btn.Position=UDim2.new(1,-86,0,11)
    btn.Text="▶ ABRIR"; btn.TextSize=9; btn.Font=Enum.Font.GothamBold
    btn.BackgroundColor3=C.scriptDim; btn.TextColor3=Color3.fromRGB(100,180,255); btn.BorderSizePixel=0
    corner(btn,6); hoverBtn(btn,C.scriptDim,C.script_c)
    btn.MouseButton1Click:Connect(function() crearMiniChat(titulo,prefijo,sufijo) end)
end

-- ============================================================
-- ARMERÍA
-- ============================================================
local armasData = {
    ["AR-15"] = {
        icon="🔫",
        pasos={
            "-saca el upper y lower del maletín-",
            "-une el upper con el lower-",
            "-inserta los pasadores delantero y trasero-",
            "-carga 30 balas 5.56mm en el cargador-",
            "-inserta el cargador en el AR-",
            "-jala la carga y suelta para chambear-",
            "-activa el seguro-",
            "-enciende la mira holográfica-",
            "-activa el láser-",
            "-coloca el silenciador (si aplica)-",
            "-extiende la culata-",
            "-desactiva el seguro antes de disparar-",
        }
    }
    -- Nuevas armas se agregan aquí siguiendo el mismo formato
}

local armaProgreso = {}

local function crearGuiArma(nombreArma, datos)
    if SG:FindFirstChild("ArmaGUI_"..nombreArma) then return end
    armaProgreso[nombreArma] = armaProgreso[nombreArma] or 0

    local gui=Instance.new("Frame",SG)
    gui.Name="ArmaGUI_"..nombreArma
    gui.Size=UDim2.new(0,360,0,440); gui.Position=UDim2.new(0.5,60,0.5,-220)
    gui.BackgroundColor3=C.panel; gui.BorderSizePixel=0
    gui.Active=true; gui.Draggable=true; gui.ClipsDescendants=true
    corner(gui,10); stroke(gui,C.armory,1.5,0.1)

    local bar=Instance.new("Frame",gui); bar.Size=UDim2.new(1,0,0,34)
    bar.BackgroundColor3=C.surface; bar.BorderSizePixel=0; corner(bar,10)
    local bFix=Instance.new("Frame",bar); bFix.Size=UDim2.new(1,0,0.5,0)
    bFix.Position=UDim2.new(0,0,0.5,0); bFix.BackgroundColor3=C.surface; bFix.BorderSizePixel=0
    local bTit=Instance.new("TextLabel",bar)
    bTit.Size=UDim2.new(1,-60,1,0); bTit.Position=UDim2.new(0,12,0,0)
    bTit.BackgroundTransparency=1; bTit.Text="🔧  ARMANDO: "..nombreArma
    bTit.TextColor3=Color3.fromRGB(255,185,80); bTit.TextSize=11; bTit.Font=Enum.Font.GothamBold
    bTit.TextXAlignment=Enum.TextXAlignment.Left
    local cA=Instance.new("TextButton",bar)
    cA.Size=UDim2.new(0,24,0,22); cA.Position=UDim2.new(1,-28,0,6)
    cA.Text="✕"; cA.TextSize=11; cA.Font=Enum.Font.GothamBold
    cA.BackgroundColor3=C.dangerDim; cA.TextColor3=Color3.fromRGB(255,100,100); cA.BorderSizePixel=0
    corner(cA,4); hoverBtn(cA,C.dangerDim,C.danger)
    cA.MouseButton1Click:Connect(function()
        tw(gui,{BackgroundTransparency=1},TI_med)
        task.delay(0.22,function() gui:Destroy() end)
    end)

    local aLine=Instance.new("Frame",gui)
    aLine.Size=UDim2.new(1,0,0,1); aLine.Position=UDim2.new(0,0,0,34)
    aLine.BackgroundColor3=C.armory; aLine.BackgroundTransparency=0.4; aLine.BorderSizePixel=0

    local pLbl=Instance.new("TextLabel",gui)
    pLbl.Size=UDim2.new(1,-12,0,18); pLbl.Position=UDim2.new(0,6,0,38)
    pLbl.BackgroundTransparency=1; pLbl.TextColor3=C.textDim; pLbl.TextSize=9; pLbl.Font=Enum.Font.Gotham
    pLbl.TextXAlignment=Enum.TextXAlignment.Left
    pLbl.Text="PASO "..armaProgreso[nombreArma].." / "..#datos.pasos

    local sc=Instance.new("ScrollingFrame",gui)
    sc.Size=UDim2.new(1,-12,0,348); sc.Position=UDim2.new(0,6,0,60)
    sc.BackgroundColor3=C.bg; sc.BorderSizePixel=0
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y; sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.ScrollBarThickness=3; sc.ScrollBarImageColor3=C.armory
    corner(sc,8)
    local scL=Instance.new("UIListLayout",sc); scL.Padding=UDim.new(0,5)
    local scP=Instance.new("UIPadding",sc)
    scP.PaddingLeft=UDim.new(0,5); scP.PaddingRight=UDim.new(0,5); scP.PaddingTop=UDim.new(0,5)

    local resetBtn=Instance.new("TextButton",gui)
    resetBtn.Size=UDim2.new(1,-12,0,22); resetBtn.Position=UDim2.new(0,6,1,-28)
    resetBtn.Text="↺  REINICIAR PROTOCOLO"; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold
    resetBtn.BackgroundColor3=C.armoryDim; resetBtn.TextColor3=Color3.fromRGB(255,185,80)
    resetBtn.BorderSizePixel=0; corner(resetBtn,6); hoverBtn(resetBtn,C.armoryDim,C.armory)

    local pasoBtns={}
    for i, paso in ipairs(datos.pasos) do
        local row=Instance.new("Frame",sc)
        row.Size=UDim2.new(1,-2,0,52); row.BackgroundColor3=C.surfaceAlt; row.BorderSizePixel=0
        corner(row,6); stroke(row,C.border,1,0.6)

        local nLbl=Instance.new("TextLabel",row)
        nLbl.Size=UDim2.new(0,22,0,22); nLbl.Position=UDim2.new(0,4,0,4)
        nLbl.BackgroundColor3=C.armoryDim; nLbl.TextColor3=C.armory
        nLbl.Text=tostring(i); nLbl.TextSize=10; nLbl.Font=Enum.Font.GothamBold
        nLbl.BackgroundTransparency=0; nLbl.BorderSizePixel=0; corner(nLbl,4)

        local pLblR=Instance.new("TextLabel",row)
        pLblR.Size=UDim2.new(1,-94,0,44); pLblR.Position=UDim2.new(0,30,0,4)
        pLblR.BackgroundTransparency=1; pLblR.TextWrapped=true
        pLblR.Text=paso; pLblR.TextColor3=C.textPrime
        pLblR.TextSize=8; pLblR.Font=Enum.Font.Gotham
        pLblR.TextXAlignment=Enum.TextXAlignment.Left; pLblR.TextYAlignment=Enum.TextYAlignment.Top

        local eBtn=Instance.new("TextButton",row)
        eBtn.Size=UDim2.new(0,58,0,38); eBtn.Position=UDim2.new(1,-62,0,7)
        eBtn.TextSize=9; eBtn.Font=Enum.Font.GothamBold; eBtn.BorderSizePixel=0; corner(eBtn,5)

        local done = i <= armaProgreso[nombreArma]
        if done then
            eBtn.Text="✓ HECHO"; eBtn.BackgroundColor3=C.accentDim; eBtn.TextColor3=C.accent
        else
            eBtn.Text="▶ HACER"; eBtn.BackgroundColor3=C.armoryDim; eBtn.TextColor3=Color3.fromRGB(255,185,80)
            hoverBtn(eBtn,C.armoryDim,C.armory)
        end
        pasoBtns[i]={btn=eBtn,lbl=pLblR,done=done}

        local idx=i
        eBtn.MouseButton1Click:Connect(function()
            if idx~=armaProgreso[nombreArma]+1 then
                tw(eBtn,{BackgroundColor3=C.danger},TI_fast)
                task.delay(0.22,function() tw(eBtn,{BackgroundColor3=C.armoryDim},TI_fast) end)
                return
            end
            EnviarAlChat(paso)
            armaProgreso[nombreArma]=armaProgreso[nombreArma]+1
            tw(eBtn,{BackgroundColor3=C.accentDim},TI_med)
            eBtn.Text="✓ HECHO"
            tw(eBtn,{TextColor3=C.accent},TI_med)
            tw(pLblR,{TextColor3=C.textDim},TI_med)
            pasoBtns[idx].done=true
            pLbl.Text="PASO "..armaProgreso[nombreArma].." / "..#datos.pasos
        end)
    end

    resetBtn.MouseButton1Click:Connect(function()
        armaProgreso[nombreArma]=0
        pLbl.Text="PASO 0 / "..#datos.pasos
        for i,d in ipairs(pasoBtns) do
            d.btn.Text="▶ HACER"
            tw(d.btn,{BackgroundColor3=C.armoryDim},TI_fast)
            tw(d.btn,{TextColor3=Color3.fromRGB(255,185,80)},TI_fast)
            tw(d.lbl,{TextColor3=C.textPrime},TI_fast)
            d.done=false
        end
    end)

    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)
end

local function crearBloqueArma(nombreArma, datos)
    layoutOrder=layoutOrder+1
    local f=Instance.new("Frame",Scroll)
    f.Size=UDim2.new(1,-2,0,64); f.BackgroundColor3=C.surfaceAlt; f.BorderSizePixel=0
    f.Name=nombreArma; f.LayoutOrder=layoutOrder; corner(f,7); stroke(f,C.border,1,0.55)
    local ind=Instance.new("Frame",f); ind.Size=UDim2.new(0,3,1,0)
    ind.BackgroundColor3=C.armory; ind.BorderSizePixel=0; corner(ind,3)
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,-110,0,26); lbl.Position=UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency=1; lbl.Text=datos.icon.."  "..nombreArma:upper()
    lbl.TextColor3=Color3.fromRGB(255,185,80); lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local sub=Instance.new("TextLabel",f)
    sub.Size=UDim2.new(1,-110,0,16); sub.Position=UDim2.new(0,10,0,34)
    sub.BackgroundTransparency=1; sub.Text=#datos.pasos.." pasos de ensamblaje"
    sub.TextColor3=C.textDim; sub.TextSize=8; sub.Font=Enum.Font.Gotham
    sub.TextXAlignment=Enum.TextXAlignment.Left
    local btn=Instance.new("TextButton",f)
    btn.Size=UDim2.new(0,94,0,42); btn.Position=UDim2.new(1,-98,0,11)
    btn.Text="🔧 ARMAR"; btn.TextSize=9; btn.Font=Enum.Font.GothamBold
    btn.BackgroundColor3=C.armoryDim; btn.TextColor3=Color3.fromRGB(255,185,80)
    btn.BorderSizePixel=0; corner(btn,6); hoverBtn(btn,C.armoryDim,C.armory)
    btn.MouseButton1Click:Connect(function() crearGuiArma(nombreArma,datos) end)
end

-- ============================================================
-- BASE DE DATOS COMPLETA
-- ============================================================
local database = {
    ["👤"] = {   -- Cuerpo
        "hombro derecho","hombro izquierdo","brazo derecho","brazo izquierdo",
        "antebrazo derecho","antebrazo izquierdo","codo derecho","codo izquierdo",
        "muñeca derecha","muñeca izquierda","mano derecha","mano izquierda",
        "dedos mano der","dedos mano izq","pecho superior","pecho inferior",
        "abdomen","ingle","muslo derecho","muslo izquierdo",
        "rodilla derecha","rodilla izquierda","pantorrilla derecha","pantorrilla izquierda",
        "tobillo derecho","tobillo izquierdo","pie derecho","pie izquierdo",
        "costilla flotante der","costilla flotante izq","clavícula der","clavícula izq",
        "esternón","ombligo","zona lumbar","sacro","escápula der","escápula izq",
        "bíceps der","bíceps izq","tríceps der","tríceps izq",
        "cuádriceps der","cuádriceps izq","isquiotibial der","isquiotibial izq",
    },
    ["🥷"] = {   -- Cabeza/cara
        "frente","ojo derecho","ojo izquierdo","mandíbula",
        "mejilla der","mejilla izq","oreja der","oreja izq",
        "nuca","cuello frontal","cuello lateral der","cuello lateral izq",
        "tráquea","nuez de adán","sien derecha","sien izquierda",
        "tabique nasal","labio superior","labio inferior","barbilla",
        "pómulo der","pómulo izq","arco superciliar der","arco superciliar izq",
    },
    ["🛡️"] = {  -- Blindaje
        "placa pectoral chaleco","placa dorsal chaleco",
        "kevlar lateral der","kevlar lateral izq",
        "hombro con protección der","hombro con protección izq",
        "casco (visera)","casco (nuca)","casco (lateral)",
        "axila derecha","axila izquierda","ingle (protección)",
        "rodillera der","rodillera izq","codiera der","codiera izq",
        "guante táctico der","guante táctico izq",
    },
    ["🚗"] = {   -- Vehículo
        "llanta del der","llanta del izq","llanta tras der","llanta tras izq",
        "motor","radiador","batería","alternador","tanque de gas",
        "parabrisas","medallón trasero","ventanilla cond","ventanilla copiloto",
        "pilar A","pilar B","bloque motor","manguera frenos",
        "disco de freno","amortiguador","faro delantero der","faro delantero izq",
        "calavera trasera","capó","cajuela","espejo retrovisor",
        "palanca de cambios","volante","pedal de freno","asiento del conductor",
    },
    ["💎"] = {   -- Blindado
        "cristal blindado N3","puerta blindada","junta de puerta",
        "bisagra superior","bisagra inferior","mirilla táctica",
        "motor parte baja","neumático run-flat",
        "placa de piso antiexplosión","turret (base)","turret (cañón)","escotilla superior",
    },
    ["🥋"] = {   -- Combate CQC
        "golpea nariz","golpea hígado","golpea bazo","golpea plexo solar",
        "gancho al mentón","patada baja muslo","patea espinilla",
        "barrida de pierna","luxa muñeca der","luxa muñeca izq",
        "llave de brazo der","llave de brazo izq","estrangulación trasera",
        "presiona nuca contra suelo","tuerce dedos mano","derribo tacleada",
        "proyecta hacia la pared","empuja fuerte al pecho",
        "pisa el pie derecho","pisa el pie izquierdo",
        "golpea el codo contra el esternón","rodillazo al muslo",
        "empuja la cabeza hacia atrás","jala del cabello",
        "toma del cuello con una mano","aplica llave de cabeza",
        "golpea el hombro con el codo","patea detrás de la rodilla",
        "tira al suelo por la pierna","gira el brazo hacia atrás",
        "presiona el pulgar en la palma","bloquea el puño y contraataca",
        "esquiva el golpe y empuja","engancha la pierna y voltea",
        "aplica presión en el antebrazo","golpea con la palma abierta",
        -- nuevas detalladas:
        "aplica palanca de muñeca en 90°","dobla el dedo meñique hacia atrás",
        "presiona el punto nervioso en el cuello (costado)","golpea el nervio peroneo",
        "bloquea el codo extendido y empuja","empuja hacia atrás del talón",
        "derriba con barrido frontal de pierna","aplica triángulo de piernas al suelo",
    },
    ["🏥"] = {   -- Primeros auxilios
        "aplica presión directa en la herida","coloca torniquete en el brazo der",
        "coloca torniquete en el brazo izq","coloca torniquete en la pierna der",
        "coloca torniquete en la pierna izq","aplica venda hemostática",
        "sella el neumotórax con parche oclusivo","abre la vía aérea",
        "aplica respiración de rescate","inicia compresiones cardíacas",
        "administra adrenalina (epi-pen)","aplica vendaje en figura de 8 (tobillo)",
        "inmoviliza la columna cervical","aplica férula en el brazo",
        "aplica férula en la pierna","limpia la herida con solución salina",
        "aplica coagulante en polvo (QuikClot)","cubre quemadura con gasa húmeda",
        "verifica pulso carotídeo","verifica pupilas",
        "evalúa nivel de consciencia (AVPU)","coloca en posición lateral de seguridad",
        "aplica manta térmica","administra analgésico oral",
        "registra la hora del torniquete","retira proyectil superficial con pinzas",
        -- nuevas:
        "aplica vendaje compresivo en el muslo","eleva el miembro lesionado 30°",
        "aplica compresa fría en la contusión","verifica temperatura corporal",
        "administra suero oral al paciente","aplica parche ocular de emergencia",
        "inmoviliza la mandíbula con venda","tapa la herida abierta en el pecho",
        "verifica la permeabilidad de la vía aérea","posiciona al paciente en decúbito supino",
    },
    ["🤟"] = {   -- Señales de mano
        "levanta el puño cerrado (alto/pausa)",
        "señala con el dedo índice hacia adelante (avanzar)",
        "mueve la mano hacia abajo con palma abierta (bajar velocidad/quieto)",
        "señala dos dedos hacia los ojos (vigilar/observar)",
        "hace círculo con el dedo índice (reagruparse)",
        "señala con tres dedos hacia la izquierda (flanquear izquierda)",
        "señala con tres dedos hacia la derecha (flanquear derecha)",
        "hace la señal de corte en el cuello (cancelar/abortar)",
        "mueve el dedo índice en zigzag (peligro al frente)",
        "señala con pulgar hacia abajo (negativo/no)",
        "señala con pulgar hacia arriba (positivo/afirmativo)",
        "toca el hombro propio (conmigo)",
        "abre y cierra la mano (hostigamiento)",
        "señala el oído con un dedo (escucha)",
        "señala los ojos con dos dedos (tengo visual)",
        "extiende la palma hacia el equipo (esperar aquí)",
        "señala con el dedo al suelo (cubrir posición)",
        "hace la V con los dedos (refuerzo necesario)",
        "cruza los brazos sobre el pecho (zona segura)",
        "señala el arma y luego al suelo (descargar/asegurar arma)",
        -- nuevas:
        "señala el reloj y levanta 2 dedos (2 minutos)",
        "hace señal de techo con las manos (cubierto/edificio)",
        "señala al frente con mano abierta y apunta arriba (objetivo en alto)",
        "lleva el puño al pecho y lo extiende (romper contacto)",
        "señala con 4 dedos hacia adelante (4 hombres al frente)",
        "hace cuña con ambas manos (formación cuña)",
        "señala en línea horizontal (formación en línea)",
        "señala en fila vertical (formación en fila india)",
    },
}

-- ============================================================
-- BUSCADOR
-- ============================================================
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q=SearchBar.Text:lower()
    for _,c in pairs(Scroll:GetChildren()) do
        if c:IsA("Frame") then
            c.Visible=(q=="" or c.Name:lower():find(q,1,true)) and true or false
        end
    end
end)

-- ============================================================
-- POBLAR SCROLL
-- ============================================================
local tipoMap = {
    ["👤"]="normal", ["🥷"]="normal", ["🛡️"]="normal",
    ["🚗"]="vehiculo", ["💎"]="vehiculo",
    ["🥋"]="combate",  ["🏥"]="medical", ["🤟"]="signal",
}
for cat,lista in pairs(database) do
    for _,v in ipairs(lista) do
        crearBloque(v, tipoMap[cat] or "normal", cat)
    end
end
crearBloqueScript("Textbox (Chat libre)","CHAT LIBRE","","")
crearBloqueScript("Textbox (Comillas)","TEXTBOX CON COMILLAS",'"','"')
crearBloqueScript("Textbox (Guiones)","TEXTBOX CON GUIONES","-","-")
for arma,datos in pairs(armasData) do
    crearBloqueArma(arma,datos)
end

-- ============================================================
-- SIDEBAR TÁCTIL CON SCROLLINGFRAME
-- ============================================================
local emos = {"👤","🥷","🛡️","🚗","💎","🥋","🏥","🤟","📜","🔧"}

-- Contenedor exterior (clip)
local SideClip = Instance.new("Frame", Main)
SideClip.Size=UDim2.new(0,58,0,310); SideClip.Position=UDim2.new(0,4,0,46)
SideClip.BackgroundColor3=C.surface; SideClip.BorderSizePixel=0
SideClip.ClipsDescendants=true
corner(SideClip,8); stroke(SideClip,C.border,1,0.5)

-- ScrollingFrame interior (táctil + rueda)
local SideScroll = Instance.new("ScrollingFrame", SideClip)
SideScroll.Size=UDim2.new(1,0,1,0); SideScroll.Position=UDim2.new(0,0,0,0)
SideScroll.BackgroundTransparency=1; SideScroll.BorderSizePixel=0
SideScroll.ScrollBarThickness=2; SideScroll.ScrollBarImageColor3=C.accent
SideScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; SideScroll.CanvasSize=UDim2.new(0,0,0,0)
SideScroll.ScrollingDirection=Enum.ScrollingDirection.Y

local sLay=Instance.new("UIListLayout",SideScroll); sLay.Padding=UDim.new(0,3)
local sPad=Instance.new("UIPadding",SideScroll)
sPad.PaddingTop=UDim.new(0,4); sPad.PaddingBottom=UDim.new(0,4)
sPad.PaddingLeft=UDim.new(0,4); sPad.PaddingRight=UDim.new(0,4)

for _, emo in ipairs(emos) do
    local b=Instance.new("TextButton", SideScroll)
    b.Size=UDim2.new(1,0,0,46); b.Text=emo; b.TextSize=22
    b.BackgroundColor3=C.surfaceAlt; b.BorderSizePixel=0
    corner(b,6)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=C.panel}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=C.surfaceAlt}) end)

    b.MouseButton1Click:Connect(function()
        tw(b,{BackgroundColor3=C.accentDim},TI_fast)
        task.delay(0.15,function() tw(b,{BackgroundColor3=C.surfaceAlt}) end)
        SearchBar.Text=""
        for _,c in pairs(Scroll:GetChildren()) do
            if c:IsA("Frame") then c.Visible=false end
        end
        if emo=="📜" then
            for _,c in pairs(Scroll:GetChildren()) do
                if c:IsA("Frame") and (
                    c.Name=="Textbox (Chat libre)" or
                    c.Name=="Textbox (Comillas)"   or
                    c.Name=="Textbox (Guiones)"
                ) then c.Visible=true end
            end
        elseif emo=="🔧" then
            for arma,_ in pairs(armasData) do
                if Scroll:FindFirstChild(arma) then Scroll[arma].Visible=true end
            end
        else
            if database[emo] then
                for _,accion in ipairs(database[emo]) do
                    if Scroll:FindFirstChild(accion) then Scroll[accion].Visible=true end
                end
            end
        end
        Scroll.CanvasPosition=Vector2.new(0,0)
    end)
end

-- ============================================================
-- OPEN / CLOSE
-- ============================================================
Control.MouseButton1Click:Connect(function()
    if not Main.Visible then
        Main.Visible=true; Main.BackgroundTransparency=1
        tw(Main,{BackgroundTransparency=0.04},TI_slow)
    else
        tw(Main,{BackgroundTransparency=1},TI_med)
        task.delay(0.22,function() Main.Visible=false end)
    end
end)
