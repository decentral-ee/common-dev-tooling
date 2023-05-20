#!/bin/bash -xe

# Required ENV:
# - DEVHOST_SERVER
# - DEVHOST_SSH_KEY
# - DEVHOST_USERNAME

function prepare_ssh_session() {
    # create temporary ssh key
    echo "$DEVHOST_SSH_KEY" > ssh.key
    chmod 600 ssh.key
    SSH_CMD="ssh -i ssh.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
}

function cleanup_ssh_session() {
    rm -f ssh.key
}

rsync -Pav \
  -e $SSH_CMD \
  ../../build/ \
  $DEVHOST_USERNAME@$DEVHOST_SERVER:$BUILD_DIR

$SSH_CM \
  $DEVHOST_USERNAME@$DEVHOST_SERVER \
  ln -nsf ../revs/${HEAD_SHORT_REV} ${LATEST_BUILD_SYMLINK}
