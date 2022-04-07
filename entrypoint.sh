#!/bin/sh -l

set -e

: ${SG_ENV_NAME?Required environment name variable not set.}
: ${SG_REMOTE_PATH?Required remote path not set.}
: ${SITEGROUND_SSHG_KEY_PRIVATE?Required secret not set.}
: ${SITEGROUND_SSHG_KEY_PUBLIC?Required secret not set.}

#SSH Key Vars 
SSH_PATH="$HOME/.ssh"
KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"
SITEGROUND_SSHG_KEY_PRIVATE_PATH="$SSH_PATH/github_action"
SITEGROUND_SSHG_KEY_PUBLIC_PATH="$SSH_PATH/github_action.pub"

#Deploy Vars
SITEGROUND_SSH_HOST="$SG_ENV_NAME.ssh.siteground.net"
SG_DESTINATION="$SG_ENV_NAME"@"$SITEGROUND_SSH_HOST":sites/"$SG_ENV_NAME"/"$SG_REMOTE_PATH"

# Setup our SSH Connection & use keys
mkdir "$SSH_PATH"
ssh-keyscan -t rsa "$SITEGROUND_SSH_HOST" >> "$KNOWN_HOSTS_PATH"

#Copy Secret Keys to container
echo "$SITEGROUND_SSHG_KEY_PRIVATE" > "$SITEGROUND_SSHG_KEY_PRIVATE_PATH"
echo "$SITEGROUND_SSHG_KEY_PUBLIC" > "$SITEGROUND_SSHG_KEY_PUBLIC_PATH"

#Set Key Perms 
chmod 700 "$SSH_PATH"
chmod 644 "$KNOWN_HOSTS_PATH"
chmod 600 "$SITEGROUND_SSHG_KEY_PRIVATE_PATH"
chmod 644 "$SITEGROUND_SSHG_KEY_PUBLIC_PATH"

# Deploy via SSH
rsync --delete --rsh="ssh -v -p 22 -i ${SITEGROUND_SSHG_KEY_PRIVATE_PATH} -o StrictHostKeyChecking=no" -a --out-format="%n"  --exclude=".*" . "$SG_DESTINATION"
