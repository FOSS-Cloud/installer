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

FILESYSTEM_MKFS_CMD=${FILESYSTEM_MKFS_CMD:="/sbin/mkfs"}
FILESYSTEM_MKSWAP_CMD=${FILESYSTEM_MKSWAP_CMD:="/sbin/mkswap"}

function filesystemCreate ()
{
    local filesystemType="$1"
    local label="$2"
    local device="$3"
    local force="$4"

    if [ "$force" = "force" ]; then
        local force="-f"
    else
        local force=""
    fi

	if [ "$filesystemType" = "ext4" ]; then
		local force=""
	fi

    ${FILESYSTEM_MKFS_CMD}.${filesystemType} \
        $force -L "${lable}" "$device" > /dev/null

    return $?
}

function filesystemCreateFat ()
{
    local lable="$1"
    local device="$2"
    local force="$3"

    filesystemCreate "ext4" "$lable" "$device" "$force"

    return $?
}

function createOsbdFilesystemFAT ()
{
     local label="${osbFilesystemLabelPrefix}_$1"
     local device="$2"

     debug "Creating filesystem for device '${device}' with label '${label}'"

     if ! filesystemCreateFat "$label" "$device" ""; then
         error "Unable to create FAT filesystem on ${device}"
         die
     fi
     
     return $?
}

function filesystemCreateXfs ()
{
   local lable="$1"
   local device="$2"
   local force="$3"

   filesystemCreate "xfs" "$lable" "$device" "$force"
   return $?
}

function filesystemCreateSwap ()
{
    local label="$1"
    local device="$2"
    local force="$3"

    if [ "$force" = "force" ]; then
        local force="-f"
    else
        local force=""
    fi

    ${FILESYSTEM_MKSWAP_CMD} "$force" -L "${label}" "$device" > /dev/null
    return $?
}
