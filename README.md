# Meetup Google OAuth Proxy

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

This proxy redirects http to https.
