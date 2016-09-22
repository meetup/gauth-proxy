#!/bin/sh -e

if [ -z "${NGINX_SERVER_NAME}" ]; then
  echo "NGINX_SERVER_NAME is not set"
  exit 1
fi

if [ -z "${NGINX_SSL_CERT}" ]; then
  echo "NGINX_SSL_CERT is not set"
  exit 1
fi

if [ -z "${NGINX_SSL_KEY}" ]; then
  echo "NGINX_SSL_KEY is not set"
  exit 1
fi

if [ -z "${NGINX_PROXY_PASS}" ]; then
  echo "NGINX_PROXY_PASS is not set"
  exit 1
fi

if [ -z "${NGO_CLIENT_ID}" ]; then
  echo "NGO_CLIENT_ID is not set"
  exit 1
fi

if [ -z "${NGO_CLIENT_SECRET}" ]; then
  echo "NGO_CLIENT_SECRET is not set"
  exit 1
fi

if [ -z "${NGO_TOKEN_SECRET}" ]; then
  echo "NGO_TOKEN_SECRET is not set"
  exit 1
fi

# Define some defaults
export NGO_CALLBACK_SCHEME=${NGO_CALLBACK_SCHEME:-https}
export NGO_CALLBACK_URI=${NGO_CALLBACK_URI-/_oauth}
export NGO_SIGNOUT_URI=${NGO_SIGNOUT_URI-/_signout}
export NGO_EMAIL_AS_USER=${NGO_EMAIL_AS_USER:-true}
export NGO_EXTRA_VALIDITY=${NGO_EXTRA_VALIDITY:-0}
export NGO_USER=${NGO_USER:-unknown}

exec nginx -g "daemon off;" -c /etc/nginx/nginx.conf