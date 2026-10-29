#!/usr/bin/bash
set -euo pipefail

echo "=== INICIANDO SCRIPT DE REPARACIÓN EN CALIENTE ==="

# 1. Forzar el mapa de teclado en español en la consola al instante
echo "[+] Configurando el teclado en castellano..."
sudo localectl set-keymap es || true

# 2. Reconstruir los archivos estéticos de Fish y Starship en tu carpeta de usuario
echo "[+] Aprovisionando configuraciones de Fish, Kitty y Starship..."
mkdir -p "$HOME/.config/kitty" "$HOME/.config/fish"
if [ -d /etc/skel/.config ]; then
    cp -rf /etc/skel/.config/kitty/kitty.conf "$HOME/.config/kitty/kitty.conf" 2>/dev/null || true
    cp -rf /etc/skel/.config/fish/config.fish "$HOME/.config/fish/config.fish" 2>/dev/null || true
    cp -rf /etc/skel/.config/starship.toml "$HOME/.config/starship.toml" 2>/dev/null || true
fi
sudo chown -R "$USER:$USER" "$HOME/.config"

# 3. Curar en salud al usuario greeter abriendo las compuertas de permisos
echo "[+] Reparando los candados de seguridad del gestor de vídeo..."
sudo mkdir -p /var/lib/greetd/.config/glow
sudo chmod -R 777 /var/lib/greetd
sudo chown -R greeter:greeter /var/lib/greetd || true

# 4. Limpieza absoluta de archivos residuales de sesión que provoquen rebotes
rm -f "$HOME/.wayland-session"

echo "[✓] ¡Reparaciones completadas! Reiniciando el entorno gráfico..."
sleep 1
sudo systemctl restart greetd
