#!/bin/bash

BACKUP=/mnt/backup
mkdir -p "$BACKUP/system"

# Atualiza arquivos de recuperação

lsblk -f >"$BACKUP/system/discos.txt"

pacman -Qqe >"$BACKUP/system/pkglist.txt"

pacman -Qqm >"$BACKUP/system/aur.txt"

btrfs subvolume list / >"$BACKUP/system/btrfs.txt" 2>/dev/null || findmnt -t btrfs >"$BACKUP/system/btrfs.txt"
date >"$BACKUP/system/last-backup.txt"

# Sincroniza home
rsync -aAXHv --delete \
  --exclude='.cache' \
  /home/jholanda/ \
  "$BACKUP/home/"
