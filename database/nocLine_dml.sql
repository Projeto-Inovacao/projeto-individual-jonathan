/* INSERTS OBRIGATÓRIOS PARA O FUNCIONAMENTO DO PROGRAMA ! */

-- USAR O DATABASE
USE nocLine;

-- INSERIR NA TABELA EMPRESA
INSERT INTO empresa VALUES 
(null, 'ViaMobilidade', '03.649.148/0001-40'); 
SELECT * FROM empresa;



-- INSERIR NA TABELA LINHA
INSERT INTO  linha VALUES 
(null, 'azul', 1, 1);
SELECT * FROM linha;

-- INSERIR NA TABELA NÍVEL DE ACESSO
INSERT INTO nivel_acesso VALUES
(null, 'RPL', 'Representante Legal'),
(null, 'SSO', 'Sala de Supervisão Opercional'),
(null, 'CCO', 'Centro de Controle Operacioal');
SELECT * FROM nivel_acesso;

-- INSERIR NA TABELA COLABORADOR
INSERT INTO colaborador VALUES
(null, 'Fernanda Caramico', '469.674.588-09', 'fernanda@caramico.com', '11-97553-6244', '12345678', '1', 1, 1);
SELECT * FROM colaborador;

-- INSERIR NA TABELA ENDEREÇO
INSERT INTO endereco VALUES
(null, '97110-835', '74', 'Rua Waldemar Balduino Ticks', 'Camobi', 'Santa Maria', 'RS', 'Brasil', '', 1);
SELECT * FROM endereco;

-- INSERIR NA TABELA PLANO
INSERT INTO plano VALUES 
(null, 'Essentials', 10, 1230.00, 15.38), 
(null, 'Master', 25, 1340.00, 12.16), 
(null, 'Plus', 50, 1480.00, 10.55);
SELECT * FROM plano;

-- INSERIR NA TABELA CONTRATO 
 INSERT INTO contrato VALUES
(null, '2023-11-01', '2024-11-01', 0, 1480.00, 'Crédito', 1, 3);
SELECT * FROM contrato;

-- INSERIR NA TABELA LINHA 
INSERT INTO linha VALUES
(null, 'azul', 1, 1);
SELECT * FROM linha;

-- INSERIR NA TABELA MÁQUINA
INSERT INTO maquina VALUES
(null, '131.72.61.67', 'Windows', 'gyulia_piqueira', 'Samsung', 'CCO', 1,now(), 1, 1);
SELECT * FROM maquina;

-- INSERIR NA TABELA UNIDADE DE MEDIDA
INSERT INTO unidade_medida VALUES
(null, 'Bytes', 'B'),
(null, 'Porcentagem', '%'),
(null, 'MegaBytes', 'MB'), 
(null, 'Graus Celsius', '°C'), 
(null, 'Milissegundos', 'MS')
(null, 'Hora', 'H'); 

SELECT * FROM unidade_medida;


select * from metrica;

-- metrica para a RAM
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (88.43, 90.71, 2);

-- metrica de CPU
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (4.04, 5.1, 2);

-- metrica de DISCO
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (50.96, 50.99, 2);

-- metrica de rede
INSERT INTO metrica (risco, perigo, fk_unidade_medida)
VALUES (176.45, 250.23, 3);

-- INSERIR NA TABELA COMPONENTE
INSERT INTO componente (id_componente,nome_componente,fk_maquina_componente,fk_empresa_componente,fk_metrica_componente) VALUES
(null, 'RAM', 1, 1, 1),
(null, 'CPU', 1, 1, 2),
(null, 'DISCO', 1, 1, 3),
(null, 'REDE', 1, 1, 4);
SELECT * FROM componente;


select*from processos;

SELECT * FROM monitoramento;
-- alguns delete que eu precisei (gyu)
-- DELETE FROM alerta WHERE fk_componenente_alerta >= 1 AND fk_componenente_alerta <= 8400;
-- DELETE FROM monitoramento WHERE id_monitoramento >= 1 AND id_monitoramento <= 8400;

