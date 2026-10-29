#!/usr/bin/bash
set -euo pipefail

# Determinar las rutas respetando los estándares XDG y KineticWE
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
PLUGIN_DIR="$DATA_HOME/noctalia-kwe/plugins/modernclock"
FONT_DIR="$HOME/.local/share/fonts/rupeji-widgets"

echo "=== INSTALADOR AUTOMÁTICO: Modern Clock (Mond) ==="
echo "Destino: $PLUGIN_DIR"

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

# 2. Enlazar el Widget en Noctalia KWE
echo "[+] Creando enlace simbólico del widget..."
rm -rf "$PLUGIN_DIR"
mkdir -p "$(dirname "$PLUGIN_DIR")"
ln -sf "$SCRIPT_DIR" "$PLUGIN_DIR"

# 3. Forzar el refresco del greeter gráfico para despertar el plugin
echo "[+] Forzando reinicio del entorno gráfico..."
sudo systemctl restart greetd || true

echo "[✓] ¡Instalación completada! Abre el menú de configuración de KineticWE para añadir tu widget."
