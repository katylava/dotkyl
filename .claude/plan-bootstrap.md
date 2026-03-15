# Plan: Fresh Machine Bootstrap

Low priority — not needed until a new computer is acquired.

## Goal

Clone both repos and run one command. Prerequisites must be in place first.

## Prerequisites (manual, in order)

1. **Xcode Command Line Tools** — provides `git`, `make`, etc.:
   ```zsh
   xcode-select --install
   # follow the GUI prompt
   ```

2. **Homebrew**:
   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **1Password app** — install from https://1password.com and sign in.

4. **mise and 1Password CLI**:
   ```zsh
   brew install mise 1password-cli
   ```

## Bootstrap script

Run `bin/bootstrap` (or fetch and run via curl before the repo is cloned):

```zsh
curl -fsSL https://raw.githubusercontent.com/<user>/.dotkyl/main/bin/bootstrap | zsh
```

`bin/bootstrap` does the following (stored in the main repo, runnable standalone):

```zsh
#!/usr/bin/env zsh
set -e

# Generate a new SSH key for this machine
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

# Register the new key with GitHub using a token from 1Password
GITHUB_TOKEN=$(op read "op://Personal/GitHub Token/credential")
curl -sf -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"$(hostname)\",\"key\":\"$(cat ~/.ssh/id_ed25519.pub)\"}"

# Clone both repos
git clone git@github.com:<user>/.dotkyl.git ~/.dotkyl
git clone git@github.com:<user>/dotkyl-private.git ~/.dotkyl/private

# Run install
cd ~/.dotkyl
mise run install
```

## After bootstrap

Add the new machine's hostname to `bin/get-host`, commit and push, then re-run
`mise run install`:

```zsh
hostname  # note this value
# edit bin/get-host: add case for new hostname
git add bin/get-host && git commit -m "hosts: add new machine" && git push
mise run install
```
