FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
# install osm2pgsql build deps
RUN apt-get update \
 && apt-get -y install software-properties-common \
 && apt-get update \
 && apt-get -y install \
    libpq-dev \
    osm2pgsql \
    libxml2-dev \
    libxslt1-dev \
    postgresql-client \
    python3-jinja2 \
    python3-yaml \
    python3-pip \
    git-core \
    make \
    wget \
    unzip \
 && rm -rf /var/lib/apt/lists/*

COPY . /usr/src/app
WORKDIR /usr/src/app
RUN pip3 install -r requirements.txt
RUN pip3 install -e .

CMD ["/bin/bash", "scripts/docker_boostrap.sh"]
