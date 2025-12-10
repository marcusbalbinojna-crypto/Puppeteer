FROM n8nio/n8n:latest

USER root

# Install Chromium and its Alpine dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

# Tell Puppeteer not to download Chromium because we already installed it
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Puppeteer
RUN cd /data && npm init -y && npm install puppeteer

# Return to the default unprivileged user
USER node


RUN npm install mammoth
