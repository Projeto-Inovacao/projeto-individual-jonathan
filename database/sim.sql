-- view CPU - py
CREATE VIEW VW_CPU_CHART AS
SELECT
    dado_coletado,
    Representacao,
    FORMAT(data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
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
    FORMAT(data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
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
WHERE nome_componente = 'CPU' and descricao='uso de cpu kt';

-- view TEMPERATURA
CREATE VIEW VW_TEMP_CHART AS
SELECT
    dado_coletado,
    Representacao,
    FORMAT(data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
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
    DISTINCT FORMAT(M1.data_hora, '%Y-%m-%d %H:%i:%s') AS data_hora,
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
  DISTINCT FORMAT(M1.data_hora, '%y-%M-%d %h:%m:%s') AS data_hora,
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
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes enviados' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS enviados,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes recebidos' THEN monitoramento.dado_coletado / 1048576.0 END), 2) AS recebidos,
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
    componente.nome_componente = 'REDE'
GROUP BY
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s'), componente.nome_componente, componente.fk_maquina_componente;

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
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s') as data_hora,
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
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s'), componente.nome_componente, componente.fk_maquina_componente;
   
    -- view Individual Rede Rita
  CREATE VIEW VW_REDE_CHARTU AS
SELECT
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s') AS data_hora,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'velocidade de download' THEN monitoramento.dado_coletado / 1000000.0 END),5) AS velocidade_download,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'velocidade de upload' THEN monitoramento.dado_coletado / 1000000.0 END),5) AS velocidade_upload,
    MAX(CASE WHEN monitoramento.descricao = 'ping' THEN monitoramento.dado_coletado END) AS ping,
    MAX(CASE WHEN monitoramento.descricao = 'latencia' THEN monitoramento.dado_coletado END) AS latencia,
        ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes enviados py' THEN monitoramento.dado_coletado / 1048576.0 END), 5) AS enviados,
    ROUND(MAX(CASE WHEN monitoramento.descricao = 'bytes enviados py' THEN monitoramento.dado_coletado / 1048576.0 END), 5) AS recebidos,
    componente.nome_componente,
    componente.fk_maquina_componente AS id_maquina,
    MAX(maquina.hostname) AS hostname,
    MAX(empresa.razao_social) AS razao_social
FROM
    monitoramento
JOIN componente ON monitoramento.fk_componentes_monitoramento = componente.id_componente
JOIN maquina ON monitoramento.fk_maquina_monitoramento = maquina.id_maquina
JOIN empresa ON maquina.fk_empresaM = empresa.id_empresa
WHERE
    componente.nome_componente IN ('bytes enviados py', 'bytes recebidos py', 'REDE', 'velocidade de download', 'velocidade de upload', 'ping', 'latencia')
GROUP BY
    FORMAT(monitoramento.data_hora, '%Y-%m-%d %H:%i:%s'), componente.nome_componente, componente.fk_maquina_componente;



SELECT
    AVG(usado) AS media_uso_ram,
    data_hora
FROM
    VW_RAM_CHART
WHERE
    id_maquina IN (
        SELECT id_maquina
        FROM maquina
        WHERE fk_linhaM = 1
    ) group by data_hora;
   
    SELECT
    AVG(dado_coletado) AS media_uso_cpu,
    data_hora
FROM
    VW_CPU_CHART
WHERE
    id_maquina IN (
        SELECT id_maquina
        FROM maquina
        WHERE fk_linhaM = 1
    )group by data_hora ORDER BY
    data_hora DESC;
   
    -- Desempenho individual jonny
   
CREATE VIEW VW_DESEMPENHO_CHART_MEDIA AS
SELECT
    C.data_hora,
    'CPU' AS recurso,
    C.id_maquina,
    C.media_uso_cpu AS uso
FROM (
    SELECT
        id_maquina,
        data_hora,
        AVG(dado_coletado) AS media_uso_cpu,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_CPU_CHART
    WHERE id_maquina IN (SELECT id_maquina FROM maquina WHERE fk_linhaM = 1)
    GROUP BY id_maquina, data_hora
) AS C
WHERE C.rn = 1

UNION ALL

SELECT
    R.data_hora,
    'RAM' AS recurso,
    R.id_maquina,
    R.media_uso_ram AS uso
FROM (
    SELECT
        id_maquina,
        data_hora,
        AVG(usado) AS media_uso_ram,
        ROW_NUMBER() OVER (PARTITION BY id_maquina ORDER BY data_hora DESC) AS rn
    FROM VW_RAM_CHART
    WHERE id_maquina IN (SELECT id_maquina FROM maquina WHERE fk_linhaM = 1)
    GROUP BY id_maquina, data_hora
) AS R
WHERE R.rn = 1;

SELECT *
        FROM VW_DESEMPENHO_CHART_MEDIA
        WHERE id_maquina IN (
            SELECT id_maquina
            FROM maquina
            WHERE fk_linhaM = 1
         ) limit 2;
         
         SELECT
  l.id_linha,
  l.nome AS nome_linha,
  l.numero AS numero_linha,
  COUNT(m.id_maquina) AS quantidade_maquinas
FROM
  linha l
LEFT JOIN
  maquina m ON l.id_linha = m.fk_linhaM
GROUP BY
  l.id_linha, l.nome, l.numero;