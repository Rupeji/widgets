#!/usr/bin/bash
set -euo pipefail

# 1. DEFINICIÓN DE RUTAS OFICIALES DE KINETICOS / KINETICWE
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
APP_DIR="noctalia-kwe"
PLUGIN_DIR="$DATA_HOME/$APP_DIR/plugins/modernclock"
FONT_DIR="$HOME/.local/share/fonts/rupeji-widgets"
PLUGIN_ID="com.rupeji.modernclock"

echo "=== INSTALADOR CONTROLADO: Modern Clock (Mond) ==="

# 2. INSTALACIÓN DE FUENTES TIPOGRÁFICAS
echo "[+] Asegurando tipografías premium (Anurati y Poppins)..."
mkdir -p "$FONT_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -d "$REPO_ROOT/assets" ]; then
  cp "$REPO_ROOT/assets/anurati."* "$FONT_DIR/" 2>/dev/null || true
  cp "$REPO_ROOT/assets/poppins."* "$FONT_DIR/" 2>/dev/null || true
  fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi

# 3. CREACIÓN DEL ENLACE EN LA CARPETA NATIVA DE DON
echo "[+] Generando enlace simbólico en la ruta de KineticWE..."
mkdir -p "$DATA_HOME/$APP_DIR/plugins"

if [ -e "$PLUGIN_DIR" ]; then
    rm -rf "$PLUGIN_DIR"
fi

# Enlazamos directamente la carpeta viva de la app
ln -sfn "$SCRIPT_DIR" "$PLUGIN_DIR"
echo "[✓] Enlazado correctamente en: $PLUGIN_DIR"

# 4. TRUCO MAESTRO: COMUNICACIÓN POR SOCKET CON EL ESCRITORIO EN VIVO
echo "[+] Enviando señal de refresco a KineticWE..."
if command -v noctalia-kwe >/dev/null 2>&1; then
    noctalia-kwe msg config-reload >/dev/null 2>&1 || true
    sleep 0.3
    if noctalia-kwe msg plugins enable "$PLUGIN_ID" >/dev/null 2>&1; then
        echo "[✓] Widget activado dinámicamente en el sistema."
    else
        echo "[-] Activa 'Modern Clock (Mond)' manualmente en Settings -> Plugins"
    fi
else
    echo "[!] Entorno gráfico no activo de forma nativa en esta sesión."
fi

echo ""
echo "Siguiente paso: Abre Settings -> Desktop -> Toggle Editor y añade tu reloj."
