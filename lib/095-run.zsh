# If my id_rsa identity has not been added to ssh-agent, add it
if ! ssh-add -l | grep -q id_rsa; then
  ssh-add ~/.ssh/id_rsa
fi
