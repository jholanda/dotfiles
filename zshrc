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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jholanda/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jholanda/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jholanda/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jholanda/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup



# 1. Autocompletar e ganchos de ferramentas
eval "$(direnv hook zsh)"
eval "$(uv generate-shell-completion zsh)"

prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local venv_name=$(basename "$VIRTUAL_ENV")
    if [[ "$venv_name" == ".venv" ]]; then
      venv_name=$(basename "$(dirname "$VIRTUAL_ENV")")
    fi
    # Usando o caractere nf-fa-python (padrão Nerd Font) que o Alacritty vai ler 100%
    prompt_segment blue black "󱔎 $venv_name"
  fi
}
export PATH="$HOME/.local/bin:$PATH"

# Reescaneia pacotes AUR contra a lista do Atomic Arch
alias aurscan='git -C ~/aur-malware-check pull --quiet && comm -12 <(pacman -Qmq | sort) <(sort ~/aur-malware-check/package_list.txt) | grep . && echo "⚠️  pacotes acima estão na lista de comprometidos" || echo "✓ limpo — nenhum pacote AUR comprometido"'
