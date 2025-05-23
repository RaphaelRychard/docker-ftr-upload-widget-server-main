# só trocar de node:20 para node:20-alpine3.21 teve reeducação de 1GB

#----------------- base ---------------------------
FROM node:20.18 AS base 

RUN npm i -g pnpm

# ---------------- dependencies --------------------------
FROM base AS dependencies

# Diretório de trabalho
WORKDIR /usr/src/app

# arquivo de origem do projeto
# COPY arquivo-origem arquivo-origem destino
COPY package.json pnpm-lock.yaml ./

# instala dependências do pnpm 
RUN pnpm install

# ---------------- build --------------------------
FROM base AS build

WORKDIR /usr/src/app

# copiar tudo da no src para nosso container
COPY . .
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN pnpm build
RUN pnpm prune --prod

# ---------------- deploy --------------------------
FROM gcr.io/distroless/nodejs20-debian12 AS deploy

USER 1000

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

## Declara envs
ENV CLOUDFLARE_ACCOUNT_ID="2cb33b802e9522d2c64f6b76b15b967f"
ENV CLOUDFLARE_ACCESS_KEY_ID="05708ee58d6b9373210e9998b52267f5"
ENV CLOUDFLARE_SECRET_ACCESS_KEY="5dffed58f105438f003184a2368ddf26fe4669f58b1cec97970138dd0c619f49"
ENV CLOUDFLARE_BUCKET="saf-nest-clean-test"
ENV CLOUDFLARE_PUBLIC_URL="https://pub-8c2c18b4943a48909c1618bc96377625.r2.dev"

# Expõem a porta da minha aplicação
EXPOSE 3333

# executara esse comando no final e segura o container
CMD ["dist/server.mjs"]