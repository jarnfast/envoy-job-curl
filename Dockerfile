FROM golang:1.13 as preflight-builder

WORKDIR /go/src/monzo

RUN git clone --depth 1 --branch v1.0 https://github.com/monzo/envoy-preflight.git .

RUN CGO_ENABLED=0 go build -o envoy-preflight \
    && chmod +x envoy-preflight

FROM alpine:3.15.5

RUN apk add --no-cache curl

COPY --from=preflight-builder /go/src/monzo/envoy-preflight /usr/bin/envoy-preflight

ENTRYPOINT ["/usr/bin/envoy-preflight"]
