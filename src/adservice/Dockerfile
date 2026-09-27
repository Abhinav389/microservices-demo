ARG BUILDPLATFORM=linux/arm64
FROM --platform=$BUILDPLATFORM eclipse-temurin:21-jdk AS builder

WORKDIR /app

COPY ["build.gradle", "settings.gradle", "gradlew", "./"]
COPY gradle/ ./gradle/
COPY src/ ./src/
COPY genproto.sh ./

RUN chmod +x ./gradlew && ./gradlew installDist -Dorg.gradle.internal.http.socketTimeout=60000

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/build/install/adservice/ ./

ENV PORT=9555

EXPOSE 9555

ENTRYPOINT ["/app/bin/AdService"]
