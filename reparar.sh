#!/usr/bin/bash
set -euo pipefail

echo "=== INICIANDO SCRIPT DE REPARACIÓN ULTRA-VITAMINADO ==="

# 1. Forzar el mapa de teclado en español en la consola al instante
echo "[+] Configurando el teclado en castellano..."
sudo localectl set-keymap es || true

# 2. Reconstruir los grupos de hardware dinámicos inyectando el grupo RENDER
echo "[+] Asegurando grupos de hardware dinámicos (video, input, render)..."
sudo mkdir -p /etc/sysusers.d
echo "g video - -" | sudo tee /etc/sysusers.d/video.conf >/dev/null
echo "g input - -" | sudo tee /etc/sysusers.d/input.conf >/dev/null
echo "g render - -" | sudo tee /etc/sysusers.d/render.conf >/dev/null
sudo systemd-sysusers || true

# 3. Forzar la creación correcta del usuario greeter con TODOS los accesos gráficos
echo "[+] Vinculando usuario greeter a la aceleración por hardware..."
if ! id "greeter" &>/dev/null; then
  sudo useradd -r -M -d /var/lib/greetd -s /sbin/nologin greeter || true
fi
sudo usermod -aG video,input,render greeter || true

# 4. Clonar configuraciones estéticas en tu home
echo "[+] Sincronizando dotfiles de Fish y Starship..."
mkdir -p "$HOME/.config/kitty" "$HOME/.config/fish"
if [ -d /etc/skel/.config ]; then
    cp -rf /etc/skel/.config/kitty/kitty.conf "$HOME/.config/kitty/kitty.conf" 2>/dev/null || true
    cp -rf /etc/skel/.config/fish/config.fish "$HOME/.config/fish/config.fish" 2>/dev/null || true
    cp -rf /etc/skel/.config/starship.toml "$HOME/.config/starship.toml" 2>/dev/null || true
fi
sudo chown -R "$USER:$USER" "$HOME/.config"

# 5. Permisos totales y limpieza de sesiones fantasma
sudo mkdir -p /var/lib/greetd/.config/glow
sudo chmod -R 777 /var/lib/greetd
sudo chown -R greeter:greeter /var/lib/greetd || true
rm -f "$HOME/.wayland-session"

echo "[✓] ¡Reparaciones completadas! Reiniciando el entorno gráfico..."
sleep 1
sudo systemctl restart greetd
