# dotfiles

Configuração e automação das minhas máquinas Arch (pc-arch e notebook).

## Estrutura

```
home/      pacote stow — espelha $HOME. Tudo aqui vira symlink real.
  .config/       i3, polybar, rofi, xkb (só pc-arch), alacritty, lazyvim,
                 systemd/user (backup.{service,timer}, onedrive só notebook)
  .local/bin/    binários pessoais (dbeaver, pycharm, etc. — só pc-arch)
  .zshrc
  bin/           scripts de sistema (hoje: atualiza-backup.sh)
pkg/       snapshot de pacotes oficiais instalados (pkglist.txt)
docs/      guia de recuperação/restauração completo (RECUPERACAO_ARCH.md)
install.sh instala pacotes, dá stow em home/ e (se fizer sentido) ativa o
           timer de backup — tudo adaptado à máquina
```

Sem AUR/yay — só pacotes oficiais do repositório do pacman.

Nem toda pasta de `home/.config/` se aplica às duas máquinas (ex.: `xkb/`
é só da pc-arch — teclado US customizado; o notebook é ABNT2 nativo.
`onedrive.service*` é só do notebook). Isso é normal: dar stow no repo
inteiro em qualquer uma das máquinas só cria symlinks a mais que nunca são
usados — não tem efeito colateral.

`pkg/pkglist.txt` é atualizado automaticamente toda vez que
`home/bin/atualiza-backup.sh` roda na pc-arch (ele copia de
`/mnt/backup/system/` pra dentro do repo). Isso não commita nem dá push
sozinho — quando quiser que o notebook fique com o mesmo conjunto de
pacotes, é só `git add/commit/push` esse arquivo e rodar `install.sh` de
novo do outro lado.

Antes disso, isso tudo ficava espalhado: parte em `~/bin`, parte em
`/mnt/backup` (script num lugar, systemd units de sistema só em `/etc`,
guia de recuperação só na própria partição de backup — nada versionado),
e a pc-arch usava `config/` solto enquanto o notebook já tinha migrado pra
`.config/` de verdade com stow. Agora é tudo este repo só; `/mnt/backup` é
só o destino dos dados gerados pelo backup, nunca fonte de scripts/config.

## Uso numa máquina nova

```bash
git clone git@github.com:jholanda/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh`:
1. Instala os pacotes oficiais de `pkg/pkglist.txt` (`pacman -S --needed`).
   Pule com `--no-packages`.
2. Dá `stow` em `home/` — symlinks reais de `.config/`, `.zshrc`, `.local/`
   e `bin/` pra dentro de `$HOME` (instala o pacote `stow` se faltar). Pule
   com `--no-dotfiles`.
3. Detecta o hostname: na `pc-arch` também ativa o timer systemd **`--user`**
   (sem sudo) de backup diário; em qualquer outro host (ex.: notebook), pula
   essa parte, porque não tem destino de backup dedicado. Force com
   `--with-backup` / `--no-backup`.

Ver `docs/RECUPERACAO_ARCH.md` para o passo a passo completo de restauração
de uma máquina do zero (discos, pacotes, backup, snapper).
