# --------------------- BASE -------------------------
# Imagem base com Node 22 + pnpm global
FROM node:22 AS base

RUN npm i -g pnpm


# ------------------ DEPENDENCIES --------------------
# Instala apenas as dependências
FROM base AS dependencies

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install


# --------------------- BUILD ------------------------
# Etapa de build da aplicação
FROM base AS build

WORKDIR /usr/src/app

COPY . .

COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN pnpm build

RUN pnpm prune --prod


# -------------------- DEPLOY ------------------------
# Imagem de produção enxuta e segura usando Node slim
FROM node:22-slim AS deploy

# Define usuário não root para segurança
USER node

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

EXPOSE 3333

CMD ["node", "dist/server.mjs"]
