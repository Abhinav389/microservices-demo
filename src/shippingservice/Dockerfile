# Stage 1: Builder
ARG BUILDPLATFORM=linux/arm64
FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build \
    -ldflags="-s -w" \
    -o /go/bin/shippingservice .

FROM gcr.io/distroless/static

WORKDIR /src
COPY --from=builder /go/bin/shippingservice /src/shippingservice

ENV APP_PORT=50051
ENV GOTRACEBACK=single


EXPOSE 50051

ENTRYPOINT ["/src/shippingservice"]

