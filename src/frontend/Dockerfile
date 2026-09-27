ARG BUILDPLATFORM=linux/arm64
FROM --platform=$BUILDPLATFORM golang:1.25-alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=arm64

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build \
    -ldflags="-s -w" \
    -o /go/bin/frontend .

FROM gcr.io/distroless/static

WORKDIR /src
COPY --from=builder /go/bin/frontend /src/server
COPY --from=builder /src/static/ /src/static/
COPY --from=builder /src/templates/ /src/templates/

ENV PORT=8080
ENV GOTRACEBACK=single

EXPOSE 8080

ENTRYPOINT ["/src/server"]
