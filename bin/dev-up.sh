DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

export SANDBOX_HOST=`./bin/find-ip.sh`
export SANDBOX_PORT=7000
docker-compose -f docker-compose.dev.yml up
