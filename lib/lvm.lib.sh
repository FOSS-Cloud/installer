#!/bin/bash
#
# Copyright (C) 2013 FOSS Group
#                    Germany
#                    http://www.foss-group.de
#                    support@foss-group.de
#
# Authors:
#  Christian Affolter <christian.affolter@stepping-stone.ch>
#  Beat Stebler <beat.stebler@foss-group.ch>
#  
# Licensed under the EUPL, Version 1.1 or – as soon they
# will be approved by the European Commission - subsequent
# versions of the EUPL (the "Licence");
# You may not use this work except in compliance with the
# Licence.
# You may obtain a copy of the Licence at:
#
# https://joinup.ec.europa.eu/software/page/eupl
#
# Unless required by applicable law or agreed to in
# writing, software distributed under the Licence is
# distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.
# See the Licence for the specific language governing
# permissions and limitations under the Licence.
#
# 
#

LVM_CONFIG=${LVM_CONFIG:="/etc/lvm/lvm.conf"}
LVM_VGSCAN_CMD=${LVM_VGSCAN_CMD:="/sbin/vgscan"}
LVM_VGCHANGE_CMD=${LVM_VGCHANGE_CMD:="/sbin/vgchange"}
LVM_VGREMOVE_CMD=${LVM_VGREMOVE_CMD:="/sbin/vgremove"}
LVM_PVS_CMD=${LVM_PVS_CMD:="/sbin/pvs"}
LVM_PVDISPLAY_CMD=${LVM_PVDISPLAY_CMD:="/sbin/pvdisplay"}
LVM_PVCREATE_CMD=${LVM_PVCREATE_CMD:="/sbin/pvcreate"}
LVM_PVREMOVE_CMD=${LVM_PVREMOVE_CMD:="/sbin/pvremove"}
LVM_VGCREATE_CMD=${LVM_VGCREATE_CMD:="/sbin/vgcreate"}
LVM_LVCREATE_CMD=${LVM_LVCREATE_CMD:="/sbin/lvcreate"}

GREP_CMD=${GREP_CMD:="/bin/grep"}
CUT_CMD=${CUT_CMD:="/bin/cut"}

function lvmConfigSetDeviceFilter ()
{
    local devicePath=$1
    sed -i -e \
        "s:^    filter =.*$:    filter = [ \"a|$devicePath|\", \"r/.*/\" ]:g" \
    $LVM_CONFIG

    return $?
}

function lvmCreateVolume ()
{
    local size="$1"
    local name="$2"
    local volumeGroup="$3"

    $LVM_LVCREATE_CMD --size "$size" --name "$name" "$volumeGroup"
    return $?
}


# Create a LVM logical volume and give the size of the volume in logical extents
#
# This is usefull in case you would like to give the number of extents in
# percentage to the size of the volume group (suffix %VG) or the remainig free
# space (suffix %FREE) of the volume group.
# Consult the LVCREATE(8) manual page for more informations.
#
# Example:
#   Create a volume ('my_volume') which uses all free space available in
#   the volume group ('my_vg0')
#   lvmCreateVolumeSizeInExtends "100%FREE" "my_volume" "my_vg0"
function lvmCreateVolumeSizeInExtends ()
{
    local extents="$1"
    local name="$2"
    local volumeGroup="$3"

    $LVM_LVCREATE_CMD --extents "$extents" --name "$name" "$volumeGroup"
    return $?
}

function lvmGetPhysicalVolumesByVolumeGroup ()
{
    local volumeGroup="$1"

    local separator=':'
    local regex="${separator}${volumeGroup}$" # ex.: :my_vg$

    $LVM_PVS_CMD \
        --noheadings \
        --options="pv_name,vg_name" \
        --separator="${separator}" | \
            $GREP_CMD -E "${regex}" | \
	    $CUT_CMD --delimiter="$separator" --field=1 | \
	    $CUT_CMD --characters=3-

    return $?
}
