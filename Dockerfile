FROM n8nio/n8n:latest

# Usar root para instalar pacotes
USER root

# Instalar Chromium e dependências (Alpine)
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

# Configurar Puppeteer para usar o Chromium já instalado
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PUPPETEER_PRODUCT=chrome

# Criar diretório /data e instalar Puppeteer lá
RUN mkdir -p /data && cd /data && npm init -y && npm install puppeteer

# Voltar para o usuário padrão do n8n
USER node



RUN npm install mammoth
