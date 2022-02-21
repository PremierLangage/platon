FROM node:12

# https://stackoverflow.com/a/70471892
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Set work directory
WORKDIR /app

# Copy dependencies
COPY platon-front/package-lock.json /app/package-lock.json
COPY platon-front/package.json /app/package.json
COPY platon-front/decorate-angular-cli.js /app/decorate-angular-cli.js
COPY platon/app/.npmrc /app/.npmrc

# Install dependencies
RUN npm ci

# Copy sources
COPY platon-front/ /app/
