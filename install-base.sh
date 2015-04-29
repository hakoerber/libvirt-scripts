#!/usr/bin/env bash

_CONN='qemu+ssh://root@10.1.2.4/system'

virt-install \
    --connect "${_CONN}" \
    --name centos7-base \
    --memory 500 \
    --vcpus=1 \
    --clock offset=utc \
    --cdrom /var/lib/libvirt/images/lvm-isos/CentOS-7.0-1406-x86_64-Minimal.iso \
    --os-variant centos7.0 \
    --disk pool=centos,size=5,bus=virtio \
    --network network=int-bridge,model=virtio \
    --graphics spice \
    "$@"

