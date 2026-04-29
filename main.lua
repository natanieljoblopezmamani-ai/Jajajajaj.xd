-- ============================================================
--  RP ULTIMATE FULL | TACTICAL EDITION v2.8 
--  RESTAURACIÓN TOTAL + SUB-GUIS DE ARMADO
-- ============================================================

local TextChatService  = game:GetService("TextChatService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local C = {
    bg = Color3.fromRGB(8, 10, 12), panel = Color3.fromRGB(14, 17, 21),
    surface = Color3.fromRGB(20, 24, 30), surfaceAlt = Color3.fromRGB(26, 31, 38),
    border = Color3.fromRGB(52, 73, 94), accent = Color3.fromRGB(0, 188, 140),
    accentDim = Color3.fromRGB(0, 120, 90), textPrime = Color3.fromRGB(220, 230, 240),
    textAccent = Color3.fromRGB(0, 210, 160), lock_on = Color3.fromRGB(0, 220, 100),
    lock_off = Color3.fromRGB(220, 50, 50), combat = Color3.fromRGB(120, 40, 220),
    aim = Color3.fromRGB(30, 80, 60), shoot = Color3.fromRGB(100, 20, 20)
}

local TI_fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad)
local function tw(obj, props) TweenService:Create(obj, TI_fast, props):Play() end
local function corner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 6); return c end
local function stroke(p, col) local s = Instance.new("UIStroke", p); s.Color = col or C.border; s.Thickness = 1; return s end

local function EnviarAlChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

-- ============================================================
-- 1. SISTEMA DE MINI-GUIS (CHATS Y ARMADO)
-- ============================================================
local function CrearVentanaBase(titulo, size)
    local Ventana = Instance.new("Frame", game:GetService("CoreGui"):FindFirstChild("RP_Ultimate_Full"))
    Ventana.Size = size or UDim2.new(0, 280, 0, 160)
    Ventana.Position = UDim2.new(0.5, -140, 0.4, 0)
    Ventana.BackgroundColor3 = C.panel
    Ventana.Active = true
    Ventana.Draggable = true
    corner(Ventana, 10); stroke(Ventana, C.accent)

    local Header = Instance.new("Frame", Ventana)
    Header.Size = UDim2.new(1, 0, 0, 30); Header.BackgroundColor3 = C.surface; corner(Header, 10)
    
    local T = Instance.new("TextLabel", Header)
    T.Size = UDim2.new(1, -60, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.Text = titulo; T.TextColor3 = C.textAccent; T.Font = Enum.Font.GothamBold; T.TextSize = 11; T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 2); Close.Text = "X"; Close.BackgroundColor3 = C.lock_off; Close.TextColor3 = Color3.new(1,1,1); corner(Close, 5)
    Close.MouseButton1Click:Connect(function() Ventana:Destroy() end)

    local Pin = Instance.new("TextButton", Header)
    Pin.Size = UDim2.new(0, 25, 0, 25); Pin.Position = UDim2.new(1, -60, 0, 2); Pin.Text = "📌"; Pin.BackgroundColor3 = C.lock_on; corner(Pin, 5)
    local mov = true
    Pin.MouseButton1Click:Connect(function() mov = not mov; Ventana.Draggable = mov; Pin.BackgroundColor3 = mov and C.lock_on or C.lock_off end)

    return Ventana
end

local function CrearMiniChat(tipo)
    local V = CrearVentanaBase("CHAT " .. tipo)
    local In = Instance.new("TextBox", V)
    In.Size = UDim2.new(0.9, 0, 0, 60); In.Position = UDim2.new(0.05, 0, 0.25, 0); In.PlaceholderText = "Escribe..."; In.BackgroundColor3 = C.surfaceAlt; In.TextColor3 = Color3.new(1,1,1); In.TextWrapped = true; corner(In, 6)
    
    local Send = Instance.new("TextButton", V)
    Send.Size = UDim2.new(0.9, 0, 0, 30); Send.Position = UDim2.new(0.05, 0, 0.7, 0); Send.Text = "ENVIAR"; Send.BackgroundColor3 = C.accent; Send.Font = Enum.Font.GothamBold; corner(Send, 6)
    Send.MouseButton1Click:Connect(function()
        if In.Text ~= "" then
            EnviarAlChat(tipo == "COMILLAS" and '"'..In.Text..'"' or "-"..In.Text.."-")
            In.Text = ""
        end
    end)
end

local function AbrirArmarAR15()
    local V = CrearVentanaBase("ARMADO: AR-15", UDim2.new(0, 300, 0, 350))
    local Scroll = Instance.new("ScrollingFrame", V)
    Scroll.Size = UDim2.new(1, -10, 1, -40); Scroll.Position = UDim2.new(0, 5, 0, 35); Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0,0,1.5,0)
    Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

    local pasos = {
        "saca el upper y lower del maletin", "une el upper con el lower", "inserta los pasadores delantero y trasero",
        "carga 30 balas 5.56mm en el cargador", "inserta el cargador en el AR", "jala la carga y suelta para recamara",
        "activa el seguro", "enciende la mira holografica", "activa el laser", "extiende la culata", "desactiva el seguro"
    }

    for _, p in ipairs(pasos) do
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, -10, 0, 35); b.Text = p:upper(); b.BackgroundColor3 = C.surfaceAlt; b.TextColor3 = C.textPrime; b.TextSize = 9; corner(b, 4)
        b.MouseButton1Click:Connect(function()
            EnviarAlChat("-" .. p .. "-")
            tw(b, {BackgroundColor3 = C.accentDim})
            task.delay(0.5, function() tw(b, {BackgroundColor3 = C.surfaceAlt}) end)
        end)
    end
end

-- ============================================================
-- 2. GUI PRINCIPAL
-- ============================================================
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui")); ScreenGui.Name = "RP_Ultimate_Full"
local Control = Instance.new("TextButton", ScreenGui); Control.Size = UDim2.new(0, 42, 0, 42); Control.Position = UDim2.new(0, 14, 0, 200); Control.BackgroundColor3 = C.surface; Control.Text = "RP"; Control.TextColor3 = C.textAccent; Control.Font = Enum.Font.GothamBold; Control.Draggable = true; corner(Control, 8); stroke(Control, C.accent)
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 460, 0, 360); Main.Position = UDim2.new(0.5, -230, 0.5, -180); Main.BackgroundColor3 = C.bg; Main.Visible = false; Main.Active = true; Main.Draggable = true; corner(Main, 10); stroke(Main, C.border)

-- Inputs y Buscador
local victimaInput = Instance.new("TextBox", Main); victimaInput.Size = UDim2.new(0, 176, 0, 28); victimaInput.Position = UDim2.new(0, 68, 0, 82); victimaInput.PlaceholderText = "👤 A QUIÉN?"; victimaInput.BackgroundColor3 = C.surface; victimaInput.TextColor3 = C.textAccent; corner(victimaInput, 6)
local balasInput = Instance.new("TextBox", Main); balasInput.Size = UDim2.new(0, 176, 0, 28); balasInput.Position = UDim2.new(0, 252, 0, 82); balasInput.PlaceholderText = "🔫 CON QUÉ?"; balasInput.BackgroundColor3 = C.surface; balasInput.TextColor3 = C.textAccent; corner(balasInput, 6)
local SearchBar = Instance.new("TextBox", Main); SearchBar.Size = UDim2.new(0, 285, 0, 28); SearchBar.Position = UDim2.new(0, 68, 0, 46); SearchBar.PlaceholderText = "🔍 BUSCADOR..."; SearchBar.BackgroundColor3 = C.surface; SearchBar.TextColor3 = Color3.new(1,1,1); corner(SearchBar, 6)
local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(0, 376, 0, 240); Scroll.Position = UDim2.new(0, 68, 0, 118); Scroll.BackgroundColor3 = C.panel; corner(Scroll, 8)
local layout = Instance.new("UIListLayout", Scroll); layout.Padding = UDim.new(0, 6)

-- ============================================================
-- 3. TODAS LAS ACCIONES (RESTAURADAS)
-- ============================================================
local database = {
    ["👤"] = {"hombro derecho", "hombro izquierdo", "brazo derecho", "brazo izquierdo", "antebrazo derecho", "antebrazo izquierdo", "codo derecho", "codo izquierdo", "muñeca derecha", "muñeca izquierdo", "mano derecha", "mano izquierda", "dedos mano der", "dedos mano izq", "pecho superior", "pecho inferior", "abdomen", "ingle", "muslo derecho", "muslo izquierdo", "rodilla derecha", "rodilla izquierda", "pantorrilla derecha", "pantorrilla izquierda", "tobillo derecho", "tobillo izquierdo", "pie derecho", "pie izquierdo", "costilla flotante der", "costilla flotante izq", "clavicula der", "clavicula izq", "esternon", "ombligo"},
    ["🥷"] = {"frente", "ojo derecho", "ojo izquierdo", "mandibula", "mejilla der", "mejilla izq", "oreja der", "oreja izq", "nuca", "cuello frontal", "cuello lateral der", "cuello lateral izq", "traquea", "nuez de adan", "sien derecha", "sien izquierda"},
    ["🛡️"] = {"placa pectoral chaleco", "placa dorsal chaleco", "kevlar lateral der", "kevlar lateral izq", "hombro con proteccion der", "hombro con proteccion izq", "casco (visera)", "casco (nuca)", "casco (lateral)", "axila derecha", "axila izquierda", "ingle (proteccion)"},
    ["🚗"] = {"llanta del der", "llanta del izq", "llanta tras der", "llanta tras izq", "motor", "radiador", "bateria", "alternador", "tanque de gas", "parabrisas", "medallon trasero", "ventanilla cond", "ventanilla copiloto", "pilar A", "pilar B", "bloque motor", "manguera frenos", "disco de freno", "amortiguador", "faro delantero der", "faro delantero izq", "calavera trasera"},
    ["💎"] = {"cristal blindado N3", "puerta blindada", "junta de puerta", "bisagra superior", "bisagra inferior", "mirilla tactica", "motor parte baja", "neumatico run-flat"},
    ["🥋"] = {"golpea nariz", "golpea higado", "golpea bazo", "golpea plexo solar", "gancho al menton", "patada baja muslo", "patea espinilla", "barrida de pierna", "luxa muñeca der", "luxa muñeca izq", "llave de brazo der", "llave de brazo izq", "estrangulacion trasera", "presiona nuca contra suelo", "tuerce dedos mano", "derribo tacleada"},
    ["🩹"] = {"aplica torniquete", "venda herida", "limpia zona alcohol", "inserta canula", "realiza RCP", "inyecta morfina"},
    ["👋"] = {"señal ALTO", "señal AVANZAR", "señal CUBIERTA", "señal ENEMIGO VISUAL", "señal REAGRUPARSE"},
    ["🔫"] = {"Armar AR-15"},
    ["📜"] = {"Chat (Comillas)", "Chat (Guiones)"}
}

local function crearBloque(txt, cat)
    local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, -10, 0, 82); f.BackgroundColor3 = C.surfaceAlt; f.Name = txt; corner(f, 7); stroke(f)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 24); l.Text = "  "..txt:upper(); l.TextColor3 = C.textAccent; l.BackgroundColor3 = C.surface; l.Font = Enum.Font.GothamBold; l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left; corner(l, 7)

    if cat == "👤" or cat == "🥷" or cat == "🛡️" or cat == "🚗" or cat == "💎" then
        local b1 = Instance.new("TextButton", f); b1.Size = UDim2.new(0.5, -4, 0, 50); b1.Position = UDim2.new(0, 2, 0, 28); b1.Text = "🎯 APUNTAR"; b1.BackgroundColor3 = C.aim; corner(b1, 6)
        b1.MouseButton1Click:Connect(function() local v = victimaInput.Text ~= "" and victimaInput.Text or "objetivo"; EnviarAlChat("-apunta a " .. txt .. " de " .. v .. "-") end)
        local b2 = Instance.new("TextButton", f); b2.Size = UDim2.new(0.5, -4, 0, 50); b2.Position = UDim2.new(0.5, 2, 0, 28); b2.Text = "💥 DISPARAR"; b2.BackgroundColor3 = C.shoot; corner(b2, 6)
        b2.MouseButton1Click:Connect(function() local v = victimaInput.Text ~= "" and victimaInput.Text or "objetivo"; local b = balasInput.Text ~= "" and balasInput.Text or "munición"; EnviarAlChat("-Dispara 1 bala (" .. b .. ") al " .. txt .. " de " .. v .. "-") end)
    else
        local b3 = Instance.new("TextButton", f); b3.Size = UDim2.new(1, -4, 0, 50); b3.Position = UDim2.new(0, 2, 0, 28); b3.Text = "👊 EJECUTAR"; b3.BackgroundColor3 = C.combat; corner(b3, 6)
        b3.MouseButton1Click:Connect(function()
            if txt == "Armar AR-15" then AbrirArmarAR15()
            elseif txt == "Chat (Comillas)" then CrearMiniChat("COMILLAS")
            elseif txt == "Chat (Guiones)" then CrearMiniChat("GUIONES")
            else local v = victimaInput.Text ~= "" and victimaInput.Text or "objetivo"; EnviarAlChat("-" .. txt .. " de " .. v .. "-") end
        end)
    end
end

for cat, list in pairs(database) do for _, v in pairs(list) do crearBloque(v, cat) end end

-- Barra Lateral y Buscador Lógica
local emos = {"👤", "🥷", "🛡️", "🚗", "💎", "🥋", "🩹", "👋", "🔫", "📜"}
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 52, 0, #emos * 42); Sidebar.Position = UDim2.new(0, 8, 0, 46); Sidebar.BackgroundColor3 = C.surface; corner(Sidebar, 8)
local sideLayout = Instance.new("UIListLayout", Sidebar); sideLayout.Padding = UDim.new(0, 2)

for _, emo in ipairs(emos) do
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = emo; b.TextSize = 20; b.BackgroundColor3 = C.surfaceAlt; corner(b, 6)
    b.MouseButton1Click:Connect(function()
        SearchBar.Text = ""
        for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
        for _, v in pairs(database[emo]) do if Scroll:FindFirstChild(v) then Scroll[v].Visible = true end end
    end)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBar.Text:lower()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c.Visible = (q=="" or c.Name:lower():find(q)) end end
end)

Control.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
