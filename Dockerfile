FROM golang:1.22-alpine AS builder
WORKDIR /build
COPY go.mod main.go ./
RUN go mod tidy && go build -o launcher .

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y ca-certificates curl tar gzip && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /build/launcher /app/launcher

# PaaS ها خودشون PORT رو ست میکنن، ما فقط EXPOSE میکنیم
ENV XUI_PORT=20530
ENV VLESS_PORT=20868
ENV SUB_PORT=2096
ENV XUI_DATA_DIR=/app/data
ENV XUI_INSTALL_DIR=/app/x-ui

EXPOSE 2053
CMD ["/app/launcher"]
