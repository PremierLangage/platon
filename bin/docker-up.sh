#!/bin/bash -e

# Authorize the execution of this script from anywhere
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

# https://stackoverflow.com/a/14203146

prod=false
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -p|--prod)
      prod=true
      shift # past argument
      ;;
  esac
done

export SANDBOX_HOST=`./bin/find-ip.sh`
export SANDBOX_PORT=7000

if [ "$prod" = true ]
then
    docker-compose -f docker-compose.prod.yml build # --force-rm --no-cache
    if [[ ! -d ./server/certbot ]]; then
      ./bin/init-letsencrypt.sh
    fi
    docker-compose -f docker-compose.prod.yml up
else
    docker-compose -f docker-compose.dev.yml build # --force-rm --no-cache
    docker-compose -f docker-compose.dev.yml up
fi



