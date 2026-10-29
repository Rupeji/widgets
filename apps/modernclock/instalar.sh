#!/usr/bin/bash
set -euo pipefail

# Definición de rutas oficiales e IDs unificados del catálogo de Noctalia
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
APP_DIR="noctalia-kwe"
PLUGIN_DIR="$DATA_HOME/$APP_DIR/plugins/rupeji/modernclock"
FONT_DIR="$HOME/.local/share/fonts/rupeji-widgets"
PLUGIN_ID="rupeji/modernclock"

echo "=== INSTALADOR CONTROLADO: Modern Clock (Mond) ==="

# 1. INSTALACIÓN DE FUENTES TIPOGRÁFICAS
echo "[+] Asegurando tipografías premium (Anurati y Poppins)..."
mkdir -p "$FONT_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -d "$REPO_ROOT/assets" ]; then
  cp "$REPO_ROOT/assets/anurati."* "$FONT_DIR/" 2>/dev/null || true
  cp "$REPO_ROOT/assets/poppins."* "$FONT_DIR/" 2>/dev/null || true
  fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi

# 2. CREACIÓN DEL ENLACE EN LA CARPETA NATIVA DEL CATÁLOGO
echo "[+] Generando enlace simbólico en la ruta de KineticWE..."
mkdir -p "$DATA_HOME/$APP_DIR/plugins/rupeji"

if [ -e "$PLUGIN_DIR" ]; then
    rm -rf "$PLUGIN_DIR"
fi

# Enlazamos la carpeta viva bajo el namespace del autor
ln -sfn "$SCRIPT_DIR" "$PLUGIN_DIR"
echo "[✓] Enlazado correctamente en: $PLUGIN_DIR"

# 3. TRUCO MAESTRO: COMUNICACIÓN POR SOCKET CON EL ESCRITORIO EN VIVO
echo "[+] Enviando señal de refresco a KineticWE..."
if command -v noctalia-kwe >/dev/null 2>&1; then
    noctalia-kwe msg config-reload >/dev/null 2>&1 || true
    sleep 0.3
    if noctalia-kwe msg plugins enable "$PLUGIN_ID" >/dev/null 2>&1; then
        echo "[✓] Widget indexado y activado dinámicamente."
    else
        echo "[-] Activa 'Modern Clock (Mond)' manualmente en Settings -> Plugins"
    fi
else
    echo "[!] Entorno gráfico no activo de forma nativa en esta sesión."
fi

echo ""
echo "Siguiente paso: Abre Settings -> Desktop -> Toggle Editor y añade tu reloj."
