-- DROP DATABASE nocline;
CREATE DATABASE nocline;
USE nocline;


CREATE TABLE empresa(
  id_empresa INT PRIMARY KEY IDENTITY(1,1), 
  razao_social VARCHAR(150),
  cnpj CHAR(18) NULL UNIQUE
);

  CREATE TABLE nivel_acesso (
  id_nivel_acesso INT PRIMARY KEY IDENTITY(1,1),
  sigla CHAR(3) NULL,
  descricao VARCHAR(50) NULL
);

CREATE TABLE colaborador (
  id_colaborador INT  IDENTITY(1,1),
  nome VARCHAR(200) NULL,
  cpf CHAR(14) NULL,
  email VARCHAR(250) NULL UNIQUE,
  celular CHAR(13) NULL,
  senha VARCHAR(255) NULL,
  status_colaborador tinyint,
  fk_empresa INT,
  fk_nivel_acesso INT,
  CONSTRAINT pk_colaborador
	UNIQUE (id_colaborador, fk_empresa),
  CONSTRAINT fk_usuarios_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa (id_empresa),
  CONSTRAINT fk_colaborador_nivel_acesso
    FOREIGN KEY (fk_nivel_acesso)
    REFERENCES nivel_acesso (id_nivel_acesso)
);

CREATE TABLE endereco (
  id_endereco INT  IDENTITY(1,1),
  cep CHAR(9),
  num INT,
  rua VARCHAR(200) NULL,
  bairro VARCHAR(200) NULL,
  cidade VARCHAR(200) NULL,
  estado VARCHAR(80) NULL,
  pais VARCHAR(80) NULL,
  complemento VARCHAR(150) NULL,
  fk_empresaE INT,
    UNIQUE (id_endereco, fk_empresaE),
  CONSTRAINT fk_empresaE
    FOREIGN KEY (fk_empresaE)
    REFERENCES empresa (id_empresa)
);

CREATE TABLE plano (
  id_plano INT PRIMARY KEY IDENTITY(1,1),
  nome_plano VARCHAR(100) NULL,
  qtd_min_maq INT NULL,
  preco_min FLOAT NULL,
  valor_add_maq INT NULL
);

CREATE TABLE contrato (
  id_contrato INT  IDENTITY(1,1),
  data_inicio DATE NULL,
  data_termino DATE NULL,
  qtd_maq_add INT NULL,
  preco_total FLOAT,
  pagamento VARCHAR(50),
  fk_empresaCO INT,
  fk_plano INT,
  UNIQUE (id_contrato, fk_empresaCO, fk_plano),
  CONSTRAINT fk_empresaCO
    FOREIGN KEY (fk_empresaCO)
    REFERENCES empresa (id_empresa),
  CONSTRAINT fk_plano
    FOREIGN KEY (fk_plano)
    REFERENCES plano (id_plano)
);

CREATE TABLE chat (
  id_chat INT IDENTITY(1,1),
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(300) NULL,
  fk_colaborador_chat INT,
  UNIQUE (id_chat, fk_colaborador_chat),
  CONSTRAINT fk_colaborador_chat
    FOREIGN KEY (fk_colaborador_chat)
    REFERENCES colaborador (id_colaborador)
);
CREATE TABLE linha(
  id_linha INT PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(45) NULL,
  numero INT NULL,
  fk_empresaL INT,
  CONSTRAINT pk_linha
   UNIQUE(id_linha, fk_empresaL),
  CONSTRAINT fk_linha_empresa
    FOREIGN KEY(fk_empresaL)
    REFERENCES empresa(id_empresa)
);

CREATE TABLE maquina(
  id_maquina INT PRIMARY KEY IDENTITY(1,1),
  ip VARCHAR(20) NULL,
  so VARCHAR(45) NULL,
  hostname VARCHAR(100),
  modelo VARCHAR(45) NULL,
  setor CHAR(3) NULL,
  status_maquina tinyint,
  data_hora_inicializacao datetime,
  fk_empresaM INT,
  fk_linhaM INT NULL,
    CONSTRAINT pk_maquina
    UNIQUE(id_maquina, fk_empresaM),
  CONSTRAINT fk_maquina_empresa
    FOREIGN KEY(fk_empresaM)
    REFERENCES empresa(id_empresa),
  CONSTRAINT fk_linha_maquina
    FOREIGN KEY(fk_linhaM)
    REFERENCES linha(id_linha)
);


CREATE TABLE controle_acesso(
  id_controle_acesso INT PRIMARY KEY IDENTITY(1,1),
  fk_colaborador INT,
  fk_empresa_colaborador INT,
  fk_maquina INT,
  fk_empresa_maquina INT,
  inicio_sessao DATETIME,
  fim_sessao DATETIME NULL,
  UNIQUE(fk_colaborador, fk_empresa_colaborador, fk_maquina, fk_empresa_maquina),
  CONSTRAINT fk_colaboradorCA
    FOREIGN KEY(fk_colaborador, fk_empresa_colaborador)
    REFERENCES colaborador(id_colaborador, fk_empresa),
  CONSTRAINT fk_maquinaCA
    FOREIGN KEY(fk_maquina, fk_empresa_maquina)
    REFERENCES maquina(id_maquina, fk_empresaM)
);

CREATE TABLE janela(
  id_janela INT PRIMARY KEY IDENTITY(1,1),
  nome_janela VARCHAR(150) NULL,
  status_abertura TINYINT NULL,
  data_hora DATETIME NULL,
  valor_negocio tinyint NULL,
  fk_maquinaJ INT,
  fk_empresaJ INT,
  CONSTRAINT fk_maq_empJ
    FOREIGN KEY(fk_maquinaJ, fk_empresaJ)
    REFERENCES maquina(id_maquina, fk_empresaM)
);

CREATE TABLE processos(
  id_processo INT PRIMARY KEY IDENTITY(1,1),
  pid INT,
  nome_processo varchar(200),
  uso_cpu FLOAT NULL,
  uso_memoria FLOAT NULL,
  memoria_virtual FLOAT NULL,
  status_abertura TINYINT NULL,
  gravacao_disco FLOAT NULL, 
  temp_execucao FLOAT NULL, 
  fk_maquinaP INT,
  fk_empresaP INT,
  CONSTRAINT fk_maq_empP
    FOREIGN KEY(fk_maquinaP, fk_empresaP)
    REFERENCES maquina(id_maquina, fk_empresaM)
);

 CREATE TABLE unidade_medida(
  id_unidade INT PRIMARY KEY IDENTITY(1,1),
  tipo_dado VARCHAR(45) NULL,
  representacao CHAR(2) NULL
);

CREATE TABLE metrica(
  id_metrica INT PRIMARY KEY IDENTITY(1,1),
  risco FLOAT NULL,
  perigo FLOAT NULL,
  fk_unidade_medida INT,
  CONSTRAINT pk_metrica
  UNIQUE(id_metrica, fk_unidade_medida),
  CONSTRAINT fk_metrica_unidade_medida
    FOREIGN KEY(fk_unidade_medida)
    REFERENCES unidade_medida(id_unidade));


CREATE TABLE componente(
  id_componente INT PRIMARY KEY IDENTITY(1,1),
  nome_componente VARCHAR(45) NULL,
  fk_maquina_componente INT,
  fk_empresa_componente INT,
  fk_metrica_componente INT NULL,
  CONSTRAINT pk_componente
    UNIQUE(id_componente, fk_maquina_componente, fk_empresa_componente),
  CONSTRAINT fk_maq_empC
    FOREIGN KEY(fk_maquina_componente, fk_empresa_componente)
    REFERENCES maquina(id_maquina, fk_empresaM),
  CONSTRAINT fk_componente_metrica
    FOREIGN KEY(fk_metrica_componente)
    REFERENCES metrica(id_metrica)
);

CREATE TABLE especificacao(
  id_especificacao INT PRIMARY KEY IDENTITY(1,1),
  identificador VARCHAR(200) NULL,
  fabricante VARCHAR(45) NULL,
  frequencia nvarchar(max) NULL,
  microarquitetura VARCHAR(45) NULL,
  fk_componente_especificacao INT,
  fk_maquina_especificacao INT,
  fk_empresa_especificacao INT,
CONSTRAINT pk_especificacao
  UNIQUE(id_especificacao, fk_componente_especificacao, fk_maquina_especificacao, fk_empresa_especificacao),
  CONSTRAINT fk_especificacao_componente1
    FOREIGN KEY(fk_componente_especificacao, fk_maquina_especificacao, fk_empresa_especificacao)
    REFERENCES componente(id_componente, fk_maquina_componente, fk_empresa_componente)
);

CREATE TABLE monitoramento(
  id_monitoramento INT PRIMARY KEY IDENTITY(1,1),
  dado_coletado FLOAT,
  data_hora DATETIME,
  descricao VARCHAR(45),
  fk_componentes_monitoramento INT,
  fk_maquina_monitoramento INT,
  fk_empresa_monitoramento INT,
  fk_unidade_medida INT,
  CONSTRAINT pk_monitoramento
    UNIQUE(id_monitoramento, fk_componentes_monitoramento, fk_maquina_monitoramento, fk_empresa_monitoramento, fk_unidade_medida),
  CONSTRAINT fk_monitoramento_componente
    FOREIGN KEY(fk_componentes_monitoramento)
    REFERENCES componente(id_componente),
  CONSTRAINT fk_monitoramento_unidade_medida
    FOREIGN KEY(fk_unidade_medida)
    REFERENCES unidade_medida(id_unidade)
);

CREATE TABLE alerta(
  id_alerta INT PRIMARY KEY IDENTITY(1,1),
  dado_coletado FLOAT,
  tipo_alerta VARCHAR(20),
  data_hora DATETIME NULL,
  fk_componenente_alerta INT,
  fk_maquina_alerta INT,
  fk_empresa_alerta INT,
  fk_unidade_medida_alerta INT,
CONSTRAINT fk_alerta_componente
    FOREIGN KEY(fk_componenente_alerta)
    REFERENCES monitoramento(fk_componentes_monitoramento),
CONSTRAINT fk_alerta_maquina
    FOREIGN KEY(fk_maquina_alerta)
    REFERENCES maquina(id_maquina),
CONSTRAINT fk_alerta_empresa
    FOREIGN KEY(fk_empresa_alerta)
    REFERENCES empresa(id_empresa),
CONSTRAINT fk_alerta_unidade_medida
    FOREIGN KEY(fk_unidade_medida_alerta)
    REFERENCES unidade_medida(id_unidade)
    );


DELIMITER //
CREATE TRIGGER trigger_alerta AFTER INSERT ON monitoramento FOR EACH ROW
BEGIN
    DECLARE v_metrica INT;
    DECLARE v_risco FLOAT;
    DECLARE v_perigo FLOAT;
    DECLARE v_nome_componente VARCHAR(45);
    DECLARE v_dado_coletado FLOAT;

    SELECT NEW.dado_coletado
    INTO v_dado_coletado;

    SELECT c.fk_metrica_componente, c.nome_componente
    INTO v_metrica, v_nome_componente
    FROM componente as c
    WHERE c.id_componente = NEW.fk_componentes_monitoramento;

    SELECT m.risco, m.perigo
    INTO v_risco, v_perigo
    FROM metrica m
    WHERE m.id_metrica = v_metrica;

    IF v_dado_coletado >= v_risco THEN
     INSERT INTO alerta (tipo_alerta, dado_coletado, fk_componenente_alerta, fk_maquina_alerta, fk_empresa_alerta, fk_unidade_medida_alerta, data_hora)
        VALUES ('perigo', v_dado_coletado, NEW.fk_componentes_monitoramento, NEW.fk_maquina_monitoramento, NEW.fk_empresa_monitoramento, NEW.fk_unidade_medida, NOW());
    ELSEIF v_dado_coletado >= v_perigo THEN
        INSERT INTO alerta (tipo_alerta, dado_coletado, fk_componenente_alerta, fk_maquina_alerta, fk_empresa_alerta, fk_unidade_medida_alerta, data_hora)
        VALUES ('risco', v_dado_coletado, NEW.fk_componentes_monitoramento, NEW.fk_maquina_monitoramento, NEW.fk_empresa_monitoramento, NEW.fk_unidade_medida, NOW());
    END IF;
END;
//
DELIMITER ;


----------------------------------------------------------------------------------------------
-- VIEWS --
----------------------------------------------------------------------------------------------

CREATE VIEW VW_CPU_CHART AS
SELECT
    dado_coletado,
    Representacao,
    DATE_FORMAT(data_hora, '%y-%M-%d %h:%m:%s') as data_hora,
    nome_componente,
    descricao,
    id_maquina,
    hostname,
    razao_social
FROM
    monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa on M.fk_empresaM = empresa.id_empresa
WHERE nome_componente = 'CPU' and descricao = 'uso de cpu py';

-- view CPU - kotlin
CREATE VIEW VW_CPU_KOTLIN_CHART AS
SELECT
    ROUND(dado_coletado,2) as dado_coletado,
    Representacao,
    DATE_FORMAT(data_hora, '%y-%M-%d %h:%m:%s') as data_hora,
    nome_componente,
    descricao,
    id_maquina,
    empresa.id_empresa,
    hostname,
    razao_social
FROM
    monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa on M.fk_empresaM = empresa.id_empresa
WHERE nome_componente = 'CPU' and descricao='uso de cpu kt';

-- view TEMPERATURA
CREATE VIEW VW_TEMP_CHART AS
SELECT
    dado_coletado,
    Representacao,
    DATE_FORMAT(data_hora, '%y-%M-%d %h:%m:%s') as data_hora,
    nome_componente,
    descricao,
    id_maquina,
    hostname,
    razao_social
FROM
    monitoramento
JOIN unidade_medida ON fk_unidade_medida = id_unidade
JOIN componente ON fk_componentes_monitoramento = id_componente
JOIN maquina as M on fk_maquina_monitoramento = M.id_maquina
JOIN empresa on M.fk_empresaM = empresa.id_empresa
WHERE nome_componente = 'CPU' and descricao='temperatura cpu';


-- view RAM
CREATE VIEW VW_RAM_CHART AS
SELECT
    DISTINCT FORMAT(M1.data_hora, '%y-%M-%d %h:%m:%s') AS data_hora,
    ROUND(((1 - M1.dado_coletado / M2.dado_coletado) * 100), 2) AS 'usado',
    ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS 'livre',
    M2.dado_coletado AS 'total',
    componente.nome_componente,
    M.id_maquina,
    M.hostname,
    empresa.razao_social
FROM
    monitoramento AS M1
JOIN monitoramento AS M2 ON M1.fk_maquina_monitoramento = M2.fk_maquina_monitoramento
JOIN componente ON M1.fk_componentes_monitoramento = componente.id_componente
JOIN maquina AS M ON M1.fk_maquina_monitoramento = M.id_maquina
JOIN empresa ON M.fk_empresaM = empresa.id_empresa
WHERE
    componente.nome_componente = 'RAM'
    AND M2.descricao = 'memoria total'
    AND M1.descricao = 'memoria disponivel';





-- view DISCO
CREATE VIEW VW_DISCO_CHART AS  
SELECT
  DISTINCT M1.data_hora,
  ROUND((M1.dado_coletado / M2.dado_coletado) * 100, 2) AS 'livre',
  ROUND(((M2.dado_coletado - M1.dado_coletado) / M2.dado_coletado) * 100, 2) AS 'usado',
  componente.nome_componente,
  id_maquina,
  hostname,
  razao_social
FROM
  monitoramento AS M1
  JOIN monitoramento AS M2 ON M1.fk_maquina_monitoramento = M2.fk_maquina_monitoramento
  JOIN unidade_medida ON M1.fk_unidade_medida = id_unidade
  JOIN componente ON M1.fk_componentes_monitoramento = componente.id_componente
  JOIN maquina AS M ON M1.fk_maquina_monitoramento = M.id_maquina
  JOIN empresa ON M.fk_empresaM = empresa.id_empresa
WHERE
  M1.descricao = 'disco livre'
  AND M2.descricao = 'disco total';

-- view REDE
CREATE VIEW VW_REDE_CHART AS
SELECT
    DATE_FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes enviados' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS enviados,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes recebidos' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS recebidos,
    componente.nome_componente,
    componente.fk_maquina_componente as id_maquina,
    MAX(maquina.hostname) AS hostname,
    MAX(empresa.razao_social) AS razao_social,
    -- Adicionando os novos dados
    MAX(CASE WHEN monitoramento.descricao = 'velocidade de download' THEN ROUND(monitoramento.dado_coletado / 1000000, 2) END) AS velocidade_download,
    MAX(CASE WHEN monitoramento.descricao = 'velocidade de upload' THEN ROUND(monitoramento.dado_coletado / 1000000, 2) END) AS velocidade_upload,
    MAX(CASE WHEN monitoramento.descricao = 'ping' THEN monitoramento.dado_coletado END) AS ping,
    MAX(CASE WHEN monitoramento.descricao = 'latencia' THEN monitoramento.dado_coletado END) AS latencia
FROM
    monitoramento
JOIN componente ON monitoramento.fk_componentes_monitoramento = componente.id_componente
JOIN maquina ON monitoramento.fk_maquina_monitoramento = maquina.id_maquina
JOIN empresa ON maquina.fk_empresaM = empresa.id_empresa
WHERE
    componente.nome_componente IN ('REDE', 'velocidade de download', 'velocidade de upload', 'ping', 'latencia')
GROUP BY
    DATE_FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s'), componente.nome_componente, componente.fk_maquina_componente;


-- view janelas
create view VW_JANELAS_CHART as select nome_janela, status_abertura, fk_maquinaJ, fk_empresaJ from janela;

-- view alertas
create view VW_ALERTAS_TABLE as
select
  M.id_maquina,
  m.ip,
  M.hostname,
  M.so,
  M.setor,
  M.modelo,
  M.status_maquina,
  M.fk_empresaM,
  COUNT(DISTINCT M.id_maquina) AS qtd_maquina,
  COUNT(CASE WHEN A.tipo_alerta = 'perigo' THEN A.id_alerta END) AS qtd_perigo,
  COUNT(CASE WHEN A.tipo_alerta = 'risco' THEN A.id_alerta END) AS qtd_risco,
  COUNT(CASE WHEN A.tipo_alerta IN ('perigo', 'risco') THEN A.id_alerta END) AS qtd_alerta_maquina,
  COUNT(CASE WHEN A.data_hora BETWEEN DATE_SUB(LAST_DAY(SYSDATE()), INTERVAL 1 MONTH) AND LAST_DAY(SYSDATE()) THEN A.id_alerta END) AS qtd_alertas_no_mes
FROM
  maquina AS M
LEFT JOIN
  alerta AS A ON M.id_maquina = A.fk_maquina_alerta
GROUP BY
  M.id_maquina, M.hostname, M.ip, M.so, M.modelo, M.setor, M.status_maquina, M.fk_empresaM;

-- view grupo
CREATE VIEW VW_DESEMPENHO_CHART AS
SELECT
    data_hora AS data_hora,
    'CPU' AS recurso,
    id_maquina AS id_maquina,
    dado_coletado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        dado_coletado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_CPU_CHART
) AS C
WHERE C.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'RAM' AS recurso,
    id_maquina AS id_maquina,
    usado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_RAM_CHART
) AS R
WHERE R.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'DISCO' AS recurso,
    id_maquina AS id_maquina,
    usado AS uso_disco
FROM (
    SELECT
        data_hora,
        id_maquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_DISCO_CHART
) AS D
WHERE D.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'TEMPERATURA' AS recurso,
    id_maquina AS id_maquina,
    dado_coletado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        dado_coletado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_TEMP_CHART
) AS T
WHERE T.rn = 1;


-- view individual gyu
CREATE VIEW VW_DESEMPENHO_CHART_TEMP AS
SELECT
    data_hora AS data_hora,
    'CPU' AS recurso,
    id_maquina AS id_maquina,
    dado_coletado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        dado_coletado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_CPU_KOTLIN_CHART
) AS C
WHERE C.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'RAM' AS recurso,
    id_maquina AS id_maquina,
    usado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        usado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_RAM_CHART
) AS R
WHERE R.rn = 1
UNION ALL
SELECT
    data_hora AS data_hora,
    'TEMPERATURA' AS recurso,
    id_maquina AS id_maquina,
    dado_coletado AS uso
FROM (
    SELECT
        data_hora,
        id_maquina,
        dado_coletado,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_TEMP_CHART
) AS T
WHERE T.rn = 1;

-- view projeto individual- gyu
CREATE VIEW VW_TEMPXCPU_CHART AS
SELECT
    DATE_FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'uso de cpu kt' THEN monitoramento.dado_coletado END),2) AS uso_cpu_kt,
    MAX(CASE WHEN monitoramento.descricao = 'temperatura cpu' THEN monitoramento.dado_coletado END) AS temperatura_cpu,
    componente.nome_componente,
    componente.fk_maquina_componente as id_maquina,
    MAX(maquina.hostname) AS hostname,
    MAX(empresa.razao_social) AS razao_social
FROM
    monitoramento
JOIN componente ON monitoramento.fk_componentes_monitoramento = componente.id_componente
JOIN maquina ON monitoramento.fk_maquina_monitoramento = maquina.id_maquina
JOIN empresa ON maquina.fk_empresaM = empresa.id_empresa
WHERE
    componente.nome_componente = 'CPU'
    AND monitoramento.descricao IN ('uso de cpu kt', 'temperatura cpu')
GROUP BY
    DATE_FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s'), componente.nome_componente, componente.fk_maquina_componente;


/*             SELECTS DASH  */

    
		select top 7 * from VW_DISCO_CHART
        where id_maquina = 1;SELECT *
        FROM VW_DESEMPENHO_CHART_MEDIA -- essa view eh do joohnny eu nao tenho essa view criada
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha} 
         );
        ;
		
		select top 7 * from VW_CPU_CHART
        where id_maquina = 1;
		
		SELECT
        top 7 
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora;
		
		select top 7 * from VW_RAM_CHART
        where id_maquina = 1;
		
		SELECT
        top 7
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora;


    select top 7 * from VW_TEMP_CHART
        where id_maquina = 1;
		
		select top 1 from VW_TEMP_CHART
        where id_maquina = 1
        ORDER BY data_hora;
		
		
		select top 7 * data_hora_inicializacao from maquina where id_maquina= 1;
		
		
		select data_hora_inicializacao from maquina where id_maquina= 1;
		
		select top 7 * from VW_REDE_CHART
        where id_maquina = 1;
		
		select top 7 * from VW_DESEMPENHO_CHART -- as views que foram criadas erradas
        where id_maquina = 1;
		
		
		select top 7 * from VW_DESEMPENHO_CHART_TEMP
        where id_maquina = 1;
		
		select top 3 * from VW_DESEMPENHO_CHART_TEMP
        where id_maquina = 1
        ORDER BY data_hora;
		
		
		select * from VW_JANELAS_CHART
        where fk_maquinaJ = 1;
		
		
		select top 1 * from VW_CPU_CHART
        where id_maquina = 1
        ORDER BY data_hora;
		
		
		SELECT
        top
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora;
		
		SELECT
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora;
		
		select top 1 * from VW_RAM_CHART
        where id_maquina = 1
        ORDER BY data_hora;
		
		select top 3 * from VW_DESEMPENHO_CHART
        where id_maquina = 1
        ORDER BY data_hora;
		
		SELECT
        top 2 *
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = $1
         );
		 
		select top 1 * from VW_REDE_CHART
        where id_maquina = 1
        ORDER BY data_hora;
		
		select top 1 * from VW_DISCO_CHART
        where id_maquina = 1
        ORDER BY data_hora;

		select top 7 * from VW_CPU_KOTLIN_CHART
        where id_maquina = 1;
		
		select top 1 * from VW_CPU_KOTLIN_CHART
        where id_maquina = 1
        ORDER BY data_hora;




/*

CREATE TABLE chat (
  UNIQUE (id_chat, fk_colaborador_chat),
  id_chat INT IDENTITY(1,1),
  titulo VARCHAR(45) NULL,
  descricao VARCHAR(300) NULL,
  fk_colaborador_chat INT,
  CONSTRAINT fk_colaborador_chat
    FOREIGN KEY (fk_colaborador_chat)
    REFERENCES colaborador(id_colaborador)
function buscarUltimasMedidasDisco(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_DISCO_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DISCO_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasRede(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_DISCO_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DISCO_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasCPU(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  select top ${limite_linhas} from VW_CPU_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  select * from VW_CPU_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMediasCPU(idLinha, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = ` SELECT
        top ${limite_linhas} 
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = ` SELECT
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora DESC
         limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasRAM(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  select top ${limite_linhas} from VW_RAM_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  select * from VW_RAM_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMediasRAM(idLinha, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  SELECT
        top ${limite_linhas}
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  SELECT
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora
       limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}


function buscarUltimasMedidasTemp(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  select top ${limite_linhas} from VW_TEMP_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  select * from VW_TEMP_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealTemp(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_TEMP_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_TEMP_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasBoot(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  select top ${limite_linhas} data_hora_inicializacao from maquina where id_maquina= ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  select data_hora_inicializacao from maquina where id_maquina= ${idMaquina}
        limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealBoot(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `  select data_hora_inicializacao from maquina where id_maquina= ${idMaquina}`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `  select data_hora_inicializacao from maquina where id_maquina= ${idMaquina}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasRede(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_REDE_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_REDE_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasDesempenho(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_DESEMPENHO_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DESEMPENHO_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasDesempenhoTemp(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_DESEMPENHO_CHART_TEMP
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DESEMPENHO_CHART_TEMP
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarUltimasMedidasDesempenhoMedia(idLinha) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = ` SELECT *
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha} 
         );
        `;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `SELECT *
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha} 
         );`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealDesempenhoTemp(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 3 from VW_DESEMPENHO_CHART_TEMP
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DESEMPENHO_CHART_TEMP
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 3`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}



function buscarUltimasJanelas(idMaquina) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select * from VW_JANELAS_CHART
        where fk_maquinaJ = ${idMaquina};`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_JANELAS_CHART
                    where fk_maquinaJ = ${idMaquina};`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealCPU(idMaquina) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_CPU_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_CPU_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMediaEmTempoCPU(idLinha) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `SELECT
        top
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora;`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `SELECT
        AVG(dado_coletado) AS media_uso_cpu,
        data_hora
    FROM
        VW_CPU_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        )group by data_hora ORDER BY
        data_hora DESC;`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMediaEmTempoRAM(idLinha) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = ` SELECT
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora;`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = ` SELECT
        AVG(usado) AS media_uso_ram,
        data_hora
    FROM
        VW_RAM_CHART
    WHERE
        id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha}
        ) group by data_hora;`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealRAM(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_RAM_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_RAM_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealDesempenho(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 3 from VW_DESEMPENHO_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DESEMPENHO_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 3`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMediasEmTempoRealDesempenho(idLinha) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `SELECT
        top 2
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha} 
         );`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `SELECT *
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = ${idLinha} 
         ) limit 2;`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}


function buscarMedidasEmTempoRealRede(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_REDE_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_REDE_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoRealDisco(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_DISCO_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_DISCO_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}



function buscarUltimasMedidasTempXCpu(idMaquina, limite_linhas) {

    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top ${limite_linhas} from VW_CPU_KOTLIN_CHART
        where id_maquina = ${idMaquina}`;
    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_CPU_KOTLIN_CHART
                    where id_maquina = ${idMaquina}
                   limit ${limite_linhas}`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}


function buscarMedidasEmTempoRealTempXCpu(idMaquina) {
    instrucaoSql = ''

    if (process.env.AMBIENTE_PROCESSO == 'producao') {
        instrucaoSql = `select top 1 from VW_CPU_KOTLIN_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora`;

    } else if (process.env.AMBIENTE_PROCESSO == 'desenvolvimento') {
        instrucaoSql = `select * from VW_CPU_KOTLIN_CHART
        where id_maquina = ${idMaquina}
        ORDER BY data_hora DESC limit 1`;
    } else {
        console.log('\nO AMBIENTE (produção OU desenvolvimento) NÃO FOI DEFINIDO EM app.js\n');
        return
    }

    console.log('Executando a instrução SQL: \n' + instrucaoSql);
    return database.executar(instrucaoSql);
}
);

CREATE TABLE linha (
  id_linha INT  IDENTITY(1,1),
  nome VARCHAR(45) NULL,
  numero INT NULL,
  fk_empresaL INT,
  CONSTRAINT pk_linha
   UNIQUE (id_linha, fk_empresaL),
  CONSTRAINT fk_linha_empresa
    FOREIGN KEY (fk_empresaL)
    REFERENCES empresa(id_empresa)
); */

/*
CREATE TABLE  nivel_acesso (
    id_nivel_acesso INT PRIMARY KEY IDENTITY(1,1),
    sigla CHAR(3) NULL,
    descricao VARCHAR(50) NULL
);

CREATE TABLE  colaborador (
    id_colaborador INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(200) NULL,
    cpf CHAR(14) NULL,
    email VARCHAR(250) NULL UNIQUE,
    celular CHAR(13) NULL,
    senha VARCHAR(255) NULL,
    status_colaborador tinyint,
    fk_empresa INT,
    fk_nivel_acesso INT,
    CONSTRAINT pk_colaborador
        UNIQUE (id_colaborador, fk_empresa),
    CONSTRAINT fk_usuarios_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa (id_empresa),
    CONSTRAINT fk_colaborador_nivel_acesso
        FOREIGN KEY (fk_nivel_acesso)
        REFERENCES nivel_acesso (id_nivel_acesso)
);

CREATE TABLE  endereco (
    id_endereco INT PRIMARY KEY IDENTITY(1,1),
    cep CHAR(9),
    num INT,
    rua VARCHAR(200) NULL,
    bairro VARCHAR(200) NULL,
    cidade VARCHAR(200) NULL,
    estado VARCHAR(80) NULL,
    pais VARCHAR(80)
*/