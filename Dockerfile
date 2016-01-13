FROM debian:jessie
MAINTAINER thaim <thaim24@gmail.com>

ENV SUBMIN_VERSION 2.2.1-1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python \
       subversion \
       python-subversion \
       apache2 \
       libapache2-svn \
       sendmail \
       curl \
       sqlite3 \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN curl -fSL "http://supermind.nl/submin/current/submin-${SUBMIN_VERSION}.tar.gz" -o submin.tar.gz \
    && tar -xf submin.tar.gz -C /opt/ \
    && rm submin.tar.gz \
    && cd /opt/submin-${SUBMIN_VERSION} \
    && python setup.py install

COPY ./docker-entrypoint.sh /

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["submin"]
