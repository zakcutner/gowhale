FROM alpine as alpine

# Install certificates for use with TLS.
RUN apk add --no-cache ca-certificates

# Add a new user and group to run the app. Its home directory can be mounted as
# a volume used for any persistent cache by the app.
RUN addgroup -S app && \
  adduser -SDh /var/lib/app -G app app

FROM scratch

# Copy certificates, users and the home directory from Alpine.
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=alpine /etc/passwd /etc/passwd
COPY --from=alpine /etc/group /etc/group
COPY --from=alpine --chown=app:app /var/lib/app /var/lib/app

# Switch to the app user and run the app.
USER app
ENTRYPOINT ["app"]
