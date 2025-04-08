# syntax=docker/dockerfile:1.4

FROM alpine as fetcher

RUN apk add --no-cache git openssh

RUN mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/id_rsa.pub

RUN --mount=type=ssh git clone git@github.com:alicja82/pawcho6.git /app

FROM node:18-alpine as builder
WORKDIR /app
COPY --from=fetcher /app/info.js .

FROM nginx:stable-alpine
ARG VERSION
ENV VERSION=${VERSION}

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /app /app

RUN chmod +x /entrypoint.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD curl -s http://localhost/health | grep -q "OK" || exit 1

ENTRYPOINT ["/entrypoint.sh"]