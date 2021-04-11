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

OS=$(uname -s)

echo -e "$Purple\nChecking dependencies...\n$Color_Off"

# Checking if Docker is installed
if ! hash docker 2> /dev/null; then
    echo "docker:$Red ERROR - Docker must be installed (see: https://docs.docker.com/engine/installation/linux/docker-ce/debian/).$Color_Off" >&2
    exit 1
fi
echo -e "docker:$Green OK !$Color_Off"


if [ "$OS" = "Darwin" ]; then
   if ! hash brew; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   fi
   echo -e "brew:$Green OK !$Color_Off"

   if ! hash openssl 2> /dev/null; then
      brew install openssl
   fi
   echo -e "openssl:$Green OK !$Color_Off"
else
   if ! hash openssl 2> /dev/null; then
      echo "ERROR:$Red brew should be installed. visit https://cloudwafer.com/blog/installing-openssl-on-ubuntu-16-04-18-04/$Color_Off"
      exit 1
   fi
   echo -e "openssl:$Green OK !$Color_Off"

   if ! hash update-ca-certificates 2> /dev/null; then
      sudo apt-get install ca-certificates
   fi
   echo -e "update-ca-certificates:$Green OK !$Color_Off"
fi


echo -e "$Purple\nChecking repositories...\n$Color_Off"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."

# SANDBOX
if [[ ! -d ../sandbox ]]; then
   git clone https://github.com/PremierLangage/sandbox ../sandbox
   echo -e "sandbox:$Green cloned !\n$Color_Off"
else
   echo -e "sandbox:$Green already cloned !\n$Color_Off"
fi

# PLATON-FRONT
if [[ ! -d ../platon-front ]]; then
   git clone https://github.com/PremierLangage/platon-front ../platon-front
   echo -e "platon-front:$Green cloned !$Color_Off"
else
   echo -e "platon-front:$Green already cloned !$Color_Off"
fi

# PLATON_SERVER
if [[ ! -d ../platon-server ]]; then
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



echo -e "$Purple\nGenerating files...\n$Color_Off"


if [[ ! -f .env ]]; then
echo -e "
# INCREASE DOCKER COMPOSE TIMEOUT DELAY DO NOT REMOVE THIS VAR
COMPOSE_HTTP_TIMEOUT=200


# POSTGRES SERVICE
POSTGRES_USER=django
POSTGRES_PASSWORD=django_password
POSTGRES_DB=django_platon
PG_DATA=/var/lib/postgresql/data


# API SERVICE
DEBUG=true
ALLOWED_HOSTS=127.0.0.1,localhost,platon.dev

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


if ! grep -q "platon.dev" /etc/hosts; then
sudo -- sh -c "echo \"127.0.0.1  platon.dev\" >> /etc/hosts"
fi
echo -e "/etc/hosts:$Green OK !$Color_Off"


mkdir -p server/certs
mkdir -p server/dhparam

# https://support.kerioconnect.gfi.com/hc/en-us/articles/360015200119-Adding-Trusted-Root-Certificates-to-the-Server

if [[ ! -f server/certs/platon.dev.crt ]]; then
echo ""
# Generate a ssl certificate of 10 years for platon.dev domain
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 3650 -keyout server/certs/platon.dev.key -out server/certs/platon.dev.crt <<EOF
fr
Ile-de-france
Champs-sur-marne
IGM
PLaTon
platon.dev
nobody@nobody.com
EOF

   if [ "$OS" = "Darwin" ]; then
      security delete-certificate -c "platon.dev"
      echo ""
      security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain server/certs/platon.dev.crt
      echo ""
   else
      sudo rm -f /usr/local/share/ca-certificates/platon.dev.crt
      sudo update-ca-certificates --fresh

      sudo cp server/certs/platon.dev.crt /usr/local/share/ca-certificates/platon.dev.crt
      sudo update-ca-certificates
   fi
fi

echo -e "server/certs/platon.dev.key:$Green OK !$Color_Off"
echo -e "server/certs/platon.dev.crt:$Green OK !$Color_Off"

if [[ ! -f server/dhparam/dhparam.pem ]]; then
   openssl dhparam -out server/dhparam/dhparam.pem 2048
fi
echo -e "server/dhparam/dhparam-2048.pem:$Green OK !\n$Color_Off"
