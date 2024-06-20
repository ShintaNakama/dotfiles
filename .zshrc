# 環境変数
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad

TIMEFMT=$'\n\n========================\nProgram : %J\nCPU     : %P\nuser    : %*Us\nsystem  : %*Ss\ntotal   : %*Es\n========================\n'

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
# 直前のコマンドの重複を削除
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# プラグインを有効化
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%T %~ %F{magenta}$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias less='less -NM'
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
alias ls='exa --time-style=long-iso -g'
alias ll='exa --git --time-style=long-iso -gl'
alias la='exa --git --time-style=long-iso -agl'
alias l1='exa -1'
# uuid
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy"
# memoフォルダへ移動
alias mymemo='cd ~/memo && vim .'
# dotfilesへ移動
alias dotfiles='cd ~/dotfiles && vim .'
# brew系アップデート
alias brup='brew update && brew upgrade'
# tmux
alias t='tmux'
alias tlist='tmux list-session'
alias tatt='tmux attach -t'
# git
alias gsta='git status'
alias gckt='git checkout'
alias gadd='git add'
alias gcmt='git commit'
alias gshow='git show'
alias gdif='git diff'
alias gpul='git pull'
alias glog='git log'
alias gbra='git branch'
alias gpush="git push origin HEAD"
alias gpushf="git push --force-with-lease --force-if-includes origin HEAD"
# 天気
tenki()
{
  curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}"
}
# drawio
#alias ndrawio='touch ~/memo/new.drawio && code ~/memo/new.drawio'
ndrawio()
{
  touch ~/memo/"${1}".drawio && code ~/memo/"${1}".drawio
}

# bindkey -v でvimodeにした場合に使う
##zshプロンプトにモード表示####################################
#function zle-line-init zle-keymap-select {
#  case $KEYMAP in
#    vicmd)
#    PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[red]%}NOR%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
#    ;;
#    main|viins)
#    PROMPT="%{$fg[red]%}[%{$reset_color%}%n/%{$fg_bold[cyan]%}INS%{$reset_color%}%{$fg[red]%}]%#%{$reset_color%} "
#    ;;
#  esac
#  zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

## ----PATH---------------------------------
eval "$(nodenv init -)"

export PATH=/usr/local/bin:$PATH
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"

USE_GKE_GCLOUD_AUTH_PLUGIN=True

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shinta.nakama/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/shinta.nakama/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shinta.nakama/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/shinta.nakama/google-cloud-sdk/completion.zsh.inc'; fi
