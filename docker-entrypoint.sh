#!/bin/bash
set -e

# allow arguments to be passed to named
if [[ "${1:0:1}" == '-' ]]; then
    EXTRA_ARGS="${*}"
    set --
elif [[ "${1}" == "named" || "${1}" == "$(command -v named)" ]]; then
    EXTRA_ARGS="${*:2}"
    set --
fi

# default behaviour is to launch named
if [[ -z "${1}" ]]; then
    echo "Starting named..."
    echo "exec $(which named) -g \"${EXTRA_ARGS}\""
    exec $(command -v named) -g ${EXTRA_ARGS}
else
    exec "${@}"
fi
