FROM node:12

# Set work directory
WORKDIR /app

# Copy dependencies
COPY platon-front/package-lock.json /app/package-lock.json
COPY platon-front/package.json /app/package.json
COPY platon-front/decorate-angular-cli.js /app/decorate-angular-cli.js
COPY platon/app/.npmrc /app/.npmrc

# Install dependencies
RUN npm set unsafe-perm true
RUN npm ci

# Copy sources
COPY platon-front/.vscode /app/.vscode
COPY platon-front/apps /app/apps
COPY platon-front/assets /app/assets
COPY platon-front/libs /app/libs
COPY platon-front/styles /app/styles
COPY platon-front/angular.json /app/angular.json
COPY platon-front/karma.conf.js /app/karma.conf.js
COPY platon-front/nx.json /app/nx.json
COPY platon-front/tsconfig.base.json /app/tsconfig.base.json
COPY platon-front/tslint.json /app/tslint.json
COPY platon-front/webpack.externals.js /app/webpack.externals.js
