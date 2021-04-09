#!/usr/bin/env bash

# COLORS
# Reset
Color_Off=$'\e[0m' # Text Reset

# Regular Colors
Red=$'\e[0;31m'    # Red
Green=$'\e[0;32m'  # Green
Yellow=$'\e[0;33m' # Yellow
Purple=$'\e[0;35m' # Purple
Cyan=$'\e[0;36m'   # Cyan

echo -e "\nChecking dependencies...\n"
# Checking if Docker is installed
if ! hash docker 2> /dev/null; then
    echo "docker:$Red ERROR - Docker must be installed (see: https://docs.docker.com/engine/installation/linux/docker-ce/debian/).$Color_Off" >&2
    exit 1
fi
echo -e "docker:$Green OK !\n$Color_Off"


echo -e "Cloning repositories...\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

# SANDBOX
if [[ ! -d ../sandbox ]]
then
   git clone https://github.com/PremierLangage/sandbox ../sandbox
   echo -e "sandbox:$Green cloned !\n$Color_Off"
else
   echo -e "sandbox:$Green already cloned !\n$Color_Off"
fi

# PLATON-FRONT
if [[ ! -d ../platon-front ]]
then
   git clone https://github.com/PremierLangage/platon-front ../platon-front
   echo -e "platon-front:$Green cloned !$Color_Off"
else
   echo -e "platon-front:$Green already cloned !$Color_Off"
fi

# PLATON_SERVER
if [[ ! -d ../platon-server ]]
then
   git clone https://github.com/PremierLangage/platon-server ../platon-server

   mkdir -p ../platon-server/media
   mkdir -p ../platon-server/static
   mkdir -p ../platon-server/shared
   mkdir -p ../platon-server/shared/static
   mkdir -p ../platon-server/shared/templates


   touch ../platon-server/platon/config.py
   echo -e "
{
   \"lms\": [
      {
            \"guid\": \"elearning.u-pem.fr\",
            \"name\": \"ELEARNING UPEM\",
            \"url\": \"https://elearning.u-pem.fr/\",
            \"outcome_url\": \"https://elearning.u-pem.fr/mod/lti/service.php\",
            \"client_id\": \"moodle\",
            \"client_secret\":\"secret\"
      }
   ],
   \"admins\": [
      {
            \"username\": \"admin\",
            \"password\": \"adminadmin\"
      }
   ],
   \"sandboxes\": [
      {
            \"name\": \"Default\",
            \"url\": \"http://localhost:7000/\",
            \"enabled\": true
      }
   ]
}
   ">> ../platon-server/platon/config.json

   echo -e "platon-server:$Green cloned !$Color_Off"
else
   echo -e "platon-server:$Green already cloned !$Color_Off"
fi




echo -e "Generating files...\n"


if [[ ! -f .env ]]
then
echo -e "
DOMAIN=example.com

# POSTGRES SERVICE
POSTGRES_USER=django
POSTGRES_PASSWORD=django_password
POSTGRES_DB=django_platon
PG_DATA=/var/lib/postgresql/data


# API SERVICE
DEBUG=true
ALLOWED_HOSTS=127.0.0.1,localhost

DB_NAME=django_platon
DB_USERNAME=django
DB_PASSWORD=django_password
DB_HOST=172.17.0.1
DB_PORT=5431

REDIS_HOST=172.17.0.1
REDIS_PORT=6379

ELASTICSEARCH_HOST=172.17.0.1
ELASTICSEARCH_PORT=9200

SANDBOX_URL=http://localhost:7000/
" >> .env
fi
echo -e ".env:$Green OK !$Color_Off"

if [[ ! -d server/dhparam ]]
then
   mkdir -p server/dhparam
   sudo openssl dhparam -out server/dhparam/dhparam-2048.pem 2048
fi
echo -e "dhparam/dhparam-2048.pem:$Green OK !\n$Color_Off"
