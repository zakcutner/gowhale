FROM golang:alpine

# Install Git in order to download Go module.
RUN apk add --no-cache git

# Change to the source directory.
WORKDIR /src

# Copy all files to the container to be built.
ONBUILD COPY . .

# Build the module without requiring any OS libraries.
ONBUILD RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/app
