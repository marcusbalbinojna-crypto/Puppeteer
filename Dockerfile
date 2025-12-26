# Stage 1: baixar chromium e libs em Debian
FROM debian:bookworm-slim AS chromium

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-freefont-ttf \
    fonts-liberation \
  && rm -rf /var/lib/apt/lists/*

# Stage 2: imagem final do n8n (sem gerenciador de pacotes)
FROM n8nio/n8n:latest

USER root

# Copiar Chromium
COPY --from=chromium /usr/bin/chromium /usr/bin/chromium

# Copiar libs e recursos que o Chromium precisa (caminhos comuns no Debian)
COPY --from=chromium /usr/lib/ /usr/lib/
COPY --from=chromium /lib/ /lib/
COPY --from=chromium /usr/share/ /usr/share/

# Instalar libs JS (puppeteer e mammoth) usando o npm que já existe no n8n
RUN mkdir -p /data \
  && cd /data \
  && npm init -y \
  && npm install --omit=dev puppeteer mammoth

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_PRODUCT=chrome \
    NODE_PATH=/data/node_modules

USER node
