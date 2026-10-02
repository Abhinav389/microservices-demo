ARG BUILDPLATFORM=linux/arm64
FROM --platform=$BUILDPLATFORM node:22-alpine AS builder

RUN apk add --update --no-cache \
    python3 \
    make \
    g++

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --production

FROM alpine:3.21

RUN apk add --no-cache nodejs

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules

COPY . .

ENV PORT=7000
EXPOSE 7000

ENTRYPOINT ["node", "server.js"]
