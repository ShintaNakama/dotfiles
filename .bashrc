# lsよりコマンド打ちやすいllで、色付き隠しファイル込属性区別付きls
alias ll='ls -alFG'

# ファイル内文字コピー
alias pbcp='pbcopy <'

# 直下ディレクトリ全てのファイル名検索
alias figr='find . -type f | grep'

# 直下ディレクトリ全てのファイル内の文章検索
alias stgr='find . -type f | xargs grep'

# memoフォルダへ移動
alias memo='cd ~/memo'

# projectフォルダへ移動
alias proj='cd ~/project'

# メモリ監視
alias pls='ps aux'

# 容量監視
alias sls='du -sh ./*'

# brew系アップデート
alias brup='brew update && brew upgrade'

# tmux
alias t='tmux'

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

