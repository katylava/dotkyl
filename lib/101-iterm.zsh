# alter iterm settings based on things and stuff


__danger_branch() {
    [ -z ${(t)DANGER_BRANCHES} ] && return 0

    local branch=`git_current_branch`
    return ${DANGER_BRANCHES[(I)${branch}]}
}

__set_iterm() {
    __danger_branch

    if [ $? -eq 0 ]; then
        printf "\e]1337;SetBadgeFormat=\a"
    else
        printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "🚫" | base64)
    fi
}

# badges are dumb when you have a right prompt :P
# precmd_functions+=(__set_iterm)
