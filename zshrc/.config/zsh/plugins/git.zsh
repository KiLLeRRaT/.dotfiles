alias gs='git status'
alias gf='git fetch'
alias gu='git pull'
alias gp='git push'
alias gpt='git push --tags'
alias gP='git push --force-with-lease'
alias ga='git add'
alias gcam='git commit -am'
alias gd='git diff'
alias gw='git diff --word-diff'
preexec(){ _lc=$1; }
alias gcm='git commit -m "${_lc#gcm }" #'
alias gl='git logo'
alias gdog='git dog'
alias gadog='git adog'
alias gb='git branch'
alias gr='git rebase'
alias gba='git branch --all'
alias gco='git checkout'
alias gm='git merge'
alias gt='git tag | sort -V | tail'
alias gcd="cd \"\$(git rev-parse --show-toplevel)\""
alias gi='git io'

gfr() {
	fd -t d --max-depth=1 -x \
		bash -c "pushd {} &> /dev/null;git fetch;git status | (echo -n ""{}: "";sed '/Your branch/!d');popd &> /dev/null"
}
# alias gtp='fn-gtp() { git tag $1 && git push --tags };fn-gtp'
gtp() { git tag $1 && git push --tags }
# alias gtD='fn-gt() { git tag -d $1 && git push origin -d $1 };fn-gt'
gtD() { git tag -d $1;git push origin -d $1 }
# GIT TAG REMOVE
# gtr(){git tag -d $1 && git push origin -d $1}
#; fn_gtr 3.4.0

