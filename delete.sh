#!/usr/bin/env bash

_STORAGE="/var/lib/libvirt/storage/lvm-local"
_BASE="centos7-base.qcow2"
_POOL="lvm-local"

usage() {
    echo "$0 <name>" >&2
}

(( $# != 1 )) && { usage ; exit 1 ; }
name="$1"
file="${name}.qcow2"
shift

if virsh --connect qemu:///system vol-info --pool ${_POOL} ${file} >/dev/null 2>&1 ; then
    virsh \
        --connect qemu:///system \
    vol-delete \
        --pool lvm-local \
        "${file}" 
else
    echo "Volume ${name}.qcow2 does not exist."
fi

if virsh --connect qemu:///system dominfo ${name} >/dev/null 2>&1 ; then
    virsh \
        --connect qemu:///system \
    destroy "${name}"

    virsh \
        --connect qemu:///system \
    undefine "${name}"

else
    echo "Domain ${name} does not exist."
fi
