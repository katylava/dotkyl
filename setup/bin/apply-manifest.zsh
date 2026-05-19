# Common scaffolding for the install:* mise tasks.
#
# A task sources this file, redefines only the hooks it needs, and calls
# `apply_manifest <Stem> <marker>`. The helper resolves setup/manifests/<Stem>.shared
# and setup/manifests/<Stem>.$DOTKYL_HOST, runs the hooks over each, and clears the
# .<marker>-outdated reminder marker.

# No-op hook defaults. Tasks override the ones they need; the rest stay inert
# so the helper can call all of them unconditionally.
check_line()   { return 0 }   # 0 = present / nothing missing
install_file() { : }
install_line() { : }
post_install() { : }

apply_manifest() {
  local stem=$1 marker=$2
  local -a files
  files=("setup/manifests/$stem.shared")
  [[ -n $DOTKYL_HOST ]] && files+=("setup/manifests/$stem.$DOTKYL_HOST")

  local f line
  for f in "${files[@]}"; do
    [[ -f $f ]] || continue

    install_file "$f"

    local -a missing_lines=()
    while IFS= read -r line || [[ -n $line ]]; do
      [[ -z $line || $line == \#* ]] && continue
      check_line "$line" || missing_lines+=$line
    done < $f
    (( ${#missing_lines} )) && install_line "${missing_lines[@]}"
  done

  post_install
  rm -f ".${marker}-outdated"
  print -r -- "✅ done"
}
