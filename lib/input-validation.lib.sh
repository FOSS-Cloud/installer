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

# valid positive integer
REGEX_POSITIVE_INTEGER=${REGEX_POSITIVE_INTEGER:='^(0|([1-9][0-9]*))$'}

function readVarAndValidateRegex ()
{
    local varname="${1}"
    local prompt="${2}"
    local regex="${3}"
    local error="${4}"

    if test -z "$error"; then
        local error="${prompt} is invalid"
    fi

    while test -z "${!varname}"; do
        readVar "${varname}" "$prompt"
        if ! echo "${!varname}" | grep -q -E ${regex}; then
            error "$error"
            eval "${varname}=''"
        fi
    done

}

function readVarAndValidateInList ()
{
    local varname="${1}"
    local prompt="${2}"
    local list="${3}"
    local error="${4}"

    if test -z "$error"; then
        local error="${prompt} is unsupported"
    fi

    while test -z "${!varname}"; do
        readVar "${varname}" "$prompt"
        if ! in_list "${!varname}" "$list"; then
            error "$error"
            eval "${varname}=''"
        fi
    done
}

function readVarAndValidatePositiveIntegerMinMax ()
{
    local varname="${1}"
    local prompt="${2}"
    local min="${3}"
    local max="${4}"
    local invalidError="${5}"
    local minError="${6}"
    local maxError="${7}"

    if test -z "$invalidError"; then
        local invalidError="Invalid input"
    fi

    if test -z "$minError"; then
        local minError="Input is too small (min: ${min})"
    fi

    if test -z "$maxError"; then
        local maxError="Input is too high (max: ${max})"
    fi


    while test -z "${!varname}"; do
        readVar "${varname}" "$prompt"
        if ! echo "${!varname}" | grep -q -E ${REGEX_POSITIVE_INTEGER}; then
            error "$invalidError"
            eval "${varname}=''"
	    continue
	fi

        if [ ${!varname} -lt ${min} ]; then
            error "$minError"
            eval "${varname}=''"
	    continue
        fi

        if [ ${!varname} -gt ${max} ]; then
            error "$maxError"
            eval "${varname}=''"
	    continue
        fi
    done
}

function yesInput ()
{
    local prompt="$1"

    local prompt="yes or no?"
    local regex='^(yes|no)$'
    local error="Please enter yes or no"

    tmpYesNoAnswer=""
    
    readVarAndValidateRegex "tmpYesNoAnswer" "${prompt}" "${regex}" "${error}"

    if [ "$tmpYesNoAnswer" = "yes" ]; then
        local returnValue=0
    else
        local returnValue=1
    fi

    unset tmpYesNoAnswer
    return $returnValue
}


readAndValidateIpAddress ()
{
    local prompt="$1"

    local prompt="yes or no?"
    local regex='^(yes|no)$'
    local error="Please enter yes or no"

    tmpYesNoAnswer=""
    
    readVarAndValidateRegex "tmpYesNoAnswer" "${prompt}" "${regex}" "${error}"

    if [ "$tmpYesNoAnswer" = "yes" ]; then
        local returnValue=0
    else
        local returnValue=1
    fi

    unset tmpYesNoAnswer
    return $returnValue
}
