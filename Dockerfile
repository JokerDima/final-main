# Сборка приложения
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o tracker

# Запуск приложения
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/tracker ./tracker
COPY --from=builder /app/tracker.db ./
RUN apk add --no-cache sqlite
CMD ["./tracker"]