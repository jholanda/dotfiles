# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/go/bin:

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

ZSH_THEME_RANDOM_CANDIDATES=(agnoster steeef)

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)


export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND="fd --type f"

alias prj="cd ~/share/unb/projeto"
alias lista="cd ~/share/unb/cn/src/lista"
alias conf="cd ~/.config"

alias v='nvim'
alias nvim='NVIM_APPNAME=kickstart-modular.nvim nvim'

# neofetch
# setxkbmap -option caps:escape

setopt HIST_EXPIRE_DUPS_FIRST  # Expire dup event first when trimming hist
setopt HIST_FIND_NO_DUPS       # Do not display previously found event
setopt HIST_IGNORE_ALL_DUPS    # Delete old event if new is dup
setopt HIST_IGNORE_DUPS        # Do not record consecutive dup events
setopt HIST_IGNORE_SPACE       # Do not record event starting with a space
setopt HIST_SAVE_NO_DUPS       # Do not write dup event to hist file


# export TESSDATA_PREFIX = /usr/share/tessdata/
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jholanda/share/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jholanda/share/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export PATH="$PATH:/home/jholanda/.local/bin"
export PATH="$PATH:/home/jholanda/.modular/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

source $ZSH/oh-my-zsh.sh
#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/share/powerlevel9k/powerlevel9k.zsh-theme
