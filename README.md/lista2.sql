CREATE OR REPLACE VIEW vw_vendas_produtos AS
SELECT 
    p.nome AS nome_produto,
    ic.quantidade,
    (p.valor * ic.quantidade) AS valor_total_venda,
    c.id_compra
FROM itens_compra ic
JOIN produtos p ON ic.id_produto = p.id_produto
JOIN compras c ON ic.id_compra = c.id_compra;


CREATE OR REPLACE VIEW vw_cidade_top_vendas_2023 AS
SELECT 
    cidade,
    COUNT(c.id_compra) AS total_vendas,
    SUM(c.valor_compra) AS valor_total_vendas
FROM compras c
JOIN usuarios u ON c.id_usuario = u.id_usuario
WHERE EXTRACT(YEAR FROM c.data_compra) = 2023
GROUP BY cidade
ORDER BY total_vendas DESC
LIMIT 1;
