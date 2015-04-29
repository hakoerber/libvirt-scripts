#!/usr/bin/env bash

_VG='centos'
_BASE_XML="$HOME/libvirt/base/centos7/centos7.xml"
_CONNECTION='qemu+ssh://root@10.1.2.4/system'

usage() {
    echo "$0 <name> [<mac>]" >&2
}

(( $# < 1 )) && { usage ; exit 1 ; }
name="$1"
shift
if (( $# >= 1 )) ; then
    mac="$1"
    shift
else
    mac="RANDOM"
fi

virt-clone --connect "${_CONNECTION}" \
    --original-xml="${_BASE_XML}" \
    --file "/dev/${_VG}/${name}" \
    --name "${name}" \
    --mac "${mac}" "${@}"

virsh --connect "${_CONNECTION}" dumpxml "${name}" | grep '<mac address'
