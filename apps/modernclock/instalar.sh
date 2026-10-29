#!/usr/bin/bash
set -euo pipefail

# Determinamos las rutas estándar de Noctalia/KineticWE
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# El enlace DEBE llamarse exactamente como el ID del plugin para que Noctalia lo valide
PLUGIN_DIR="$DATA_HOME/noctalia/plugins/com.rupeji.modernclock"
FONT_DIR="$HOME/.local/share/fonts/rupeji-widgets"

echo "=== INSTALADOR CONTROLADO: Modern Clock (Mond) ==="

# 1. INSTALACIÓN DE FUENTES TIPOGRÁFICAS ORIGINALES
echo "[+] Asegurando tipografías premium (Anurati y Poppins)..."
mkdir -p "$FONT_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Copiar las fuentes desde la carpeta global assets de la repo hacia las fuentes del sistema
if [ -d "$REPO_ROOT/assets" ]; then
  cp "$REPO_ROOT/assets/anurati."* "$FONT_DIR/" 2>/dev/null || true
  cp "$REPO_ROOT/assets/poppins."* "$FONT_DIR/" 2>/dev/null || true
  fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
fi

# 2. ENLACE DE ESTRUCTURA PLANA EN NOCTALIA
echo "[+] Generando enlace de estructura plana compatible..."
# Borramos cualquier rastro residual anterior
rm -rf "$PLUGIN_DIR"
mkdir -p "$(dirname "$PLUGIN_DIR")"

# Creamos el enlace simbólico apuntando DIRECTAMENTE a la carpeta que contiene el plugin.toml
ln -sf "$SCRIPT_DIR" "$PLUGIN_DIR"

# 3. REFRESCO DE LA CACHÉ DEL ENTORNO GRÁFICO (Obliga a escanear de cero)
echo "[+] Forzando refresco del greeter gráfico..."
sudo systemctl restart greetd || true

echo "[✓] ¡Estructura corregida con éxito! Abre tu entorno e inicia el Toggle Editor."
