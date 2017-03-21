#!/bin/bash -e

docker build -t sshd-service-test .

docker run --rm \
  -v $PWD:/src \
  sshd-service-test \
  bash -c 'rspec --format documentation spec/'
