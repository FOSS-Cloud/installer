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

GRUB_CMD=${GRUB_CMD:="/sbin/grub"}
SED_CMD=${SED_CMD:="/bin/sed"}

function grubDetectBootPartition ()
{
    local searchFilePath="$1"

    # local bootPartition=`echo df 'find -name $searchFilePath' | \
    #     $GRUB_CMD --batch --no-floppy 2>/dev/null | \
	# grep -E '^ \(hd[0-9],[0-9]\)$'`

	local bootPartition=$(df `find -name $searchFilePath` | \
		cut -d " " -f1 | \
		grep /dev/ | \
		cut -d "/" -f3)
		echo "Zeile 46 in grub.lib.sh BootPartition = $bootPartition"
		
    if test -z "$bootPartition"; then
        return 1
    fi

    echo ${bootPartition:1} # trim the first white space
    return 0
}

function grubSetup ()
{
    local rootPartition="$1"
    local setupPartition="$2"
    echo "Root partition = ${rootPartition} line 54 in grub.lib.sh"
    echo "Setup partition = ${setupPartition} line 55 in grub.lib.sh"

    echo -e "root ${rootPartition}\nsetup ${setupPartition}\nquit" | \
        $GRUB_CMD --batch 2>&1 | grep --color=never "Error"

    if test $? -eq 0; then
        # grub had errors which were caught by grep
        return 1
    fi

    return 0
}

function grubConfigChangeRootPartition ()
{
    local grubConfig="$1"
    local rootString="$2" # ex. (hd0,0)

    $SED_CMD -i -e "s:(hd[0-9],[0-9]):${rootString}:" "$grubConfig"

    return $?
}
