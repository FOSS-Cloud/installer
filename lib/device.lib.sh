#!/bin/bash
#
# Copyright (C) 2012 FOSS Group
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

DEVICE_SYS_CLASS_BLOCK_PATH="/sys/class/block"
DEVICE_SYS_CLASS_NET_PATH="/sys/class/net"
DEVICE_SYS_BLOCK_SIZE="512"
PARTED_CMD="/usr/sbin/parted"
PARTPROBE_CMD=${PARTPROBE_CMD:="/usr/sbin/partprobe"}


function deviceListAllBlockDevices ()
{
   local regexFilter=$1

   if test -z $regexFilter; then
       regexFilter='^.*$'
   fi

   ls $DEVICE_SYS_CLASS_BLOCK_PATH | grep --color=never -E $regexFilter
}

# Prints the block device size in byte
function deviceGetBlockDeviceSize ()
{
    local device=$1
    local divisor=$2

    if test -z $divisor; then
        divisor=1 # defaults to byte 
    fi

    local size=`cat $DEVICE_SYS_CLASS_BLOCK_PATH/$device/size`

    echo $(( $size * $DEVICE_SYS_BLOCK_SIZE / $divisor ))
}

function deviceGetBlockDeviceSizeGB ()
{
    local device=$1
    deviceGetBlockDeviceSize $device $(( 1024 * 1024 * 1024 ))
}


function devicePrintPartitionTable ()
{
    local device=$1
    $PARTED_CMD --script $device print
}

function deviceCreateGptDiskLabel ()
{
    local device=$1

    local commands="mklabel gpt"

    $PARTED_CMD -s -- $device $commands
    return $?
}


function deviceCreateOsbdPartitionLayout ()
{
    local device=$1

    local commands="mklabel msdos
                    mkpart primary 1MiB 64MiB
                    mkpart primary linux-swap 64MiB 4160MiB
                    mkpart primary 4160MiB 8256MiB
                    mkpart extended 8256MiB -1
                    mkpart logical 8257MiB -1
                    set 1 boot on
                    set 5 LVM on
                   "

    $PARTED_CMD --script --align optimal -- $device $commands
    return $?
}

function deviceErasePartitionTable ()
{
    local devicePath="$1"

    dd if=/dev/zero of=${devicePath} count=2 bs=1M > /dev/null 2>&1

    # inform the kernel about the partition change, otherwise it still sees
    # the old layout if there was one
    $PARTPROBE_CMD "${devicePath}"

    return $?
}

function deviceListAllEthernetInterfaces ()
{
   local regexFilter=$1

   if test -z $regexFilter; then
       regexFilter='^eth[0-9]+$'
   fi

   ls $DEVICE_SYS_CLASS_NET_PATH | grep --color=never -E $regexFilter
}
