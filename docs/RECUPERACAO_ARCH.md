# Recuperação Arch Linux

Este documento (e todo o resto da automação de backup) mora neste repositório
— não mais em `/mnt/backup`. `/mnt/backup` é só o destino dos dados gerados
pelo backup (home sincronizado + listas de pacotes), nunca a fonte de
verdade de scripts/config.

## Discos (pc-arch)

SSD principal:
- nvme1n1
- Arch em nvme1n1p6 (label `pc-arch`)
- /home no mesmo Btrfs

SSD backup:
- nvme0n1p2 (label `backup`)

---

# 1. Instalar Arch novamente

Inicializar pelo ISO do Arch.
Conectar internet.
Montar partições:

```bash
mkdir /mnt
mount /dev/nvme1n1p6 /mnt
mkdir /mnt/home
```

---

# 2. Restaurar backup

Montar backup:

```bash
mkdir -p /mnt/backup
mount /dev/nvme0n1p2 /mnt/backup
```

Restaurar home:

```bash
rsync -aAXHv \
  /mnt/backup/home/ \
  /mnt/home/
```

---

# 3. Restaurar pacotes

Lista em `/mnt/backup/system/pkglist.txt` (pacotes oficiais).
Lista AUR em `/mnt/backup/system/aur.txt` (instalar manualmente depois).

Instalar pacotes oficiais:

```bash
pacman -S --needed - < /mnt/backup/system/pkglist.txt
```

---

# 4. Dotfiles + automação de backup

Tudo num repo só:

```bash
git clone git@github.com:jholanda/dotfiles.git ~/dotfiles
```

Aplicar dotfiles (config/, .local/, zshrc, wezterm.lua, xkb/) como sempre —
copiar/ajustar manualmente para o home.

Instalar scripts + (se for a pc-arch) o timer de backup:

```bash
cd ~/dotfiles
./install.sh
```

O `install.sh` detecta o hostname:
- `pc-arch` → linka `~/bin/atualiza-backup.sh` ao script do repo **e** instala
  o timer systemd de backup diário.
- qualquer outro host (ex.: notebook) → linka só o script, sem timer. Use
  `./install.sh --with-backup` se essa outra máquina também tiver um destino
  de backup dedicado, ou `--no-backup` para forçar o contrário.

---

# 5. Montagem automática do backup (pc-arch)

A partição de backup precisa estar no `/etc/fstab` com `nofail`, senão o
timer roda e o script escreve num diretório qualquer do disco raiz sem
avisar que a partição real não está montada (isso já aconteceu — ver
histórico do repo).

```
UUID=5bded178-fce7-4d9d-853b-0fdace47d09f  /mnt/backup  btrfs  defaults,nofail  0  2
```

Depois de editar, rodar `sudo mount -a` e conferir com `findmnt /mnt/backup`.

O próprio `bin/atualiza-backup.sh` também confere isso sozinho (`mountpoint -q`)
e aborta em vez de escrever no lugar errado.

---

# 6. Snapper

Instalar e configurar:

```bash
pacman -S snapper snap-pac
snapper -c root create-config /
```

Política de retenção (`/etc/snapper/configs/root`):

```
HOURLY=5
DAILY=7
WEEKLY=0
MONTHLY=0
QUARTERLY=0
YEARLY=0
NUMBER_LIMIT=10
NUMBER_LIMIT_IMPORTANT=5
```

---

# 7. Pós-instalação

Verificar:
- rede
- áudio
- vídeo
- i3
- neovim
- ssh
- navegadores

---

# Backup — referência rápida

## Arquivos gerados pelo script (em `/mnt/backup/system/`, não versionados)

| Arquivo | Conteúdo |
|---|---|
| `pkglist.txt` | Pacotes oficiais instalados |
| `aur.txt` | Pacotes AUR instalados |
| `discos.txt` | Layout de discos (lsblk -f) |
| `btrfs.txt` | Subvolumes Btrfs |
| `last-backup.txt` | Data do último backup |

## Automação

Serviço e timer de sistema (root), instalados por `install.sh` a partir de
`systemd/` neste repo, disparam diariamente:

```bash
# Ver status do timer
sudo systemctl list-timers backup-home.timer

# Rodar backup manualmente
sudo systemctl start backup-home.service
sudo systemctl status backup-home.service

# Logs
journalctl -u backup-home.service
```

Fonte de verdade dos arquivos do serviço (editar aqui, não em `/etc` direto):
- `systemd/backup-home.service`
- `systemd/backup-home.timer`
- Script: `bin/atualiza-backup.sh`

Depois de editar qualquer um desses, rodar `./install.sh` de novo para
reinstalar.

## Backup manual (rsync direto)

```bash
~/bin/atualiza-backup.sh
# ou, para outro destino:
BACKUP_ROOT=/mnt/outro ~/bin/atualiza-backup.sh
```
