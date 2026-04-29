-- ============================================================
--  RP ULTIMATE FULL | TACTICAL EDITION v2.5 (BROOKHAVEN)
--  Categorías: Salud, Señales, AR-15 y Mini-Chats
-- ============================================================

local TextChatService  = game:GetService("TextChatService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

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

local TI_fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad)
local TI_med  = TweenInfo.new(0.22, Enum.EasingStyle.Quad)

-- UTILIDADES
local function tw(obj, props, info) TweenService:Create(obj, info or TI_fast, props):Play() end
local function corner(parent, px) local u = Instance.new("UICorner", parent); u.CornerRadius = UDim.new(0, px or 4); return u end
local function stroke(parent, color, thickness, trans) local s = Instance.new("UIStroke", parent); s.Color = color or C.border; s.Thickness = thickness or 1; s.Transparency = trans or 0; return s end

-- SISTEMA DE ENVÍO
local function EnviarAlChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

-- ============================================================
-- LÓGICA DE MINI-GUIS (SCRIPTS)
-- ============================================================
local function CrearMiniChat(tipo)
    local Mini = Instance.new("Frame", game:GetService("CoreGui"):FindFirstChild("RP_Ultimate_Full"))
    Mini.Size = UDim2.new(0, 280, 0, 140)
    Mini.Position = UDim2.new(0.5, -140, 0.4, 0)
    Mini.BackgroundColor3 = C.panel
    Mini.BorderSizePixel = 0
    Mini.Active = true
    Mini.Draggable = true
    corner(Mini, 10)
    stroke(Mini, C.accent, 1.5)

    local Header = Instance.new("TextLabel", Mini)
    Header.Size = UDim2.new(1, 0, 0, 30); Header.Text = "  ◈ CHAT PERSONALIZADO: "..tipo; Header.TextColor3 = C.textAccent; Header.BackgroundColor3 = C.surface; Header.TextXAlignment = Enum.TextXAlignment.Left; Header.Font = Enum.Font.GothamBold; Header.TextSize = 10
    corner(Header, 10)

    local Pin = Instance.new("TextButton", Mini)
    Pin.Size = UDim2.new(0, 20, 0, 20); Pin.Position = UDim2.new(1, -25, 0, 5); Pin.Text = "📌"; Pin.BackgroundColor3 = C.lock_on; corner(Pin, 4)
    local pinMovible = true
    Pin.MouseButton1Click:Connect(function()
        pinMovible = not pinMovible
        Mini.Draggable = pinMovible
        Pin.BackgroundColor3 = pinMovible and C.lock_on or C.lock_off
    end)

    local Input = Instance.new("TextBox", Mini)
    Input.Size = UDim2.new(0.9, 0, 0, 50); Input.Position = UDim2.new(0.05, 0, 0.3, 0); Input.PlaceholderText = "Escribe aquí..."; Input.Text = ""; Input.BackgroundColor3 = C.surfaceAlt; Input.TextColor3 = Color3.new(1,1,1); Input.TextWrapped = true; corner(Input, 6); stroke(Input, C.border, 1)

    local Send = Instance.new("TextButton", Mini)
    Send.Size = UDim2.new(0.45, 0, 0, 30); Send.Position = UDim2.new(0.05, 0, 0.75, 0); Send.Text = "ENVIAR"; Send.BackgroundColor3 = C.accent; Send.Font = Enum.Font.GothamBold; corner(Send, 6)

    local Close = Instance.new("TextButton", Mini)
    Close.Size = UDim2.new(0.45, 0, 0, 30); Close.Position = UDim2.new(0.5, 5, 0.75, 0); Close.Text = "CERRAR"; Close.BackgroundColor3 = C.dangerDim; Close.Font = Enum.Font.GothamBold; corner(Close, 6)

    Send.MouseButton1Click:Connect(function()
        if Input.Text ~= "" then
            local finalMsg = tipo == "COMILLAS" and '"'..Input.Text..'"' or "-"..Input.Text.."-"
            EnviarAlChat(finalMsg)
            Input.Text = "" -- Limpiar al enviar
        end
    end)
    Close.MouseButton1Click:Connect(function() Mini:Destroy() end)
end

-- ============================================================
-- SCREENGUI E INTERFAZ PRINCIPAL
-- ============================================================
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RP_Ultimate_Full"

local Control = Instance.new("TextButton", ScreenGui)
Control.Size = UDim2.new(0, 42, 0, 42); Control.Position = UDim2.new(0, 14, 0, 200); Control.BackgroundColor3 = C.surface; Control.Text = "RP"; Control.TextColor3 = C.textAccent; Control.Font = Enum.Font.GothamBold; Control.Draggable = true; corner(Control, 8); stroke(Control, C.accent, 1.5)

local Lock = Instance.new("Frame", Control)
Lock.Size = UDim2.new(0, 8, 0, 8); Lock.Position = UDim2.new(1, -5, 0, -3); Lock.BackgroundColor3 = C.lock_on; corner(Lock, 4)

local movible = true
Control.MouseButton2Click:Connect(function()
    movible = not movible; Control.Draggable = movible
    tw(Lock, {BackgroundColor3 = movible and C.lock_on or C.lock_off})
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 360); Main.Position = UDim2.new(0.5, -230, 0.5, -180); Main.BackgroundColor3 = C.bg; Main.Visible = false; Main.Active = true; Main.Draggable = true; corner(Main, 10); stroke(Main, C.border, 1.5)

-- Barra de título
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 36); Title.Text = "◈ TACTICAL RP SYSTEM v2.5 ◈"; Title.TextColor3 = C.textAccent; Title.BackgroundColor3 = C.surface; Title.Font = Enum.Font.GothamBold; corner(Title, 10)

-- Inputs
local victimaInput = Instance.new("TextBox", Main)
victimaInput.Size = UDim2.new(0, 176, 0, 28); victimaInput.Position = UDim2.new(0, 68, 0, 82); victimaInput.PlaceholderText = "👤 A QUIÉN?"; victimaInput.BackgroundColor3 = C.surface; victimaInput.TextColor3 = C.textAccent; corner(victimaInput, 6); stroke(victimaInput, C.accentDim, 1)

local balasInput = Instance.new("TextBox", Main)
balasInput.Size = UDim2.new(0, 176, 0, 28); balasInput.Position = UDim2.new(0, 252, 0, 82); balasInput.PlaceholderText = "🔫 CON QUÉ?"; balasInput.BackgroundColor3 = C.surface; balasInput.TextColor3 = C.textAccent; corner(balasInput, 6); stroke(balasInput, C.accentDim, 1)

-- Buscador
local SearchBar = Instance.new("TextBox", Main)
SearchBar.Size = UDim2.new(0, 285, 0, 28); SearchBar.Position = UDim2.new(0, 68, 0, 46); SearchBar.PlaceholderText = "🔍 BUSCADOR..."; SearchBar.BackgroundColor3 = C.surface; SearchBar.TextColor3 = Color3.new(1,1,1); corner(SearchBar, 6)

local Clear = Instance.new("TextButton", Main)
Clear.Size = UDim2.new(0, 68, 0, 28); Clear.Position = UDim2.new(0, 360, 0, 46); Clear.Text = "LIMPIAR"; Clear.BackgroundColor3 = C.dangerDim; Clear.TextColor3 = Color3.new(1,1,1); corner(Clear, 6)

-- Scroll
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0, 376, 0, 230); Scroll.Position = UDim2.new(0, 68, 0, 118); Scroll.BackgroundColor3 = C.panel; Scroll.CanvasSize = UDim2.new(0,0,0,0); corner(Scroll, 8)
local scrollLayout = Instance.new("UIListLayout", Scroll); scrollLayout.Padding = UDim.new(0, 6)

-- ============================================================
-- BASE DE DATOS Y LÓGICA DE ARMAS
-- ============================================================
local database = {
    ["👤"] = {"hombro derecho", "hombro izquierdo", "brazo derecho", "brazo izquierdo", "antebrazo derecho", "antebrazo izquierdo", "codo derecho", "codo izquierdo", "muñeca derecha", "muñeca izquierdo", "mano derecha", "mano izquierdo", "pecho superior", "abdomen", "muslo derecho", "muslo izquierdo", "rodilla derecha", "pie derecho", "espalda", "nuca"},
    ["🛡️"] = {"placa pectoral", "kevlar lateral der", "kevlar lateral izq", "casco (visera)", "axila derecha", "axila izquierda"},
    ["🥋"] = {"golpea nariz", "golpea higado", "golpea plexo solar", "patea espinilla", "luxa muñeca der", "barre pierna der", "derribo tacleada"},
    ["🩹"] = {"aplica torniquete", "venda herida", "limpia zona con alcohol", "inserta canula", "realiza RCP", "inyecta morfina", "checa pulso carotido"},
    ["👋"] = {"señal ALTO", "señal AVANZAR", "señal ENEMIGO VISUAL", "señal CUBIERTA", "señal REAGRUPARSE", "señal SILENCIO"},
    ["🔫"] = {"AR-15: saca upper y lower", "AR-15: une upper con lower", "AR-15: inserta pasadores", "AR-15: carga cargador 5.56", "AR-15: inserta cargador", "AR-15: jala carga (bala en recamara)", "AR-15: activa seguro", "AR-15: enciende mira", "AR-15: activa laser", "AR-15: extiende culata", "AR-15: quita seguro"},
    ["📜"] = {"Mini-Chat COMILLAS", "Mini-Chat GUIONES"}
}

local function Procesar(texto, tipo)
    if texto:find("Mini-Chat") then
        local t = texto:find("COMILLAS") and "COMILLAS" or "GUIONES"
        CrearMiniChat(t)
        return
    end

    local vic = victimaInput.Text ~= "" and victimaInput.Text or "objetivo"
    local bal = balasInput.Text ~= "" and balasInput.Text or "munición"
    local verbos = {"Dispara", "Percuta", "Acciona", "Detona", "Abre fuego con"}
    
    local final = ""
    if tipo == "apuntar" then
        final = "-apunta a " .. texto .. " de " .. vic .. "-"
    elseif tipo == "disparar" then
        final = "-" .. verbos[math.random(#verbos)] .. " 1 bala (" .. bal .. ") al " .. texto .. " de " .. vic .. "-"
    else
        final = "-" .. texto .. " de " .. vic .. "-"
    end
    EnviarAlChat(final)
end

local function crearBloque(texto, cat)
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, -10, 0, 80); f.BackgroundColor3 = C.surfaceAlt; f.Name = texto; corner(f, 7); stroke(f, C.border, 1, 0.5)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -10, 0, 25); l.Position = UDim2.new(0, 5, 0, 0); l.Text = texto:upper(); l.TextColor3 = C.textAccent; l.Font = Enum.Font.GothamBold; l.TextSize = 10; l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left

    if cat == "🥋" or cat == "🩹" or cat == "👋" or cat == "🔫" or cat == "📜" then
        local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, -10, 0, 45); b.Position = UDim2.new(0, 5, 0, 30); b.Text = "EJECUTAR ACCIÓN"; b.BackgroundColor3 = C.combatDim; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; corner(b, 6)
        b.MouseButton1Click:Connect(function() Procesar(texto, "ejecutar") end)
    else
        local b1 = Instance.new("TextButton", f); b1.Size = UDim2.new(0.5, -7, 0, 45); b1.Position = UDim2.new(0, 5, 0, 30); b1.Text = "🎯 APUNTAR"; b1.BackgroundColor3 = C.aim; b1.Font = Enum.Font.GothamSemibold; corner(b1, 6)
        b1.MouseButton1Click:Connect(function() Procesar(texto, "apuntar") end)
        local b2 = Instance.new("TextButton", f); b2.Size = UDim2.new(0.5, -7, 0, 45); b2.Position = UDim2.new(0.5, 2, 0, 30); b2.Text = "💥 DISPARAR"; b2.BackgroundColor3 = C.shoot; b2.Font = Enum.Font.GothamSemibold; corner(b2, 6)
        b2.MouseButton1Click:Connect(function() Procesar(texto, "disparar") end)
    end
end

-- CARGA INICIAL
for cat, lista in pairs(database) do for _, v in pairs(lista) do crearBloque(v, cat) end end

-- BARRA LATERAL
local emos = {"👤", "🛡️", "🥋", "🩹", "👋", "🔫", "📜"}
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 52, 0, #emos * 45); Sidebar.Position = UDim2.new(0, 8, 0, 46); Sidebar.BackgroundColor3 = C.surface; corner(Sidebar, 8)
local sideLayout = Instance.new("UIListLayout", Sidebar); sideLayout.Padding = UDim.new(0, 2)

for _, emo in ipairs(emos) do
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 42); b.Text = emo; b.TextSize = 22; b.BackgroundColor3 = C.surfaceAlt; corner(b, 6)
    b.MouseButton1Click:Connect(function()
        SearchBar.Text = ""
        for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
        for _, v in pairs(database[emo]) do if Scroll:FindFirstChild(v) then Scroll[v].Visible = true end end
        Scroll.CanvasPosition = Vector2.new(0,0)
    end)
end

-- BUSCADOR LÓGICA
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBar.Text:lower()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c.Visible = (q == "" or c.Name:lower():find(q)) and true or false end end
end)
Clear.MouseButton1Click:Connect(function() SearchBar.Text = "" end)

-- TOGGLE GUI
Control.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
