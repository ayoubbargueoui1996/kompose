FROM golang:1.16 as builder
ARG RELEASE=master

RUN git -C /go/src clone --quiet https://github.com/kubernetes/kompose && \
    git -C /go/src/kompose checkout ${RELEASE}
WORKDIR /go/src/kompose
RUN go install -ldflags="-w -s -X github.com/kubernetes/kompose/pkg/version.GITCOMMIT=${RELEASE}"
ENTRYPOINT sleep infinity

FROM debian:buster-slim as kompose
RUN apt-get update && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    sudo \
    && rm -rf /var/lib/apt/lists/*
ENV WORKDIR=""
ENV USERID=0
ENV GROUPID=0
COPY --from=builder /go/bin/kompose /usr/local/bin/kompose
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["help"]
