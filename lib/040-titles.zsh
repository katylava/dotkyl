# COPIED MOSTLY FROM OH-MY-ZSH
#
# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)
function title {
  emulate -L zsh
  setopt prompt_subst

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"
# Avoid duplication of directory in terminals with independent dir display
if [[ "$TERM_PROGRAM" == Apple_Terminal ]]; then
  ZSH_THEME_TERM_TITLE_IDLE="%n@%m"
fi

# Runs before showing the prompt
function omz_termsupport_precmd {
  emulate -L zsh
  if [[ -z "$_tab_color_set" ]]; then
    tab-color --random
    _tab_color_set=1
  fi
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

# Runs before executing the command
function omz_termsupport_preexec {
  emulate -L zsh
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(omz_termsupport_precmd)
preexec_functions+=(omz_termsupport_preexec)

# Set iTerm session name on directory change so idle tabs show the last PWD
# instead of the profile name. OSC 1 titles are temporary; session name persists.
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  function _iterm_set_session_name {
    osascript -e "tell application \"iTerm2\" to tell current session of current tab of current window to set name to \"$(print -Pn '%15<..<%~%<<')\"" &>/dev/null &!
  }
  chpwd_functions+=(_iterm_set_session_name)
  # Defer initial call to first prompt so bookmarks (080) are loaded for %~ expansion
  function _iterm_init_session_name {
    _iterm_set_session_name
    precmd_functions=("${(@)precmd_functions:#_iterm_init_session_name}")
    unfunction _iterm_init_session_name
  }
  precmd_functions+=(_iterm_init_session_name)
fi

# Set tab title to PWD before launching claude, so the tab shows "dir (claude)"
# instead of "claude (claude)"
function claude { print -Pn "\e]1;%15<..<%~%<<\a"; command claude "$@"; }
