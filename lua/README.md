# Vendored Lua scripts

These files were copied verbatim from the `cloudflare/nginx-google-oauth:1.1.1`
image, which is no longer maintained:

- `nginx-google-oauth/access.lua` — CloudFlare Google OAuth access handler, MIT
  (https://github.com/cloudflare/nginx-google-oauth)
- `resty/http.lua`, `resty/http_headers.lua` — lua-resty-http 0.07, BSD-2-Clause
  (https://github.com/ledgetech/lua-resty-http)

They are baked into the image at `/etc/nginx/lua/`.
