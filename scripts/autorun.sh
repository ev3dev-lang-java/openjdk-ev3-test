#!/bin/bash

if [ "$AUTOBUILD" -eq "1" ] || [ "$AUTOBUILD" == "yes" ]; then
    set -e

    cd "$(dirname ${BASH_SOURCE[0]})"
    source config.sh

    ./test.sh
else
    exec bash --login
fi
