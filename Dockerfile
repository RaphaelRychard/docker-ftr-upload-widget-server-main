# --------------------- BASE -------------------------
FROM node:22-bookworm-slim AS base

RUN npm i -g pnpm


# ------------------ DEPENDENCIES --------------------
FROM base AS dependencies

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile


# --------------------- BUILD ------------------------
FROM base AS build

WORKDIR /usr/src/app

COPY . .

COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN pnpm build

RUN pnpm prune --prod


# -------------------- DEPLOY ------------------------
FROM node:22-bookworm-slim AS deploy

RUN apt-get update && apt-get upgrade -y && apt-get clean

USER node

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

EXPOSE 3333

ENV NODE_ENV=production

CMD ["node", "dist/server.mjs"]
