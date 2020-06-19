#
# This shell prompt config file was created by promptline.vim, then very
# heavily modified.
#

NEWLINE=$'\n'

SYMBOL=' ⁍ '

function __promptline_symbol {
    # checking "Use Unicode Version 9 Widths" in iTerm2
    # (under Profile > Text) seems to fix any weirdness
    # with using an emoji in the prompt
    # ... never mind, no it doesn't
    local symbol='⛵'

    mail -e
    [ $? -eq 0 ] && symbol="📨"

    [ ! -z "${DOCKER_MACHINE_NAME}" ] && symbol=$(echo -e "\ue7b0")

    printf "%s" "${symbol}"
}
function __promptline_kubecontext {
   # emulate -L zsh
   # setopt extended_glob
   # setopt +o nomatch

   local context
   local namespace

   if [ $commands[kubectl] ]; then
       ## using kubectl is too slow
       # context=`kubectl config current-context`
       # namespace=`kubectl config view --minify --output 'jsonpath={..namespace}'`
       context=`ag current-context ~/.kube/config | cut -d' ' -f2`
       namespace=`ag --nonumbers "name: ${context}" -B2 ~/.kube/config | ag namespace | gsed -E 's/^\s+//' | cut -d' ' -f2`

       printf "%s" "⎈ $context:$namespace"
       return
   fi

   return 1
}
function __promptline_last_exit_code {

  [[ $last_exit_code -gt 0 ]] || return 1;

  printf "%s" "$last_exit_code"
}
function __promptline_last_exec_time {
    local t=`fc -lD | tail -n1 | cut -f3 -d' '`

    printf "%s" "${t}"
}
function __promptline_virtualenv {
  [[ -z "${VIRTUAL_ENV}" ]] && return 1

  local name=$(basename "${VIRTUAL_ENV}")

  if [[ "${name}" =~ "\.v?env" ]]; then
      name=$(basename $(dirname "${VIRTUAL_ENV}"))
  fi

  printf "\ue606 %s" "$name"
}
function __promptline_danger_branch {
    [ -z ${(t)DANGER_BRANCHES} ] && return 0
    return ${DANGER_BRANCHES[(I)${1}]}
}
function __promptline_vcs_branch {
  local branch=`git_current_branch`
  local branch_symbol=" "
  local stash_symbol=" ᛋ"
  local blink="%{[5m%}"
  local blinkoff="%{[25m%}"

  # git
  if hash git 2>/dev/null; then
    if [ ! -z $branch ]; then

      __promptline_danger_branch $branch

      if [ $? -eq 0 ]; then
          blink=''
          blinkoff=''
      fi

      git stash list | grep ${branch} > /dev/null 2>&1

      if [ $? -eq 1 ]; then
          stash_symbol=''
      fi

      branch=${branch##*/}
      printf "%s" "${blink}${branch_symbol}${branch:-unknown}${stash_symbol}${blinkoff}"
      return
    fi
  fi
  return 1
}
function __promptline_cwd {
  local dir_limit="2"
  local truncation="⋯"
  local trunc_part=""
  local part_count=0
  local formatted_cwd=""
  local dir_sep="  "
  local tilde="~"

  # this file expansion syntax will give us a path that uses bookmark names
  local first_dir="${(%):-%-1~}"
  local last_dirs="${(%):-%3~}"

  # if the first directory is right under root, then let's just use root as the
  # first directory instead
  [[ "$first_dir[1]" == "/" ]] && first_dir="/"

  # For each directory in the last 3 directories...
  for part in ${(s:/:)${last_dirs}}; do
    # ... make sure it's not a dupe of the first director, which happens then
    # there are 3 or fewer directories in the path
    [[ $part == $first_dir ]] && continue
    # then truncate really long directory names
    len="${#part}"
    [[ len -gt 15 ]] && part=${part:0:7}⁎${part:$len-7:7}
    # and append this part to the string we are building up for the prompt
    formatted_cwd="$formatted_cwd$dir_sep$part"
  done

  # For directories under ~ or a bookmark, include the truncation string if
  # there are more directories between first_dir and last_dirs. The first
  # condition here handles an edge case with being at the root of a bookmarked
  # directory, where the second condition would get the number of chars in the
  # bookmark name instead of the number of directories in the path.
  [[ $part != $first_dir ]] && [[ ${#${(s:/:)${(%):-%~}}} -gt 4 ]] \
      && trunc_part=$dir_sep$truncation

  # For directories NOT under ~ or a bookmark, we pulled the real first
  # directory off of it, so we need to truncate at 3 instead of 4.
  [[ $first_dir == "/" ]] && [[ ${#${(s:/:)${(%):-%~}}} -gt 3 ]] \
      && trunc_part=$dir_sep$truncation

  printf "%s" "$first_dir$trunc_part$formatted_cwd"
}
function __promptline_left_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "a" header
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}" slice_suffix="$space${a_sep_fg}" slice_joiner="${a_fg}${a_bg}${alt_sep}${space}" slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}" slice_suffix="$space${b_sep_fg}" slice_joiner="${b_fg}${b_bg}${alt_sep}${space}" slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "$(__promptline_virtualenv)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}" slice_suffix="$space${c_sep_fg}" slice_joiner="${c_fg}${c_bg}${alt_sep}${space}" slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "$(__promptline_kubecontext)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "d" header
  slice_prefix="${d_bg}${sep}${d_fg}${d_bg}${space}" slice_suffix="$space${d_sep_fg}" slice_joiner="${d_fg}${d_bg}${alt_sep}${space}" slice_empty_prefix="${d_fg}${d_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "d" slices
  __promptline_wrapper "$(__promptline_symbol)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}
function __promptline_wrapper {
  # wrap the text in $1 with $2 and $3, only if $1 is not empty
  # $2 and $3 typically contain non-content-text, like color escape codes and separators

  [[ -n "$1" ]] || return 1
  printf "%s" "${2}${1}${3}"
}
function __promptline_git_status {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

  local added_symbol="✚"
  local unmerged_symbol="✗"
  local modified_symbol="✽"
  local clean_symbol="✔"
  local has_untracked_files_symbol="…"

  local ahead_symbol="↑"
  local behind_symbol="↓"

  local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=""

  set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  local behind_count=$1
  local ahead_count=$2

  # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T), Unmerged (U), Unknown (X), Broken (B)
  while read line; do
    case "$line" in
      M*) modified_count=$(( $modified_count + 1 )) ;;
      U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(( $added_count + 1 )) ;;
    esac
  done < <(git diff --name-status --cached)

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    has_untracked_files=1
  fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
    is_clean=1
  fi

  local leading_whitespace=""
  [[ $ahead_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$ahead_symbol$ahead_count"; leading_whitespace=" "; }
  [[ $behind_count -gt 0 ]]        && { printf "%s" "$leading_whitespace$behind_symbol$behind_count"; leading_whitespace=" "; }
  [[ $modified_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$modified_symbol$modified_count"; leading_whitespace=" "; }
  [[ $unmerged_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$unmerged_symbol$unmerged_count"; leading_whitespace=" "; }
  [[ $added_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$added_symbol$added_count"; leading_whitespace=" "; }
  [[ $has_untracked_files -gt 0 ]] && { printf "%s" "$leading_whitespace$has_untracked_files_symbol"; leading_whitespace=" "; }
  [[ $is_clean -gt 0 ]]            && { printf "%s" "$leading_whitespace$clean_symbol"; leading_whitespace=" "; }
}
function __promptline_right_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix

  # section "warn" header
  slice_prefix="${warn_sep_fg}${rsep}${warn_fg}${warn_bg}${space}" slice_suffix="$space${warn_sep_fg}" slice_joiner="${warn_fg}${warn_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "x" header
  slice_prefix="${x_sep_fg}${rsep}${x_fg}${x_bg}${space}" slice_suffix="$space${x_sep_fg}" slice_joiner="${x_fg}${x_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "x" slices
  __promptline_wrapper "$(__promptline_last_exec_time) %*" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "y" header
  slice_prefix="${y_sep_fg}${rsep}${y_fg}${y_bg}${space}" slice_suffix="$space${y_sep_fg}" slice_joiner="${y_fg}${y_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "y" slices
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # section "z" header
  slice_prefix="${z_sep_fg}${rsep}${z_fg}${z_bg}${space}" slice_suffix="$space${z_sep_fg}" slice_joiner="${z_fg}${z_bg}${alt_rsep}${space}" slice_empty_prefix=""
  # section "z" slices
  __promptline_wrapper "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # close sections
  printf "%s" "$reset"
}
function __promptline {
  local last_exit_code="${PROMPTLINE_LAST_EXIT_CODE:-$?}"

  local esc=$'[' end_esc=m
  if [[ -n ${ZSH_VERSION-} ]]; then
    local noprint='%{' end_noprint='%}'
  elif [[ -n ${FISH_VERSION-} ]]; then
    local noprint='' end_noprint=''
  else
    local noprint='\[' end_noprint='\]'
  fi
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local space=" "
  local sep=""
  local rsep=""
  local alt_sep=""
  local alt_rsep=""
  local reset="${wrap}0${end_wrap}"
  local reset_bg="${wrap}49${end_wrap}"
  local a_fg="${wrap}36${end_wrap}"
  local a_bg="${wrap}40${end_wrap}"
  local a_sep_fg="${wrap}30${end_wrap}"
  local b_fg="${wrap}33${end_wrap}"
  local b_bg="${wrap}45${end_wrap}"
  local b_sep_fg="${wrap}35${end_wrap}"
  local c_fg="${wrap}30${end_wrap}"
  local c_bg="${wrap}44${end_wrap}"
  local c_sep_fg="${wrap}34${end_wrap}"
  local d_fg="${wrap}30${end_wrap}"
  local d_bg="${wrap}46${end_wrap}"
  local d_sep_fg="${wrap}36${end_wrap}"
  local warn_fg="${wrap}30${end_wrap}"
  local warn_bg="${wrap}41${end_wrap}"
  local warn_sep_fg="${wrap}31${end_wrap}"
  local x_fg="${wrap}37${end_wrap}"
  local x_bg="${wrap}40${end_wrap}"
  local x_sep_fg="${wrap}30${end_wrap}"
  local y_fg="${wrap}30${end_wrap}"
  local y_bg="${wrap}42${end_wrap}"
  local y_sep_fg="${wrap}32${end_wrap}"
  local z_fg="${wrap}1;30${end_wrap}"
  local z_bg="${wrap}43${end_wrap}"
  local z_sep_fg="${wrap}33${end_wrap}"
  if [[ -n ${ZSH_VERSION-} ]]; then
    PROMPT="$(__promptline_left_prompt)$NEWLINE$SYMBOL "
    RPROMPT="$(__promptline_right_prompt)"
  elif [[ -n ${FISH_VERSION-} ]]; then
    if [[ -n "$1" ]]; then
      [[ "$1" = "left" ]] && __promptline_left_prompt || __promptline_right_prompt
    else
      __promptline_ps1
    fi
  else
    PS1="$(__promptline_ps1)"
  fi
}

if [[ -n ${ZSH_VERSION-} ]]; then
  if [[ ! ${precmd_functions[(r)__promptline]} == __promptline ]]; then
    precmd_functions+=(__promptline)
  fi
elif [[ -n ${FISH_VERSION-} ]]; then
  __promptline "$1"
else
  if [[ ! "$PROMPT_COMMAND" == *__promptline* ]]; then
    PROMPT_COMMAND='__promptline;'$'\n'"$PROMPT_COMMAND"
  fi
fi
