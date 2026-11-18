-- IngressoÁgil · Trio: <nome 1>, <nome 2>, <nome 3>
--
-- CPF de todo comprador "por via das dúvidas": o trio não concorda.
-- Produtora: pra vender ingresso basta nome e email; guardar CPF sem uso aumenta o risco
-- e a responsabilidade dela pela LGPD em caso de vazamento.
-- Cliente: é um dado pessoal sensível exposto a vazamento e golpe sem trazer nenhum benefício pra ela.

-- 1) Tabelas: primeiro as que não têm chave estrangeira
CREATE TABLE espaco (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  endereco TEXT NOT NULL
);

CREATE TABLE cliente (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE
);

CREATE TABLE evento (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  data DATE NOT NULL,
  preco_atual NUMERIC(10, 2) NOT NULL,
  espaco_id INTEGER NOT NULL REFERENCES espaco (id)
);

CREATE TABLE compra (
  id INTEGER PRIMARY KEY,
  data DATE NOT NULL,
  cliente_id INTEGER NOT NULL REFERENCES cliente (id)
);

-- Resolve o N:N entre compra e evento. Guarda o preço pago no dia, não o de hoje
CREATE TABLE item_compra (
  compra_id INTEGER NOT NULL REFERENCES compra (id),
  evento_id INTEGER NOT NULL REFERENCES evento (id),
  quantidade INTEGER NOT NULL CHECK (quantidade > 0),
  preco_pago NUMERIC(10, 2) NOT NULL,
  PRIMARY KEY (compra_id, evento_id)
);

-- 2) Dados da planilha: primeiro quem é apontado pela FK
INSERT INTO espaco (id, nome, endereco) VALUES
  (1, 'Galpão Arte Viva', 'Rua das Flores, 100'),
  (2, 'Quadra do Samba', 'Av. Central, 50');

INSERT INTO cliente (id, nome, email) VALUES
  (1, 'Joana Reis', 'joana@email.com'),
  (2, 'Caio Melo', 'caio@email.com'),
  (3, 'Lia Santos', 'lia@email.com');

INSERT INTO evento (id, nome, data, preco_atual, espaco_id) VALUES
  (1, 'Slam das Minas', '2026-12-05', 20, 1),
  (2, 'Batalha da Estação', '2026-12-12', 15, 1),
  (3, 'Roda de Samba de Fim de Ano', '2026-12-20', 30, 2);

INSERT INTO compra (id, data, cliente_id) VALUES
  (1, '2026-11-20', 1),
  (2, '2026-11-21', 2),
  (3, '2026-11-25', 1),
  (4, '2026-11-26', 3);

INSERT INTO item_compra (compra_id, evento_id, quantidade, preco_pago) VALUES
  (1, 1, 2, 20),
  (1, 2, 1, 15),
  (2, 3, 1, 25),
  (3, 3, 2, 30),
  (4, 1, 1, 20);

-- 3) Conferência das contagens: 3, 3, 4, 5
SELECT COUNT(*) AS eventos FROM evento;
SELECT COUNT(*) AS clientes FROM cliente;
SELECT COUNT(*) AS compras FROM compra;
SELECT COUNT(*) AS itens FROM item_compra;

-- 4) Quantos ingressos cada evento vendeu e quanto faturou (esperado: 85, 60, 15)
SELECT
  e.nome,
  SUM(i.quantidade) AS ingressos,
  SUM(i.quantidade * i.preco_pago) AS faturamento
FROM evento e
JOIN item_compra i ON i.evento_id = e.id
GROUP BY e.id, e.nome
ORDER BY faturamento DESC;
