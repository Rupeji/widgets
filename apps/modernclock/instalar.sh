#!/usr/bin/bash
set -euo pipefail

# Determinar las rutas respetando los estándares XDG
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
PLUGIN_DIR="$DATA_HOME/noctalia/plugins/com.rupeji.modernclock"
FONT_DIR="$HOME/.local/share/fonts/rupeji-widgets"

echo "=== INSTALADOR AUTOMÁTICO: Modern Clock (Mond) ==="

# 1. Instalar las fuentes originales en el sistema de usuario
echo "[+] Copiando tipografías premium (Anurati y Poppins)..."
mkdir -p "$FONT_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [ -d "$REPO_ROOT/assets" ]; then
  cp "$REPO_ROOT/assets/anurati."* "$FONT_DIR/" 2>/dev/null || true
  cp "$REPO_ROOT/assets/poppins."* "$FONT_DIR/" 2>/dev/null || true
  fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi

# 2. Enlazar el Widget en Noctalia
echo "[+] Creando enlace simbólico del widget en Noctalia..."
rm -rf "$PLUGIN_DIR"
mkdir -p "$(dirname "$PLUGIN_DIR")"
ln -sf "$SCRIPT_DIR" "$PLUGIN_DIR"

echo "[✓] ¡Instalación completada! Reinicia tu entorno gráfico para activar las fuentes y el reloj."
