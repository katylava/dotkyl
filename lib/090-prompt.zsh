eval "$(starship init zsh)"

function _mypwd {

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
        # ... make sure it's not a dupe of the first directory, which happens when
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

    export MYPWD="$first_dir$trunc_part$formatted_cwd"
}

_mypwd

precmd_functions+=(_mypwd)
