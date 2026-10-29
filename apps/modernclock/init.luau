local ui = require("noctalia.ui")
local palette = require("noctalia.palette")
local timer = require("noctalia.timer")

local plugin = {}

-- Función para obtener el tiempo respetando la localización nativa del sistema operativo
local function get_localized_time()
    -- %A = Nombre completo del día de la semana (se adapta solo al idioma del sistema)
    -- %B = Nombre completo del mes (se adapta solo al idioma del sistema)
    -- %d = Número del día del mes
    -- %Y = Año completo
    local text_day   = os.date("%A")
    local text_time  = os.date("%H:%M")
    local text_date  = os.date("%B %d, %Y")
    
    return text_day, text_time, text_date
end

function plugin.init()
    local day, hora, fecha = get_localized_time()

    -- 1. El marco contenedor (Totalmente transparente para flotar sobre el fondo de pantalla)
    local container = ui.create("Frame", {
        Size = ui.size(450, 180),
        BackgroundColor = ui.color(0, 0, 0, 0), -- Transparencia total
        Padding = 10
    })

    -- 2. El Día de la Semana (Usa la fuente Anurati oficial en el color acento Catppuccin)
    local day_label = ui.create("TextLabel", {
        Parent = container,
        Size = ui.size(430, 60),
        Position = ui.point(0, 0),
        Text = day,
        TextColor = palette.get("mauve"), -- Color pastel dinámico
        TextSize = 46,
        Font = "Anurati, Sans", -- Llama a tu fuente Anurati geométrica
        Alignment = "Left"
    })

    -- 3. La Hora y Minutos (Línea minimalista usando la tipografía Poppins)
    local time_label = ui.create("TextLabel", {
        Parent = container,
        Size = ui.size(430, 50),
        Position = ui.point(5, 65),
        Text = hora,
        TextColor = palette.get("text"),
        TextSize = 38,
        Font = "Poppins, Sans", -- Llama a tu fuente Poppins limpia
        Bold = false,
        Alignment = "Left"
    })

    -- 4. La Fecha Completa (Pequeña, elegante y formateada según el idioma local)
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

    -- 5. EL REFRESH EN TIEMPO REAL: Se despierta cada segundo gastando 0% de CPU
    timer.create(1.0, function()
        local current_day, current_hora, current_fecha = get_localized_time()
        day_label.Text = current_day
        time_label.Text = current_hora
        date_label.Text = current_fecha
    end)

    return container
end

return plugin
