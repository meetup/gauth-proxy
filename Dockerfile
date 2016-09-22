FROM cloudflare/nginx-google-oauth:1.1

RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

ADD default.conf /etc/nginx/conf.d/
ADD run.sh /etc/nginx/
