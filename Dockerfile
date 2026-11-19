ARG NGINX_VERSION=1.30.7

# The upstream cloudflare/nginx-google-oauth image is unmaintained and ships
# nginx 1.10.3 on Debian 9. Build the Lua module as a dynamic module for the
# official nginx image instead, reusing that image's own configure arguments so
# the module stays ABI compatible.
FROM nginx:${NGINX_VERSION}-alpine AS lua-module

ARG NGINX_VERSION
ARG NGINX_SHA256=2565b5c837050e958f70fb0f73c48e2bca4542ad349fd356f46fb0c72610bc6e
ARG LUA_NGINX_MODULE_VERSION=0.10.31
ARG LUA_NGINX_MODULE_SHA256=123d8203e74bf66f71437c7b3fa070bf8d24e6d332981bc18dc2db43303cc741
ARG NGX_DEVEL_KIT_VERSION=0.3.4
ARG NGX_DEVEL_KIT_SHA256=14a28063294f645d457b1eb10e3c23bbba44398f1c5f021421b58b6f8ab31662

RUN apk add --no-cache --virtual .build-deps \
      build-base \
      curl \
      linux-headers \
      luajit-dev \
      openssl-dev \
      pcre2-dev \
      zlib-dev

# Sources are pinned by checksum: a moved tag or tampered archive fails the
# build. The GitHub archive hashes change if GitHub ever regenerates them, in
# which case the version and its hash must be updated together.
RUN set -eux; cd /tmp \
 && curl -fsSLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
 && curl -fsSL -o lua-nginx-module.tar.gz https://github.com/openresty/lua-nginx-module/archive/v${LUA_NGINX_MODULE_VERSION}.tar.gz \
 && curl -fsSL -o ngx_devel_kit.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${NGX_DEVEL_KIT_VERSION}.tar.gz \
 && echo "${NGINX_SHA256}  nginx-${NGINX_VERSION}.tar.gz" | sha256sum -c - \
 && echo "${LUA_NGINX_MODULE_SHA256}  lua-nginx-module.tar.gz" | sha256sum -c - \
 && echo "${NGX_DEVEL_KIT_SHA256}  ngx_devel_kit.tar.gz" | sha256sum -c - \
 && tar xzf nginx-${NGINX_VERSION}.tar.gz \
 && tar xzf lua-nginx-module.tar.gz \
 && tar xzf ngx_devel_kit.tar.gz

RUN cd /tmp/nginx-${NGINX_VERSION} \
 && CONFARGS=$(nginx -V 2>&1 | sed -n 's/^configure arguments: //p') \
 && export LUAJIT_INC=/usr/include/luajit-2.1 LUAJIT_LIB=/usr/lib \
 && eval ./configure $CONFARGS \
      --add-dynamic-module=/tmp/ngx_devel_kit-${NGX_DEVEL_KIT_VERSION} \
      --add-dynamic-module=/tmp/lua-nginx-module-${LUA_NGINX_MODULE_VERSION} \
 && make -j"$(nproc)" modules \
 && mkdir -p /modules \
 && cp objs/*.so /modules/

FROM nginx:${NGINX_VERSION}-alpine

RUN apk add --no-cache luajit lua-resty-core lua-resty-lrucache lua5.1-cjson

COPY --from=lua-module /modules/ /usr/lib/nginx/modules/

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY lua/ /etc/nginx/lua/
COPY run.sh /etc/nginx/run.sh

RUN chmod +x /etc/nginx/run.sh

ENTRYPOINT ["/etc/nginx/run.sh"]
