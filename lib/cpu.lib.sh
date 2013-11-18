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
TAIL_CMD=${TAIL_CMD:="/bin/tail"}
CUT_CMD=${CUT_CMD:="/bin/cut"}
CPU_PROC_CPUINFO=${CPU_PROC_CPUINFO:="/proc/cpuinfo"}


function cpuHasFlag ()
{
    local flag="$1"

    # note that there is a literal TAB after "flags"
    # for testing this in the shell use Ctrl-V TAB
    $GREP_CMD --quiet --max-count=1 -E "^flags	*:.* ${flag}( |$)" \
        $CPU_PROC_CPUINFO

    return $?
}

function cpuHasIntelVTSupport ()
{
    cpuHasFlag 'vmx'
    return $?
}

function cpuHasAMDVSupport ()
{
    cpuHasFlag 'svm'
    return $?
}

function cpuHasVirtualizationSupport ()
{
    if cpuHasIntelVTSupport || cpuHasAMDVSupport; then
        return 0
    fi 

    return 1
}

function cpuGetModelName ()
{
    local cpuId=0

    if ! test -z $1; then
        local cpuId="$1"
    fi

    # note that there is a literal TAB after "processor"
    # for testing this in the shell use Ctrl-V TAB
    $GREP_CMD -E "^processor	*: ${cpuId}$" --after-context=4 \
        $CPU_PROC_CPUINFO | $TAIL_CMD --lines 1 | $CUT_CMD -c 14-
}


function cpuGetVendorId ()
{
    local cpuId=0

    if ! test -z $1; then
        local cpuId="$1"
    fi

    # note that there is a literal TAB after "processor"
    # for testing this in the shell use Ctrl-V TAB
    $GREP_CMD -E "^processor	*: ${cpuId}$" --after-context=1 \
        $CPU_PROC_CPUINFO | $TAIL_CMD --lines 1 | $CUT_CMD -c 13-
}
