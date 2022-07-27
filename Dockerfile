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

COPY --from=builder /app/emulator .

COPY rootCA.pem /usr/local/share/ca-certificates/rootCA.crt
RUN cat /usr/local/share/ca-certificates/rootCA.crt >> /etc/ssl/certs/ca-certificates.crt
# RUN update-ca-certificates
