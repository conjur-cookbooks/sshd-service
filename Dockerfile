FROM debian:jessie
MAINTAINER Conjur, Inc

RUN apt-get update -yqq && apt-get install -yq curl

ENV CHEFDK_VERSION 0.15.16
RUN curl -L -o /tmp/chefdk.deb \
  https://packages.chef.io/files/stable/chefdk/$CHEFDK_VERSION/debian/8/chefdk_$CHEFDK_VERSION-1_amd64.deb && \
  dpkg -i /tmp/chefdk.deb && \
  rm /tmp/chefdk.deb

# Add ChefDK's Ruby to path
ENV PATH /opt/chefdk/embedded/bin:$PATH

RUN mkdir -p /src
WORKDIR /src
