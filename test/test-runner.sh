#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# very dumb testing script for now.

PUBLISH_TAG=$1

docker run -d \
  --name proxied \
  nginx:1.11.4-alpine

docker run -d \
  --link proxied:something.lol \
  -e NGINX_PROXY_PASS=http://something.lol \
  -e NGO_CLIENT_ID=my_id \
  -e NGO_CLIENT_SECRET=my_secret \
  -e NGO_TOKEN_SECRET=my_token_secret \
  -v $DIR:/etc/nginx/certs \
  --name gauth-proxy \
  $PUBLISH_TAG

docker run --link gauth-proxy:gauth.lol \
  --name tester \
  -v $DIR:/var/test \
  -e NGINX_HOST=gauth.lol \
  buildpack-deps:curl /var/test/test.sh

EXIT_CODE=$?

docker rm -f tester gauth-proxy proxied

exit $EXIT_CODE
