# --------------------- BASE -------------------------
# Imagem base com Node + pnpm instalado globalmente
FROM node:22 AS base

RUN npm i -g pnpm


# ------------------ DEPENDENCIES --------------------
# Instala apenas as dependências
FROM base AS dependencies

# Diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Copia arquivos de definição de dependências
COPY package.json pnpm-lock.yaml ./

# Instala dependências (inclusive devDependencies)
RUN pnpm install


# --------------------- BUILD ------------------------
# Etapa de build da aplicação
FROM base AS build

WORKDIR /usr/src/app

# Copia todo o código fonte
COPY . .

# Copia node_modules da etapa de dependências
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

# Build do projeto (gera ./dist)
RUN pnpm build

# Remove dependências de desenvolvimento
RUN pnpm prune --prod


# -------------------- DEPLOY ------------------------
FROM node:22-bookworm-slim AS deploy

RUN apt-get update && apt-get upgrade -y && apt-get clean


# Define diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Copia apenas os arquivos necessários para execução
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

# Expõe a porta que a aplicação roda dentro do container
EXPOSE 3333

# Comando que roda a aplicação no container
CMD ["node", "dist/server.mjs"]
