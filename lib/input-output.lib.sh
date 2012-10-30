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
# http://www.osor.eu/eupl
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

function header ()
{
    # Prints nice header boxes
    # +-----------------------+
    # |    title              |
    # +-----------------------+

    local title=$1
    local width=$2

    if test -z "$width"; then
        local width=80
    fi

    local spacesAfterTitle="$(( $width - ${#title} - 6))"

    echo -e "\n"
    echo "+`repeatCharacter '-' "$(( $width - 2 ))"`+"
    echo "|    ${title}`repeatCharacter ' ' ${spacesAfterTitle}`|"
    echo "+`repeatCharacter '-' "$(( $width - 2 ))"`+"
}

function debug ()
{
    if [ "$debug" == "yes" ]; then
        echo -e " DEBUG: $1"
    fi
}

function info ()
{
    echo -e " $1"
}

function error ()
{
    echo -e " ERROR: $1" >&2
}

function die ()
{
    local exitCode=$1

    if test -z $exitCode; then
        local exitCode=1
    fi

    echo ""
    error "Installation aborted\n"
    info "If you want to restart the installation process execute"
    info "bash $0"
    exit $exitCode
}

function printInputLine ()
{
    echo -e -n "\n$1: "
}

function repeatCharacter ()
{
    local character="$1"
    local amount="$2"

    readonly character=${character:='#'}
    readonly amount=${amount:=80}

    local i=0;
    while (( $i < $amount )); do
        printf "%s" "$character";
        let i++
    done;
}

# readVar <varname> <description>
function readVar() {
    local varname="${1}"
    local default_varname="DEFAULT_${varname}"
    local prompt="${2}"

    read -e -p "${prompt}: " -i "${!default_varname}" "${varname}"
    debug "${prompt} is set to '${!varname}'"
}

