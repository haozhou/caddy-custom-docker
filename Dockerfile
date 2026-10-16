ARG CADDY_VERSION=2.11.7

# Builder runs natively on the CI host and cross-compiles for each target
# platform, so multi-arch builds don't need QEMU emulation.
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/caddy-dns/route53@v1.6.2 \
    --with github.com/caddy-dns/cloudflare@v0.2.4 \
    --with github.com/caddy-dns/alidns@v1.0.29 \
    --output /usr/bin/caddy

FROM caddy:${CADDY_VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
