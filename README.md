# dotfiles

Configuração e automação das minhas máquinas Arch (pc-arch e notebook).

## Estrutura

```
config/    dotfiles de aplicativos (i3, polybar, rofi) — aplicados manualmente
.local/    binários pessoais (~/.local/bin)
xkb/       layout de teclado customizado
wezterm.lua, zshrc
bin/       scripts de sistema (hoje: backup). Linkados em ~/bin por install.sh
systemd/   units de automação (hoje: timer diário de backup)
docs/      guia de recuperação/restauração completo (RECUPERACAO_ARCH.md)
install.sh instala bin/ e systemd/ (backup) de forma adaptada à máquina
```

Antes disso, backup ficava dividido entre `~/bin` e `/mnt/backup` (script
num lugar, systemd units só em `/etc`, guia de recuperação só na própria
partição de backup — nada disso versionado). Agora tudo isso é gerenciado
por este repo; `/mnt/backup` é só o destino dos dados gerados pelo backup
(home sincronizado + listas de pacotes), nunca fonte de scripts/config.

## Uso numa máquina nova

```bash
git clone git@github.com:jholanda/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` detecta o hostname:
- **pc-arch**: linka `~/bin/atualiza-backup.sh` ao script do repo e instala
  o timer systemd de backup diário para `/mnt/backup`.
- **qualquer outro host** (ex.: notebook): linka só o script, sem o timer
  (não tem destino de backup dedicado). Force com `--with-backup` /
  `--no-backup` se quiser outro comportamento.

Dotfiles de config (`config/`, `.local/`, `zshrc`, `wezterm.lua`, `xkb/`)
continuam aplicados manualmente por enquanto — ver `docs/RECUPERACAO_ARCH.md`
para o passo a passo completo de restauração de uma máquina do zero.
