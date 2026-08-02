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

# 3. Dotfiles + pacotes + automação de backup

Tudo num repo só — inclusive dotfiles (via stow, pacote `home/`) e a lista
de pacotes (`pkg/pkglist.txt`, só oficiais, sem AUR/yay). Nada disso depende
de `/mnt/backup`, que só existe na pc-arch:

```bash
git clone git@github.com:jholanda/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

O `install.sh`:
1. Instala os pacotes oficiais de `pkg/pkglist.txt` (`pacman -S --needed`).
   Pule com `--no-packages`.
2. Dá `stow` no pacote `home/` — cria os symlinks reais de `.config/`,
   `.zshrc`, `.local/` e `bin/` dentro de `$HOME` (instala o pacote `stow`
   se não tiver). Pule com `--no-dotfiles`.
3. Detecta o hostname: na `pc-arch` também ativa o timer systemd **`--user`**
   (sem sudo) de backup diário; em qualquer outro host (ex.: notebook),
   pula essa parte. Force com `--with-backup` / `--no-backup`.

Nem tudo em `home/.config/` se aplica a toda máquina (`xkb/` é só da
pc-arch — teclado US customizado, o notebook é ABNT2; `onedrive.service*`
é só do notebook) — sem problema, symlink de config não usada é inofensivo.

`pkg/pkglist.txt` só fica atualizado até a data do último `git push` feito
depois de um backup na pc-arch — não é regenerado automaticamente no clone.

---

# 4. Montagem automática do backup (pc-arch)

A partição de backup precisa estar no `/etc/fstab` com `nofail`, senão o
timer roda e o script escreve num diretório qualquer do disco raiz sem
avisar que a partição real não está montada (isso já aconteceu — ver
histórico do repo).

```
UUID=5bded178-fce7-4d9d-853b-0fdace47d09f  /mnt/backup  btrfs  defaults,nofail  0  2
```

Depois de editar, rodar `sudo mount -a` e conferir com `findmnt /mnt/backup`.
Esse passo continua precisando de sudo (é `/etc/fstab`, sistema); o timer de
backup em si (systemd `--user`) não precisa mais.

O próprio `home/bin/atualiza-backup.sh` também confere isso sozinho
(`mountpoint -q`) e aborta em vez de escrever no lugar errado.

---

# 5. Snapper

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

# 6. Pós-instalação

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
| `pkglist.txt` | Pacotes oficiais instalados (também copiado pra `pkg/` no repo) |
| `aur.txt` | Pacotes fora dos repos oficiais — só diagnóstico, deve ficar vazio (sem AUR/yay em uso); não é copiado pro repo nem instalado por `install.sh` |
| `discos.txt` | Layout de discos (lsblk -f) |
| `btrfs.txt` | Subvolumes Btrfs |
| `last-backup.txt` | Data do último backup |

## Automação

Timer systemd **`--user`** (sem root), ativado por `install.sh` a partir de
`home/.config/systemd/user/backup.{service,timer}`, dispara diariamente:

```bash
# Ver status do timer
systemctl --user list-timers backup.timer

# Rodar backup manualmente
systemctl --user start backup.service
systemctl --user status backup.service

# Logs
journalctl --user -u backup.service
```

Fonte de verdade dos arquivos do serviço (editar aqui, não em
`~/.config/systemd/user/` direto — lá é só o symlink do stow):
- `home/.config/systemd/user/backup.service`
- `home/.config/systemd/user/backup.timer`
- Script: `home/bin/atualiza-backup.sh`

Depois de editar qualquer um desses, rodar `./install.sh` de novo (o stow
já resolve o symlink; só precisa de `systemctl --user daemon-reload` se
mudou o `.service`/`.timer`, o que `install.sh` já faz).

## Backup manual (rsync direto)

```bash
~/bin/atualiza-backup.sh
# ou, para outro destino:
BACKUP_ROOT=/mnt/outro ~/bin/atualiza-backup.sh
```
