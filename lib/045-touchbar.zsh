test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# GIT
GIT_UNCOMMITTED="${GIT_UNCOMMITTED:-✚}"
GIT_UNSTAGED="${GIT_UNSTAGED:-✽}"
GIT_UNTRACKED="${GIT_UNTRACKED:-…}"
# GIT_STASHED="${GIT_STASHED:-$}"
GIT_UNPULLED="${GIT_UNPULLED:-↓}"
GIT_UNPUSHED="${GIT_UNPUSHED:-↑}"

# Output name of current branch.
git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Uncommitted changes.
# Check for uncommitted changes in the index.
git_uncomitted() {
  if ! $(git diff --quiet --ignore-submodules --cached); then
    echo -n "${GIT_UNCOMMITTED}"
  fi
}

# Unstaged changes.
# Check for unstaged changes.
git_unstaged() {
  if ! $(git diff-files --quiet --ignore-submodules --); then
    echo -n "${GIT_UNSTAGED}"
  fi
}

# Untracked files.
# Check for untracked files.
git_untracked() {
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo -n "${GIT_UNTRACKED}"
  fi
}

# Stashed changes.
# Check for stashed changes.
git_stashed() {
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    echo -n "${GIT_STASHED}"
  fi
}

# Unpushed and unpulled commits.
# Get unpushed and unpulled commits from remote and draw arrows.
git_unpushed_unpulled() {
  # check if there is an upstream configured for this branch
  command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

  local count
  count="$(command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)"
  # exit if the command failed
  (( !$? )) || return

  # counters are tab-separated, split on tab and store as array
  count=(${(ps:\t:)count})
  local arrows left=${count[1]} right=${count[2]}

  (( ${right:-0} > 0 )) && arrows+="${GIT_UNPULLED}"
  (( ${left:-0} > 0 )) && arrows+="${GIT_UNPUSHED}"

  [ -n $arrows ] && echo -n "${arrows}"
}

touchbar_precmd() {
  # Reset Touchbar
  echo -ne "\033]1337;PopKeyLabels\a"

  # CURRENT_DIR
  # -----------
  # echo -ne "\033]1337;SetKeyLabel=F1=👉 $(echo $(pwd) | awk -F/ '{print $(NF-1)"/"$(NF)}')\a"

  # GIT
  # ---
  # Check if the current directory is in a Git repository.
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  # Check if the current directory is in .git before running git checks.
  if [[ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]]; then

    # Ensure the index is up to date.
    git update-index --really-refresh -q &>/dev/null

    # String of indicators
    local indicators=''

    indicators+="$(git_uncomitted)"
    indicators+="$(git_unstaged)"
    indicators+="$(git_untracked)"
    # indicators+="$(git_stashed)"
    indicators+="$(git_unpushed_unpulled)"

    [ -z "${indicators}" ] && touchbarIndicators="✔" || touchbarIndicators="${indicators}"

    local _status="ᛅ $(git_current_branch) $touchbarIndicators"

    it2setkeylabel set status "${_status}"
  fi
}

# i never actually use this, so commenting it out for now
# precmd_functions+=(touchbar_precmd)
