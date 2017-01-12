#!/bin/sh -e

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

#create self signed ssl cert
mkdir -p /etc/nginx/certs/
openssl req -new -nodes -x509 -subj "/C=US/ST=New York/L=New York/O=IT/CN=*.meetup.com" -days 3650 -out /etc/nginx/certs/tls.crt -keyout /etc/nginx/certs/tls.key -extensions v3_ca
exec nginx -g "daemon off;" -c /etc/nginx/nginx.conf
