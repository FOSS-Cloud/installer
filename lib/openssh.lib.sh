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

SED_CMD=${SED_CMD:="/bin/sed"}

OPENSSH_SSHD_CONFIG=${OPENSSH_SSHD_CONFIG:="/etc/ssh/sshd_config"}


function opensshChangeListeningAddress ()
{
    local address="$1"
    local config="$2"

    if [ -z "$config" ]; then
        config=${OPENSSH_SSHD_CONFIG}
    fi

    sed -i "s/^#\?\(ListenAddress\) .*$/\1 ${address}/" $config
    return $?
}

function opensshReplaceConfigPattern ()
{
    local pattern="$1"
    local value="$2"
    local config="$3"

    if [ -z "$config" ]; then
        config=${OPENSSH_SSHD_CONFIG}
    fi

    sed -i "s/^#\?${pattern}$/${value}/" $config
    return $?
}
