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

# cheap IPv4 address regex
REGEX_IPV4_ADDRESS=${REGEX_IPV4_ADDRESS:='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'}

# 0 - 32
REGEX_IPV4_CIDR_MASK=${REGEX_IPV4_CIDR_MASK:='^([0-9]|(1|2)[0-9]|3[0-2])$'}

# host name regex
REGEX_HOST_NAME=${REGEX_HOST_NAME:='^[a-z0-9\-]{1,255}$'}

# incredibly cheap domain name regex
REGEX_DOMAIN_NAME=${REGEX_DOMAIN_NAME:='^[a-z0-9][-a-z0-9.]+[^.]$'}


readVarAndValidateIpAddress ()
{
    local varname="${1}"
    local prompt="${2}"
    local error="${3}"

    if test -z "$prompt"; then
        local prompt='IP address'
    fi

    if test -z "$error"; then
        local error='Please enter a valid IP address'
    fi


    local regex="$REGEX_IPV4_ADDRESS"
    
    readVarAndValidateRegex "${varname}" "${prompt}" "${regex}" "${error}"
}

readVarAndValidateCidrNetmask ()
{
    local varname="${1}"
    local prompt="${2}"
    local error="${3}"

    if test -z "$prompt"; then
        local prompt='Netmask'
    fi

    if test -z "$error"; then
        local error='Please enter a valid CIDR netmask (0-32)'
    fi


    local regex="$REGEX_IPV4_CIDR_MASK"
    
    readVarAndValidateRegex "${varname}" "${prompt}" "${regex}" "${error}"
}

readVarAndValidateHostName ()
{
    local varname="${1}"
    local prompt="${2}"
    local error="${3}"

    if test -z "$prompt"; then
        local prompt='Host name'
    fi

    if test -z "$error"; then
        local error='Please enter a valid host name'
    fi


    local regex="$REGEX_HOST_NAME"
    
    readVarAndValidateRegex "${varname}" "${prompt}" "${regex}" "${error}"
}

readVarAndValidateDomainName ()
{
    local varname="${1}"
    local prompt="${2}"
    local error="${3}"

    if test -z "$prompt"; then
        local prompt='Domain name'
    fi

    if test -z "$error"; then
        local error='Please enter a valid domain name'
    fi


    local regex="$REGEX_DOMAIN_NAME"
    
    readVarAndValidateRegex "${varname}" "${prompt}" "${regex}" "${error}"
}

readVarAndValidateVlanId ()
{
    local varname="${1}"
    local prompt="${2}"
    local error="${3}"
    local invalidError="${4}"
    local minError="${5}"
    local maxError="${6}"

    local min=1
    local max=4094

    if test -z "$prompt"; then
        local prompt='VLAN ID'
    fi

    if test -z "$invalidError"; then
        local invalidError='Please enter a valid VLAN ID (1 - 4094)'
    fi

    if test -z "$minError"; then
        local minError='VLAN ID is too small it has to be >= 1'
    fi

    if test -z "$maxError"; then
        local maxError='VLAN ID is to high, it has to be <= 4094'
    fi

    readVarAndValidatePositiveIntegerMinMax \
        "${varname}" "${prompt}" "${min}" "${max}" \
        "${invalidError}" "${minError}" "${maxError}"
}
