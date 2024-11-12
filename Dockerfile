FROM python:3.9-alpine AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    make \
    bash \
    curl

WORKDIR /usr/src/app

RUN curl -o awscli.tar.gz https://awscli.amazonaws.com/awscli.tar.gz && \
    tar -xzf awscli.tar.gz && \
    cd awscli-2.19.4 && \
    ./configure --with-download-deps --prefix=/usr/local && \
    make && \
    make DESTDIR=/ install

# FROM alpine:3.16
FROM python:3.9-alpine

RUN apk add --no-cache \
    bash

COPY --from=builder /usr/local/bin/aws /usr/local/bin/
COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/

WORKDIR /aws
ENTRYPOINT ["/usr/local/bin/aws"]
