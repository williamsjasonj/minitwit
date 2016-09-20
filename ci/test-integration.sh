#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"
cd "${script_dir}"

DOCKER_IMG="${DOCKER_IMG:-williamsjasonj/minitwit}"

COOKIE_JAR="cookies-$(date | md5 | head -c 10).txt"

# create mysql environment file
cat > mysql.env << EOF
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=minitwit
MYSQL_USER=minitwit
MYSQL_PASSWORD=minitwit
EOF

#docker rm -f minitwit mysql
# start mysql server
MYSQL_CONTAINER_ID="$(docker run -d --name=mysql --env-file=mysql.env mysql:5.7.15)"

# find mysql IP
MYSQL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' mysql)

# create minitwit environment file
cat > minitwit.env << EOF
SPRING_DATASOURCE_URL=jdbc:mysql://${MYSQL_IP}:3306/minitwit?autoReconnect=true&useSSL=false
SPRING_DATASOURCE_USERNAME=minitwit
SPRING_DATASOURCE_PASSWORD=minitwit
SPRING_DATASOURCE_DRIVER-CLASS-NAME=com.mysql.cj.jdbc.Driver
SPRING_DATASOURCE_PLATFORM=mysql
EOF

CONTAINER_ID="$(docker run -d --name=minitwit --env-file=minitwit.env "${DOCKER_IMG}")"

function cleanup {
  rm -f "${COOKIE_JAR}"
  docker rm -f "$CONTAINER_ID" "$MYSQL_CONTAINER_ID"
}
trap cleanup EXIT

CONTAINER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER_ID})"

i="0"
while [[ ${i} < 200 ]]; do
  set +o errexit
  STATUS_CODE="$(curl -I -s "http://${CONTAINER_IP}/public" | grep "HTTP/1.1" | cut -d' ' -f2)"
  set -o errexit
  if [[ "200" == "${STATUS_CODE}" ]]; then
    break
  fi
  i=$[$i+1]
  sleep 2
done

STATUS_CODE="$(curl -I -s "http://${CONTAINER_IP}/public" | grep "HTTP/1.1" | cut -d' ' -f2)"
echo $STATUS_CODE

USERNAME="$(date | md5 | head -c 10)"
echo $USERNAME

curl -v -f -X POST \
  --data "username=${USERNAME}&email=test@mailinator.com&password=password&password2=password" \
  "http://${CONTAINER_IP}/register"

curl -v -f -X POST -c "${COOKIE_JAR}" \
  --data "username=${USERNAME}&password=password" \
  "http://${CONTAINER_IP}/login"

MESSAGE="$(date | md5 | head -c 10)"
echo $MESSAGE
curl -v -f -X POST -b "${COOKIE_JAR}" \
  --data "text=secret-test-message" \
  "http://${CONTAINER_IP}/message"

curl -f "http://${CONTAINER_IP}/public" | grep -s "${MESSAGE}"

echo "TEST PASSED"
