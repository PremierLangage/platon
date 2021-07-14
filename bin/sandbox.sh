#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

SANDBOX_HOST=`./bin/find-ip.sh`
SANDBOX_PORT=7000

cd ../sandbox/
source ./env/bin/activate
python3 manage.py runserver $SANDBOX_HOST:$SANDBOX_PORT
