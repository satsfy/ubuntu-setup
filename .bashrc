[ -f /home/renato/Desktop/ubuntu-setup/secrets/.bashrc ] && source /home/renato/Desktop/ubuntu-setup/secrets/.bashrc

. "$HOME/.cargo/env"
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
        echo "Using $candidate as base ref." >&2
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

act-logs() {
	act -W .github/workflows/rust.yaml --pull=false --concurrent-jobs 3 --json | jq -r '.message'
}

ci() {
  local output_dir="."
  local save_log="1"
  local workflow=".github/workflows/rust.yml"
  local event="pull_request"
  local jobs="1"
  local log_file=""
  local -a act_args=()
  local status=0

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -o|--output-dir)
        [ -n "$2" ] || { echo "ci: missing value for $1" >&2; return 2; }
        output_dir="$2"
        shift 2
        ;;
      -q|--no-log-file)
        save_log="0"
        shift
        ;;
      -w|--workflow)
        [ -n "$2" ] || { echo "ci: missing value for $1" >&2; return 2; }
        workflow="$2"
        shift 2
        ;;
      -e|--event)
        [ -n "$2" ] || { echo "ci: missing value for $1" >&2; return 2; }
        event="$2"
        shift 2
        ;;
      -j|--jobs)
        [ -n "$2" ] || { echo "ci: missing value for $1" >&2; return 2; }
        jobs="$2"
        shift 2
        ;;
      -h|--help)
        cat <<'EOF'
Usage: ci [options] [-- <extra act args>]

Run act for rust CI with optional log saving.

Options:
  -o, --output-dir DIR   Folder where log file is saved (default: .)
  -q, --no-log-file      Do not save run output to a log file
  -w, --workflow PATH    Workflow file (default: .github/workflows/rust.yml)
  -e, --event EVENT      Event name (default: pull_request)
  -j, --jobs N           Concurrent jobs for act (default: 1)
  -h, --help             Show this help

Examples:
  ci
  ci -o .act-logs
  ci -q
  ci -o .act-logs -- -n
EOF
        return 0
        ;;
      --)
        shift
        while [ "$#" -gt 0 ]; do
          act_args+=("$1")
          shift
        done
        ;;
      *)
        act_args+=("$1")
        shift
        ;;
    esac
  done

  output_dir="${output_dir/#\~/$HOME}"

  if [ "$save_log" = "1" ]; then
    mkdir -p "$output_dir" || return 1
    log_file="$output_dir/ci-$(date +%F_%H-%M-%S).log"

    act "$event" -W "$workflow" \
      --pull=false \
      --concurrent-jobs "$jobs" \
      --log-prefix-job-id \
      "${act_args[@]}" \
      2>&1 | tee "$log_file"

    status="${PIPESTATUS[0]}"
    echo "saved log: $log_file"
    return "$status"
  fi

  act "$event" -W "$workflow" \
    --pull=false \
    --concurrent-jobs "$jobs" \
    --log-prefix-job-id \
    "${act_args[@]}"
}

gh-cmp-stashes(){
  git show stash@{0}:src/primitives/correction.rs > /tmp/corr0.rs
  git show stash@{2}:src/primitives/correction.rs > /tmp/corr1.rs
  code --diff /tmp/corr0.rs /tmp/corr1.rs
}

gh-cmp-commits(){
  git show stash@{0}:src/primitives/correction.rs > /tmp/corr0.rs
  git show stash@{2}:src/primitives/correction.rs > /tmp/corr1.rs
  code --diff /tmp/corr0.rs /tmp/corr1.rs
}

gh-checkpoint() {
  name="checkpoint: $1"
  oid=$(git stash create "$name")
  git stash store -m "$name" "$oid"
}
