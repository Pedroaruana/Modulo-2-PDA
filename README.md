# Modulo-2-PDA

[![ci](https://img.shields.io/github/actions/workflow/status/Pedroaruana/Modulo-2-PDA/testa-apis.yml?label=ci&logo=github)](https://github.com/Pedroaruana/Modulo-2-PDA/actions/workflows/testa-apis.yml)
![Node.js](https://img.shields.io/badge/Node.js-22-339933?logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-5-000000?logo=express&logoColor=white)
![Nodemon](https://img.shields.io/badge/Nodemon-3-76D04B?logo=nodemon&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-4169E1?logo=postgresql&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite&logoColor=white)
![Excalidraw](https://img.shields.io/badge/DER-Excalidraw-6965DB?logo=excalidraw&logoColor=white)
[![License](https://img.shields.io/badge/License-MIT-D4A72C)](LICENSE)

Meus trabalhos do Módulo 2 do Programadores do Amanhã (turma T8). O módulo 1 está no [Modulo-1-PDA](https://github.com/Pedroaruana/Modulo-1-PDA).

Por enquanto tem a aula 3, que fecha a parte de banco de dados e começa a parte de API com Express. Os exercícios de casa vou subindo aos poucos.

## Aula 3

### Parte 1: IngressoÁgil

Era pra ser em trio, mas fiz sozinho. A ideia é pegar a planilha de vendas de ingresso de uma produtora (slam, batalha de rima, roda de samba) e transformar num banco de verdade.

O que está na pasta [`aula-03/parte-1-ingressoagil`](aula-03/parte-1-ingressoagil):

- `modelo-normalizado.md`: o passo a passo da 1FN até a 3FN, as tabelas finais com PK e FK e as decisões que tomei no caminho
- `der.png` e `der.excalidraw`: o DER (o `.excalidraw` dá pra abrir no [excalidraw.com](https://excalidraw.com) e mexer)
- `ingressoagil.sql`: cria as tabelas, insere os dados da planilha e roda a consulta de faturamento

O banco ficou com 5 tabelas: `espaco`, `evento`, `cliente`, `compra` e `item_compra`. A `item_compra` resolve o N:N entre compra e evento e guarda a quantidade e o preço pago.

O ponto que mais pegou foi o preço. O evento tem o preço de hoje, mas o cliente paga o preço do lote que estava valendo no dia. Se usar o preço do evento na conta, a Roda de Samba fatura 90 em vez de 85. Por isso o `preco_pago` fica no item da compra e não no evento.

Resultado da consulta:

```
            nome             | ingressos | faturamento
-----------------------------+-----------+-------------
 Roda de Samba de Fim de Ano |         3 |       85.00
 Slam das Minas              |         3 |       60.00
 Batalha da Estação          |         1 |       15.00
```

Testei o script no PostgreSQL e no SQLite. Pra rodar é só colar no [PGlite](https://pglite.dev/repl/) ou no [Sqlime](https://sqlime.org).

No modelo também respondi o desafio da meia-entrada e a pergunta do CPF (spoiler: não guardaria).

### Parte 2: API do MercadoÁgil

Primeiro servidor com Express. Ainda sem banco, os dados ficam num array no próprio arquivo.

Rotas:

| Método | Caminho | O que faz |
|---|---|---|
| GET | `/` | mensagem de boas-vindas |
| GET | `/produtos` | lista os produtos |
| GET | `/vendedores` | lista os vendedores |

Pra rodar (precisa do Node 22):

```bash
cd aula-03/parte-2-mercadoagil-api
npm install
npm run dev
```

Aí é abrir `http://localhost:3000/produtos` no navegador ou testar com o curl:

```bash
curl -i http://localhost:3000/produtos
```

No Windows, pelo PowerShell, tem que usar `curl.exe` em vez de `curl`.

O `npm run dev` sobe com o Nodemon, que reinicia sozinho quando salva o arquivo. O `npm start` sobe com o node puro.

## Testes

Tem um workflow em `.github/workflows/testa-apis.yml` que instala as dependências, sobe a API e bate nas rotas. Ele não roda sozinho, só quando eu disparo pela aba Actions.
