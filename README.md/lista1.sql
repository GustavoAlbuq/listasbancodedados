
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    categoria VARCHAR(50),
    valor DECIMAL(10, 2)
);

CREATE TABLE compras (
    id_compra SERIAL PRIMARY KEY,
    id_usuario INTEGER REFERENCES usuarios(id_usuario),
    forma_pagamento VARCHAR(50),
    valor_compra DECIMAL(10, 2),
    data_compra DATE
);

CREATE TABLE itens_compra (
    id_item SERIAL PRIMARY KEY,
    id_compra INTEGER REFERENCES compras(id_compra),
    id_produto INTEGER REFERENCES produtos(id_produto),
    quantidade INTEGER
);

SELECT nome, valor
FROM produtos
WHERE categoria = 'Casa e bem-estar';

SELECT u.nome, SUM(c.valor_compra) AS total_vendas
FROM usuarios u
JOIN compras c ON u.id_usuario = c.id_usuario
GROUP BY u.nome
ORDER BY total_vendas DESC;

SELECT DISTINCT u.id_usuario, u.nome
FROM usuarios u
JOIN compras c ON u.id_usuario = c.id_usuario
WHERE c.forma_pagamento = 'pix';

WITH media_categoria AS (
    SELECT AVG(valor) AS media_valor
    FROM produtos
    WHERE categoria = 'Moda e beleza'
)
SELECT nome, valor
FROM produtos
WHERE categoria = 'Moda e beleza'
  AND valor > (SELECT media_valor FROM media_categoria);
