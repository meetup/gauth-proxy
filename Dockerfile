ARG NGINX_VERSION=1.30.7

# The upstream cloudflare/nginx-google-oauth image is unmaintained and ships
# nginx 1.10.3 on Debian 9. Build the Lua module as a dynamic module for the
# official nginx image instead, reusing that image's own configure arguments so
# the module stays ABI compatible.
FROM nginx:${NGINX_VERSION}-alpine AS lua-module

ARG NGINX_VERSION
ARG LUA_NGINX_MODULE_VERSION=0.10.31
ARG NGX_DEVEL_KIT_VERSION=0.3.4

RUN apk add --no-cache --virtual .build-deps \
      build-base \
      curl \
      linux-headers \
      luajit-dev \
      openssl-dev \
      pcre2-dev \
      zlib-dev

RUN cd /tmp \
 && curl -fsSLO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
 && tar xzf nginx-${NGINX_VERSION}.tar.gz \
 && curl -fsSL https://github.com/openresty/lua-nginx-module/archive/v${LUA_NGINX_MODULE_VERSION}.tar.gz | tar xz \
 && curl -fsSL https://github.com/vision5/ngx_devel_kit/archive/v${NGX_DEVEL_KIT_VERSION}.tar.gz | tar xz

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
