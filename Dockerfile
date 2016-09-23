FROM cloudflare/nginx-google-oauth:1.1

RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

RUN echo "env NGINX_PROXY_PASS;" >> /etc/nginx/http.conf.d/env.conf

ADD default.conf /etc/nginx/conf.d/
ADD run.sh /etc/nginx/
