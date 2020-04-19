# 環境変数
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegedabagacad

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
alias ll='ls --git --time-style=long-iso -gl'
alias la='ls --git --time-style=long-iso -agl'
alias l1='exa -1'
# memoフォルダへ移動
alias memo='cd ~/memo'
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
alias gcmt='git commit -m'
alias gshow='git show'
alias gdif='git diff'
alias gpul='git pull'
alias glog='git log'
alias gbra='git branch'
# 天気
wttr()
{
  curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}"
}

# ----PATH---------------------------------
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH=$PATH:$HOME/.nodebrew/current/bin
#export PATH="$PATH:`yarn global bin`"
# mac python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# added by Anaconda3 5.2.0 installer
#export PATH="/anaconda3/bin:$PATH"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export GOPATH=$HOME/go

export PATH="$HOME/go/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/completion.zsh.inc'; fi
