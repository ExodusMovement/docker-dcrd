FROM golang:1.11 as builder

ENV BUILD_TAG 1.3.0

RUN wget -O- https://github.com/decred/dcrd/archive/v$BUILD_TAG.tar.gz | tar xz && mv ./dcrd-$BUILD_TAG /dcrd
WORKDIR /dcrd

RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go install . ./cmd/...

FROM alpine:3.8

RUN apk add --no-cache ca-certificates
COPY --from=builder /go/bin/dcrctl /go/bin/dcrd /usr/local/bin/

RUN addgroup -g 1000 dcrd \
  && adduser -u 1000 -G dcrd -s /bin/sh -D dcrd

USER dcrd

# PEER & RPC PORTS
EXPOSE 9108 9109

ENV \
  DCRD_BIND=0.0.0.0 \
  DCRD_PORT=9108 \
  DCRD_RPC_BIND=0.0.0.0 \
  DCRD_RPC_PORT=9109 \
  DCRD_ARGUMENTS=""

CMD exec dcrd \
  --listen=$DCRD_BIND:$DCRD_PORT \
  --rpclisten=$DCRD_RPC_BIND:$DCRD_RPC_PORT \
  $DCRD_ARGUMENTS
