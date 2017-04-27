# Meetup Google OAuth Proxy [![Build Status](https://travis-ci.org/meetup/gauth-proxy.svg?branch=master)](https://travis-ci.org/meetup/gauth-proxy)

A nginx docker image for oauthing with google and
proxing some service through it.  This is extended
from the very awesome CloudFlare project of the
same topic: https://github.com/cloudflare/nginx-google-oauth

## Usage

Required env vars from the CloudFlare base are:

* NGO_CLIENT_ID
* NGO_CLIENT_SECRET
* NGO_TOKEN_SECRET

One from us:

* NGINX_PROXY_PASS

The project also expects certificates to be mounted as:

* `/etc/nginx/certs/tls.crt`
* `/etc/nginx/certs/tls.key`

Or you can have it generate self signed certificates on startup by setting
* NGO_GENERATE_CERT_CMD

example: openssl req -new -nodes -x509 -subj "/C=US/ST=New York/L=New York/O=IT/CN=*.domain.com" -days 365 -out /etc/nginx/certs/tls.crt -keyout /etc/nginx/certs/tls.key -extensions v3_ca
This proxy redirects http to https.
