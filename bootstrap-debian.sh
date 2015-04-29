#!/usr/bin/env bash

_IDENTITY=~/.ssh/id_rsa_lab

_SALT_MASTER='10.1.1.4'
_SALT_MASTER_PORT=22

usage() {
    echo "$0 <target> <hostname>" >&2
}

(( $# != 2 )) && { usage ; exit 1 ; }

# we generate new SSH keys on the master
cat << EOF |
sudo /srv/salt/scripts/gen_ssh_host_keys.sh "${2}" /srv/salt
EOF
ssh -p ${_SALT_MASTER_PORT} "${_SALT_MASTER}" -T

# we disable host key checking, as the host key will be changed 
# later anyway

cat << EOF | 
echo "$2" > /etc/hostname
cat /etc/hostname
echo "$2" > /etc/salt/minion_id
service salt-minion restart
EOF
ssh -i "${_IDENTITY}" -p 22 root@"${1}" -T \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null
