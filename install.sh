#!/bin/bash
# Instala o que este repo controla numa máquina Arch: pacotes pacman, os
# dotfiles em home/ (via stow) e, quando fizer sentido, a automação de
# backup (timer systemd --user, sem precisar de root).
#
# Uso:
#   ./install.sh                 # auto-detecta pelo hostname
#   ./install.sh --with-backup   # força instalar o timer de backup
#   ./install.sh --no-backup     # força não instalar o timer de backup
#   ./install.sh --no-packages   # pula a instalação de pacotes pacman
#   ./install.sh --no-dotfiles   # pula o stow (só pacotes/backup)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$(cat /etc/hostname 2>/dev/null || hostname)"

# Por padrão, só a pc-arch tem destino físico de backup (/mnt/backup).
WITH_BACKUP=0
[ "$HOST" = "pc-arch" ] && WITH_BACKUP=1
WITH_PACKAGES=1
WITH_DOTFILES=1

for arg in "$@"; do
  case "$arg" in
    --with-backup) WITH_BACKUP=1 ;;
    --no-backup) WITH_BACKUP=0 ;;
    --with-packages) WITH_PACKAGES=1 ;;
    --no-packages) WITH_PACKAGES=0 ;;
    --no-dotfiles) WITH_DOTFILES=0 ;;
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

if [ "$WITH_DOTFILES" = "1" ]; then
  command -v stow >/dev/null || sudo pacman -S --needed stow
  echo "-> Linkando dotfiles (home/) com stow..."
  stow -d "$DOTFILES_DIR" -t "$HOME" -R home
else
  echo "-> Pulando stow dos dotfiles."
fi

if [ "$WITH_BACKUP" = "1" ]; then
  echo "-> Ativando timer de backup diário (systemd --user)..."
  systemctl --user daemon-reload
  systemctl --user enable --now backup.timer
  echo "-> Timer ativo. Ver com: systemctl --user list-timers backup.timer"
else
  echo "-> Pulando timer de backup (host sem destino dedicado). Use --with-backup para forçar."
fi
