FROM nginx:latest
RUN rm /var/log/nginx/access.log && rm /var/log/nginx/error.log
RUN apt-get update && apt-get install -y \
    apt-utils autoconf automake build-essential git libcurl4-openssl-dev \
    libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev \
    pkgconf wget zlib1g-dev

RUN git clone --depth 1 -b v3.0.4 --single-branch https://github.com/SpiderLabs/ModSecurity
WORKDIR ModSecurity

RUN git submodule init && git submodule update && ./build.sh && ./configure && make && make install
RUN mkdir -p /etc/nginx/modsecurity && touch /etc/nginx/modsecurity/modsecurity.conf 
RUN cp modsecurity.conf-recommended /etc/nginx/modsecurity/modsecurity.conf && cp unicode.mapping /etc/nginx/modsecurity
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
RUN wget http://nginx.org/download/nginx-1.19.9.tar.gz && tar zxvf nginx-1.19.9.tar.gz && \
    cd nginx-1.19.9 && ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx && make modules

# RUN cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

