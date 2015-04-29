#!/usr/bin/env bash

_STORAGE="/var/lib/libvirt/storage/lvm-local"
_BASE="centos7-base.qcow2"
_POOL="lvm-local"

usage() {
    echo "$0 <name> <mac> [<additional args for virt-install>]" >&2
}

(( $# < 2 )) && { usage ; exit 1 ; }
name="$1"
mac="$2"
file="${name}.qcow2"
shift
shift

if ! virsh --connect qemu:///system vol-info --pool ${_POOL} ${file} >/dev/null 2>&1 ; then
    virsh \
        --connect qemu:///system \
    vol-create-as \
        --pool lvm-local \
        --name "${file}" \
        --capacity $(( 5 * 1024**3 )) \
        --format qcow2 \
        --backing-vol "${_STORAGE}/${_BASE}" \
        --backing-vol-format qcow2
else
    echo "Volume ${name}.qcow2 already exists."
fi

if ! virsh --connect qemu:///system dominfo ${name} >/dev/null 2>&1 ; then
    virt-install \
        --connect qemu:///system \
        --name "${name}" \
        --memory 500 \
        --vcpus 1 \
        --cpu host \
        --clock offset=utc \
        --import \
        --disk vol=lvm-local/"${file}",bus=virtio \
        --os-variant centos7.0 \
        --network network=internal-bridge,mac=${mac},model=virtio \
        --graphics spice \
        "$@"
else
    echo "Domain ${name} already exists."
fi
