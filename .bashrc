export btcn1ip="<TODO: secret>"
export btcn1port="80"
export btcn1user="<TODO: secret>"
export btcn1password="<TODO: secret>"
alias btcn1="bitcoin-cli -rpcconnect=$btcn1ip -rpcport=$btcn1port -rpcuser=$btcn1user -rpcpassword=$btcn1password"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

gh-branch() {
  repo_url=$(printf '%s\n' "$1" | sed 's|/pull/.*||; s|\.git$||')
  if printf '%s\n' "$1" | grep -q '/pull/'; then
    pr_number=$(printf '%s\n' "$1" | sed 's|.*/pull/||; s|/.*||')
    git fetch "$repo_url" "pull/$pr_number/head:pr-$pr_number" && git switch "pr-$pr_number"
  else
    branch=$(printf '%s\n' "$1" | sed 's|.*/tree/||')
    git fetch "$repo_url" "$branch:$branch" && git switch "$branch"
  fi
}

gh-get-hist() {
    git format-patch --stdout $1..HEAD
}
