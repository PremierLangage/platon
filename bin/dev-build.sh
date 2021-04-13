DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

docker-compose -f docker-compose.dev.yml build
# docker-compose -f docker-compose.dev.yml build --force-rm --no-cache
