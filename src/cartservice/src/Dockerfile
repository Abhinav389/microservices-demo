ARG BUILDPLATFORM=linux/arm64
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS builder

ARG TARGETARCH=arm64

WORKDIR /app

COPY cartservice.csproj .
RUN dotnet restore cartservice.csproj -a $TARGETARCH

COPY . .
RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -a $TARGETARCH \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice

FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble-chiseled

WORKDIR /app
COPY --from=builder /cartservice .

ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070

EXPOSE 7070

USER 1000

ENTRYPOINT ["/app/cartservice"]
