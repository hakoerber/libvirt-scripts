#!/usr/bin/env bash

_VG='centos'
_CONNECTION='qemu+ssh://root@10.1.2.4/system'
_BASE_XML="$HOME/dev/projects/libvirt-scripts/schema/"

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

echo "MAC: $mac"

case "$type" in
    "centos7")
        _xml="${_BASE_XML}/centos7.xml"
        ;;
    "debian8")
        _xml="${_BASE_XML}/debian8.xml"
        ;;
esac

virt-clone --connect "${_CONNECTION}" \
    --original-xml="${_xml}" \
    --file "/dev/${_VG}/${name}" \
    --name "${name}" \
    --mac "${mac}" "${@}"
