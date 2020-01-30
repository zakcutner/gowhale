FROM golang:alpine AS alpine

RUN apk add --no-cache \
  git \
  ca-certificates

RUN addgroup -S app && \
  adduser -SDh /var/lib/app -G app app

WORKDIR /src

FROM scratch AS runtime

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=alpine /etc/passwd /etc/passwd
COPY --from=alpine /etc/group /etc/group
COPY --from=alpine --chown=app:app /var/lib/app /var/lib/app

USER app

FROM alpine AS builder

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/app

FROM runtime

COPY --from=builder /usr/bin/app /usr/bin/app

ENTRYPOINT ["app"]
