FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
# install osm2pgsql build deps
RUN apt-get update \
 && apt-get -y install software-properties-common \
 && apt-get update \
 && apt-get -y install \
    python2.7 \
    libpq-dev \
    osm2pgsql \
    libxml2-dev \
    libxslt1-dev \
    postgresql-client \
    python-jinja2 \
    python-yaml \
    python-pip \
    git-core \
    make \
    wget \
    unzip \
 && rm -rf /var/lib/apt/lists/*

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN pip2 install -r requirements.txt
RUN pip2 install -e .

CMD ["/bin/bash", "scripts/docker_boostrap.sh"]
