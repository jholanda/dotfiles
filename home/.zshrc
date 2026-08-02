# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/go/bin:

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)


export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND="fd --type f"

alias conf="cd ~/.config"
alias exe="cd ~/share/fontes/exercism/python"
alias arco="cd ~/share/fontes/senado/arco"
alias clipboard='xclip -selection clipboard'

# 1. Abre com a configuração do kickstart-modular.nvim
alias lvim='NVIM_APPNAME=lazyvim \nvim'



# setxkbmap -option caps:escape

setopt HIST_EXPIRE_DUPS_FIRST  # Expire dup event first when trimming hist
setopt HIST_FIND_NO_DUPS       # Do not display previously found event
setopt HIST_IGNORE_ALL_DUPS    # Delete old event if new is dup
setopt HIST_IGNORE_DUPS        # Do not record consecutive dup events
setopt HIST_IGNORE_SPACE       # Do not record event starting with a space
setopt HIST_SAVE_NO_DUPS       # Do not write dup event to hist file


export PATH="$PATH:/home/jholanda/.local/bin"
export PATH="$PATH:/home/jholanda/.modular/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/usr/lib/claude-desktop-bin"
export LANG="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"


# export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

source $ZSH/oh-my-zsh.sh



# cache do uv na share (p8): alivia a raiz + restaura hardlink
export UV_CACHE_DIR="$HOME/share/.cache/uv"

# reescaneia pacotes AUR contra a lista do Atomic Arch
alias aurscan='git -C ~/aur-malware-check pull --quiet && comm -12 <(pacman -Qmq | sort) <(sort ~/aur-malware-check/package_list.txt) | grep . && echo "⚠️  pacotes acima estão na lista de comprometidos" || echo "✓ limpo — nenhum pacote AUR comprometido"'
