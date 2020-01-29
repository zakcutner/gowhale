FROM golang:alpine AS builder

RUN apk add --no-cache \
  git \
  ca-certificates

RUN addgroup -S app && \
  adduser -SDh /var/lib/app -G app app

WORKDIR /src

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/app

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /usr/bin/app /usr/bin/app
COPY --from=builder --chown=app:app /var/lib/app /var/lib/app

USER app
ENTRYPOINT ["app"]
