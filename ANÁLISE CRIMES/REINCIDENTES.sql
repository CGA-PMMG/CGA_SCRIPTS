/*--------------------------------------------------------------------------------------------------------
 * O objetivo deste script é identificar indivíduos reincidentes em ocorrências policiais, 
 * Ele seleciona dados de envolvidos cujos códigos de envolvimento são autores ou suspeitos, 
 * exclui certas naturezas de ocorrências e identifica os reincidentes com base em múltiplas ocorrências
 *  registradas no período.
 * 
 * Contruibuição: Gabriel A S e Brito, Sd PM.
------------------------------------------------------------------------------------------------------- */
WITH envolvido AS ( -- Define uma CTE chamada "envolvido" que armazena os dados temporários para uso subsequente.
    SELECT 
    env.numero_ocorrencia, -- Seleciona o número da ocorrência.
    env.nome_completo_envolvido, -- Seleciona o nome completo do envolvido.
    env.nome_mae, -- Seleciona o nome da mãe do envolvido.
    env.data_nascimento, -- Seleciona data de nascimento do envolvido.
    env.envolvimento_codigo, -- Seleciona o código do envolvimento.
    env.envolvimento_descricao -- Seleciona a descrição do envolvimento.
    FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env -- Define a tabela "tb_envolvido_ocorrencia" do banco de dados como origem dos dados.
    INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO -- Realiza uma junção com a tabela "tb_ocorrencia" através do INNER JOIN.
    ON env.numero_ocorrencia = OCO.numero_ocorrencia -- A junção é baseada no número de ocorrência presente em ambas as tabelas.
    WHERE 1=1 -- Condição universal sempre verdadeira para facilitar a adição de filtros.
    AND env.codigo_municipio IN (0,0,0,...) -- Filtra as ocorrências apenas para os municípios com esses códigos específicos.
    AND OCO.data_hora_fato BETWEEN '2024-01-01 00:00:00' AND '2024-12-31 23:59:59' -- Filtra data/hora do fato detro do período especificado.
    AND (SUBSTRING(OCO.natureza_codigo,1,1) <> 'A' ) -- Exclui naturezas começam com a letra 'A'.
    AND env.envolvimento_codigo IN ('0100','1100') -- Filtra as ocorrências em que o codigo do envolvimento corresponde a 'Autor' ou 'Suspeito'.
),
reincidente AS ( -- Define uma CTE chamada "reincidente" que identifica pessoas envolvidas em mais de uma ocorrência.
    SELECT  
    e.nome_completo_envolvido, -- Seleciona o nome completo do envolvido da CTE "envolvido".
    e.nome_mae, -- Seleciona o nome da mãe do envolvido da CTE "envolvido".
    e.data_nascimento -- Seleciona a data de nascimento do envolvido da CTE "envolvido".
 FROM envolvido e -- Utiliza a CTE "envolvido" como origem dos dados.
    GROUP BY e.nome_completo_envolvido, e.nome_mae, -- Agrupa os dados por nome completo, nome da mãe e data de nascimento.
    e.data_nascimento
    HAVING COUNT(*) > 1 -- Filtra para mostrar apenas aqueles que apareceram mais de uma vez (reincidentes).
)
SELECT 
    OCO.numero_ocorrencia, -- Seleciona o número da ocorrência da tabela "tb_ocorrencia".
	e.nome_completo_envolvido, -- Seleciona o nome completo do envolvido da CTE "envolvido".
	e.nome_mae, -- Seleciona o nome da mãe do envolvido da CTE "envolvido".
	e.data_nascimento, -- Seleciona a data de nascimento do envolvido da CTE "envolvido".
	e.envolvimento_descricao, -- Seleciona a descrição do envolvimento da CTE "envolvido".
    OCO.natureza_codigo, -- Seleciona o código da natureza da ocorrência da tabela "tb_ocorrencia".
    OCO.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência da tabela "tb_ocorrencia".
    CAST(OCO.data_hora_fato AS DATE) AS data_hora_fato, -- Converte o campo "data_hora_fato" para o tipo de dado DATE.
    CONCAT( -- Concatena e formata a hora do fato no formato HH:MM:SS.
            LPAD(CAST(EXTRACT(HOUR FROM OCO.data_hora_fato) AS STRING), 2, '0'), ':',
            LPAD(CAST(EXTRACT(MINUTE FROM OCO.data_hora_fato) AS STRING), 2, '0'), ':',
            LPAD(CAST(EXTRACT(SECOND FROM OCO.data_hora_fato) AS STRING), 2, '0')
        ) AS hora_fato, -- Nomeia o campo concatenado como "hora_fato".
    OCO.nome_municipio, -- Seleciona o nome do município do fato.
    OCO.unidade_responsavel_registro_nome -- Seleciona o nome da unidade responsável pelo registro.
FROM  envolvido e -- Utiliza a CTE "envolvido" como origem para a junção.
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO -- Realiza uma junção com a tabela "tb_ocorrencia".
ON OCO.numero_ocorrencia = e.numero_ocorrencia -- A junção é feita com base no campo "numero_ocorrencia".
INNER JOIN reincidente R -- Realiza uma junção com a CTE "reincidente".
 ON (upper(e.nome_completo_envolvido) = Upper(R.nome_completo_envolvido) -- Compara os nomes completos em maiúsculas para garantir a correspondência.
  AND UPPER(e.nome_mae) = UPPER(R.nome_mae) -- Compara os nomes das mães em maiúsculas para garantir a correspondência.
  AND CAST(e.data_nascimento AS date) = CAST(R.data_nascimento AS date)) -- Compara as datas de nascimento convertidas para o tipo DATE.
WHERE 1=1 -- Condição universal sempre verdadeira para facilitar a adição de filtros.
    AND OCO.codigo_municipio IN (0,0,0,...) -- Filtra as ocorrências apenas para os municípios com esses códigos específicos.
    AND OCO.data_hora_fato BETWEEN '2024-01-01 00:00:00' AND '2024-12-31 23:59:59' -- Filtra data/hora do fato detro do período especificado.
  AND (SUBSTRING(OCO.natureza_codigo,1,1) <> 'A' ) -- Exclui naturezas começam com a letra 'A'.
    AND e.envolvimento_codigo IN ('0100','1100') -- Filtra as ocorrências em que o codigo do envolvimento corresponde a 'Autor' ou 'Suspeito'.
    ORDER BY e.nome_completo_envolvido, e.nome_mae, e.data_nascimento, OCO.data_hora_fato; -- Ordena o resultado pelo nome completo, nome da mãe, data de nascimento e data da ocorrência.
