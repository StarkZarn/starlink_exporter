FROM golang:latest as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY cmd ./cmd
COPY pkg ./pkg
COPY internal ./internal

RUN CGO_ENABLED=0 GOOS=linux go build -o /starlink_exporter ./cmd/starlink_exporter/main.go

FROM gcr.io/distroless/static:latest
COPY --from=builder /starlink_exporter /
ENTRYPOINT ["/starlink_exporter"]
