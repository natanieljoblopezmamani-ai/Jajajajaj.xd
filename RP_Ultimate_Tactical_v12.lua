-- ============================================================
--  RP ULTIMATE FULL  |  TACTICAL EDITION  v7.0
--  + Sistema Ayudante (x5), formato configurable, añadir al ayudante
--  + Nombre/munición OPCIONALES globales (toggle)
--  + Todo lo de v6 preservado
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
    helper     = Color3.fromRGB(60,   90, 180),
    helperDim  = Color3.fromRGB(20,   35,  80),
    helperHov  = Color3.fromRGB(90,  130, 240),
    dot        = Color3.fromRGB(255,  60,  60),
    textPrime  = Color3.fromRGB(220, 230, 240),
    textDim    = Color3.fromRGB(100, 120, 145),
    textAccent = Color3.fromRGB(0,   210, 160),
    lock_on    = Color3.fromRGB(0,   210, 100),
    lock_off   = Color3.fromRGB(220,  50,  50),
    toast_bg   = Color3.fromRGB(18,  24,  34),
}

local TI_fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_med  = TweenInfo.new(0.22, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TI_slow = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- ============================================================
-- HELPERS GLOBALES
-- ============================================================
local function tw(o, p, i) TweenService:Create(o, i or TI_fast, p):Play() end

local function corner(p, px)
    local u = Instance.new("UICorner", p)
    u.CornerRadius = UDim.new(0, px or 4); return u
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.border; s.Thickness = th or 1; s.Transparency = tr or 0; return s
end

local function hoverBtn(btn, n, h)
    btn.MouseEnter:Connect(function()       tw(btn,{BackgroundColor3=h}) end)
    btn.MouseLeave:Connect(function()       tw(btn,{BackgroundColor3=n}) end)
    btn.MouseButton1Down:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.82}) end)
    btn.MouseButton1Up:Connect(function()   tw(btn,{BackgroundColor3=h,BackgroundTransparency=0}) end)
end

local function mkBox(parent, sz, pos, ph, tc)
    local tb = Instance.new("TextBox", parent)
    tb.Size=sz; tb.Position=pos; tb.BackgroundColor3=C.surface; tb.BorderSizePixel=0
    tb.PlaceholderText=ph; tb.PlaceholderColor3=C.textDim; tb.Text=""
    tb.TextColor3=tc or C.textAccent; tb.TextSize=11; tb.Font=Enum.Font.GothamSemibold
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
SG.IgnoreGuiInset  = true

-- ============================================================
-- TOAST GLOBAL (aviso flotante)
-- ============================================================
local Toast = Instance.new("Frame", SG)
Toast.Size=UDim2.new(0,240,0,32); Toast.Position=UDim2.new(0.5,-120,0,14)
Toast.BackgroundColor3=C.toast_bg; Toast.BorderSizePixel=0; Toast.Visible=false
Toast.ZIndex=100; corner(Toast,8); stroke(Toast,C.accent,1,0.3)
local ToastLbl = Instance.new("TextLabel", Toast)
ToastLbl.Size=UDim2.new(1,-10,1,0); ToastLbl.Position=UDim2.new(0,5,0,0)
ToastLbl.BackgroundTransparency=1; ToastLbl.TextColor3=C.textAccent
ToastLbl.TextSize=10; ToastLbl.Font=Enum.Font.GothamBold
ToastLbl.TextXAlignment=Enum.TextXAlignment.Center; ToastLbl.ZIndex=101

local toastThread
local function showToast(msg, col)
    if toastThread then task.cancel(toastThread) end
    ToastLbl.Text=msg; ToastLbl.TextColor3=col or C.textAccent
    Toast.BackgroundTransparency=0; Toast.Visible=true
    tw(Toast,{BackgroundTransparency=0},TI_fast)
    toastThread=task.delay(2, function()
        tw(Toast,{BackgroundTransparency=1},TI_med)
        task.delay(0.25,function() Toast.Visible=false end)
    end)
end

-- ============================================================
-- MAPAS CORPORALES Y DE AUTO (preservados de v6)
-- ============================================================
local bodyMap = {
    ["frente"]={0.50,0.04},["sien derecha"]={0.34,0.05},["sien izquierda"]={0.66,0.05},
    ["ojo derecho"]={0.40,0.07},["ojo izquierdo"]={0.60,0.07},["tabique nasal"]={0.50,0.09},
    ["mejilla der"]={0.38,0.10},["mejilla izq"]={0.62,0.10},["pómulo der"]={0.37,0.08},
    ["pómulo izq"]={0.63,0.08},["mandíbula"]={0.50,0.13},["labio superior"]={0.50,0.11},
    ["labio inferior"]={0.50,0.12},["barbilla"]={0.50,0.14},["oreja der"]={0.31,0.09},
    ["oreja izq"]={0.69,0.09},["arco superciliar der"]={0.40,0.06},["arco superciliar izq"]={0.60,0.06},
    ["nuca"]={0.50,0.08},["nuez de adán"]={0.50,0.17},["tráquea"]={0.50,0.18},
    ["cuello frontal"]={0.50,0.16},["cuello lateral der"]={0.40,0.17},["cuello lateral izq"]={0.60,0.17},
    ["clavícula der"]={0.37,0.22},["clavícula izq"]={0.63,0.22},
    ["hombro derecho"]={0.27,0.24},["hombro izquierdo"]={0.73,0.24},
    ["pecho superior"]={0.50,0.26},["pecho inferior"]={0.50,0.31},["esternón"]={0.50,0.28},
    ["escápula der"]={0.35,0.27},["escápula izq"]={0.65,0.27},
    ["placa pectoral chaleco"]={0.50,0.27},["placa dorsal chaleco"]={0.50,0.27},
    ["abdomen"]={0.50,0.36},["ombligo"]={0.50,0.38},["zona lumbar"]={0.50,0.40},
    ["sacro"]={0.50,0.43},["ingle"]={0.50,0.46},
    ["costilla flotante der"]={0.38,0.35},["costilla flotante izq"]={0.62,0.35},
    ["brazo derecho"]={0.22,0.31},["brazo izquierdo"]={0.78,0.31},
    ["bíceps der"]={0.21,0.30},["bíceps izq"]={0.79,0.30},
    ["tríceps der"]={0.20,0.32},["tríceps izq"]={0.80,0.32},
    ["codo derecho"]={0.19,0.36},["codo izquierdo"]={0.81,0.36},
    ["antebrazo derecho"]={0.17,0.40},["antebrazo izquierdo"]={0.83,0.40},
    ["muñeca derecha"]={0.15,0.44},["muñeca izquierda"]={0.85,0.44},
    ["mano derecha"]={0.14,0.48},["mano izquierda"]={0.86,0.48},
    ["dedos mano der"]={0.13,0.51},["dedos mano izq"]={0.87,0.51},
    ["muslo derecho"]={0.41,0.54},["muslo izquierdo"]={0.59,0.54},
    ["cuádriceps der"]={0.40,0.56},["cuádriceps izq"]={0.60,0.56},
    ["isquiotibial der"]={0.41,0.58},["isquiotibial izq"]={0.59,0.58},
    ["rodilla derecha"]={0.41,0.64},["rodilla izquierda"]={0.59,0.64},
    ["pantorrilla derecha"]={0.40,0.72},["pantorrilla izquierda"]={0.60,0.72},
    ["tobillo derecho"]={0.40,0.80},["tobillo izquierdo"]={0.60,0.80},
    ["pie derecho"]={0.39,0.86},["pie izquierdo"]={0.61,0.86},
    ["kevlar lateral der"]={0.33,0.33},["kevlar lateral izq"]={0.67,0.33},
    ["axila derecha"]={0.30,0.28},["axila izquierda"]={0.70,0.28},
    ["casco (visera)"]={0.50,0.03},["casco (nuca)"]={0.50,0.06},["casco (lateral)"]={0.36,0.05},
    ["rodillera der"]={0.41,0.64},["rodillera izq"]={0.59,0.64},
    ["codiera der"]={0.19,0.36},["codiera izq"]={0.81,0.36},
}
local DEFAULT_DOT={0.50,0.30}

local carMap = {
    ["llanta del der"]={0.86,0.14},["llanta del izq"]={0.10,0.14},
    ["llanta tras der"]={0.86,0.78},["llanta tras izq"]={0.10,0.78},
    ["motor"]={0.50,0.20},["radiador"]={0.50,0.10},["batería"]={0.38,0.22},
    ["alternador"]={0.62,0.22},["tanque de gas"]={0.50,0.82},["parabrisas"]={0.50,0.28},
    ["medallón trasero"]={0.50,0.76},["ventanilla cond"]={0.22,0.48},
    ["ventanilla copiloto"]={0.78,0.48},["pilar A"]={0.22,0.34},["pilar B"]={0.22,0.56},
    ["bloque motor"]={0.50,0.18},["manguera frenos"]={0.38,0.62},
    ["disco de freno"]={0.12,0.72},["amortiguador"]={0.12,0.28},
    ["faro delantero der"]={0.78,0.08},["faro delantero izq"]={0.22,0.08},
    ["calavera trasera"]={0.50,0.88},["capó"]={0.50,0.16},["cajuela"]={0.50,0.84},
    ["espejo retrovisor"]={0.18,0.44},["palanca de cambios"]={0.50,0.52},
    ["volante"]={0.34,0.42},["pedal de freno"]={0.38,0.50},
    ["asiento del conductor"]={0.30,0.46},["cristal blindado N3"]={0.50,0.32},
    ["puerta blindada"]={0.15,0.52},["junta de puerta"]={0.18,0.52},
    ["bisagra superior"]={0.18,0.38},["bisagra inferior"]={0.18,0.62},
    ["mirilla táctica"]={0.22,0.46},["motor parte baja"]={0.50,0.24},
    ["neumático run-flat"]={0.10,0.14},["placa de piso antiexplosión"]={0.50,0.54},
    ["turret (base)"]={0.50,0.50},["turret (cañón)"]={0.50,0.40},["escotilla superior"]={0.50,0.50},
}
local DEFAULT_CAR={0.50,0.50}

-- ============================================================
-- LÓGICA DE CHAT
-- ============================================================
local function EnviarAlChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    else
        local ok,rs=pcall(function()
            return game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
        end)
        if ok then rs:FireServer(msg,"All") end
    end
end

-- ============================================================
-- ESTADO GLOBAL OPCIONALES (nombre / munición)
-- ============================================================
local globalOpts = {
    nombreActivo  = false,
    munActiva     = false,
    nombreVal     = "",
    munVal        = "",
}

-- ============================================================
-- 1. BOTÓN FLOTANTE
-- ============================================================
local Control = Instance.new("TextButton", SG)
Control.Size=UDim2.new(0,46,0,46); Control.Position=UDim2.new(0,14,0,200)
Control.BackgroundColor3=C.surface; Control.Text="RP"
Control.TextColor3=C.textAccent; Control.TextSize=13; Control.Font=Enum.Font.GothamBold
Control.Draggable=true; Control.BorderSizePixel=0
corner(Control,9); stroke(Control,C.accent,1.5,0.15)
hoverBtn(Control,C.surface,C.surfaceAlt)

local LockDot=Instance.new("Frame",Control)
LockDot.Size=UDim2.new(0,10,0,10); LockDot.Position=UDim2.new(1,-7,0,-3)
LockDot.BackgroundColor3=C.lock_on; LockDot.BorderSizePixel=0; corner(LockDot,5)

local LockIcon=Instance.new("TextLabel",Control)
LockIcon.Size=UDim2.new(0,14,0,14); LockIcon.Position=UDim2.new(0,-4,1,-10)
LockIcon.BackgroundTransparency=1; LockIcon.Text="🔓"; LockIcon.TextSize=10
LockIcon.Font=Enum.Font.GothamBold; LockIcon.TextColor3=C.lock_on

local ctrlMovible=true
-- Doble tap = toggle candado, clic normal = abrir GUI
-- Usar botón separado de candado encima del botón principal
local LockBtnFloat=Instance.new("TextButton",SG)
LockBtnFloat.Size=UDim2.new(0,20,0,20); LockBtnFloat.Position=UDim2.new(0,40,0,200)
LockBtnFloat.BackgroundColor3=C.surface; LockBtnFloat.Text="🔓"; LockBtnFloat.TextSize=9
LockBtnFloat.Font=Enum.Font.GothamBold; LockBtnFloat.TextColor3=C.lock_on
LockBtnFloat.BorderSizePixel=0; corner(LockBtnFloat,5)
stroke(LockBtnFloat,C.lock_on,1,0.4)
LockBtnFloat.MouseButton1Click:Connect(function()
    ctrlMovible=not ctrlMovible; Control.Draggable=ctrlMovible
    local col=ctrlMovible and C.lock_on or C.lock_off
    tw(LockDot,{BackgroundColor3=col},TI_med)
    tw(LockIcon,{TextColor3=col},TI_med)
    tw(LockBtnFloat,{TextColor3=col},TI_med)
    stroke(LockBtnFloat,col,1,0.4)
    LockIcon.Text=ctrlMovible and "🔓" or "🔒"
    LockBtnFloat.Text=ctrlMovible and "🔓" or "🔒"
end)
-- Mantener MouseButton2Click también para PC
Control.MouseButton2Click:Connect(function()
    ctrlMovible=not ctrlMovible; Control.Draggable=ctrlMovible
    local col=ctrlMovible and C.lock_on or C.lock_off
    tw(LockDot,{BackgroundColor3=col},TI_med); tw(LockIcon,{TextColor3=col},TI_med)
    tw(LockBtnFloat,{TextColor3=col},TI_med)
    LockIcon.Text=ctrlMovible and "🔓" or "🔒"
    LockBtnFloat.Text=ctrlMovible and "🔓" or "🔒"
end)

-- ============================================================
-- 2. MAIN FRAME
-- ============================================================
local FULL_H=420; local MINI_H=38

local Main=Instance.new("Frame",SG)
Main.Size=UDim2.new(0,500,0,FULL_H); Main.Position=UDim2.new(0.5,-250,0.5,-210)
Main.BackgroundColor3=C.bg; Main.BackgroundTransparency=0.04; Main.BorderSizePixel=0
Main.Visible=false; Main.Active=true; Main.Draggable=true; Main.ClipsDescendants=true
corner(Main,10); stroke(Main,C.border,1.5,0.08)

-- Barra título
local TBar=Instance.new("Frame",Main)
TBar.Size=UDim2.new(1,0,0,MINI_H); TBar.BackgroundColor3=C.surface; TBar.BorderSizePixel=0
corner(TBar,10)
local tbFix=Instance.new("Frame",TBar); tbFix.Size=UDim2.new(1,0,0.5,0)
tbFix.Position=UDim2.new(0,0,0.5,0); tbFix.BackgroundColor3=C.surface; tbFix.BorderSizePixel=0

local TTitle=Instance.new("TextLabel",TBar)
TTitle.Size=UDim2.new(1,-150,1,0); TTitle.Position=UDim2.new(0,12,0,0)
TTitle.BackgroundTransparency=1; TTitle.Text="◈  TACTICAL RP  v7.0  ◈"
TTitle.TextColor3=C.textAccent; TTitle.TextSize=11; TTitle.Font=Enum.Font.GothamBold
TTitle.TextXAlignment=Enum.TextXAlignment.Left

local AccLine=Instance.new("Frame",Main)
AccLine.Size=UDim2.new(1,0,0,1); AccLine.Position=UDim2.new(0,0,0,MINI_H)
AccLine.BackgroundColor3=C.accent; AccLine.BackgroundTransparency=0.45; AccLine.BorderSizePixel=0

-- Botones barra título
local function mkTBtn(xOff,txt,bg,tc)
    local b=Instance.new("TextButton",TBar)
    b.Size=UDim2.new(0,28,0,24); b.Position=UDim2.new(1,-xOff,0,7)
    b.Text=txt; b.TextSize=11; b.Font=Enum.Font.GothamBold
    b.BackgroundColor3=bg; b.TextColor3=tc; b.BorderSizePixel=0
    corner(b,5); return b
end
local CloseBtn=mkTBtn(32,"✕",C.dangerDim,Color3.fromRGB(255,110,110))
local MinBtn  =mkTBtn(64,"▼",C.surfaceAlt,C.textDim)
local LockBtn =mkTBtn(96,"🔓",C.surfaceAlt,C.lock_on)

hoverBtn(CloseBtn,C.dangerDim,C.danger)
hoverBtn(MinBtn,C.surfaceAlt,C.panel)
hoverBtn(LockBtn,C.surfaceAlt,C.panel)

CloseBtn.MouseButton1Click:Connect(function()
    tw(Main,{BackgroundTransparency=1},TI_med)
    task.delay(0.22,function() Main.Visible=false end)
end)

local minimized=false; local mainMovible=true
MinBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    tw(Main,{Size=UDim2.new(0,500,0,minimized and MINI_H or FULL_H)},TI_slow)
    MinBtn.Text=minimized and "▲" or "▼"
end)
LockBtn.MouseButton1Click:Connect(function()
    mainMovible=not mainMovible; Main.Draggable=mainMovible
    LockBtn.Text=mainMovible and "🔓" or "🔒"
    tw(LockBtn,{TextColor3=mainMovible and C.lock_on or C.lock_off},TI_med)
end)

-- ============================================================
-- BARRA OPCIONALES GLOBALES (nombre + munición toggle)
-- ============================================================
local OptsBar=Instance.new("Frame",Main)
OptsBar.Size=UDim2.new(1,-68,0,28); OptsBar.Position=UDim2.new(0,68,0,42)
OptsBar.BackgroundColor3=C.panel; OptsBar.BorderSizePixel=0
corner(OptsBar,6); stroke(OptsBar,C.border,1,0.6)

-- Toggle nombre
local NombreToggle=Instance.new("TextButton",OptsBar)
NombreToggle.Size=UDim2.new(0,26,0,20); NombreToggle.Position=UDim2.new(0,4,0,4)
NombreToggle.Text="👤"; NombreToggle.TextSize=12; NombreToggle.BackgroundColor3=C.surface
NombreToggle.TextColor3=C.textDim; NombreToggle.BorderSizePixel=0
corner(NombreToggle,5)

local NombreBox=Instance.new("TextBox",OptsBar)
NombreBox.Size=UDim2.new(0,120,0,20); NombreBox.Position=UDim2.new(0,34,0,4)
NombreBox.BackgroundColor3=C.surface; NombreBox.BorderSizePixel=0
NombreBox.PlaceholderText="Nombre..."; NombreBox.PlaceholderColor3=C.textDim
NombreBox.Text=""; NombreBox.TextColor3=C.textAccent; NombreBox.TextSize=10
NombreBox.Font=Enum.Font.Gotham; NombreBox.ClearTextOnFocus=false
NombreBox.Visible=false; corner(NombreBox,5); stroke(NombreBox,C.accentDim,1,0.4)

-- Toggle munición
local MunToggle=Instance.new("TextButton",OptsBar)
MunToggle.Size=UDim2.new(0,26,0,20); MunToggle.Position=UDim2.new(0,162,0,4)
MunToggle.Text="🔫"; MunToggle.TextSize=12; MunToggle.BackgroundColor3=C.surface
MunToggle.TextColor3=C.textDim; MunToggle.BorderSizePixel=0
corner(MunToggle,5)

local MunBox=Instance.new("TextBox",OptsBar)
MunBox.Size=UDim2.new(0,120,0,20); MunBox.Position=UDim2.new(0,192,0,4)
MunBox.BackgroundColor3=C.surface; MunBox.BorderSizePixel=0
MunBox.PlaceholderText="Munición..."; MunBox.PlaceholderColor3=C.textDim
MunBox.Text=""; MunBox.TextColor3=Color3.fromRGB(255,190,80); MunBox.TextSize=10
MunBox.Font=Enum.Font.Gotham; MunBox.ClearTextOnFocus=false
MunBox.Visible=false; corner(MunBox,5); stroke(MunBox,Color3.fromRGB(120,80,20),1,0.4)

-- Lógica toggles
NombreToggle.MouseButton1Click:Connect(function()
    globalOpts.nombreActivo=not globalOpts.nombreActivo
    NombreBox.Visible=globalOpts.nombreActivo
    tw(NombreToggle,{BackgroundColor3=globalOpts.nombreActivo and C.accentDim or C.surface},TI_fast)
    tw(NombreToggle,{TextColor3=globalOpts.nombreActivo and C.textAccent or C.textDim},TI_fast)
    -- Reposicionar MunToggle
    MunToggle.Position=globalOpts.nombreActivo and UDim2.new(0,162,0,4) or UDim2.new(0,34,0,4)
    MunBox.Position=globalOpts.nombreActivo and UDim2.new(0,192,0,4) or UDim2.new(0,64,0,4)
end)
MunToggle.MouseButton1Click:Connect(function()
    globalOpts.munActiva=not globalOpts.munActiva
    MunBox.Visible=globalOpts.munActiva
    tw(MunToggle,{BackgroundColor3=globalOpts.munActiva and Color3.fromRGB(80,50,10) or C.surface},TI_fast)
    tw(MunToggle,{TextColor3=globalOpts.munActiva and Color3.fromRGB(255,190,80) or C.textDim},TI_fast)
end)

-- Sincronizar valores
NombreBox:GetPropertyChangedSignal("Text"):Connect(function() globalOpts.nombreVal=NombreBox.Text end)
MunBox:GetPropertyChangedSignal("Text"):Connect(function() globalOpts.munVal=MunBox.Text end)

-- ============================================================
-- BARRA DE BÚSQUEDA
-- ============================================================
local SearchBar=Instance.new("TextBox",Main)
SearchBar.Size=UDim2.new(0,374,0,26); SearchBar.Position=UDim2.new(0,68,0,76)
SearchBar.BackgroundColor3=C.surface; SearchBar.BorderSizePixel=0
SearchBar.PlaceholderText="  🔍  BUSCADOR UNIVERSAL..."
SearchBar.PlaceholderColor3=C.textDim; SearchBar.Text=""
SearchBar.TextColor3=C.textPrime; SearchBar.TextSize=11; SearchBar.Font=Enum.Font.Gotham
SearchBar.ClearTextOnFocus=false
corner(SearchBar,6); stroke(SearchBar,C.border,1,0.4)

-- Icono limpiar (sin rojo)
local ClearBtn=Instance.new("TextButton",Main)
ClearBtn.Size=UDim2.new(0,26,0,26); ClearBtn.Position=UDim2.new(0,450,0,76)
ClearBtn.Text="✕"; ClearBtn.TextSize=11; ClearBtn.Font=Enum.Font.GothamBold
ClearBtn.BackgroundColor3=C.surface; ClearBtn.TextColor3=C.textDim
ClearBtn.BorderSizePixel=0; corner(ClearBtn,6)
ClearBtn.MouseButton1Click:Connect(function() SearchBar.Text="" end)

-- ============================================================
-- SCROLL PRINCIPAL
-- ============================================================
local Scroll=Instance.new("ScrollingFrame",Main)
Scroll.Size=UDim2.new(0,400,0,260); Scroll.Position=UDim2.new(0,68,0,108)
Scroll.BackgroundColor3=C.panel; Scroll.BorderSizePixel=0
Scroll.CanvasSize=UDim2.new(0,0,0,0); Scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Scroll.ScrollBarThickness=3; Scroll.ScrollBarImageColor3=C.accent
Scroll.ScrollingDirection=Enum.ScrollingDirection.Y
corner(Scroll,8)
local scLay=Instance.new("UIListLayout",Scroll); scLay.Padding=UDim.new(0,5)
scLay.SortOrder=Enum.SortOrder.LayoutOrder
local scPad=Instance.new("UIPadding",Scroll)
scPad.PaddingLeft=UDim.new(0,5); scPad.PaddingRight=UDim.new(0,5)
scPad.PaddingTop=UDim.new(0,5); scPad.PaddingBottom=UDim.new(0,5)

-- ============================================================
-- PROCESAR ACCIÓN (usa globalOpts)
-- ============================================================
-- ============================================================
-- TABLA DE EFECTOS NARRATIVOS POR ZONA Y CANTIDAD DE BALAS
-- ============================================================
-- Zonas: cabeza, cuello, torso, abdomen, brazo, mano, pierna, pie, general
-- Niveles: 1 bala, 2-3 balas, 4+ balas

-- Mapa de zonas: lista ordenada [patron_exacto → zona]
-- Se evalúa en orden: el primer match gana. Más específico primero.
local ZONA_MAP = {
    -- PROTEGIDAS (detectar antes que la zona base)
    {"placa pectoral",   "torso"},
    {"placa dorsal",     "torso"},
    {"kevlar",           "torso"},
    {"chaleco",          "torso"},
    {"hombro con protección", "torso"},
    {"ingle (protección)", "abdomen"},
    {"axila derecha",    "torso"},
    {"axila izquierda",  "torso"},
    {"casco",            "cabeza"},
    {"codiera",          "brazo"},
    {"rodillera",        "pierna"},
    {"guante táctico",   "brazo"},
    -- CABEZA
    {"frente",           "cabeza"},
    {"sien",             "cabeza"},
    {"ojo ",             "cabeza"},  -- espacio evita match en "objetivo"
    {"ojo d",            "cabeza"},
    {"ojo i",            "cabeza"},
    {"mandíbula",        "cabeza"},
    {"mejilla",          "cabeza"},
    {"oreja",            "cabeza"},
    {"nuca",             "cabeza"},
    {"tabique",          "cabeza"},
    {"labio",            "cabeza"},
    {"barbilla",         "cabeza"},
    {"pómulo",           "cabeza"},
    {"arco superciliar", "cabeza"},
    -- CUELLO
    {"cuello",           "cuello"},
    {"tráquea",          "cuello"},
    {"nuez de adán",     "cuello"},
    -- TORSO
    {"pecho",            "torso"},
    {"esternón",         "torso"},
    {"clavícula",        "torso"},
    {"escápula",         "torso"},
    {"costilla",         "torso"},
    {"hombro",           "torso"},   -- después de "hombro con protección"
    -- ABDOMEN
    {"abdomen",          "abdomen"},
    {"ombligo",          "abdomen"},
    {"plexo",            "abdomen"},
    {"ingle",            "abdomen"},
    {"zona lumbar",      "abdomen"},
    {"sacro",            "abdomen"},
    -- BRAZO (ANTES que pie para evitar "pie" en "izquierdo")
    {"antebrazo",        "brazo"},   -- antebrazo antes que brazo
    {"brazo",            "brazo"},
    {"bíceps",           "brazo"},
    {"tríceps",          "brazo"},
    {"codo",             "brazo"},
    {"muñeca",           "brazo"},
    {"mano ",            "brazo"},
    {"mano d",           "brazo"},
    {"mano i",           "brazo"},
    {"dedos",            "brazo"},
    -- PIERNA (antes que pie)
    {"pantorrilla",      "pierna"},
    {"isquiotibial",     "pierna"},
    {"cuádriceps",       "pierna"},
    {"rodilla",          "pierna"},
    {"muslo",            "pierna"},
    {"tobillo",          "pierna"},
    -- PIE (al final, match exacto)
    {"pie derecho",      "pie"},
    {"pie izquierdo",    "pie"},
}

local function getZona(parte)
    local p = parte:lower()
    for _, entry in ipairs(ZONA_MAP) do
        local patron = entry[1]
        local zona   = entry[2]
        if p:find(patron, 1, true) then
            return zona
        end
    end
    return "general"
end

-- ============================================================
-- EFECTOS NARRATIVOS FICTICIOS — Solo RP, sin términos médicos
-- Zonas × Nivel (1=leve, 2=moderado, 3=múltiple)
-- Con protección y sin protección
-- ============================================================
local EFECTOS = {
    -- ── CABEZA ───────────────────────────────────────────────
    cabeza = {
        sin = {
            [1]={
                "la zona recibe el impacto y pierde el equilibrio por un momento",
                "el golpe en la cabeza hace que retroceda hacia atrás",
                "pierde estabilidad al recibir el impacto en la cabeza",
                "el impacto en la cabeza desorienta brevemente",
                "tambalea hacia atrás por el impacto recibido",
            },
            [2]={
                "los impactos en la cabeza hacen que caiga de rodillas",
                "la cabeza recibe los golpes y pierde el control de la postura",
                "retrocede con fuerza y apoya una mano en el suelo",
                "los golpes en la cabeza dejan sin poder reaccionar por unos segundos",
                "cae hacia un lado al no poder mantener el equilibrio",
            },
            [3]={
                "los múltiples impactos en la cabeza dejan sin poder continuar",
                "la zona recibe demasiados golpes y cae al suelo sin fuerza",
                "colapsa al no poder sostenerse tras los impactos en la cabeza",
                "los golpes repetidos en la cabeza anulan por completo la respuesta",
                "queda fuera de combate tras los impactos recibidos en la cabeza",
            },
        },
        con = {
            [1]={
                "el casco absorbe parte del impacto pero retrocede por la fuerza",
                "la protección en la cabeza recibe el golpe y pierde el paso",
                "el impacto rebota en el casco y tropieza hacia atrás",
                "el casco amortigua el golpe pero pierde estabilidad",
                "la protección cede ligeramente ante el impacto y retrocede",
            },
            [2]={
                "el casco recibe varios impactos y cae de rodillas",
                "la protección en la cabeza absorbe los golpes pero pierde el equilibrio",
                "los impactos en el casco hacen que apoye las manos en el suelo",
                "lucha por mantenerse en pie tras los golpes en la protección",
                "el casco resiste pero no puede mantener la postura",
            },
            [3]={
                "los múltiples impactos en el casco obligan a caer al suelo",
                "la protección en la cabeza recibe demasiados golpes y colapsa",
                "queda fuera de combate a pesar de la protección en la cabeza",
                "los golpes repetidos en el casco dejan sin poder continuar",
                "la zona protegida cede ante los impactos acumulados y cae",
            },
        },
    },
    -- ── CUELLO ───────────────────────────────────────────────
    cuello = {
        sin = {
            [1]={
                "el impacto en el cuello hace que lleve las manos a la zona",
                "retrocede y se toma el cuello al recibir el golpe",
                "la zona del cuello recibe el impacto y pierde el paso",
                "el golpe en el cuello hace que se detenga en seco",
                "trastabilla hacia atrás al recibir el impacto en el cuello",
            },
            [2]={
                "los impactos en el cuello hacen que caiga de rodillas",
                "pierde el equilibrio y apoya una mano en el suelo",
                "los golpes en el cuello dejan sin poder moverse con soltura",
                "retrocede con fuerza y tropieza al recibir los impactos",
                "la zona del cuello recibe los golpes y pierde control de la postura",
            },
            [3]={
                "los múltiples impactos en el cuello dejan fuera de combate",
                "cae al suelo sin poder continuar tras los golpes en el cuello",
                "la zona recibe demasiados impactos y colapsa",
                "los golpes repetidos en el cuello anulan la respuesta por completo",
                "queda en el suelo sin poder levantarse",
            },
        },
        con = {
            [1]={
                "el cuello recibe el impacto y retrocede con fuerza",
                "la zona del cuello absorbe el golpe y pierde el paso",
                "tambalea al recibir el impacto en el cuello",
                "el golpe en el cuello hace que pierda el equilibrio brevemente",
                "se detiene en seco y retrocede por el impacto",
            },
            [2]={
                "los impactos en el cuello hacen que tropiece",
                "pierde la postura y cae de rodillas tras los golpes",
                "la zona del cuello recibe los impactos y no puede mantenerse",
                "los golpes en el cuello obligan a apoyarse en algo",
                "pierde el control de la postura al recibir los impactos",
            },
            [3]={
                "los múltiples golpes en el cuello dejan sin poder continuar",
                "cae al suelo tras los impactos repetidos en el cuello",
                "la zona recibe demasiados golpes y colapsa por completo",
                "los impactos acumulados en el cuello anulan",
                "queda fuera de combate",
            },
        },
    },
    -- ── TORSO ────────────────────────────────────────────────
    torso = {
        sin = {
            [1]={
                "el impacto en el torso hace que retroceda un paso",
                "pierde el equilibrio brevemente al recibir el golpe en el pecho",
                "la zona del torso recibe el impacto y se tambalea",
                "el golpe en el pecho empuja hacia atrás",
                "trastabilla al sentir el impacto en el torso",
                "el impacto en el torso hace que pierda el paso",
                "retrocede con fuerza al recibir el golpe en el pecho",
            },
            [2]={
                "los impactos en el torso hacen que caiga de rodillas",
                "pierde la postura y se dobla hacia adelante",
                "los golpes en el pecho obligan a apoyarse en algo",
                "la zona del torso recibe los impactos y no puede mantenerse en pie",
                "retrocede con fuerza y tropieza al recibir los golpes",
                "los impactos en el torso dejan sin poder reaccionar",
            },
            [3]={
                "los múltiples impactos en el torso dejan en el suelo",
                "colapsa al no poder sostenerse tras los golpes en el pecho",
                "la zona del torso recibe demasiados impactos y cae",
                "los golpes repetidos en el torso anulan por completo la respuesta",
                "queda fuera de combate tras los impactos en el pecho",
                "los impactos acumulados en el torso dejan sin poder levantarse",
            },
        },
        con = {
            [1]={
                "el chaleco absorbe el impacto pero retrocede por la fuerza",
                "la protección en el torso recibe el golpe y pierde el paso",
                "el impacto rebota en el chaleco y tropieza hacia atrás",
                "el chaleco amortigua el golpe pero pierde estabilidad",
                "la protección resiste pero retrocede al sentir la fuerza",
                "el chaleco recibe el impacto y da un paso atrás",
                "el golpe en la protección hace que pierda el equilibrio un momento",
            },
            [2]={
                "el chaleco recibe varios impactos y cae de rodillas",
                "la protección absorbe los golpes pero pierde el equilibrio",
                "los impactos en el chaleco hacen que tropiece",
                "lucha por mantenerse en pie tras los golpes en la protección",
                "el chaleco resiste pero no puede mantener la postura",
                "la protección recibe los impactos y se dobla hacia adelante",
            },
            [3]={
                "los múltiples impactos en el chaleco obligan a caer",
                "la protección en el torso recibe demasiados golpes y colapsa",
                "queda fuera de combate a pesar del chaleco",
                "los golpes repetidos en la protección dejan sin poder continuar",
                "la protección cede ante los impactos acumulados y cae al suelo",
                "no puede sostenerse tras los múltiples impactos en el chaleco",
            },
        },
    },
    -- ── ABDOMEN ──────────────────────────────────────────────
    abdomen = {
        sin = {
            [1]={
                "el impacto en el abdomen hace que se doble hacia adelante",
                "retrocede y lleva las manos a la zona al recibir el golpe",
                "la zona del abdomen recibe el impacto y pierde el paso",
                "el golpe en el abdomen hace que se tambalee",
                "pierde el equilibrio brevemente al sentir el impacto",
                "el impacto en el abdomen obliga a retroceder",
            },
            [2]={
                "los impactos en el abdomen hacen que caiga de rodillas",
                "se dobla hacia adelante y pierde la postura",
                "los golpes en el abdomen dejan sin poder erguirse",
                "la zona recibe los impactos y tropieza hacia atrás",
                "pierde el control de la postura al recibir los golpes",
                "los impactos en el abdomen obligan a apoyarse en algo",
            },
            [3]={
                "los múltiples impactos en el abdomen dejan en el suelo",
                "colapsa al recibir demasiados golpes en el abdomen",
                "la zona del abdomen acumula los impactos y cae",
                "los golpes repetidos en el abdomen anulan por completo",
                "queda fuera de combate tras los impactos en el abdomen",
                "los impactos acumulados dejan sin poder continuar",
            },
        },
        con = {
            [1]={
                "la protección abdominal absorbe el impacto pero retrocede",
                "el chaleco recibe el golpe en el abdomen y pierde el paso",
                "el impacto en la protección hace que se tambalee",
                "el chaleco amortigua el golpe pero pierde estabilidad",
                "la protección resiste y retrocede por la fuerza del impacto",
            },
            [2]={
                "la protección abdominal recibe varios golpes y cae de rodillas",
                "el chaleco absorbe los impactos pero pierde el equilibrio",
                "los golpes en la protección del abdomen hacen que tropiece",
                "la protección resiste pero no puede mantener la postura",
                "lucha por sostenerse tras los impactos en la protección",
            },
            [3]={
                "los múltiples impactos en la protección abdominal obligan a caer",
                "el chaleco recibe demasiados golpes y colapsa",
                "la protección cede ante los impactos acumulados en el abdomen",
                "queda fuera de combate a pesar de la protección",
                "los golpes repetidos dejan en el suelo sin poder levantarse",
            },
        },
    },
    -- ── BRAZO ────────────────────────────────────────────────
    brazo = {
        sin = {
            [1]={
                "el brazo recibe el impacto y pierde fuerza temporalmente",
                "suelta lo que sostenía al recibir el golpe en el brazo",
                "la zona del brazo recibe el impacto y el movimiento se vuelve limitado",
                "el impacto en el brazo hace que lo lleve hacia atrás",
                "el brazo pierde respuesta momentáneamente tras el golpe",
                "retrocede al recibir el impacto en el brazo",
                "el golpe en el brazo hace que cambie de postura",
            },
            [2]={
                "los impactos en el brazo dejan la extremidad sin respuesta por un momento",
                "no puede usar el brazo con normalidad tras los golpes",
                "la zona del brazo recibe los impactos y el movimiento queda muy limitado",
                "los golpes en el brazo hacen que lo cuelgue sin fuerza",
                "el brazo pierde movilidad tras los impactos recibidos",
                "cambia de postura al sentir los golpes en el brazo",
            },
            [3]={
                "los múltiples impactos en el brazo lo dejan sin respuesta",
                "ya no puede usar el brazo tras los golpes acumulados",
                "la zona del brazo acumula los impactos y queda completamente sin fuerza",
                "los golpes repetidos en el brazo lo inutilizan por completo",
                "el brazo cuelga sin fuerza tras los múltiples impactos recibidos",
                "pierde el control del brazo tras los golpes",
            },
        },
        con = {
            [1]={
                "la protección en el brazo recibe el impacto y el miembro pierde fuerza",
                "la codiera absorbe el golpe pero el brazo queda con movimiento limitado",
                "el impacto en la protección hace que el brazo pierda respuesta momentánea",
                "la protección del brazo amortigua el golpe pero retrocede",
                "la codiera recibe el impacto y cambia de postura",
            },
            [2]={
                "la protección del brazo recibe varios golpes y la extremidad pierde movilidad",
                "la codiera absorbe los impactos pero el brazo queda sin respuesta",
                "los golpes en la protección del brazo limitan el movimiento ",
                "la protección resiste pero el brazo pierde fuerza tras los impactos",
                "no puede usar el brazo con normalidad a pesar de la protección",
            },
            [3]={
                "los múltiples impactos en la protección del brazo lo dejan inutilizado",
                "la codiera cede ante los golpes acumulados y el brazo pierde toda respuesta",
                "el brazo queda sin fuerza tras los múltiples impactos en la protección",
                "la protección del brazo recibe demasiados golpes y el miembro queda inútil",
                "pierde el control del brazo a pesar de la protección",
            },
        },
    },
    -- ── PIERNA ───────────────────────────────────────────────
    pierna = {
        sin = {
            [1]={
                "la pierna recibe el impacto y pierde el paso",
                "cojea ligeramente al sentir el golpe en la pierna",
                "la zona de la pierna recibe el impacto y el movimiento se ralentiza",
                "el impacto en la pierna hace que pierda el equilibrio",
                "cambia el peso al otro pie al recibir el golpe",
                "el golpe en la pierna obliga a reducir la velocidad",
                "la pierna pierde estabilidad brevemente tras el impacto",
            },
            [2]={
                "los impactos en la pierna hacen que caiga de rodillas",
                "no puede desplazarse con normalidad tras los golpes en la pierna",
                "la zona de la pierna recibe los impactos y el movimiento queda limitado",
                "los golpes en la pierna obligan a apoyarse en algo",
                "la pierna pierde movilidad tras los impactos recibidos",
                "arrastra la pierna al intentar moverse",
            },
            [3]={
                "los múltiples impactos en la pierna dejan en el suelo",
                "cae y no puede levantarse tras los golpes en la pierna",
                "la zona de la pierna acumula los impactos y queda sin respuesta",
                "los golpes repetidos en la pierna la dejan completamente inutilizada",
                "la pierna cede bajo el peso  tras los múltiples impactos",
                "queda en el suelo sin poder sostenerse en pie",
            },
        },
        con = {
            [1]={
                "la rodillera absorbe el impacto pero la pierna pierde estabilidad",
                "la protección en la pierna recibe el golpe y pierde el paso",
                "el impacto en la protección hace que la pierna pierda movilidad momentánea",
                "la rodillera amortigua el golpe pero cojea ligeramente",
                "la protección de la pierna recibe el impacto y retrocede",
            },
            [2]={
                "la protección de la pierna recibe varios golpes y el movimiento se limita",
                "la rodillera absorbe los impactos pero la pierna pierde movilidad",
                "los golpes en la protección de la pierna obligan a apoyarse",
                "la protección resiste pero la pierna pierde fuerza tras los impactos",
                "no puede moverse con normalidad a pesar de la protección",
            },
            [3]={
                "los múltiples impactos en la protección de la pierna la dejan inutilizada",
                "la rodillera cede ante los golpes acumulados y la pierna queda sin respuesta",
                "la pierna queda sin fuerza tras los múltiples impactos en la protección",
                "la protección recibe demasiados golpes y la pierna pierde toda movilidad",
                "cae al suelo a pesar de la protección en la pierna",
            },
        },
    },
    -- ── PIE ──────────────────────────────────────────────────
    pie = {
        sin = {
            [1]={
                "el pie recibe el impacto y pierde el equilibrio",
                "cojea al sentir el golpe en el pie",
                "la zona del pie recibe el impacto y el movimiento se dificulta",
                "el golpe en el pie hace que apoye el peso en el otro",
                "el impacto en el pie obliga a detenerse un momento",
            },
            [2]={
                "los impactos en el pie hacen que no pueda desplazarse",
                "apoya algo cercano al recibir los golpes en el pie",
                "la zona del pie recibe los impactos y el movimiento queda muy limitado",
                "los golpes en el pie obligan a quedarse quieto",
                "el pie pierde movilidad tras los impactos recibidos",
            },
            [3]={
                "los múltiples impactos en el pie dejan en el suelo",
                "cae al no poder sostenerse sobre el pie tras los golpes",
                "la zona del pie acumula los impactos y queda completamente inutilizada",
                "los golpes repetidos en el pie anulan cualquier desplazamiento",
                "queda tirado al perder el apoyo en el pie",
            },
        },
        con = {
            [1]={
                "la protección del pie absorbe el impacto pero pierde el paso",
                "la bota recibe el golpe y pierde el equilibrio brevemente",
                "el impacto en la protección del pie hace que cojee",
                "la protección amortigua el golpe pero se detiene",
                "la bota recibe el impacto y cambia el peso al otro pie",
            },
            [2]={
                "la protección del pie recibe varios golpes y el movimiento queda limitado",
                "la bota absorbe los impactos pero el pie pierde movilidad",
                "los golpes en la protección obligan a quedarse quieto",
                "la protección resiste pero el pie pierde fuerza tras los impactos",
                "no puede desplazarse con normalidad a pesar de la protección",
            },
            [3]={
                "los múltiples impactos en la protección del pie lo dejan inutilizado",
                "la bota cede ante los golpes acumulados y el pie queda sin respuesta",
                "la protección recibe demasiados golpes y cae al suelo",
                "los golpes repetidos anulan el movimiento a pesar de la protección",
                "queda en el suelo sin poder sostenerse",
            },
        },
    },
    -- ── GENERAL (fallback) ────────────────────────────────────
    general = {
        sin = {
            [1]={
                "la zona recibe el impacto y retrocede",
                "pierde el equilibrio al recibir el golpe",
                "el impacto hace que pierda el paso",
                "tambalea al sentir el golpe",
                "la zona afectada recibe el impacto y retrocede un paso",
                "el golpe llega a la zona y pierde estabilidad momentáneamente",
            },
            [2]={
                "los impactos hacen que caiga de rodillas",
                "pierde la postura al recibir los golpes",
                "la zona recibe los impactos y no puede mantenerse en pie",
                "los golpes dejan sin poder reaccionar",
                "tropieza y apoya una mano en el suelo",
            },
            [3]={
                "los múltiples impactos dejan en el suelo",
                "colapsa al recibir demasiados golpes",
                "la zona acumula los impactos y cae",
                "los golpes repetidos anulan por completo la respuesta",
                "queda fuera de combate tras los impactos recibidos",
            },
        },
        con = {
            [1]={
                "la protección absorbe el impacto pero retrocede",
                "el equipo recibe el golpe y pierde el paso",
                "el impacto en la protección hace que pierda estabilidad",
                "la protección amortigua el golpe pero tambalea",
                "el equipo resiste y retrocede por la fuerza",
            },
            [2]={
                "la protección recibe varios golpes y pierde el equilibrio",
                "el equipo absorbe los impactos pero cae de rodillas",
                "los golpes en la protección hacen que tropiece",
                "la protección resiste pero no puede mantenerse en pie",
                "lucha por sostenerse tras los impactos en la protección",
            },
            [3]={
                "los múltiples impactos en la protección obligan a caer",
                "el equipo cede ante los golpes acumulados y colapsa",
                "la protección recibe demasiados golpes y queda en el suelo",
                "los golpes repetidos dejan fuera de combate",
                "cae a pesar de la protección",
            },
        },
    },
}

local PROTEGIDAS = {"chaleco","kevlar","placa","casco","codiera","rodillera","guante táctico","blindaje","hombro con protección","ingle (protección)","axila derecha","axila izquierda"}

local function tieneProteccion(parte)
    local p = parte:lower()
    for _, palabra in ipairs(PROTEGIDAS) do
        if p:find(palabra, 1, true) then return true end
    end
    return false
end

-- getZona definida arriba junto a ZONA_MAP

local function getEfectoNivel(numBalas)
    if numBalas <= 1 then return 1
    elseif numBalas <= 3 then return 2
    else return 3 end
end

local function generarEfecto(parte, numBalas, municion)
    local zona    = getZona(parte)
    local nivel   = getEfectoNivel(numBalas)
    local conProt = tieneProteccion(parte)
    local subtabla = conProt and "con" or "sin"
    local tabla   = EFECTOS[zona] and EFECTOS[zona][subtabla] and EFECTOS[zona][subtabla][nivel]
                    or EFECTOS.general[subtabla][nivel]
    -- Capitalizar primera letra del efecto
    local efecto  = tabla[math.random(#tabla)]
    efecto = efecto:sub(1,1):upper() .. efecto:sub(2)
    return "*"..efecto..".*"
end

-- ============================================================
-- PROCESAR ACCIÓN (v9 — con numBalas y efecto automático)
-- ============================================================
local function Procesar(parte, tipo, extraVic, numBalas)
    numBalas = numBalas or 1
    local vic  = globalOpts.nombreActivo and globalOpts.nombreVal or ""
    local bal  = globalOpts.munActiva    and globalOpts.munVal    or ""
    local vbs  = {"Dispara","Percuta","Acciona","Detona","Descarga","Abre fuego con"}
    local nStr = numBalas == 1 and "bala" or "balas"
    local balLabel = bal ~= "" and ("("..bal..")") or ""

    if tipo=="apuntar" then
        if vic~="" then EnviarAlChat("-apunta a "..parte.." de "..vic.."-")
        else            EnviarAlChat("-apunta a "..parte.."-") end

    elseif tipo=="disparar" then
        local tiros = numBalas == 1 and "1 tiro" or (numBalas.." tiros")
        local msg
        if vic~="" then
            msg="-Efectúa "..tiros.." "..balLabel.." al "..parte.." de "..vic.."-"
        else
            msg="-Efectúa "..tiros.." "..balLabel.." al "..parte.."-"
        end
        EnviarAlChat(msg)
        -- Efecto narrativo ficticio tras 1.8 segundos
        task.delay(1.8, function()
            EnviarAlChat(generarEfecto(parte, numBalas, bal))
        end)

    elseif tipo=="vehiculo_apuntar" then
        local cond=(extraVic and extraVic~="") and (" del vehículo de "..extraVic) or ""
        EnviarAlChat("-apunta a la "..parte..cond.."-")

    elseif tipo=="vehiculo_disparar" then
        local cond=(extraVic and extraVic~="") and (" del vehículo de "..extraVic) or ""
        local tiros = numBalas == 1 and "1 tiro" or (numBalas.." tiros")
        local msg="-Efectúa "..tiros.." "..balLabel.." en la "..parte..cond.."-"
        EnviarAlChat(msg)
        task.delay(1.8, function()
            EnviarAlChat(generarEfecto(parte, numBalas, bal))
        end)

    elseif tipo=="combate" then
        local sufijo=(extraVic and extraVic~="") and (" [entra "..extraVic.."]") or ""
        EnviarAlChat("-"..parte..sufijo.."-")
    else
        EnviarAlChat("-"..parte.."-")
    end
end

-- ============================================================
-- DIAGRAMAS (preservados de v6)
-- ============================================================
local DiagramPanel=Instance.new("Frame",Main)
DiagramPanel.Size=UDim2.new(0,96,0,186); DiagramPanel.Position=UDim2.new(1,-100,0,46)
DiagramPanel.BackgroundColor3=C.panel; DiagramPanel.BorderSizePixel=0; DiagramPanel.Visible=false
corner(DiagramPanel,8); stroke(DiagramPanel,C.border,1,0.4)

local DiagZoneTxt=Instance.new("TextLabel",DiagramPanel)
DiagZoneTxt.Size=UDim2.new(1,-4,0,14); DiagZoneTxt.Position=UDim2.new(0,2,1,-16)
DiagZoneTxt.BackgroundTransparency=1; DiagZoneTxt.TextWrapped=true
DiagZoneTxt.Text=""; DiagZoneTxt.TextColor3=C.dot; DiagZoneTxt.TextSize=7
DiagZoneTxt.Font=Enum.Font.GothamBold; DiagZoneTxt.TextXAlignment=Enum.TextXAlignment.Center

local BodyView=Instance.new("Frame",DiagramPanel)
BodyView.Size=UDim2.new(1,0,1,-16); BodyView.BackgroundTransparency=1; BodyView.BorderSizePixel=0

local function mkSil(p,x,y,w,h,col)
    local f=Instance.new("Frame",p); f.Size=UDim2.new(0,w,0,h); f.Position=UDim2.new(0,x,0,y)
    f.BackgroundColor3=col or C.surfaceAlt; f.BorderSizePixel=0; corner(f,3); return f
end
mkSil(BodyView,31,12,30,28,Color3.fromRGB(40,48,58))
mkSil(BodyView,39,40,14,8, Color3.fromRGB(35,42,52))
mkSil(BodyView,22,48,48,54,Color3.fromRGB(40,48,58))
mkSil(BodyView, 9,48,13,46,Color3.fromRGB(36,44,54))
mkSil(BodyView,70,48,13,46,Color3.fromRGB(36,44,54))
mkSil(BodyView,22,102,21,66,Color3.fromRGB(40,48,58))
mkSil(BodyView,49,102,21,66,Color3.fromRGB(40,48,58))

local BodyDot=Instance.new("Frame",BodyView)
BodyDot.Size=UDim2.new(0,9,0,9); BodyDot.BackgroundColor3=C.dot
BodyDot.BorderSizePixel=0; BodyDot.ZIndex=10; corner(BodyDot,5)
local BodyRing=Instance.new("Frame",BodyView)
BodyRing.Size=UDim2.new(0,15,0,15); BodyRing.BackgroundTransparency=1
BodyRing.BorderSizePixel=0; BodyRing.ZIndex=9; corner(BodyRing,8)
local bRS=Instance.new("UIStroke",BodyRing); bRS.Color=C.dot; bRS.Thickness=1.5; bRS.Transparency=0.3

local CarView=Instance.new("Frame",DiagramPanel)
CarView.Size=UDim2.new(1,0,1,-16); CarView.BackgroundTransparency=1
CarView.BorderSizePixel=0; CarView.Visible=false

local function mkCar(p,x,y,w,h,col,rad)
    local f=Instance.new("Frame",p); f.Size=UDim2.new(0,w,0,h); f.Position=UDim2.new(0,x,0,y)
    f.BackgroundColor3=col; f.BorderSizePixel=0; corner(f,rad or 3); return f
end
mkCar(CarView,18,8,56,148,Color3.fromRGB(38,46,56),8)
mkCar(CarView,24,18,44,40,Color3.fromRGB(28,36,46),4)
mkCar(CarView,24,108,44,30,Color3.fromRGB(28,36,46),4)
mkCar(CarView,4,14,14,24,Color3.fromRGB(22,28,36),5)
mkCar(CarView,74,14,14,24,Color3.fromRGB(22,28,36),5)
mkCar(CarView,4,116,14,24,Color3.fromRGB(22,28,36),5)
mkCar(CarView,74,116,14,24,Color3.fromRGB(22,28,36),5)
mkCar(CarView,45,8,2,148,Color3.fromRGB(50,60,72),0)

local CarDot=Instance.new("Frame",CarView)
CarDot.Size=UDim2.new(0,9,0,9); CarDot.BackgroundColor3=C.dot
CarDot.BorderSizePixel=0; CarDot.ZIndex=10; corner(CarDot,5)
local CarRing=Instance.new("Frame",CarView)
CarRing.Size=UDim2.new(0,15,0,15); CarRing.BackgroundTransparency=1
CarRing.BorderSizePixel=0; CarRing.ZIndex=9; corner(CarRing,8)
local cRS=Instance.new("UIStroke",CarRing); cRS.Color=C.dot; cRS.Thickness=1.5; cRS.Transparency=0.3

local function showDiagram(zona,esAuto)
    local W,H=92,170
    if esAuto then
        BodyView.Visible=false; CarView.Visible=true
        local c=carMap[zona:lower()] or DEFAULT_CAR
        CarDot.Position=UDim2.new(0,math.floor(c[1]*W)-4,0,math.floor(c[2]*H)-4)
        CarRing.Position=UDim2.new(0,math.floor(c[1]*W)-7,0,math.floor(c[2]*H)-7)
    else
        CarView.Visible=false; BodyView.Visible=true
        local c=bodyMap[zona:lower()] or DEFAULT_DOT
        BodyDot.Position=UDim2.new(0,math.floor(c[1]*W)-4,0,math.floor(c[2]*H)-4)
        BodyRing.Position=UDim2.new(0,math.floor(c[1]*W)-7,0,math.floor(c[2]*H)-7)
    end
    DiagZoneTxt.Text=zona:upper(); DiagramPanel.Visible=true
end

local function hideDiagram() DiagramPanel.Visible=false end

-- ============================================================
-- SISTEMA AYUDANTE
-- ============================================================
local MAX_AYUDANTES = 5
local ayudanteData  = {}   -- {gui, minimized, movible, formato, textBox, nombreBox, munBox, nombreOn, munOn}
local ayudantesVisible = true

-- Formatos disponibles
local FORMATOS = {
    {label="-",  pre="-",  suf="-"},
    {label="*",  pre="*",  suf="*"},
    {label=".",  pre=".",  suf="."},
    {label="/",  pre="/",  suf="/"},
    {label="∅",  pre="",   suf=""},
}

local function crearAyudante(idx)
    if ayudanteData[idx] and ayudanteData[idx].gui and ayudanteData[idx].gui.Parent then
        -- Ya existe, solo mostrar
        ayudanteData[idx].gui.Visible=true; return
    end

    local fmtIdx = 1  -- formato activo (índice en FORMATOS)
    local minAy  = false
    local movAy  = true
    local nomOn  = false
    local munOn2 = false

    -- Posición escalonada para que no se sobrepongan
    local ox = 10 + (idx-1)*24
    local oy = 80 + (idx-1)*30

    local gui=Instance.new("Frame",SG)
    gui.Name="Ayudante_"..idx
    gui.Size=UDim2.new(0,200,0,148); gui.Position=UDim2.new(0,ox,0.5,oy)
    gui.BackgroundColor3=C.panel; gui.BorderSizePixel=0
    gui.Active=true; gui.Draggable=true; gui.ClipsDescendants=true; gui.Visible=true
    corner(gui,10); stroke(gui,C.helper,1.5,0.1)

    -- Barra título
    local bar=Instance.new("Frame",gui)
    bar.Size=UDim2.new(1,0,0,30); bar.BackgroundColor3=C.surface; bar.BorderSizePixel=0
    corner(bar,10)
    local bFix=Instance.new("Frame",bar); bFix.Size=UDim2.new(1,0,0.5,0)
    bFix.Position=UDim2.new(0,0,0.5,0); bFix.BackgroundColor3=C.surface; bFix.BorderSizePixel=0

    local bTit=Instance.new("TextLabel",bar)
    bTit.Size=UDim2.new(1,-100,1,0); bTit.Position=UDim2.new(0,10,0,0)
    bTit.BackgroundTransparency=1; bTit.Text="🧩 AYUDANTE "..idx
    bTit.TextColor3=Color3.fromRGB(140,170,255); bTit.TextSize=10; bTit.Font=Enum.Font.GothamBold
    bTit.TextXAlignment=Enum.TextXAlignment.Left

    -- Botón ajustes
    local btnCfg=Instance.new("TextButton",bar)
    btnCfg.Size=UDim2.new(0,24,0,22); btnCfg.Position=UDim2.new(1,-98,0,4)
    btnCfg.Text="⚙"; btnCfg.TextSize=13; btnCfg.Font=Enum.Font.GothamBold
    btnCfg.BackgroundColor3=C.surfaceAlt; btnCfg.TextColor3=C.textDim; btnCfg.BorderSizePixel=0
    corner(btnCfg,5); hoverBtn(btnCfg,C.surfaceAlt,C.panel)

    -- Botón candado
    local btnLck=Instance.new("TextButton",bar)
    btnLck.Size=UDim2.new(0,24,0,22); btnLck.Position=UDim2.new(1,-70,0,4)
    btnLck.Text="🔓"; btnLck.TextSize=11; btnLck.Font=Enum.Font.GothamBold
    btnLck.BackgroundColor3=C.surfaceAlt; btnLck.TextColor3=C.lock_on; btnLck.BorderSizePixel=0
    corner(btnLck,5); hoverBtn(btnLck,C.surfaceAlt,C.panel)

    -- Botón minimizar
    local btnMin=Instance.new("TextButton",bar)
    btnMin.Size=UDim2.new(0,24,0,22); btnMin.Position=UDim2.new(1,-42,0,4)
    btnMin.Text="▼"; btnMin.TextSize=10; btnMin.Font=Enum.Font.GothamBold
    btnMin.BackgroundColor3=C.surfaceAlt; btnMin.TextColor3=C.textDim; btnMin.BorderSizePixel=0
    corner(btnMin,5); hoverBtn(btnMin,C.surfaceAlt,C.panel)

    -- Botón cerrar
    local btnClose=Instance.new("TextButton",bar)
    btnClose.Size=UDim2.new(0,24,0,22); btnClose.Position=UDim2.new(1,-14,0,4)
    btnClose.Text="✕"; btnClose.TextSize=11; btnClose.Font=Enum.Font.GothamBold
    btnClose.BackgroundColor3=C.dangerDim; btnClose.TextColor3=Color3.fromRGB(255,100,100); btnClose.BorderSizePixel=0
    corner(btnClose,5); hoverBtn(btnClose,C.dangerDim,C.danger)

    -- Línea accent
    local aLine=Instance.new("Frame",gui)
    aLine.Size=UDim2.new(1,0,0,1); aLine.Position=UDim2.new(0,0,0,30)
    aLine.BackgroundColor3=C.helper; aLine.BackgroundTransparency=0.5; aLine.BorderSizePixel=0

    -- Indicador de formato activo
    local fmtBadge=Instance.new("TextLabel",gui)
    fmtBadge.Size=UDim2.new(0,30,0,16); fmtBadge.Position=UDim2.new(0,6,0,34)
    fmtBadge.BackgroundColor3=C.helperDim; fmtBadge.BorderSizePixel=0
    fmtBadge.Text=FORMATOS[fmtIdx].label; fmtBadge.TextColor3=Color3.fromRGB(140,170,255)
    fmtBadge.TextSize=10; fmtBadge.Font=Enum.Font.GothamBold
    fmtBadge.TextXAlignment=Enum.TextXAlignment.Center
    corner(fmtBadge,4)

    -- Texto principal
    local txtBox=Instance.new("TextBox",gui)
    txtBox.Size=UDim2.new(1,-14,0,40); txtBox.Position=UDim2.new(0,7,0,33)
    txtBox.BackgroundColor3=C.surface; txtBox.BorderSizePixel=0
    txtBox.PlaceholderText="Escribe aquí tu acción RP..."
    txtBox.PlaceholderColor3=C.textDim; txtBox.Text=""
    txtBox.TextColor3=C.textPrime; txtBox.TextSize=11; txtBox.Font=Enum.Font.Gotham
    txtBox.ClearTextOnFocus=false; txtBox.MultiLine=false
    txtBox.TextXAlignment=Enum.TextXAlignment.Left
    corner(txtBox,6); stroke(txtBox,C.helper,1,0.5)
    txtBox.Focused:Connect(function()   tw(txtBox,{BackgroundColor3=Color3.fromRGB(14,18,30)}) end)
    txtBox.FocusLost:Connect(function() tw(txtBox,{BackgroundColor3=C.surface}) end)

    -- Toggles nombre/munición del ayudante
    local togNom=Instance.new("TextButton",gui)
    togNom.Size=UDim2.new(0.48,0,0,18); togNom.Position=UDim2.new(0,7,0,78)
    togNom.Text="👤 Nombre"; togNom.TextSize=9; togNom.Font=Enum.Font.GothamBold
    togNom.BackgroundColor3=C.surface; togNom.TextColor3=C.textDim; togNom.BorderSizePixel=0
    corner(togNom,5)

    local togMun=Instance.new("TextButton",gui)
    togMun.Size=UDim2.new(0.48,0,0,18); togMun.Position=UDim2.new(0.52,-7,0,78)
    togMun.Text="🔫 Munición"; togMun.TextSize=9; togMun.Font=Enum.Font.GothamBold
    togMun.BackgroundColor3=C.surface; togMun.TextColor3=C.textDim; togMun.BorderSizePixel=0
    corner(togMun,5)

    local nomBoxAy=Instance.new("TextBox",gui)
    nomBoxAy.Size=UDim2.new(0.48,0,0,18); nomBoxAy.Position=UDim2.new(0,7,0,100)
    nomBoxAy.BackgroundColor3=C.surface; nomBoxAy.BorderSizePixel=0
    nomBoxAy.PlaceholderText="Nombre..."; nomBoxAy.PlaceholderColor3=C.textDim
    nomBoxAy.Text=""; nomBoxAy.TextColor3=C.textAccent; nomBoxAy.TextSize=9
    nomBoxAy.Font=Enum.Font.Gotham; nomBoxAy.ClearTextOnFocus=false; nomBoxAy.Visible=false
    corner(nomBoxAy,5); stroke(nomBoxAy,C.accentDim,1,0.4)

    local munBoxAy=Instance.new("TextBox",gui)
    munBoxAy.Size=UDim2.new(0.48,0,0,18); munBoxAy.Position=UDim2.new(0.52,-7,0,100)
    munBoxAy.BackgroundColor3=C.surface; munBoxAy.BorderSizePixel=0
    munBoxAy.PlaceholderText="Munición..."; munBoxAy.PlaceholderColor3=C.textDim
    munBoxAy.Text=""; munBoxAy.TextColor3=Color3.fromRGB(255,190,80); munBoxAy.TextSize=9
    munBoxAy.Font=Enum.Font.Gotham; munBoxAy.ClearTextOnFocus=false; munBoxAy.Visible=false
    corner(munBoxAy,5); stroke(munBoxAy,Color3.fromRGB(120,80,20),1,0.4)

    -- Botón ENVIAR en panel inferior (siempre en posicion fija)
    local sendPanel=Instance.new("Frame",gui)
    sendPanel.Size=UDim2.new(1,0,0,30); sendPanel.Position=UDim2.new(0,0,1,-30)
    sendPanel.BackgroundColor3=C.panel; sendPanel.BorderSizePixel=0
    local sFix=Instance.new("Frame",sendPanel); sFix.Size=UDim2.new(1,0,0.5,0)
    sFix.BackgroundColor3=C.panel; sFix.BorderSizePixel=0
    local btnSend=Instance.new("TextButton",sendPanel)
    btnSend.Size=UDim2.new(1,-10,0,24); btnSend.Position=UDim2.new(0,5,0,3)
    btnSend.Text="➤ ENVIAR"; btnSend.TextSize=10; btnSend.Font=Enum.Font.GothamBold
    btnSend.BackgroundColor3=C.helperDim; btnSend.TextColor3=Color3.fromRGB(140,170,255)
    btnSend.BorderSizePixel=0; corner(btnSend,6)
    hoverBtn(btnSend,C.helperDim,C.helper)

    -- Panel ajustes (formatos)
    local cfgPanel=Instance.new("Frame",gui)
    cfgPanel.Size=UDim2.new(1,-6,0,56); cfgPanel.Position=UDim2.new(0,3,0,30)
    cfgPanel.BackgroundColor3=C.bg; cfgPanel.BorderSizePixel=0
    cfgPanel.Visible=false; corner(cfgPanel,8); stroke(cfgPanel,C.helper,1,0.4)
    cfgPanel.ZIndex=20

    local cfgLbl=Instance.new("TextLabel",cfgPanel)
    cfgLbl.Size=UDim2.new(1,0,0,16); cfgLbl.BackgroundTransparency=1
    cfgLbl.Text="FORMATO DE ENVÍO:"; cfgLbl.TextColor3=C.textDim
    cfgLbl.TextSize=8; cfgLbl.Font=Enum.Font.GothamBold
    cfgLbl.TextXAlignment=Enum.TextXAlignment.Left
    cfgLbl.Position=UDim2.new(0,6,0,2)

    local fmtBtns={}
    for fi, fmt in ipairs(FORMATOS) do
        local fb=Instance.new("TextButton",cfgPanel)
        fb.Size=UDim2.new(0,32,0,24); fb.Position=UDim2.new(0,(fi-1)*36+4,0,20)
        fb.Text=fmt.label=="∅" and "Nada" or fmt.pre.."x"..fmt.suf
        fb.TextSize=9; fb.Font=Enum.Font.GothamBold; fb.BorderSizePixel=0
        fb.BackgroundColor3=(fi==fmtIdx) and C.helperDim or C.surface
        fb.TextColor3=(fi==fmtIdx) and Color3.fromRGB(140,170,255) or C.textDim
        corner(fb,5); fb.ZIndex=21
        fmtBtns[fi]=fb
        fb.MouseButton1Click:Connect(function()
            fmtIdx=fi
            fmtBadge.Text=fmt.label
            for j,b2 in ipairs(fmtBtns) do
                tw(b2,{BackgroundColor3=(j==fi) and C.helperDim or C.surface},TI_fast)
                tw(b2,{TextColor3=(j==fi) and Color3.fromRGB(140,170,255) or C.textDim},TI_fast)
            end
            cfgPanel.Visible=false
        end)
    end

    -- Altura completa del ayudante (puede cambiar si están activos nombre/munición)
    local function recalcHeight()
        local base = 118
        if nomOn then base = base + 20 end
        if munOn2 then base = base + 20 end
        if not minAy then
            tw(gui,{Size=UDim2.new(0,200,0,base)},TI_fast)
        end
    end

    -- Toggle nom/mun
    togNom.MouseButton1Click:Connect(function()
        nomOn=not nomOn; nomBoxAy.Visible=nomOn
        tw(togNom,{BackgroundColor3=nomOn and C.accentDim or C.surface},TI_fast)
        tw(togNom,{TextColor3=nomOn and C.textAccent or C.textDim},TI_fast)
        recalcHeight()
    end)
    togMun.MouseButton1Click:Connect(function()
        munOn2=not munOn2; munBoxAy.Visible=munOn2
        tw(togMun,{BackgroundColor3=munOn2 and Color3.fromRGB(80,50,10) or C.surface},TI_fast)
        tw(togMun,{TextColor3=munOn2 and Color3.fromRGB(255,190,80) or C.textDim},TI_fast)
        recalcHeight()
    end)

    -- Enviar
    local function doSendAy()
        local texto=txtBox.Text
        if texto=="" then return end
        local fmt=FORMATOS[fmtIdx]
        local pre=fmt.pre; local suf=fmt.suf
        -- Añadir nombre si activo
        if nomOn and nomBoxAy.Text~="" then
            texto=texto.." de "..nomBoxAy.Text
        end
        -- Añadir munición si activo
        if munOn2 and munBoxAy.Text~="" then
            texto=texto.." ("..munBoxAy.Text..")"
        end
        EnviarAlChat(pre..texto..suf)
        txtBox.Text=""
    end
    btnSend.MouseButton1Click:Connect(doSendAy)
    txtBox.FocusLost:Connect(function(enter) if enter then doSendAy() end end)

    -- Ajustes toggle
    btnCfg.MouseButton1Click:Connect(function()
        cfgPanel.Visible=not cfgPanel.Visible
    end)

    -- Candado
    btnLck.MouseButton1Click:Connect(function()
        movAy=not movAy; gui.Draggable=movAy
        btnLck.Text=movAy and "🔓" or "🔒"
        tw(btnLck,{TextColor3=movAy and C.lock_on or C.lock_off},TI_med)
    end)

    -- Minimizar (colapsa a barra pero deja el botón enviar visible en la barra)
    btnMin.MouseButton1Click:Connect(function()
        minAy=not minAy
        if minAy then
            -- Solo barra: 30px (sendPanel queda oculto por ClipsDescendants)
            tw(gui,{Size=UDim2.new(0,200,0,30)},TI_slow)
            btnMin.Text="▲"
        else
            recalcHeight()
            btnMin.Text="▼"
        end
    end)

    -- Cerrar
    btnClose.MouseButton1Click:Connect(function()
        tw(gui,{BackgroundTransparency=1},TI_med)
        task.delay(0.25,function() gui.Visible=false end)
    end)

    -- Fade in
    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)

    ayudanteData[idx]={
        gui=gui, txtBox=txtBox, fmtBadge=fmtBadge,
        nomBoxAy=nomBoxAy, munBoxAy=munBoxAy
    }
end

-- ============================================================
-- POPUP "AÑADIR AL AYUDANTE"
-- ============================================================
local function mostrarPopupAyudante(texto)
    -- Cerrar popups anteriores
    for _,v in ipairs(SG:GetChildren()) do
        if v.Name=="PopupAyudante" then v:Destroy() end
    end

    local pop=Instance.new("Frame",SG)
    pop.Name="PopupAyudante"
    pop.Size=UDim2.new(0,200,0,160); pop.Position=UDim2.new(0.5,-100,0.5,-80)
    pop.BackgroundColor3=C.panel; pop.BorderSizePixel=0; pop.Active=true
    corner(pop,10); stroke(pop,C.helper,1.5,0.15)

    local pTit=Instance.new("TextLabel",pop)
    pTit.Size=UDim2.new(1,0,0,28); pTit.BackgroundTransparency=1
    pTit.Text="Mover al Ayudante:"; pTit.TextColor3=Color3.fromRGB(140,170,255)
    pTit.TextSize=10; pTit.Font=Enum.Font.GothamBold

    local pClose=Instance.new("TextButton",pop)
    pClose.Size=UDim2.new(0,22,0,20); pClose.Position=UDim2.new(1,-24,0,4)
    pClose.Text="✕"; pClose.TextSize=10; pClose.Font=Enum.Font.GothamBold
    pClose.BackgroundColor3=C.dangerDim; pClose.TextColor3=Color3.fromRGB(255,100,100)
    pClose.BorderSizePixel=0; corner(pClose,4)
    pClose.MouseButton1Click:Connect(function() pop:Destroy() end)

    for i=1,MAX_AYUDANTES do
        local b=Instance.new("TextButton",pop)
        b.Size=UDim2.new(1,-12,0,22); b.Position=UDim2.new(0,6,0,28+(i-1)*26)
        b.Text="🧩 Ayudante "..i; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
        b.BackgroundColor3=C.helperDim; b.TextColor3=Color3.fromRGB(140,170,255)
        b.BorderSizePixel=0; corner(b,6)
        hoverBtn(b,C.helperDim,C.helper)
        b.MouseButton1Click:Connect(function()
            -- Crear ayudante si no existe
            crearAyudante(i)
            -- Poner el texto
            if ayudanteData[i] and ayudanteData[i].txtBox then
                ayudanteData[i].txtBox.Text=texto
                ayudanteData[i].gui.Visible=true
            end
            pop:Destroy()
            showToast("✓ Acción en Ayudante "..i, C.textAccent)
        end)
    end

    pop.BackgroundTransparency=1; tw(pop,{BackgroundTransparency=0},TI_slow)
end

-- ============================================================
-- CREADOR DE BLOQUES (con botón ➕ ayudante)
-- ============================================================
local layoutOrder=0

local function crearBloque(texto, tipo, catKey)
    layoutOrder=layoutOrder+1
    local esCombate=(tipo=="combate")
    local isMedical=(tipo=="medical")
    local isSignal =(tipo=="signal")
    local isVeh    =(tipo=="vehiculo")

    local hdrCol=
        (esCombate and C.combat)   or
        (isMedical and C.medical)  or
        (isSignal  and C.signal)   or
        (isVeh     and Color3.fromRGB(80,140,200)) or
        C.accent

    -- Altura: vehículo/combate tienen campo extra
    local blkH=(isVeh or esCombate) and 108 or 88

    local f=Instance.new("Frame",Scroll)
    f.Size=UDim2.new(1,-2,0,blkH); f.BackgroundColor3=C.surfaceAlt
    f.BorderSizePixel=0; f.Name=texto; f.LayoutOrder=layoutOrder
    corner(f,7); stroke(f,C.border,1,0.55)

    f.MouseEnter:Connect(function() showDiagram(texto,isVeh) end)
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
    lbl.Size=UDim2.new(1,-36,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=texto:upper()
    lbl.TextColor3=hdrCol; lbl.TextSize=9; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextTruncate=Enum.TextTruncate.AtEnd

    -- Botón ➕ en el header
    local addBtn=Instance.new("TextButton",hdr)
    addBtn.Size=UDim2.new(0,28,0,18); addBtn.Position=UDim2.new(1,-30,0,3)
    addBtn.Text="➕"; addBtn.TextSize=10; addBtn.Font=Enum.Font.GothamBold
    addBtn.BackgroundColor3=C.helperDim; addBtn.TextColor3=Color3.fromRGB(140,170,255)
    addBtn.BorderSizePixel=0; corner(addBtn,4)
    hoverBtn(addBtn,C.helperDim,C.helper)
    addBtn.MouseButton1Click:Connect(function()
        -- Construir texto de acción para el ayudante
        local textoAy = texto
        if tipo == "apuntar" then
            textoAy = "apunta a "..texto
        elseif tipo == "disparar" then
            textoAy = "dispara al "..texto
        elseif tipo == "vehiculo_apuntar" then
            textoAy = "apunta a la "..texto
        elseif tipo == "vehiculo_disparar" then
            textoAy = "dispara en la "..texto
        end
        mostrarPopupAyudante(textoAy)
    end)

    -- Botones acción según tipo
    if isVeh then
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
        b1.MouseButton1Click:Connect(function() Procesar(texto,"vehiculo_apuntar",condInput.Text) end)

        -- Selector balas vehículo
        local numBalasV=1; local balBtnsV={}
        local sRowV=Instance.new("Frame",f)
        sRowV.Size=UDim2.new(1,-4,0,16); sRowV.Position=UDim2.new(0,2,0,34)
        sRowV.BackgroundColor3=C.bg; sRowV.BorderSizePixel=0; corner(sRowV,4)
        local sLayV=Instance.new("UIListLayout",sRowV)
        sLayV.FillDirection=Enum.FillDirection.Horizontal; sLayV.Padding=UDim.new(0,2)
        local sPadV=Instance.new("UIPadding",sRowV); sPadV.PaddingLeft=UDim.new(0,3)
        for i=1,10 do
            local bb=Instance.new("TextButton",sRowV)
            bb.Size=UDim2.new(0,28,0,12); bb.Text=tostring(i)
            bb.TextSize=7; bb.Font=Enum.Font.GothamBold; bb.BorderSizePixel=0
            bb.BackgroundColor3=(i==1) and C.shoot or C.surface
            bb.TextColor3=(i==1) and Color3.fromRGB(255,140,140) or C.textDim
            corner(bb,3); balBtnsV[i]=bb
            bb.MouseButton1Click:Connect(function()
                numBalasV=i
                for j,btn in ipairs(balBtnsV) do
                    tw(btn,{BackgroundColor3=j==i and C.shoot or C.surface},TI_fast)
                    tw(btn,{TextColor3=j==i and Color3.fromRGB(255,140,140) or C.textDim},TI_fast)
                end
            end)
        end
        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.new(0.5,-4,0,34); b2.Position=UDim2.new(0.5,2,0,50)
        b2.Text="💥  DISPARAR"; b2.TextSize=10; b2.Font=Enum.Font.GothamSemibold
        b2.BackgroundColor3=C.shoot; b2.TextColor3=Color3.fromRGB(255,140,140); b2.BorderSizePixel=0
        corner(b2,6); hoverBtn(b2,C.shoot,C.shootHover)
        b2.MouseButton1Click:Connect(function() Procesar(texto,"vehiculo_disparar",condInput.Text,numBalasV) end)

    elseif esCombate then
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
        b.MouseButton1Click:Connect(function() Procesar(texto,"combate",meterInput.Text) end)

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
        -- Selector de balas (1-10)
        local numBalas = 1
        local balasBtns = {}
        local selectorRow = Instance.new("Frame",f)
        selectorRow.Size=UDim2.new(1,-4,0,20); selectorRow.Position=UDim2.new(0,2,0,28)
        selectorRow.BackgroundColor3=C.bg; selectorRow.BorderSizePixel=0; corner(selectorRow,4)
        local selLay=Instance.new("UIListLayout",selectorRow)
        selLay.FillDirection=Enum.FillDirection.Horizontal; selLay.Padding=UDim.new(0,2)
        selLay.VerticalAlignment=Enum.VerticalAlignment.Center
        local selPad=Instance.new("UIPadding",selectorRow)
        selPad.PaddingLeft=UDim.new(0,3); selPad.PaddingTop=UDim.new(0,2)

        for i=1,10 do
            local bb=Instance.new("TextButton",selectorRow)
            bb.Size=UDim2.new(0,34,0,16); bb.Text=tostring(i)
            bb.TextSize=8; bb.Font=Enum.Font.GothamBold; bb.BorderSizePixel=0
            bb.BackgroundColor3=(i==1) and C.shoot or C.surface
            bb.TextColor3=(i==1) and Color3.fromRGB(255,140,140) or C.textDim
            corner(bb,4)
            balasBtns[i]=bb
            bb.MouseButton1Click:Connect(function()
                numBalas=i
                for j,btn in ipairs(balasBtns) do
                    tw(btn,{BackgroundColor3=j==i and C.shoot or C.surface},TI_fast)
                    tw(btn,{TextColor3=j==i and Color3.fromRGB(255,140,140) or C.textDim},TI_fast)
                end
            end)
        end

        local b1=Instance.new("TextButton",f)
        b1.Size=UDim2.new(0.5,-4,0,32); b1.Position=UDim2.new(0,2,0,50)
        b1.Text="🎯  APUNTAR"; b1.TextSize=10; b1.Font=Enum.Font.GothamSemibold
        b1.BackgroundColor3=C.aim; b1.TextColor3=Color3.fromRGB(140,255,200); b1.BorderSizePixel=0
        corner(b1,6); hoverBtn(b1,C.aim,C.aimHover)
        b1.MouseButton1Click:Connect(function() Procesar(texto,"apuntar",nil,1) end)

        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.new(0.5,-4,0,32); b2.Position=UDim2.new(0.5,2,0,50)
        b2.Text="💥  DISPARAR"; b2.TextSize=10; b2.Font=Enum.Font.GothamSemibold
        b2.BackgroundColor3=C.shoot; b2.TextColor3=Color3.fromRGB(255,140,140); b2.BorderSizePixel=0
        corner(b2,6); hoverBtn(b2,C.shoot,C.shootHover)
        b2.MouseButton1Click:Connect(function() Procesar(texto,"disparar",nil,numBalas) end)
    end
    return f
end

-- ============================================================
-- MINI-GUI SCRIPTS (preservada)
-- ============================================================
local function crearMiniChat(titulo, prefijo, sufijo)
    prefijo=prefijo or ""; sufijo=sufijo or ""
    local gui=Instance.new("Frame",SG)
    gui.Size=UDim2.new(0,300,0,112); gui.Position=UDim2.new(0.5,-150,1,-120)
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
    inp.Size=UDim2.new(1,-10,0,40); inp.Position=UDim2.new(0,5,0,32)
    inp.BackgroundColor3=C.surface; inp.BorderSizePixel=0
    inp.PlaceholderText="  Escribe aquí..."; inp.PlaceholderColor3=C.textDim
    inp.Text=""; inp.TextColor3=C.textPrime; inp.TextSize=11; inp.Font=Enum.Font.Gotham
    inp.ClearTextOnFocus=false; inp.MultiLine=false; inp.TextXAlignment=Enum.TextXAlignment.Left
    corner(inp,6); stroke(inp,C.script_c,1,0.4)
    local snd=Instance.new("TextButton",gui)
    snd.Size=UDim2.new(1,-10,0,26); snd.Position=UDim2.new(0,5,0,78)
    snd.Text="  ➤  ENVIAR"; snd.TextSize=10; snd.Font=Enum.Font.GothamBold
    snd.BackgroundColor3=C.scriptDim; snd.TextColor3=Color3.fromRGB(100,180,255); snd.BorderSizePixel=0
    corner(snd,6); hoverBtn(snd,C.scriptDim,C.script_c)
    local function doS()
        local m=inp.Text; if m~="" then EnviarAlChat(prefijo..m..sufijo); inp.Text="" end
    end
    snd.MouseButton1Click:Connect(doS)
    inp.FocusLost:Connect(function(e) if e then doS() end end)
    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)
end

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
-- ARMERÍA (preservada de v6)
-- ============================================================
local armasData={
    ["AR-15"]={icon="🔫",pasos={
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
    }}
}
local armaProgreso={}

local function crearGuiArma(nombreArma,datos)
    if SG:FindFirstChild("ArmaGUI_"..nombreArma) then return end
    armaProgreso[nombreArma]=armaProgreso[nombreArma] or 0
    local gui=Instance.new("Frame",SG); gui.Name="ArmaGUI_"..nombreArma
    gui.Size=UDim2.new(0,340,0,420); gui.Position=UDim2.new(0.5,60,0.5,-210)
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
    local cA=Instance.new("TextButton",bar); cA.Size=UDim2.new(0,24,0,22); cA.Position=UDim2.new(1,-28,0,6)
    cA.Text="✕"; cA.TextSize=11; cA.Font=Enum.Font.GothamBold
    cA.BackgroundColor3=C.dangerDim; cA.TextColor3=Color3.fromRGB(255,100,100); cA.BorderSizePixel=0
    corner(cA,4); hoverBtn(cA,C.dangerDim,C.danger)
    cA.MouseButton1Click:Connect(function()
        tw(gui,{BackgroundTransparency=1},TI_med); task.delay(0.22,function() gui:Destroy() end)
    end)
    local aLine=Instance.new("Frame",gui); aLine.Size=UDim2.new(1,0,0,1); aLine.Position=UDim2.new(0,0,0,34)
    aLine.BackgroundColor3=C.armory; aLine.BackgroundTransparency=0.4; aLine.BorderSizePixel=0
    local pLbl=Instance.new("TextLabel",gui); pLbl.Size=UDim2.new(1,-12,0,18); pLbl.Position=UDim2.new(0,6,0,38)
    pLbl.BackgroundTransparency=1; pLbl.TextColor3=C.textDim; pLbl.TextSize=9; pLbl.Font=Enum.Font.Gotham
    pLbl.TextXAlignment=Enum.TextXAlignment.Left
    pLbl.Text="PASO "..armaProgreso[nombreArma].." / "..#datos.pasos
    local sc=Instance.new("ScrollingFrame",gui)
    sc.Size=UDim2.new(1,-12,0,334); sc.Position=UDim2.new(0,6,0,60)
    sc.BackgroundColor3=C.bg; sc.BorderSizePixel=0
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y; sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.ScrollBarThickness=3; sc.ScrollBarImageColor3=C.armory; corner(sc,8)
    local scL=Instance.new("UIListLayout",sc); scL.Padding=UDim.new(0,5)
    local scP=Instance.new("UIPadding",sc)
    scP.PaddingLeft=UDim.new(0,5); scP.PaddingRight=UDim.new(0,5); scP.PaddingTop=UDim.new(0,5)
    local resetBtn=Instance.new("TextButton",gui)
    resetBtn.Size=UDim2.new(1,-12,0,22); resetBtn.Position=UDim2.new(0,6,1,-28)
    resetBtn.Text="↺  REINICIAR PROTOCOLO"; resetBtn.TextSize=9; resetBtn.Font=Enum.Font.GothamBold
    resetBtn.BackgroundColor3=C.armoryDim; resetBtn.TextColor3=Color3.fromRGB(255,185,80)
    resetBtn.BorderSizePixel=0; corner(resetBtn,6); hoverBtn(resetBtn,C.armoryDim,C.armory)
    local pasoBtns={}
    for i,paso in ipairs(datos.pasos) do
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
        pLblR.BackgroundTransparency=1; pLblR.TextWrapped=true; pLblR.Text=paso
        pLblR.TextColor3=C.textPrime; pLblR.TextSize=8; pLblR.Font=Enum.Font.Gotham
        pLblR.TextXAlignment=Enum.TextXAlignment.Left; pLblR.TextYAlignment=Enum.TextYAlignment.Top
        local eBtn=Instance.new("TextButton",row)
        eBtn.Size=UDim2.new(0,58,0,38); eBtn.Position=UDim2.new(1,-62,0,7)
        eBtn.TextSize=9; eBtn.Font=Enum.Font.GothamBold; eBtn.BorderSizePixel=0; corner(eBtn,5)
        local done=i<=armaProgreso[nombreArma]
        if done then eBtn.Text="✓ HECHO"; eBtn.BackgroundColor3=C.accentDim; eBtn.TextColor3=C.accent
        else eBtn.Text="▶ HACER"; eBtn.BackgroundColor3=C.armoryDim; eBtn.TextColor3=Color3.fromRGB(255,185,80)
            hoverBtn(eBtn,C.armoryDim,C.armory) end
        pasoBtns[i]={btn=eBtn,lbl=pLblR,done=done}
        local idx=i
        eBtn.MouseButton1Click:Connect(function()
            if idx~=armaProgreso[nombreArma]+1 then
                tw(eBtn,{BackgroundColor3=C.danger},TI_fast)
                task.delay(0.22,function() tw(eBtn,{BackgroundColor3=C.armoryDim},TI_fast) end); return
            end
            EnviarAlChat(paso); armaProgreso[nombreArma]=armaProgreso[nombreArma]+1
            tw(eBtn,{BackgroundColor3=C.accentDim},TI_med); eBtn.Text="✓ HECHO"
            tw(eBtn,{TextColor3=C.accent},TI_med); tw(pLblR,{TextColor3=C.textDim},TI_med)
            pasoBtns[idx].done=true; pLbl.Text="PASO "..armaProgreso[nombreArma].." / "..#datos.pasos
        end)
    end
    resetBtn.MouseButton1Click:Connect(function()
        armaProgreso[nombreArma]=0; pLbl.Text="PASO 0 / "..#datos.pasos
        for i,d in ipairs(pasoBtns) do
            d.btn.Text="▶ HACER"; tw(d.btn,{BackgroundColor3=C.armoryDim},TI_fast)
            tw(d.btn,{TextColor3=Color3.fromRGB(255,185,80)},TI_fast)
            tw(d.lbl,{TextColor3=C.textPrime},TI_fast); d.done=false
        end
    end)
    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)
end

local function crearBloqueArma(nombreArma,datos)
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
-- DATABASE COMPLETA (v6)
-- ============================================================
local database={
    ["👤"]={"hombro derecho","hombro izquierdo","brazo derecho","brazo izquierdo","antebrazo derecho","antebrazo izquierdo","codo derecho","codo izquierdo","muñeca derecha","muñeca izquierda","mano derecha","mano izquierda","dedos mano der","dedos mano izq","pecho superior","pecho inferior","abdomen","ingle","muslo derecho","muslo izquierdo","rodilla derecha","rodilla izquierda","pantorrilla derecha","pantorrilla izquierda","tobillo derecho","tobillo izquierdo","pie derecho","pie izquierdo","costilla flotante der","costilla flotante izq","clavícula der","clavícula izq","esternón","ombligo","zona lumbar","sacro","escápula der","escápula izq","bíceps der","bíceps izq","tríceps der","tríceps izq","cuádriceps der","cuádriceps izq","isquiotibial der","isquiotibial izq"},
    ["🥷"]={"frente","ojo derecho","ojo izquierdo","mandíbula","mejilla der","mejilla izq","oreja der","oreja izq","nuca","cuello frontal","cuello lateral der","cuello lateral izq","tráquea","nuez de adán","sien derecha","sien izquierda","tabique nasal","labio superior","labio inferior","barbilla","pómulo der","pómulo izq","arco superciliar der","arco superciliar izq"},
    ["🛡️"]={"placa pectoral chaleco","placa dorsal chaleco","kevlar lateral der","kevlar lateral izq","hombro con protección der","hombro con protección izq","casco (visera)","casco (nuca)","casco (lateral)","axila derecha","axila izquierda","ingle (protección)","rodillera der","rodillera izq","codiera der","codiera izq","guante táctico der","guante táctico izq"},
    ["🚗"]={"llanta del der","llanta del izq","llanta tras der","llanta tras izq","motor","radiador","batería","alternador","tanque de gas","parabrisas","medallón trasero","ventanilla cond","ventanilla copiloto","pilar A","pilar B","bloque motor","manguera frenos","disco de freno","amortiguador","faro delantero der","faro delantero izq","calavera trasera","capó","cajuela","espejo retrovisor","palanca de cambios","volante","pedal de freno","asiento del conductor"},
    ["💎"]={"cristal blindado N3","puerta blindada","junta de puerta","bisagra superior","bisagra inferior","mirilla táctica","motor parte baja","neumático run-flat","placa de piso antiexplosión","turret (base)","turret (cañón)","escotilla superior"},
    ["🥋"]={"golpea nariz","golpea hígado","golpea bazo","golpea plexo solar","gancho al mentón","patada baja muslo","patea espinilla","barrida de pierna","luxa muñeca der","luxa muñeca izq","llave de brazo der","llave de brazo izq","estrangulación trasera","presiona nuca contra suelo","tuerce dedos mano","derribo tacleada","proyecta hacia la pared","empuja fuerte al pecho","pisa el pie derecho","pisa el pie izquierdo","golpea el codo contra el esternón","rodillazo al muslo","empuja la cabeza hacia atrás","jala del cabello","toma del cuello con una mano","aplica llave de cabeza","golpea el hombro con el codo","patea detrás de la rodilla","tira al suelo por la pierna","gira el brazo hacia atrás","presiona el pulgar en la palma","bloquea el puño y contraataca","esquiva el golpe y empuja","engancha la pierna y voltea","aplica presión en el antebrazo","golpea con la palma abierta","aplica palanca de muñeca en 90°","dobla el dedo meñique hacia atrás","presiona el punto nervioso en el cuello (costado)","golpea el nervio peroneo","bloquea el codo extendido y empuja","empuja hacia atrás del talón","derriba con barrido frontal de pierna","aplica triángulo de piernas al suelo"},
    ["🏥"]={"aplica presión directa en la herida","coloca torniquete en el brazo der","coloca torniquete en el brazo izq","coloca torniquete en la pierna der","coloca torniquete en la pierna izq","aplica venda hemostática","sella el neumotórax con parche oclusivo","abre la vía aérea","aplica respiración de rescate","inicia compresiones cardíacas","administra adrenalina (epi-pen)","aplica vendaje en figura de 8 (tobillo)","inmoviliza la columna cervical","aplica férula en el brazo","aplica férula en la pierna","limpia la herida con solución salina","aplica coagulante en polvo (QuikClot)","cubre quemadura con gasa húmeda","verifica pulso carotídeo","verifica pupilas","evalúa nivel de consciencia (AVPU)","coloca en posición lateral de seguridad","aplica manta térmica","administra analgésico oral","registra la hora del torniquete","retira proyectil superficial con pinzas","aplica vendaje compresivo en el muslo","eleva el miembro lesionado 30°","aplica compresa fría en la contusión","verifica temperatura corporal","administra suero oral al paciente","aplica parche ocular de emergencia","inmoviliza la mandíbula con venda","tapa la herida abierta en el pecho","verifica la permeabilidad de la vía aérea","posiciona al paciente en decúbito supino"},
    ["🤟"]={"levanta el puño cerrado (alto/pausa)","señala con el dedo índice hacia adelante (avanzar)","mueve la mano hacia abajo con palma abierta (bajar velocidad/quieto)","señala dos dedos hacia los ojos (vigilar/observar)","hace círculo con el dedo índice (reagruparse)","señala con tres dedos hacia la izquierda (flanquear izquierda)","señala con tres dedos hacia la derecha (flanquear derecha)","hace la señal de corte en el cuello (cancelar/abortar)","mueve el dedo índice en zigzag (peligro al frente)","señala con pulgar hacia abajo (negativo/no)","señala con pulgar hacia arriba (positivo/afirmativo)","toca el hombro propio (conmigo)","abre y cierra la mano (hostigamiento)","señala el oído con un dedo (escucha)","señala los ojos con dos dedos (tengo visual)","extiende la palma hacia el equipo (esperar aquí)","señala con el dedo al suelo (cubrir posición)","hace la V con los dedos (refuerzo necesario)","cruza los brazos sobre el pecho (zona segura)","señala el arma y luego al suelo (descargar/asegurar arma)","señala el reloj y levanta 2 dedos (2 minutos)","hace señal de techo con las manos (cubierto/edificio)","señala al frente con mano abierta y apunta arriba (objetivo en alto)","lleva el puño al pecho y lo extiende (romper contacto)","señala con 4 dedos hacia adelante (4 hombres al frente)","hace cuña con ambas manos (formación cuña)","señala en línea horizontal (formación en línea)","señala en fila vertical (formación en fila india)"},
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
local tipoMap={
    ["👤"]="normal",["🥷"]="normal",["🛡️"]="normal",
    ["🚗"]="vehiculo",["💎"]="vehiculo",
    ["🥋"]="combate",["🏥"]="medical",["🤟"]="signal",
}
for cat,lista in pairs(database) do
    for _,v in ipairs(lista) do crearBloque(v,tipoMap[cat] or "normal",cat) end
end
crearBloqueScript("Textbox (Chat libre)","CHAT LIBRE","","")
crearBloqueScript("Textbox (Comillas)","TEXTBOX CON COMILLAS",'"','"')
crearBloqueScript("Textbox (Guiones)","TEXTBOX CON GUIONES","-","-")
for arma,datos in pairs(armasData) do crearBloqueArma(arma,datos) end

-- ============================================================
-- SIDEBAR TÁCTIL
-- ============================================================
local emos={"👤","🥷","🛡️","🚗","💎","🥋","🏥","🤟","📜","🔧"}

local SideClip=Instance.new("Frame",Main)
SideClip.Size=UDim2.new(0,58,0,310); SideClip.Position=UDim2.new(0,4,0,46)
SideClip.BackgroundColor3=C.surface; SideClip.BorderSizePixel=0; SideClip.ClipsDescendants=true
corner(SideClip,8); stroke(SideClip,C.border,1,0.5)

local SideScroll=Instance.new("ScrollingFrame",SideClip)
SideScroll.Size=UDim2.new(1,0,1,0); SideScroll.BackgroundTransparency=1; SideScroll.BorderSizePixel=0
SideScroll.ScrollBarThickness=2; SideScroll.ScrollBarImageColor3=C.accent
SideScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; SideScroll.CanvasSize=UDim2.new(0,0,0,0)
SideScroll.ScrollingDirection=Enum.ScrollingDirection.Y
local sLay=Instance.new("UIListLayout",SideScroll); sLay.Padding=UDim.new(0,3)
local sPad=Instance.new("UIPadding",SideScroll)
sPad.PaddingTop=UDim.new(0,4); sPad.PaddingBottom=UDim.new(0,4)
sPad.PaddingLeft=UDim.new(0,4); sPad.PaddingRight=UDim.new(0,4)

for _,emo in ipairs(emos) do
    local b=Instance.new("TextButton",SideScroll)
    b.Size=UDim2.new(1,0,0,46); b.Text=emo; b.TextSize=22
    b.BackgroundColor3=C.surfaceAlt; b.BorderSizePixel=0; corner(b,6)
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
                if c:IsA("Frame") and (c.Name=="Textbox (Chat libre)" or c.Name=="Textbox (Comillas)" or c.Name=="Textbox (Guiones)") then
                    c.Visible=true end
            end
        elseif emo=="🔧" then
            for arma,_ in pairs(armasData) do
                if Scroll:FindFirstChild(arma) then Scroll[arma].Visible=true end
            end
        else
            if database[emo] then
                for _,ac in ipairs(database[emo]) do
                    if Scroll:FindFirstChild(ac) then Scroll[ac].Visible=true end
                end
            end
        end
        Scroll.CanvasPosition=Vector2.new(0,0)
    end)
end

-- ============================================================
-- BOTÓN AYUDANTE (en barra título, antes del candado)
-- ============================================================
local AyudanteBtn=Instance.new("TextButton",TBar)
AyudanteBtn.Size=UDim2.new(0,28,0,24); AyudanteBtn.Position=UDim2.new(1,-130,0,7)
AyudanteBtn.Text="🧩"; AyudanteBtn.TextSize=13; AyudanteBtn.Font=Enum.Font.GothamBold
AyudanteBtn.BackgroundColor3=C.helperDim; AyudanteBtn.TextColor3=Color3.fromRGB(140,170,255)
AyudanteBtn.BorderSizePixel=0; corner(AyudanteBtn,5)
hoverBtn(AyudanteBtn,C.helperDim,C.helper)

-- Popup para elegir qué ayudante abrir
local ayBtnCount=0
AyudanteBtn.MouseButton1Click:Connect(function()
    -- Cerrar popup previo
    for _,v in ipairs(SG:GetChildren()) do
        if v.Name=="PopupAbrirAy" then v:Destroy() end
    end
    local pop=Instance.new("Frame",SG); pop.Name="PopupAbrirAy"
    pop.Size=UDim2.new(0,170,0,158); pop.Position=UDim2.new(0.5,-85,0,50)
    pop.BackgroundColor3=C.panel; pop.BorderSizePixel=0; pop.Active=true
    corner(pop,10); stroke(pop,C.helper,1.5,0.15)
    local pt=Instance.new("TextLabel",pop)
    pt.Size=UDim2.new(1,0,0,26); pt.BackgroundTransparency=1
    pt.Text="  Abrir Ayudante:"; pt.TextColor3=Color3.fromRGB(140,170,255)
    pt.TextSize=10; pt.Font=Enum.Font.GothamBold; pt.TextXAlignment=Enum.TextXAlignment.Left
    local pc=Instance.new("TextButton",pop)
    pc.Size=UDim2.new(0,22,0,20); pc.Position=UDim2.new(1,-24,0,3)
    pc.Text="✕"; pc.TextSize=10; pc.Font=Enum.Font.GothamBold
    pc.BackgroundColor3=C.dangerDim; pc.TextColor3=Color3.fromRGB(255,100,100); pc.BorderSizePixel=0
    corner(pc,4); pc.MouseButton1Click:Connect(function() pop:Destroy() end)
    for i=1,MAX_AYUDANTES do
        local b=Instance.new("TextButton",pop)
        b.Size=UDim2.new(1,-10,0,22); b.Position=UDim2.new(0,5,0,26+(i-1)*26)
        b.Text="🧩 Ayudante "..i; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
        b.BackgroundColor3=C.helperDim; b.TextColor3=Color3.fromRGB(140,170,255)
        b.BorderSizePixel=0; corner(b,6); hoverBtn(b,C.helperDim,C.helper)
        b.MouseButton1Click:Connect(function()
            crearAyudante(i); pop:Destroy()
        end)
    end
    pop.BackgroundTransparency=1; tw(pop,{BackgroundTransparency=0},TI_slow)
end)

-- ============================================================
-- OPEN / CLOSE MAIN
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

-- ============================================================
-- SISTEMA DE COMBOS DE ARTES MARCIALES
-- ============================================================
-- Cada estilo tiene combos para noquear.
-- Al buscar "noquear" en el buscador universal aparecen todos.
-- Al tocar un combo → GUI de pasos con botón por acción.

local combosAM = {
    -- ══════════════════════════════════════════════
    -- BOXEO
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Boxeo · Frente (Jab-Cross-Hook)",
        estilo="🥊 Boxeo",
        desc="Combinación clásica 1-2-3. Entra de frente, finta con jab, conecta el cross y cierra con hook.",
        pasos={
            "-lanza un jab al rostro para abrir distancia-",
            "-conecta un cross directo a la mandíbula-",
            "-remata con un hook explosivo a la sien-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Boxeo · Lateral (Shoulder Roll + Cross Counter)",
        estilo="🥊 Boxeo",
        desc="Desde el lateral derecho. Provoca el jab rival, rueda el hombro y contraataca con cross al mentón.",
        pasos={
            "-se posiciona en ángulo lateral derecho-",
            "-absorbe el jab entrante con el shoulder roll-",
            "-explota con un cross counter al mentón-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Boxeo · Desde atrás (Bob and Weave + Uppercut)",
        estilo="🥊 Boxeo",
        desc="Se agacha ante el hook, pasa por detrás y sube el uppercut con todo el cuerpo.",
        pasos={
            "-realiza bob and weave bajo el hook del rival-",
            "-gira por la espalda aprovechando el impulso-",
            "-sube un uppercut con el cuerpo completo al mentón-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- MUAY THAI
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Muay Thai · Frente (Teep + High Kick)",
        estilo="🦵 Muay Thai",
        desc="Empuja con el Teep para crear distancia y lanza la patada circular alta al cuello.",
        pasos={
            "-lanza un Teep al pecho para alejar al rival-",
            "-aprovecha el rebote del rival para cargar la pierna-",
            "-conecta una Tae Tad alta al cuello con el empeine-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Muay Thai · Clinch (Plum + Codo Descendente)",
        estilo="🦵 Muay Thai",
        desc="Desde el clinch controla la cabeza y aplica el codo descendente Sok Ngad.",
        pasos={
            "-entra al clinch y aplica el doble control de cuello (Full Plum)-",
            "-jala la cabeza del rival hacia abajo-",
            "-aplica el Sok Ngad (codo descendente) en la nuca-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Muay Thai · Salto (Rodilla Voladora)",
        estilo="🦵 Muay Thai",
        desc="Finta baja y explota con la Khao Yao (rodilla voladora) al rostro.",
        pasos={
            "-finta una patada baja para bajar la guardia del rival-",
            "-da un paso explosivo y salta con la rodilla adelantada-",
            "-conecta la Khao Yao (rodilla voladora) directo al rostro-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- KICKBOXING
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Kickboxing · Frente (Dutch Combo)",
        estilo="🥋 Kickboxing",
        desc="Combinación holandesa clásica: jab-cross-hook-low kick y cierra con high kick.",
        pasos={
            "-abre con jab-cross al rostro-",
            "-conecta el hook al costado de la cabeza-",
            "-aplica el low kick a la pierna de apoyo-",
            "-remata con un high kick explosivo a la sien-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Kickboxing · Giro (Spinning Back Kick + Overhand)",
        estilo="🥋 Kickboxing",
        desc="Desde el lateral gira y conecta la patada trasera al cuerpo, aprovecha el desequilibrio para el overhand.",
        pasos={
            "-se posiciona en ángulo lateral izquierdo-",
            "-ejecuta un giro y lanza la Spinning Back Kick al torso-",
            "-mientras el rival se dobla, conecta el overhand al temporal-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- KARATE
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Karate · Frente (Gyaku Tsuki + Uraken)",
        estilo="🥷 Karate",
        desc="Entra con el Gyaku Tsuki al plexo y remata con el Uraken al temporal.",
        pasos={
            "-adopta la postura de combate Kyokushin-",
            "-lanza el Gyaku Tsuki (puño inverso) al plexo solar-",
            "-cuando el rival baja la guardia, conecta el Uraken (reverso) al temporal-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · Karate · Salto (Tobi Mawashi Geri)",
        estilo="🥷 Karate",
        desc="Desde distancia salta y conecta la patada circular giratoria en salto al mentón.",
        pasos={
            "-toma distancia de dos pasos-",
            "-finta con un jab recto-",
            "-salta y ejecuta el Tobi Mawashi Geri (patada circular en salto) al mentón-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- TAEKWONDO
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · TKD · Frente (Dollyo Chagi alto)",
        estilo="🦶 Taekwondo",
        desc="Avanza con paso rápido y conecta la patada circular alta a la cabeza.",
        pasos={
            "-da un paso de deslizamiento hacia el rival-",
            "-eleva la rodilla simulando patada baja-",
            "-extiende el Dollyo Chagi (circular) directo a la sien-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · TKD · Giro 360 (Momdollyo Chagi)",
        estilo="🦶 Taekwondo",
        desc="Giro completo de 360° y conecta el talón en la sien.",
        pasos={
            "-finta adelantándose con un jab-",
            "-pivota sobre el pie de apoyo en giro completo de 360°-",
            "-conecta el Momdollyo Chagi (giro completo) con el talón en la sien-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · TKD · Salto (Twio Dollyo Chagi)",
        estilo="🦶 Taekwondo",
        desc="Salta y conecta la patada circular voladora en la cabeza.",
        pasos={
            "-da dos pasos de impulso-",
            "-salta con ambas piernas y gira en el aire-",
            "-conecta el Twio Dollyo Chagi (circular voladora) al rostro-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- SANDA / SANSHOU
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Sanda · Frente (Bian Tui + Derribo)",
        estilo="🐉 Sanda",
        desc="Circular al cuerpo para doblar al rival, captura la pierna y proyecta con volteo.",
        pasos={
            "-lanza la Bian Tui (patada circular) al costado del rival-",
            "-cuando el rival pierde balance, captura la pierna-",
            "-ejecuta el volteo lateral con empuje-",
            "-remata con el puño giratorio (Spinning Backfist) al caer-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- MMA
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · MMA · Frente (Oblique Kick + Overhand)",
        estilo="🏆 MMA",
        desc="Rompe la rodilla con el oblique kick y finaliza con overhand al temporal.",
        pasos={
            "-lanza el Oblique Kick (patada stomp a la rodilla del rival)-",
            "-mientras el rival cojea, entra con step rápido-",
            "-conecta el overhand explosivo al temporal-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · MMA · Desde atrás (Suplex + Ground and Pound)",
        estilo="🏆 MMA",
        desc="Toma la espalda, suplex de cintura y remata con codazos en el suelo.",
        pasos={
            "-se acerca por la espalda y engancha la cintura-",
            "-ejecuta el suplex de cintura lanzando al rival al suelo-",
            "-monta al rival en posición Tate Shiho Gatame-",
            "-aplica codazos descendentes Sok Ngad al rostro-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · MMA · Lateral (Judo Osoto Gari + Codo)",
        estilo="🏆 MMA",
        desc="Derribo Osoto Gari desde el clinch y codazo al caer.",
        pasos={
            "-entra al clinch lateral y aplica underhook derecho-",
            "-ejecuta el Osoto Gari (gran siega exterior) derribando al rival-",
            "-mientras cae, aplica el codo circular Sok Tad al rostro-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- JUDO (solo golpes legales en contexto RP)
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Judo · Proyección (Ippon Seoi Nage)",
        estilo="🎌 Judo",
        desc="Proyección sobre el hombro con impacto en el suelo.",
        pasos={
            "-toma el agarre de solapa y manga-",
            "-gira dando la espalda y carga al rival sobre el hombro-",
            "-ejecuta el Ippon Seoi Nage proyectando al rival al suelo-",
            "-el impacto en el suelo lo deja inconsciente-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- BJJ (KO por sumisión / choke)
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · BJJ · Mataleón (RNC desde atrás)",
        estilo="🇧🇷 BJJ",
        desc="Toma la espalda, inserta los ganchos y aplica el Rear Naked Choke.",
        pasos={
            "-toma la espalda del rival con ambos ganchos insertados-",
            "-pasa el brazo por debajo del cuello del rival-",
            "-agarra su propio bíceps y apoya la cabeza contra la del rival-",
            "-aprieta el Hadaka Jime (mataleón) cortando el flujo carotídeo-",
            "-Lo noquea-",
        }
    },
    {
        nombre="Noquear · BJJ · Triángulo desde guardia",
        estilo="🇧🇷 BJJ",
        desc="Desde guardia abierta, captura la cabeza y el brazo en triángulo de piernas.",
        pasos={
            "-desde guardia abierta desvía el brazo del rival hacia afuera-",
            "-sube la pierna sobre el cuello del rival-",
            "-cruza el tobillo y aprieta el Sankaku Jime (triángulo)-",
            "-Lo noquea-",
        }
    },
    -- ══════════════════════════════════════════════
    -- LUCHA OLÍMPICA
    -- ══════════════════════════════════════════════
    {
        nombre="Noquear · Lucha · Suplex (Arco de cintura)",
        estilo="🏅 Lucha",
        desc="Desde el clinch de espalda ejecuta el suplex de cintura con arco completo.",
        pasos={
            "-toma el clinch por la espalda enganchando la cintura con ambas manos-",
            "-dobla las rodillas y explota hacia arriba-",
            "-ejecuta el suplex de cintura lanzando al rival sobre su cabeza-",
            "-el impacto en el suelo lo deja inconsciente-",
            "-Lo noquea-",
        }
    },
}

-- ── GUI DE COMBO ──────────────────────────────────────────────
local function abrirCombo(combo)
    -- Evitar duplicados
    local existing = SG:FindFirstChild("ComboGUI_"..combo.nombre:sub(1,20))
    if existing then existing:Destroy() end

    local gui=Instance.new("Frame",SG)
    gui.Name="ComboGUI_"..combo.nombre:sub(1,20)
    gui.Size=UDim2.new(0,300,0,50 + #combo.pasos*48)
    gui.Position=UDim2.new(0.5,-150,0.5,-(25 + #combo.pasos*24))
    gui.BackgroundColor3=C.panel; gui.BorderSizePixel=0
    gui.Active=true; gui.Draggable=true; gui.ClipsDescendants=false
    corner(gui,10); stroke(gui,C.combat,1.5,0.1)

    -- Barra título
    local bar=Instance.new("Frame",gui)
    bar.Size=UDim2.new(1,0,0,32); bar.BackgroundColor3=C.surface; bar.BorderSizePixel=0
    corner(bar,10)
    local bFix=Instance.new("Frame",bar); bFix.Size=UDim2.new(1,0,0.5,0)
    bFix.Position=UDim2.new(0,0,0.5,0); bFix.BackgroundColor3=C.surface; bFix.BorderSizePixel=0
    local bTit=Instance.new("TextLabel",bar)
    bTit.Size=UDim2.new(1,-32,1,0); bTit.Position=UDim2.new(0,10,0,0)
    bTit.BackgroundTransparency=1; bTit.Text=combo.estilo.."  COMBO"
    bTit.TextColor3=Color3.fromRGB(190,140,255); bTit.TextSize=10; bTit.Font=Enum.Font.GothamBold
    bTit.TextXAlignment=Enum.TextXAlignment.Left
    local cBtn=Instance.new("TextButton",bar)
    cBtn.Size=UDim2.new(0,22,0,20); cBtn.Position=UDim2.new(1,-24,0,6)
    cBtn.Text="✕"; cBtn.TextSize=10; cBtn.Font=Enum.Font.GothamBold
    cBtn.BackgroundColor3=C.dangerDim; cBtn.TextColor3=Color3.fromRGB(255,100,100)
    cBtn.BorderSizePixel=0; corner(cBtn,4)
    hoverBtn(cBtn,C.dangerDim,C.danger)
    cBtn.MouseButton1Click:Connect(function()
        tw(gui,{BackgroundTransparency=1},TI_med)
        task.delay(0.22,function() gui:Destroy() end)
    end)

    -- Desc breve
    local descLbl=Instance.new("TextLabel",gui)
    descLbl.Size=UDim2.new(1,-12,0,28); descLbl.Position=UDim2.new(0,6,0,34)
    descLbl.BackgroundTransparency=1; descLbl.TextWrapped=true
    descLbl.Text=combo.desc; descLbl.TextColor3=C.textDim
    descLbl.TextSize=8; descLbl.Font=Enum.Font.Gotham
    descLbl.TextXAlignment=Enum.TextXAlignment.Left; descLbl.TextYAlignment=Enum.TextYAlignment.Top

    -- Pasos
    for i,paso in ipairs(combo.pasos) do
        local esFinal=(paso:find("Lo noquea") ~= nil)
        local yPos = 64 + (i-1)*48

        local rowBg=Instance.new("Frame",gui)
        rowBg.Size=UDim2.new(1,-12,0,42); rowBg.Position=UDim2.new(0,6,0,yPos)
        rowBg.BackgroundColor3=esFinal and Color3.fromRGB(30,10,40) or C.surfaceAlt
        rowBg.BorderSizePixel=0; corner(rowBg,6)
        stroke(rowBg, esFinal and C.combat or C.border, 1, esFinal and 0.2 or 0.6)

        local numLbl=Instance.new("TextLabel",rowBg)
        numLbl.Size=UDim2.new(0,20,1,0); numLbl.BackgroundTransparency=1
        numLbl.Text=tostring(i); numLbl.TextColor3=esFinal and C.combat or C.textDim
        numLbl.TextSize=9; numLbl.Font=Enum.Font.GothamBold

        local pasoLbl=Instance.new("TextLabel",rowBg)
        pasoLbl.Size=UDim2.new(1,-80,0,38); pasoLbl.Position=UDim2.new(0,22,0,2)
        pasoLbl.BackgroundTransparency=1; pasoLbl.TextWrapped=true
        pasoLbl.Text=paso; pasoLbl.TextSize=9; pasoLbl.Font=Enum.Font.Gotham
        pasoLbl.TextColor3=esFinal and Color3.fromRGB(190,140,255) or C.textPrime
        pasoLbl.TextXAlignment=Enum.TextXAlignment.Left
        pasoLbl.TextYAlignment=Enum.TextYAlignment.Top

        local acBtn=Instance.new("TextButton",rowBg)
        acBtn.Size=UDim2.new(0,54,0,32); acBtn.Position=UDim2.new(1,-58,0,5)
        acBtn.TextSize=9; acBtn.Font=Enum.Font.GothamBold; acBtn.BorderSizePixel=0; corner(acBtn,5)
        if esFinal then
            acBtn.Text="💀 FINAL"; acBtn.BackgroundColor3=C.combatDim
            acBtn.TextColor3=Color3.fromRGB(190,140,255)
            hoverBtn(acBtn,C.combatDim,C.combat)
        else
            acBtn.Text="▶ HACER"; acBtn.BackgroundColor3=C.surfaceAlt
            acBtn.TextColor3=C.textDim
            hoverBtn(acBtn,C.surfaceAlt,Color3.fromRGB(50,60,80))
        end
        acBtn.MouseButton1Click:Connect(function()
            EnviarAlChat(paso)
            -- Flash de confirmación
            tw(rowBg,{BackgroundColor3=C.accentDim},TI_fast)
            task.delay(0.3,function() tw(rowBg,{BackgroundColor3=esFinal and Color3.fromRGB(30,10,40) or C.surfaceAlt},TI_med) end)
            tw(acBtn,{BackgroundColor3=C.accent},TI_fast)
            task.delay(0.3,function()
                tw(acBtn,{BackgroundColor3=esFinal and C.combatDim or C.surfaceAlt},TI_fast)
            end)
        end)
    end

    gui.BackgroundTransparency=1; tw(gui,{BackgroundTransparency=0},TI_slow)
end

-- ── BLOQUES DE COMBO EN EL SCROLL ────────────────────────────
local function crearBloqueCombo(combo)
    layoutOrder=layoutOrder+1
    local f=Instance.new("Frame",Scroll)
    f.Size=UDim2.new(1,-2,0,72); f.BackgroundColor3=C.surfaceAlt; f.BorderSizePixel=0
    f.Name=combo.nombre; f.LayoutOrder=layoutOrder
    corner(f,7); stroke(f,C.border,1,0.55)

    -- Indicador de estilo
    local ind=Instance.new("Frame",f); ind.Size=UDim2.new(0,3,1,0)
    ind.BackgroundColor3=C.combat; ind.BorderSizePixel=0; corner(ind,3)

    local estiloLbl=Instance.new("TextLabel",f)
    estiloLbl.Size=UDim2.new(1,-106,0,18); estiloLbl.Position=UDim2.new(0,10,0,4)
    estiloLbl.BackgroundTransparency=1; estiloLbl.Text=combo.estilo
    estiloLbl.TextColor3=Color3.fromRGB(190,140,255); estiloLbl.TextSize=9
    estiloLbl.Font=Enum.Font.GothamBold; estiloLbl.TextXAlignment=Enum.TextXAlignment.Left

    local nomLbl=Instance.new("TextLabel",f)
    nomLbl.Size=UDim2.new(1,-106,0,18); nomLbl.Position=UDim2.new(0,10,0,22)
    nomLbl.BackgroundTransparency=1; nomLbl.TextWrapped=false
    nomLbl.Text=combo.nombre; nomLbl.TextColor3=C.textPrime
    nomLbl.TextSize=8; nomLbl.Font=Enum.Font.Gotham
    nomLbl.TextXAlignment=Enum.TextXAlignment.Left; nomLbl.TextTruncate=Enum.TextTruncate.AtEnd

    local stepsLbl=Instance.new("TextLabel",f)
    stepsLbl.Size=UDim2.new(1,-106,0,14); stepsLbl.Position=UDim2.new(0,10,0,40)
    stepsLbl.BackgroundTransparency=1
    stepsLbl.Text=#combo.pasos.." pasos  ·  termina en -Lo noquea-"
    stepsLbl.TextColor3=C.textDim; stepsLbl.TextSize=8; stepsLbl.Font=Enum.Font.Gotham
    stepsLbl.TextXAlignment=Enum.TextXAlignment.Left

    local openBtn=Instance.new("TextButton",f)
    openBtn.Size=UDim2.new(0,90,0,50); openBtn.Position=UDim2.new(1,-94,0,11)
    openBtn.Text="👊 COMBO"; openBtn.TextSize=10; openBtn.Font=Enum.Font.GothamBold
    openBtn.BackgroundColor3=C.combatDim; openBtn.TextColor3=Color3.fromRGB(190,140,255)
    openBtn.BorderSizePixel=0; corner(openBtn,7)
    hoverBtn(openBtn,C.combatDim,C.combat)
    openBtn.MouseButton1Click:Connect(function() abrirCombo(combo) end)
end

-- Poblar combos en el scroll
for _,combo in ipairs(combosAM) do
    crearBloqueCombo(combo)
end

-- Agregar categoría 🥊 a la sidebar
-- (Insertar botón en SideScroll para filtrar combos)
local bAM=Instance.new("TextButton",SideScroll)
bAM.Size=UDim2.new(1,0,0,46); bAM.Text="🥊"; bAM.TextSize=22
bAM.BackgroundColor3=C.surfaceAlt; bAM.BorderSizePixel=0; corner(bAM,6)
bAM.MouseEnter:Connect(function() tw(bAM,{BackgroundColor3=C.panel}) end)
bAM.MouseLeave:Connect(function() tw(bAM,{BackgroundColor3=C.surfaceAlt}) end)
bAM.MouseButton1Click:Connect(function()
    tw(bAM,{BackgroundColor3=C.combatDim},TI_fast)
    task.delay(0.15,function() tw(bAM,{BackgroundColor3=C.surfaceAlt}) end)
    SearchBar.Text=""
    for _,c in pairs(Scroll:GetChildren()) do
        if c:IsA("Frame") then c.Visible=false end
    end
    for _,combo in ipairs(combosAM) do
        local blk=Scroll:FindFirstChild(combo.nombre)
        if blk then blk.Visible=true end
    end
    Scroll.CanvasPosition=Vector2.new(0,0)
end)

-- El buscador universal ya cubre los combos por nombre automáticamente
-- (buscar "noquear", "boxeo", "judo", etc.)

-- ============================================================
-- CATÁLOGO DE MUNICIONES (categoría 🔫 navegable)
-- ============================================================
local municionesData = {
    -- ── PISTOLA ──────────────────────────────────────────────
    {cat="🔫 Pistola", nombre="9×19mm Parabellum",
     armas="Glock 17, Beretta M9, SIG P226, H&K USP",
     desc="La más usada en el mundo. Disparo rápido y controlable. Sonido seco y corto."},
    {cat="🔫 Pistola", nombre=".45 ACP",
     armas="Colt 1911, Glock 21, H&K USP .45",
     desc="Bala gruesa y pesada. Retroceso notorio. Sonido grave y contundente."},
    {cat="🔫 Pistola", nombre=".40 S&W",
     armas="Glock 22, Sig P229, Beretta Px4",
     desc="Entre el 9mm y el .45. Retroceso medio-alto. Muy usado en fuerzas policiales."},
    {cat="🔫 Pistola", nombre=".380 ACP",
     armas="Walther PPK, Glock 42, Ruger LCP",
     desc="Pistolas compactas y de bolsillo. Disparo suave. Sonido discreto."},
    {cat="🔫 Pistola", nombre="10mm Auto",
     armas="Glock 20, Colt Delta Elite",
     desc="Alta potencia en pistola. Retroceso fuerte. Sonido potente."},
    {cat="🔫 Pistola", nombre=".357 Magnum",
     armas="Revólver Smith & Wesson Model 686",
     desc="Revólver clásico. Destello intenso al disparar. Sonido muy alto."},
    {cat="🔫 Pistola", nombre=".44 Magnum",
     armas="Revólver Desert Eagle, S&W Model 29",
     desc="Extremadamente potente para pistola. Retroceso brutal. Sonido ensordecedor."},
    {cat="🔫 Pistola", nombre="5.7×28mm",
     armas="FN Five-seveN, FN P90",
     desc="Bala pequeña y veloz. Poca vibración. Sonido agudo y seco."},
    -- ── RIFLE ────────────────────────────────────────────────
    {cat="🎯 Rifle", nombre="5.56×45mm NATO",
     armas="AR-15, M4, M16, HK416",
     desc="Estándar de la OTAN. Alta velocidad. Sonido agudo y seco con retroceso manejable."},
    {cat="🎯 Rifle", nombre="7.62×39mm",
     armas="AK-47, AKM, AK-74",
     desc="Bala soviética clásica. Contundente a media distancia. Sonido grave y fuerte."},
    {cat="🎯 Rifle", nombre="7.62×51mm NATO",
     armas="M14, FN FAL, H&K G3",
     desc="Rifle de batalla. Alta potencia. Retroceso fuerte. Muy precisa a larga distancia."},
    {cat="🎯 Rifle", nombre=".308 Winchester",
     armas="Remington 700, Tikka T3, AR-10",
     desc="Civil equivalente al 7.62 NATO. Muy precisa. Usada en caza y tiro deportivo."},
    {cat="🎯 Rifle", nombre=".300 Winchester Magnum",
     armas="Remington 700, Winchester Model 70",
     desc="Alta velocidad y alcance extremo. Retroceso notable. Sonido potente."},
    {cat="🎯 Rifle", nombre=".338 Lapua Magnum",
     armas="Accuracy International AXMC, Barrett MRAD",
     desc="Francotirador de largo alcance. Retroceso fuerte. Sonido grave y profundo."},
    {cat="🎯 Rifle", nombre=".50 BMG",
     armas="Barrett M82, M107",
     desc="El calibre más potente en uso. Retroceso extremo. Sonido atronador."},
    {cat="🎯 Rifle", nombre="6.5 Creedmoor",
     armas="Ruger Precision Rifle, Tikka T3x",
     desc="Alta precisión a larga distancia con retroceso moderado. Favorita en competición."},
    -- ── ESCOPETA ─────────────────────────────────────────────
    {cat="💥 Escopeta", nombre="12 Gauge",
     armas="Mossberg 500, Remington 870, Benelli M4",
     desc="La escopeta estándar. Disparo devastador a corta distancia. Sonido explosivo."},
    {cat="💥 Escopeta", nombre="20 Gauge",
     armas="Remington 870 Junior, Mossberg 500 Youth",
     desc="Versión más ligera del 12. Menos retroceso. Sonido menos intenso."},
    {cat="💥 Escopeta", nombre=".410 Bore",
     armas="Taurus Judge, S&W Governor, escopetas de caza menores",
     desc="El calibre más pequeño de escopeta. Suave y compacto. Ideal para caza menor."},
    -- ── SUBFUSIL ─────────────────────────────────────────────
    {cat="⚡ Subfusil", nombre="9mm (SMG)",
     armas="MP5, UMP-9, CZ Scorpion EVO",
     desc="Subfusil estándar. Cadencia alta. Sonido rápido y repetitivo."},
    {cat="⚡ Subfusil", nombre=".45 ACP (SMG)",
     armas="Thompson M1A1, UMP-45",
     desc="Subfusil pesado y contundente. Cadencia más lenta que el 9mm."},
    {cat="⚡ Subfusil", nombre="4.6×30mm",
     armas="H&K MP7",
     desc="Bala compacta y penetrante. Muy controlable en automático. Sonido agudo."},
    -- ── FRANCOTIRADOR ────────────────────────────────────────
    {cat="🎯 Francotirador", nombre=".300 Win Mag (Sniper)",
     armas="Remington 700, CheyTac M200",
     desc="Alcance extremo y alta precisión. El favorito de francotiradores profesionales."},
    {cat="🎯 Francotirador", nombre=".338 Lapua Magnum (Sniper)",
     armas="Accuracy International L115A3",
     desc="Récords de alcance en combate. Sonido profundo. Retroceso muy fuerte."},
    {cat="🎯 Francotirador", nombre=".408 CheyTac",
     armas="CheyTac M200 Intervention",
     desc="Especializado en distancias ultra largas. Alta estabilidad balística."},
    {cat="🎯 Francotirador", nombre=".50 BMG (Sniper)",
     armas="Barrett M82, Hecate II",
     desc="Anti-material y anti-personal. El calibre más temido. Sonido devastador."},
    -- ── RIMFIRE / DEPORTIVA ───────────────────────────────────
    {cat="🏹 Rimfire", nombre=".22 LR",
     armas="Ruger 10/22, Walther P22",
     desc="La más silenciosa y económica. Poca potencia. Ideal para entrenamiento."},
    {cat="🏹 Rimfire", nombre=".17 HMR",
     armas="Savage Arms A17, CZ 455",
     desc="Alta velocidad en calibre pequeño. Muy precisa a corta-media distancia."},
    -- ── MILITARES ESPECIALES ──────────────────────────────────
    {cat="⭐ Militar especial", nombre="5.45×39mm",
     armas="AK-74, AK-74M, RPK-74",
     desc="Evolución soviética del 7.62×39. Más veloz y plana. Sonido agudo."},
    {cat="⭐ Militar especial", nombre="7.62×54mmR",
     armas="SVD Dragunov, PKM, Mosin-Nagant",
     desc="Cartucho ruso rimmed. Potente y preciso. Sonido grave y retroceso notable."},
    {cat="⭐ Militar especial", nombre="12.7×108mm",
     armas="DShK, NSV, KORD (ametralladoras pesadas)",
     desc="Anti-material soviético. Equivalente al .50 BMG. Sonido absolutamente atronador."},
    {cat="⭐ Militar especial", nombre="14.5×114mm",
     armas="KPV, ZPU (antiaéreo)",
     desc="El cartucho de ametralladora más grande en uso. Devastador. Solo en vehículos."},
}

-- ── Bloque de munición en el scroll ──────────────────────────
local function crearBloqueMunicion(mun)
    layoutOrder=layoutOrder+1
    local f=Instance.new("Frame",Scroll)
    f.Size=UDim2.new(1,-2,0,88); f.BackgroundColor3=C.surfaceAlt; f.BorderSizePixel=0
    f.Name="mun_"..mun.nombre; f.LayoutOrder=layoutOrder
    corner(f,7); stroke(f,C.border,1,0.55)

    -- Barra categoría
    local catBar=Instance.new("Frame",f)
    catBar.Size=UDim2.new(1,0,0,20); catBar.BackgroundColor3=C.surface; catBar.BorderSizePixel=0
    corner(catBar,7)
    local cFix=Instance.new("Frame",catBar); cFix.Size=UDim2.new(1,0,0.5,0)
    cFix.Position=UDim2.new(0,0,0.5,0); cFix.BackgroundColor3=C.surface; cFix.BorderSizePixel=0

    -- Indicador lateral color munición
    local ind=Instance.new("Frame",catBar); ind.Size=UDim2.new(0,3,1,0)
    ind.BackgroundColor3=C.armory; ind.BorderSizePixel=0; corner(ind,3)

    local catLbl=Instance.new("TextLabel",catBar)
    catLbl.Size=UDim2.new(0.6,-6,1,0); catLbl.Position=UDim2.new(0,10,0,0)
    catLbl.BackgroundTransparency=1; catLbl.Text=mun.cat
    catLbl.TextColor3=Color3.fromRGB(255,185,80); catLbl.TextSize=8
    catLbl.Font=Enum.Font.GothamBold; catLbl.TextXAlignment=Enum.TextXAlignment.Left

    local nomLbl=Instance.new("TextLabel",catBar)
    nomLbl.Size=UDim2.new(1,-14,1,0); nomLbl.Position=UDim2.new(0,10,0,0)
    nomLbl.BackgroundTransparency=1; nomLbl.Text=mun.nombre
    nomLbl.TextColor3=Color3.fromRGB(255,220,120); nomLbl.TextSize=9
    nomLbl.Font=Enum.Font.GothamBold; nomLbl.TextXAlignment=Enum.TextXAlignment.Left

    -- Armas
    local armasLbl=Instance.new("TextLabel",f)
    armasLbl.Size=UDim2.new(1,-100,0,16); armasLbl.Position=UDim2.new(0,8,0,22)
    armasLbl.BackgroundTransparency=1; armasLbl.TextWrapped=false
    armasLbl.Text="🔫 "..mun.armas; armasLbl.TextColor3=C.textDim
    armasLbl.TextSize=8; armasLbl.Font=Enum.Font.Gotham
    armasLbl.TextXAlignment=Enum.TextXAlignment.Left
    armasLbl.TextTruncate=Enum.TextTruncate.AtEnd

    -- Descripción
    local descLbl=Instance.new("TextLabel",f)
    descLbl.Size=UDim2.new(1,-100,0,28); descLbl.Position=UDim2.new(0,8,0,40)
    descLbl.BackgroundTransparency=1; descLbl.TextWrapped=true
    descLbl.Text=mun.desc; descLbl.TextColor3=C.textPrime
    descLbl.TextSize=8; descLbl.Font=Enum.Font.Gotham
    descLbl.TextXAlignment=Enum.TextXAlignment.Left
    descLbl.TextYAlignment=Enum.TextYAlignment.Top

    -- Botón "Usar esta munición"
    local usarBtn=Instance.new("TextButton",f)
    usarBtn.Size=UDim2.new(0,88,0,62); usarBtn.Position=UDim2.new(1,-92,0,14)
    usarBtn.Text="✓ USAR"; usarBtn.TextSize=9; usarBtn.Font=Enum.Font.GothamBold
    usarBtn.BackgroundColor3=C.armoryDim; usarBtn.TextColor3=Color3.fromRGB(255,185,80)
    usarBtn.BorderSizePixel=0; corner(usarBtn,7)
    hoverBtn(usarBtn,C.armoryDim,C.armory)

    usarBtn.MouseButton1Click:Connect(function()
        -- Activar munición global
        globalOpts.munActiva=true
        globalOpts.munVal=mun.nombre
        MunBox.Text=mun.nombre
        MunBox.Visible=true
        -- Activar el toggle visualmente
        tw(MunToggle,{BackgroundColor3=Color3.fromRGB(80,50,10)},TI_fast)
        tw(MunToggle,{TextColor3=Color3.fromRGB(255,190,80)},TI_fast)
        showToast("Munición activa: "..mun.nombre, Color3.fromRGB(255,185,80))
        -- Flash en el botón
        tw(usarBtn,{BackgroundColor3=C.armory},TI_fast)
        task.delay(0.5,function() tw(usarBtn,{BackgroundColor3=C.armoryDim},TI_med) end)
    end)
end

-- Poblar municiones
for _,mun in ipairs(municionesData) do
    crearBloqueMunicion(mun)
end

-- Botón 🔫 en sidebar para filtrar municiones
local bMun=Instance.new("TextButton",SideScroll)
bMun.Size=UDim2.new(1,0,0,46); bMun.Text="🔫"; bMun.TextSize=22
bMun.BackgroundColor3=C.surfaceAlt; bMun.BorderSizePixel=0; corner(bMun,6)
bMun.MouseEnter:Connect(function() tw(bMun,{BackgroundColor3=C.panel}) end)
bMun.MouseLeave:Connect(function() tw(bMun,{BackgroundColor3=C.surfaceAlt}) end)
bMun.MouseButton1Click:Connect(function()
    tw(bMun,{BackgroundColor3=C.armoryDim},TI_fast)
    task.delay(0.15,function() tw(bMun,{BackgroundColor3=C.surfaceAlt}) end)
    SearchBar.Text=""
    for _,c in pairs(Scroll:GetChildren()) do
        if c:IsA("Frame") then c.Visible=false end
    end
    for _,mun in ipairs(municionesData) do
        local blk=Scroll:FindFirstChild("mun_"..mun.nombre)
        if blk then blk.Visible=true end
    end
    Scroll.CanvasPosition=Vector2.new(0,0)
end)
