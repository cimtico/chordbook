#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "Waiting for $1:$2"
while ! nc -z $1 $2 </dev/null; do sleep 10; done