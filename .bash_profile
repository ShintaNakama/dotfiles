if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
[ -f "$HOME/.profile" ] && source "$HOME/.profile"
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
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
if [ -f '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/path.bash.inc' ]; then . '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/nakamashinta/GoogleCloudSDK/google-cloud-sdk/completion.bash.inc'; fi
