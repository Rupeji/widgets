local ui = require("noctalia.ui")
local palette = require("noctalia.palette")
local timer = require("noctalia.timer")

local plugin = {}

-- Función para obtener el tiempo respetando la localización nativa del sistema
local function get_localized_time()
    -- %A = Nombre completo del día de la semana según el idioma del sistema
    -- %B = Nombre completo del mes según el idioma del sistema
    -- %d = Día del mes con dos dígitos
    -- %Y = Año con cuatro dígitos
    local text_day   = os.date("%A")
    local text_time  = os.date("%H:%M")
    local text_date  = os.date("%B %d, %Y")
    
    return text_day, text_time, text_date
end

function plugin.init()
    local day, hora, fecha = get_localized_time()

    -- 1. El marco contenedor (Totalmente transparente para flotar sobre cualquier wallpaper)
    local container = ui.create("Frame", {
        Size = ui.size(450, 180),
        BackgroundColor = ui.color(0, 0, 0, 0),
        Padding = 10
    })

    -- 2. El Día de la Semana (Usa la fuente oficial Anurati y el color acento aciano/malva)
    local day_label = ui.create("TextLabel", {
        Parent = container,
        Size = ui.size(430, 60),
        Position = ui.point(0, 0),
        Text = day,
        TextColor = palette.get("mauve"), -- Tono pastel dinámico de Catppuccin
        TextSize = 46,
        Font = "Anurati, Sans", -- Tipografía oficial del widget original de Prayag2
        Alignment = "Left"
    })

    -- 3. La Hora y Minutos (Línea minimalista y fina usando la tipografía Poppins)
    local time_label = ui.create("TextLabel", {
        Parent = container,
        Size = ui.size(430, 50),
        Position = ui.point(5, 65),
        Text = hora,
        TextColor = palette.get("text"),
        TextSize = 38,
        Font = "Poppins, Sans", -- Tipografía oficial para el reloj minimalista
        Bold = false,
        Alignment = "Left"
    })

    -- 4. La Fecha Completa (Pequeña, estilizada y adaptada al idioma local)
    local date_label = ui.create("TextLabel", {
        Parent = container,
        Size = ui.size(430, 30),
        Position = ui.point(5, 120),
        Text = fecha,
        TextColor = palette.get("subtext1"),
        TextSize = 14,
        Font = "Poppins, Sans",
        Alignment = "Left"
    })

    -- 5. EL TEMPORIZADOR DE TIEMPO REAL: Se refresca cada segundo con gasto 0 de CPU
    timer.create(1.0, function()
        local current_day, current_hora, current_fecha = get_localized_time()
        day_label.Text = current_day
        time_label.Text = current_hora
        date_label.Text = current_fecha
    end)

    return container
end

return plugin
