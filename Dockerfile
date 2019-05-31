FROM nginx:1.13-alpine

MAINTAINER Mush Mo <mush@pandorica.io>

ENV LUAJIT_INC=/usr/include/luajit-2.1
ENV LUAJIT_LIB=/usr/lib

RUN apk add --no-cache luajit-dev==2.1.0_beta3-r0
RUN apk add --no-cache lua5.1-cjson
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg \
        libxslt-dev \
        gd-dev \
        geoip-dev \
    && CONFIG="\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
    " \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && curl -fSL https://github.com/openresty/encrypted-session-nginx-module/archive/v0.08.tar.gz -o encrypted-session-nginx-module.tar.gz \
    && curl -fSL https://github.com/simplresty/ngx_devel_kit/archive/v0.3.0.tar.gz -o ngx_dev_kit.tar.gz \
    && curl -fSL https://github.com/openresty/set-misc-nginx-module/archive/v0.32.tar.gz -o ngx_set_misc.tar.gz \
    && curl -fSL https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz  -o lua_nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && tar -zxC /usr/src -f ngx_dev_kit.tar.gz  \
    && tar -zxC /usr/src -f encrypted-session-nginx-module.tar.gz \
    && tar -zxC /usr/src -f ngx_set_misc.tar.gz \
    && tar -zxC /usr/src -f lua_nginx.tar.gz \
    && rm *.tar.gz \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG  --add-module=/usr/src/ngx_devel_kit-0.3.0 --add-module=/usr/src/encrypted-session-nginx-module-0.08 --add-module=/usr/src/set-misc-nginx-module-0.32 --add-module=/usr/src/lua-nginx-module-0.10.13 --with-debug \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && rm -rf /usr/src

ADD ./nginx.conf /etc/nginx/conf.d/default.conf

