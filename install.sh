#!/bin/bash
# Instala o que este repo controla numa máquina Arch: pacotes pacman, os
# scripts em bin/ e, quando fizer sentido, a automação de backup (timer).
#
# Uso:
#   ./install.sh                 # auto-detecta pelo hostname
#   ./install.sh --with-backup   # força instalar o timer de backup
#   ./install.sh --no-backup     # força não instalar o timer de backup
#   ./install.sh --no-packages   # pula a instalação de pacotes pacman
#
# Dotfiles (config/, .local/, zshrc, wezterm.lua, xkb/) continuam sendo
# aplicados manualmente, como sempre foram até aqui — este script cuida só
# da parte de pacotes/scripts/backup.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$(cat /etc/hostname 2>/dev/null || hostname)"

# Por padrão, só a pc-arch tem destino físico de backup (/mnt/backup).
# Outras máquinas (ex.: notebook) recebem só os scripts, sem o timer.
WITH_BACKUP=0
[ "$HOST" = "pc-arch" ] && WITH_BACKUP=1
# Pacotes, por padrão, instala em qualquer host — é o que deixa as duas
# máquinas parecidas.
WITH_PACKAGES=1

for arg in "$@"; do
  case "$arg" in
    --with-backup) WITH_BACKUP=1 ;;
    --no-backup) WITH_BACKUP=0 ;;
    --with-packages) WITH_PACKAGES=1 ;;
    --no-packages) WITH_PACKAGES=0 ;;
    *)
      echo "argumento desconhecido: $arg" >&2
      exit 1
      ;;
  esac
done

echo "Host: $HOST"

if [ "$WITH_PACKAGES" = "1" ]; then
  echo "-> Instalando pacotes oficiais (pkg/pkglist.txt)..."
  sudo pacman -S --needed - <"$DOTFILES_DIR/pkg/pkglist.txt"
else
  echo "-> Pulando instalação de pacotes."
fi

mkdir -p "$HOME/bin"
ln -sf "$DOTFILES_DIR/bin/atualiza-backup.sh" "$HOME/bin/atualiza-backup.sh"
echo "-> ~/bin/atualiza-backup.sh linkado para o repo."

if [ "$WITH_BACKUP" = "1" ]; then
  echo "-> Instalando timer de backup diário (systemd)..."
  sudo install -Dm644 "$DOTFILES_DIR/systemd/backup-home.service" /etc/systemd/system/backup-home.service
  sudo install -Dm644 "$DOTFILES_DIR/systemd/backup-home.timer" /etc/systemd/system/backup-home.timer
  sudo systemctl daemon-reload
  sudo systemctl enable --now backup-home.timer
  echo "-> Timer ativo. Ver com: systemctl list-timers backup-home.timer"
else
  echo "-> Pulando timer de backup (host sem destino dedicado). Use --with-backup para forçar."
fi
