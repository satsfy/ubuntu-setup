export btcn1ip="<TODO: secret>"
export btcn1port="80"
export btcn1user="<TODO: secret>"
export btcn1password="<TODO: secret>"
alias btcn1="bitcoin-cli -rpcconnect=$btcn1ip -rpcport=$btcn1port -rpcuser=$btcn1user -rpcpassword=$btcn1password"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

gh-branch() {
  local input="$1" repo_url pr_number branch target

  [ -z "$input" ] && {
    echo "usage: gh-branch <.../pull/N or .../tree/branch>" >&2
    return 1
  }

  repo_url=$(printf '%s\n' "$input" | sed 's|/pull/.*||; s|/tree/.*||; s|\.git$||')

  if [[ "$input" == *"/pull/"* ]]; then
    pr_number=$(printf '%s\n' "$input" | sed -E 's|.*/pull/([0-9]+).*|\1|')
    target="pr-$pr_number"
    git fetch "$repo_url" "pull/$pr_number/head" || return
    git switch -C "$target" FETCH_HEAD
  else
    branch=$(printf '%s\n' "$input" | sed 's|.*/tree/||')
    git fetch "$repo_url" "$branch" || return
    git switch -C "$branch" FETCH_HEAD
  fi
}

gh-get-hist() {
  local base="$1"

  if [ -z "$base" ]; then
    local candidates=(
      "upstream/master"
      "upstream/main"
      "origin/master"
      "origin/main"
    )
    local candidate

    for candidate in "${candidates[@]}"; do
      if git show-ref --verify --quiet "refs/remotes/$candidate"; then
        base="$candidate"
        break
      fi
    done

    if [ -z "$base" ]; then
      echo "No upstream/origin master/main found. Please specify a base ref: gh-get-hist <base-ref>" >&2
      return 1
    fi
  fi

  git format-patch --stdout "$base..HEAD"
}

gh-get-folder-diff() {
    git diff --no-index "$(mktemp -d)" $1
}

