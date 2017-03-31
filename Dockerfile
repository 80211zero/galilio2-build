# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node for intel galileo gen 2.
FROM ubuntu:xenial
MAINTAINER Vipin Madhavanunni <vipmadha@gmail.com>

# meta-clanton version
ENV version=v1.2.1.1
ENV LANG=en_US.UTF-8

# In case you need proxy
#RUN echo 'Acquire::http::Proxy "http://127.0.0.1:8080";' >> /etc/apt/apt.conf

# Install Yocto requirement
RUN apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" \
    git diffstat texinfo gawk chrpath file python build-essential gcc-multilib vim-common \
    uuid-dev iasl subversion nasm autoconf lzop patchutils parted wget screen \
    vim vim-common bash-completion &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" \
    language-pack-en-base &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN locale-gen en_US $LANG
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANGUAGE=$LANG

# Setup basic git config
RUN git config --global user.name "Vipin Madhavanunni"
RUN git config --global user.email "vipmadha@gmail.com"

# Yocto build
WORKDIR /source
COPY BSP/meta-clanton_$version.tar.gz meta-clanton_$version.tar.gz

# Build drive
VOLUME /build

