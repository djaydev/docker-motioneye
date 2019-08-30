FROM alpine:edge

ENV UID=1000
ENV GID=100

# Define software versions.
ARG MOTIONEYE_VERSION=0.41

WORKDIR /tmp

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk --no-cache add py2-pillow python2 curl openssl tzdata py-setuptools bash libwebp busybox ffmpeg jpeg libmicrohttpd libwebp v4l-utils \
&& apk --no-cache add --virtual=builddeps build-base git libtool curl-dev jpeg-dev ffmpeg-dev libwebp-dev	v4l-utils-dev openssl-dev autoconf automake libmicrohttpd-dev python2-dev zlib-dev wget py2-pip \
&& git clone --branch 4.2 https://github.com/Motion-Project/motion.git \
&& cd motion && autoreconf -fiv && ./configure --without-pgsql --without-sqlite3 --without-mysql && make && make install \
&& cd /tmp && wget https://github.com/ccrisan/motioneye/archive/${MOTIONEYE_VERSION}.tar.gz \
&& tar -xvf ${MOTIONEYE_VERSION}.tar.gz \
&& cd motioneye-${MOTIONEYE_VERSION} && pip install --no-cache-dir . \
&& apk del builddeps \
&& rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

COPY startapp.sh /startapp.sh
RUN  chmod +x /startapp.sh

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z localhost 8765 || exit 1

CMD /startapp.sh /usr/bin/meyectl startserver -c /etc/motioneye/motioneye.conf

EXPOSE 8765