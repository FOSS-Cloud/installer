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

DATA_CMD=${DATE_CMD:="/bin/date"}
CAT_CMD=${CAT_CMD:="/bin/cat"}

function fossCloudLogo ()
{
	clear
	echo -e "\e[1;34m"
	echo '             __________  __________       ________                __'
	echo '            / ____/ __ \/ ___/ ___/      / ____/ /___  __  ______/ /'
	echo '           / /_  / / / /\__ \\__ \______/ /   / / __ \/ / / / __  /'
	echo '          / __/ / /_/ /___/ /__/ /_____/ /___/ / /_/ / /_/ / /_/ /'
	echo '         /_/    \____//____/____/      \____/_/\____/\__,_/\__,_/'
	echo -e "\e[0m"
}

function fossCloudLogoWithProgramInfo ()
{
    local programName="${1:-"`getFossCloudNodeType`-node"}"
    local version="${2:-"`getFossCloudVersion`"}"

    local width=10

    local title="${programName} v${version}"
    local copyright="Copyright (C) 2010 - `${DATE_CMD} +%Y` FOSS-Group"
    local url="http://www.foss-group.de"

    fossCloudLogo

    echo "`repeatCharacter ' ' $(( $width - ${#title} ))` ${title}"
    echo ""
    echo "`repeatCharacter ' ' $(( $width - ${#copyright} ))` ${copyright}"
    echo "`repeatCharacter ' ' $(( $width - ${#url} ))` ${url}"
}

function getFossCloudVersion ()
{
    local versionFile='/etc/foss-cloud_version'

    if test -f ${versionFile}; then
        ${CAT_CMD} ${versionFile}
        return 0
    else
        echo 'unknown version'
        return 1
    fi
}

function getFossCloudNodeType ()
{
    local nodeTypeFile='/etc/foss-cloud/foss-cloud_node-type'

    if test -f ${nodeTypeFile}; then
        ${CAT_CMD} ${nodeTypeFile}
        return 0
    else
        echo "unknown"
        return 1
    fi
}


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

