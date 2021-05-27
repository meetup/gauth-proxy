# Meetup Google OAuth Proxy
[![Build Status](https://travis-ci.com/meetup/gauth-proxy.svg?branch=master)](https://travis-ci.com/meetup/gauth-proxy)
[![](https://images.microbadger.com/badges/image/meetup/gauth-proxy.svg)](https://microbadger.com/images/meetup/gauth-proxy "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/meetup/gauth-proxy.svg)](https://microbadger.com/images/meetup/gauth-proxy "Get your own version badge on microbadger.com")

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

## Local Development and Testing

1. Copy `secrets.env.template` to `secrets.env` (gitignored) and populate environment variables. Secrets can be found in AWS Parameter Store under `/classic/admin` namespace, other values can be taken from the production CloudFormation stack [gauth-proxy-prod](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/parameters?filteringText=gauth&filteringStatus=active&viewNested=true&hideStacks=false&stackId=arn%3Aaws%3Acloudformation%3Aus-east-1%3A212646169882%3Astack%2Fgauth-proxy-prod%2F9690d7b0-fcd1-11e9-a582-0a182a3cd028)
2. Build and run a Docker container 
```sh
$ make package
$ docker run --rm -p 443:443 --env-file secrets.env -it <image_id>
```
3. Determine an IP address of the container by running `docker inspect <container_id>`
4. Add an alias to local `/etc/hosts`
```
<container_ip>  admin.meetup.com
```
5. Open `https://admin.meetup.com/admin` in a browser, dismiss the warning about an invalid certficate. If Chrome does not display 'proceed' option, type `thisisunsafe` on your keyboard to proceed. 
6. Sign in with your Meetup Google account. You should be redirected to the Meetup Admin website.
