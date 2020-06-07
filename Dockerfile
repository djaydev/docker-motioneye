FROM alpine:3.11

ENV UID=1000
ENV GID=100

# Define software versions.
ARG MOTIONEYE_VERSION=0.42.1

WORKDIR /tmp

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk --no-cache add py2-pillow python2 curl openssl tzdata py-setuptools bash motion \
&& apk --no-cache add --virtual=builddeps build-base curl-dev jpeg-dev openssl-dev python2-dev zlib-dev wget tar py2-pip \
&& wget https://github.com/ccrisan/motioneye/archive/${MOTIONEYE_VERSION}.tar.gz \
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