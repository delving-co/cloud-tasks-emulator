FROM golang:1.13-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o emulator .


FROM alpine:latest

LABEL org.opencontainers.image.source=https://github.com/delving-co/cloud-tasks-emulator

ENTRYPOINT ["/emulator"]

WORKDIR /
COPY mkcert /usr/local/bin
COPY rootCA*.pem /root/.local/share/mkcert/
RUN chmod +x /usr/local/bin/mkcert \
  && mkcert -install \
  && rm -rf /usr/local/bin/mkcert

COPY --from=builder /app/emulator .
