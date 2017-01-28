FROM ubuntu:14.04.5

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get  update && \
  apt-get -y install \
  apt-transport-https \
  curl && \
  curl -s https://repo.varnish-cache.org/ubuntu/GPG-key.txt | apt-key add - && \
  echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list && \
  apt-get -y update && \
  apt-get -y install varnish

EXPOSE 80

ENV VARNISH_PORT 80

WORKDIR /data

VOLUME ["/data"]

ADD default.vcl /etc/varnish/default.vcl

ADD start.sh /start.sh
CMD ["/start.sh"]
