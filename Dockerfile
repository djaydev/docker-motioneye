FROM alpine:edge

ENV UID=1000
ENV GID=100

# Define software versions.
ARG MOTIONEYE_VERSION=0.41rc1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk --no-cache add py2-pillow motion python curl openssl tzdata py-setuptools \
&& apk --no-cache add --virtual=builddeps build-base curl-dev jpeg-dev openssl-dev python-dev zlib-dev wget py2-pip \
&& wget https://github.com/ccrisan/motioneye/archive/${MOTIONEYE_VERSION}.tar.gz \
&& tar -xvf ${MOTIONEYE_VERSION}.tar.gz \
&& cd motioneye-${MOTIONEYE_VERSION} &&  pip install . \
&& apk del builddeps \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY startapp.sh /startapp.sh
RUN  chmod +x /startapp.sh

CMD /startapp.sh /usr/bin/meyectl startserver -c /etc/motioneye/motioneye.conf

EXPOSE 8765