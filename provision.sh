#!/usr/bin/env bash

_VG='centos'
_CONNECTION='qemu+ssh://root@10.1.2.4/system'

usage() {
    cat << EOF >&2
$0 <type> <name> [<mac>]

available types:
debian8
centos7
EOF
}

(( $# < 2 )) && { usage ; exit 1 ; }
type="$1"
shift
name="$1"
shift
if (( $# >= 1 )) ; then
    mac="$1"
    shift
else
    mac="$(printf '52:54:00:%02X:%02X:%02X' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])"
fi

echo "MAC address: $mac"

case "$type" in
    "centos7")
        _BASE_XML="$HOME/libvirt/base/centos7/centos7.xml"
        ;;
    "debian8")
        _BASE_XML="$HOME/libvirt/base/debian8/debian8.xml"
        ;;
esac

virt-clone --connect "${_CONNECTION}" \
    --original-xml="${_BASE_XML}" \
    --file "/dev/${_VG}/${name}" \
    --name "${name}" \
    --mac "${mac}" "${@}"
