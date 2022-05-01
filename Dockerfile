# development stage
FROM node:16-alpine AS dev-stage

WORKDIR /srv

COPY package*.json ./

RUN yarn install

COPY . .

ARG PACKAGE_VERSION=untagged
ENV PACKAGE_VERSION=${PACKAGE_VERSION}
LABEL rest-api.package-version=${PACKAGE_VERSION}

CMD [ "yarn", "dev" ]

# build stage
FROM dev-stage AS build-stage

RUN yarn build

RUN rm -rf node_modules

RUN yarn install --production

# production stage
FROM node:16-alpine AS production-stage

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
LABEL rest-api.node-env=${NODE_ENV}

WORKDIR /srv

COPY --from=build-stage /srv /srv

CMD [ "yarn", "build"]