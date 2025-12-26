FROM n8nio/n8n:latest

USER root

# Instalar Chromium e libs necessárias no Debian/Ubuntu base
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-freefont-ttf \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
  && rm -rf /var/lib/apt/lists/*

# Criar uma pasta para módulos extras e instalar puppeteer + mammoth
RUN mkdir -p /data \
  && cd /data \
  && npm init -y \
  && npm install --omit=dev puppeteer mammoth

# Configurar Puppeteer para NÃO baixar Chromium e usar o do sistema
# Ajuste do executable path: geralmente é /usr/bin/chromium em Debian
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_PRODUCT=chrome \
    NODE_PATH=/data/node_modules

USER node
