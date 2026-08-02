#!/bin/bash
# Atualiza o backup de home + metadados do sistema (pacotes, discos, btrfs).
#
# Destino padrão: /mnt/backup (partição dedicada, label "backup").
# Pode ser sobrescrito por variável de ambiente ou argumento:
#
#   BACKUP_ROOT=/mnt/outro ./atualiza-backup.sh
#   ./atualiza-backup.sh /mnt/outro
#
# Se o destino não existir/não estiver montado, o script aborta em vez de
# escrever silenciosamente num diretório qualquer do disco raiz.

set -euo pipefail

BACKUP_ROOT="${1:-${BACKUP_ROOT:-/mnt/backup}}"

if ! mountpoint -q "$BACKUP_ROOT"; then
  echo "erro: '$BACKUP_ROOT' não é um ponto de montagem ativo. Backup abortado." >&2
  echo "(confira 'findmnt $BACKUP_ROOT' e o /etc/fstab)" >&2
  exit 1
fi

mkdir -p "$BACKUP_ROOT/system"

lsblk -f >"$BACKUP_ROOT/system/discos.txt"

pacman -Qqe >"$BACKUP_ROOT/system/pkglist.txt"

pacman -Qqm >"$BACKUP_ROOT/system/aur.txt"

btrfs subvolume list / >"$BACKUP_ROOT/system/btrfs.txt" 2>/dev/null || findmnt -t btrfs >"$BACKUP_ROOT/system/btrfs.txt"
date >"$BACKUP_ROOT/system/last-backup.txt"

# Mantém a lista de pacotes oficiais versionada no repo também (pra outras
# máquinas rodarem `install.sh` e ficarem com o mesmo conjunto instalado).
# Não commita/dá push sozinho — isso fica pro seu fluxo normal de git.
# aur.txt fica só no destino de backup (diagnóstico), sem AUR helper em uso.
DOTFILES_PKG_DIR="$HOME/dotfiles/pkg"
if [ -d "$DOTFILES_PKG_DIR" ]; then
  cp "$BACKUP_ROOT/system/pkglist.txt" "$DOTFILES_PKG_DIR/pkglist.txt"
fi

# Sincroniza home
rsync -aAXHv --delete \
  --exclude='.cache' \
  "$HOME/" \
  "$BACKUP_ROOT/home/"
