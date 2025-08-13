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
# Imagem extremamente enxuta e segura usando distroless
FROM gcr.io/distroless/nodejs22-debian12 AS deploy

# Define usuário não root para segurança (USER 1000)
USER 1000

# Define diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Copia apenas os arquivos necessários para execução
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

# Expõe a porta que a aplicação roda dentro do container
EXPOSE 3333

# Comando que roda a aplicação no container
CMD ["-r newrelic dist/server.mjs"]
