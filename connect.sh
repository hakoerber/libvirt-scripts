#!/usr/bin/env bash

_IDENTITY=~/.ssh/id_rsa_lab

usage() {
    echo "$0 <target>" >&2
}

(( $# != 1 )) && { usage ; exit 1 ; }

ssh -i "${_IDENTITY}" -p 22 root@"${1}"
