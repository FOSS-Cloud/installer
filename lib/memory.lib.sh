#!/bin/bash
#
# Copyright (C) 2012 FOSS Group
#                    Germany
#                    http://www.foss-group.de
#                    support@foss-group.de
#
# Authors:
#  Christian Affolter <christian.affolter@stepping-stone.ch>
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

GREP_CMD=${GREP_CMD:="/bin/grep"}
AWK_CMD=${AWK_CMD:="/bin/awk"}
MEMORY_PROC_MEMINFO=${MEMORY_PROC_MEMINFO:="/proc/meminfo"}

function memoryGetTotal ()
{
    # returns total physical memory in KB
    $GREP_CMD "MemTotal:" $MEMORY_PROC_MEMINFO | $AWK_CMD '{print $2}'
    return $?
}

function memoryGetTotalInGb ()
{
    local totalMemory=`memoryGetTotal`
    local returnValue=$?

    echo $(( $totalMemory / 1024 / 1024 ))

    return $?
}
