## Comandos

* **Build da imagem:**

```bash
docker build -t nome-arquivo:versao .
```

* Exemplo:

```bash
docker build -t widget-server:v1 .
```

---

* **Executar container:**

```bash
docker run -p 3000:3333 widget-server:v1
```

* `3000`: porta da minha interface
* `3333`: porta do container

---

* **Ver logs:**

  * Obtenha o ID do container com:

    ```bash
    docker ps
    ```

  * Visualize os logs com:

    ```bash
    docker logs 7cbfb587d310
    ```

---

## Utiliza Node

* [ ] `pnpm install`
* [ ] `pnpm build`
* [ ] Adicionar variáveis de ambiente
* [ ] Executar com `node files.js` ou `pnpm start`

---

## Utiliza o pnpm

## Possui variáveis de ambiente (env)

---

## Acessar a interface do container

```bash
docker exec -it <NOME_DO_CONTAINER|ID_DO_CONTAINER> /bin/sh
```

**Exemplo:**

```bash
~/workspaces/pos/docker/ftr-upload-widget-server-main  docker exec -it amazing_wright /bin/sh
```

**Resultado:**

```bash
/usr/src/app # ls -lah
total 24K    
drwxr-xr-x    1 root     root        4.0K May 18 03:33 .
drwxr-xr-x    1 root     root        4.0K May 18 03:31 ..
drwxr-xr-x    5 root     root        4.0K May 18 03:33 dist
drwxr-xr-x    5 root     root        4.0K May 18 03:33 node_modules
-rw-rw-r--    1 root     root         638 May 17 23:13 package.json
```

---

Para visualizar variáveis de ambiente dentro do container:

```bash
echo $NOME_DA_ENV
```

**Exemplo:**

```bash
/usr/src/app # echo $$CLOUDFLARE_PUBLIC_URL
https://pub-8c2c18b4943a48909c1618bc96377625.r2.dev
```

---

## Segurança dos nossos containers

- **whoami**: exbi qual a permissão atual
```bash
/usr/src/app # whoami
root
```

-- Colocar dentro do container dockerfile USER 1000 no caso pq ja veio por parão o usuário node para que não use o user root 


#### Venerabilidades
com isso é possível ver quais são as venerabilidades e como faz para corrigir
- trivy image node:20
- trivy image node:20-alpine3.21 


Perfeito. Aqui está o fluxo completo apenas com a tag `v1`:

---

## Push Docker Hub Image (tag `v1`)

1. **Login no Docker Hub**

```bash
docker login
```

2. **Build da imagem com a tag `v1` diretamente no repositório do Docker Hub**

```bash
docker build -t ryazero/widget-server:v1 .
```

3. **Push da imagem para o Docker Hub**

```bash
docker push ryazero/widget-server:v1
```

---

✔️ Simples e direto, sem necessidade de usar `docker tag`.


aws configure

AWS Access Key ID[None]: example
AWS Secret Access Key: example
Default region name [None]: us-east-2


