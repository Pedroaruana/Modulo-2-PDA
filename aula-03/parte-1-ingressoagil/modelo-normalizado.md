# IngressoÁgil · Modelo normalizado

Autor: Pedro Aruanã

## Passo 1: entidades e relacionamentos

Entidades: ESPACO, EVENTO, CLIENTE, COMPRA.

| Relacionamento | Cardinalidade |
|---|---|
| ESPACO **recebe** EVENTO | 1:N |
| CLIENTE **faz** COMPRA | 1:N |
| COMPRA **inclui** EVENTO | N:N (resolvido com ITEM_COMPRA) |

## Passo 2: 1ª forma normal

Uma linha por evento comprado. Chave: (compra, evento).

| compra | data_compra | cliente | email | evento | data_evento | espaco | endereco_espaco | quantidade | preco_pago |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 2026-11-20 | Joana Reis | joana@email.com | Slam das Minas | 2026-12-05 | Galpão Arte Viva | Rua das Flores, 100 | 2 | 20 |
| 1 | 2026-11-20 | Joana Reis | joana@email.com | Batalha da Estação | 2026-12-12 | Galpão Arte Viva | Rua das Flores, 100 | 1 | 15 |
| 2 | 2026-11-21 | Caio Melo | caio@email.com | Roda de Samba de Fim de Ano | 2026-12-20 | Quadra do Samba | Av. Central, 50 | 1 | 25 |
| 3 | 2026-11-25 | Joana Reis | joana@email.com | Roda de Samba de Fim de Ano | 2026-12-20 | Quadra do Samba | Av. Central, 50 | 2 | 30 |
| 4 | 2026-11-26 | Lia Santos | lia@email.com | Slam das Minas | 2026-12-05 | Galpão Arte Viva | Rua das Flores, 100 | 1 | 20 |

## Passo 3: 2ª e 3ª formas normais

- 2FN: `data_compra` e `cliente` dependem só da compra. `data_evento` e `espaco` dependem só do evento. `quantidade` e `preco_pago` dependem da chave inteira (compra, evento).
- 3FN: `email` depende do cliente, não da compra. `endereco_espaco` depende do espaço, não do evento.

## Tabelas finais

| Tabela | Campos | PK | FK |
|---|---|---|---|
| ESPACO | id, nome, endereco | id | |
| EVENTO | id, nome, data, preco_atual, espaco_id | id | espaco_id → ESPACO.id |
| CLIENTE | id, nome, email | id | |
| COMPRA | id, data, cliente_id | id | cliente_id → CLIENTE.id |
| ITEM_COMPRA | compra_id, evento_id, quantidade, preco_pago | (compra_id, evento_id) | compra_id → COMPRA.id, evento_id → EVENTO.id |

Por que o preço pago fica no item e não no evento: o preço do evento muda por lote, e cada compra precisa lembrar quanto foi cobrado naquele dia. `evento.preco_atual` é o preço de hoje (Roda de Samba R$ 30); `item_compra.preco_pago` é o que o Caio pagou no 1º lote (R$ 25). Se o faturamento usasse o preço do evento, a Roda de Samba daria 90 em vez de 85.

## Decisões (Discordância Positiva)

1. **Chave do ITEM_COMPRA.** Opção A: um `id` próprio. Opção B: a chave composta (compra_id, evento_id). Escolhemos B: o mesmo evento não aparece duas vezes na mesma compra (vira quantidade maior), e a chave composta garante isso no banco sem regra extra.
2. **Preço no evento ou no item.** Opção A: só `evento.preco`. Opção B: `preco_atual` no evento e `preco_pago` no item. Escolhemos B: com A o histórico de lotes se perde e o faturamento fica errado.

## Desafio extra: meia-entrada

Defendemos as duas opções:

- **Coluna `tipo` no item** (`'inteira'` ou `'meia'`): mais simples, uma tabela a menos. Contra: o texto pode ser digitado errado e a regra do desconto fica espalhada no código.
- **Tabela TIPO_INGRESSO** (id, nome, percentual): o desconto mora num lugar só e dá pra criar outros tipos (estudante, idoso) sem mudar a estrutura.

Escolhemos a tabela TIPO_INGRESSO. A chave do ITEM_COMPRA muda: passa a ser (compra_id, evento_id, tipo_ingresso_id), porque a Joana pode levar 1 inteira e 1 meia do Slam na mesma compra. O `preco_pago` continua no item (já com o desconto aplicado no dia).

```sql
CREATE TABLE tipo_ingresso (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE,
  percentual NUMERIC(5, 2) NOT NULL -- 100 = inteira, 50 = meia
);

-- item_compra ganha tipo_ingresso_id e a PK passa a ser
-- PRIMARY KEY (compra_id, evento_id, tipo_ingresso_id)
```
