FROM openresty/openresty:1.19.3.1-1-centos AS last-stage

MAINTAINER "shenshuo<191715030@qq.com>"
## 设置编码
ENV LANG en_US.UTF-8
# 同步时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY .  /usr/local/openresty/nginx/

WORKDIR /usr/local/openresty/nginx/
VOLUME /usr/local/openresty/nginx/logs/

EXPOSE 8888 11000

CMD ["/usr/bin/openresty", "-g", "daemon off;"]

STOPSIGNAL SIGQUIT

#FROM openresty/openresty:alpine-fat AS production-stage
#COPY . /tmp/
#RUN set -x \
#    && /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories \
#    && apk add --no-cache --virtual .builddeps \
#    automake \
#    autoconf \
#    libtool \
#    pkgconfig \
#    cmake \
#    git \
#    && cd /tmp \
#    && ls /tmp \
#    && make deps \
#    && apk del .builddeps build-base make unzip
#
#FROM alpine:3.11 AS last-stage
#
## 安装依赖包
#RUN set -x \
#    && /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories \
#    && apk add --no-cache bash libstdc++ curl
#
#
#COPY --from=production-stage /usr/local/openresty/ /usr/local/openresty/
#
#COPY --from=production-stage /tmp/ /usr/local/openresty/nginx/
#
#
#WORKDIR /usr/local/openresty/nginx/
#VOLUME /usr/local/openresty/nginx/logs/
#
#EXPOSE 8888 11000
#
#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
#
#ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin
#
#STOPSIGNAL SIGQUIT
