
ALTER TABLE clientes ADD COLUMN ultima_atualizacao TIMESTAMP;

CREATE OR REPLACE FUNCTION atualiza_data_modificacao()
RETURNS TRIGGER AS $$
BEGIN
    NEW.ultima_atualizacao := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualiza_data_modificacao
BEFORE UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION atualiza_data_modificacao();

ALTER TABLE funcionarios ADD COLUMN tipo VARCHAR(20);

CREATE OR REPLACE FUNCTION verifica_idade_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.idade < 18 THEN
        NEW.tipo := 'Menor Aprendiz';
    ELSE
        NEW.tipo := 'Normal';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verifica_idade_funcionario
BEFORE INSERT ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION verifica_idade_funcionario();

CREATE TABLE historico_produtos (
    id SERIAL PRIMARY KEY,
    id_produto INTEGER,
    nome_antigo VARCHAR(100),
    valor_antigo DECIMAL(10, 2),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION registra_alteracao_produto()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO historico_produtos (id_produto, nome_antigo, valor_antigo)
    VALUES (OLD.id_produto, OLD.nome, OLD.valor);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_historico_produtos
AFTER UPDATE ON produtos
FOR EACH ROW
EXECUTE FUNCTION registra_alteracao_produto();
