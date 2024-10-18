/*--------------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como objetivo identificar reincidências de vítimas de violência doméstica (VD) em 
 * ocorrências registradas pela Polícia Militar de Minas Gerais, agregando múltiplas informações por vítima, 
 * como os tipos de violência, municípios e ocorrências, consolidando os dados em uma visão sintética para 
 * cada vítima reincidente. 
 * Esse script apresenta um resumo para análises de padrões de reincidência de VD, auxiliando na análise, formulação de 
 * políticas preventivas e estratégicas de segurança pública.
 ---------------------------------------------------------------------------------------------------------------------*/

WITH REINCIDENCIA_VD AS -- Criação de uma CTE (Common Table Expression) denominada REINCIDENCIA_VD, que serve para organizar a seleção de dados
(
    SELECT 
        UPPER(ENV.nome_completo_envolvido) as nome_completo_envolvido, -- Seleciona e converte o nome completo do envolvido para letras maiúsculas
        UPPER(ENV.nome_mae) as nome_mae, -- Seleciona e converte o nome da mãe do envolvido para letras maiúsculas
        ENV.data_nascimento, -- Seleciona a data de nascimento do envolvido
        ENV.envolvimento_descricao, -- Seleciona a descrição do envolvimento do indivíduo na ocorrência
        OCO.numero_ocorrencia, -- Seleciona o número da ocorrência
        OCO.data_hora_fato, -- Seleciona a data/hora do fato da ocorrência
        OCO.natureza_codigo, -- Seleciona o código da natureza da ocorrência
        OCO.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
        ENV.condicao_fisica_descricao, -- Seleciona a descrição da condição física do envolvido
        OCO.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
        OCO.unidade_area_militar_nome, -- Seleciona o nome da área militar 
        OCO.codigo_municipio, -- Seleciona o código do município da ocorrência 
        OCO.nome_municipio, -- Seleciona o nome do município da ocorrência 
        CASE  
            WHEN OCO.natureza_codigo IN ('D01213', 'D01217', 'B01124', 'D01502', 'B05502', 'C01173', 'B05503', 'D08061', 'B05505', 'B05241', 'D01504', 'D01530', 'B05501', 'D01228', 'D99000', 'D01230', 'B01125', 'B05240', 'D01505', 'D01229', 'D01227', 'B05504') THEN 'SEXUAL' -- Classifica a ocorrência como violência sexual com base no código da natureza
            WHEN OCO.natureza_codigo IN ('B01147', 'A02000', 'D08065', 'B01150', 'B01146', 'B01148', 'B05237', 'B05232', 'H01212', 'B05230', 'K06071', 'K26056', 'K07011', 'K19581', 'K07014', 'D01506', 'K26154', 'D01216', 'G01337', 'B05238', 'B13096', 'K07005') THEN 'PSICOLOGICA' -- Classifica a ocorrência como violência psicológica
            WHEN OCO.natureza_codigo IN ('C01155', 'C01163', 'C01171', 'C01168', 'C99000', 'C01157', 'C01161', 'C01501', 'B26056', 'G01300', 'C01158', 'C01180', 'G01314', 'C01160', 'B13104', 'C08026', 'C01156', 'B01154', 'B01153', 'L29004', 'B01151', 'C01176', 'C01182', 'C01177', 'M31014', 'C01181', 'K23078', 'C01159', 'E01264', 'B24040', 'J20295') THEN 'PATRIMONIAL' -- Classifica a ocorrência como violência patrimonial
            WHEN OCO.natureza_codigo IN ('B01140', 'B01139', 'B01138', 'G01339') THEN 'MORAL' -- Classifica a ocorrência como violência moral
            WHEN OCO.natureza_codigo IN ('B01129', 'B08021', 'B01136', 'E08042', 'B01121', 'B02001', 'B01137', 'B01123', 'B01122', 'H18020', 'F01200') THEN 'FISICA' -- Classifica a ocorrência como violência física
            ELSE 'OUTROS' -- Classifica como 'OUTROS' quando a natureza da ocorrência não corresponde a nenhuma das categorias acima
        END AS TIPO_VIOLENCIA, -- Atribui o tipo de violência com base na natureza da ocorrência
        ROW_NUMBER() OVER (PARTITION BY ENV.nome_completo_envolvido, ENV.nome_mae, ENV.data_nascimento ORDER BY OCO.data_hora_fato) AS ORDEM_OCORRENCIA -- Gera um número sequencial para cada ocorrência, agrupado por nome, mãe e data de nascimento
    FROM db_bisp_reds_reporting.tb_ocorrencia OCO -- Seleciona a tabela de ocorrências (OCO)
    INNER JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV -- Faz a junção com a tabela de envolvidos (ENV)
        ON OCO.numero_ocorrencia = ENV.numero_ocorrencia -- Junta as tabelas OCO e ENV com base no número de ocorrência
    WHERE 1=1 -- Condição sempre verdadeira para facilitar a adição de condições subsequentes
        AND OCO.data_hora_fato BETWEEN '2022-01-01 00:00:00' AND '2024-10-18 23:59:59' -- Filtra data/hora do fato dentro do período especificado
        AND ENV.codigo_sexo = 'F' -- Filtra para selecionar apenas vítimas do sexo feminino
        AND ENV.id_relacao_vitima_autor IN (22,21,15,6,7,19,18,16,5,20) -- Filtra com base na relação entre vítima e autor, especificando valores predeterminados
        AND ENV.id_envolvimento IN (25,32,872) -- Filtra tipos específicos de envolvimento do indivíduo na ocorrência
        AND OCO.natureza_codigo NOT LIKE 'A20%' -- Exclui ocorrências cuja natureza tenha código iniciado por 'A20'
        AND OCO.relator_sigla_orgao = 'PM' -- Filtra apenas ocorrências relatadas pela Polícia Militar
        AND OCO.ocorrencia_uf = 'MG' -- Filtra apenas ocorrências que ocorreram em Minas Gerais
        --AND OCO.codigo_municipio IN (0,0,0,...) -- Filtro opcional por município 
        --AND unidade_responsavel_registro_nome LIKE '%BELO HORI%' -- Filtro opcional por unidade responsável pelo  registro 
)
SELECT  
    CONCAT(
        UPPER(COALESCE(RVD.nome_completo_envolvido, 'Desconhecido')), -- Concatena e converte o nome completo do envolvido para letras maiúsculas, substituindo valores nulos por 'Desconhecido'
        ' - ',
        UPPER(COALESCE(RVD.nome_mae, 'Desconhecido')), -- Concatena e converte o nome da mãe para letras maiúsculas, substituindo valores nulos por 'Desconhecido'
        ' - ',
        COALESCE(CAST(RVD.data_nascimento AS STRING), 'Data Não Informada') -- Concatena e converte a data de nascimento para string, substituindo valores nulos por 'Data Não Informada'
    ) AS Dados_envolvido, -- Gera a coluna 'Dados_envolvido' concatenando as informações acima
    GROUP_CONCAT(DISTINCT RVD.envolvimento_descricao) AS envolvimentos_descricao, -- Agrupa e concatena as descrições distintas do envolvimento do indivíduo
    GROUP_CONCAT(DISTINCT RVD.numero_ocorrencia) AS numero_ocorrencias, -- Agrupa e concatena os números distintos de ocorrência
    GROUP_CONCAT(DISTINCT RVD.natureza_codigo) AS naturezas_codigo, -- Agrupa e concatena os códigos distintos de natureza da ocorrência
    GROUP_CONCAT(DISTINCT RVD.natureza_descricao) AS naturezas_descricao, -- Agrupa e concatena as descrições distintas da natureza da ocorrência
    GROUP_CONCAT(DISTINCT RVD.nome_municipio) AS nomes_municipios, -- Agrupa e concatena os nomes distintos dos municípios
    GROUP_CONCAT(DISTINCT RVD.TIPO_VIOLENCIA) AS TIPO_VIOLENCIA, -- Agrupa e concatena os tipos distintos de violência
    MAX(RVD.ORDEM_OCORRENCIA) AS QTDE_OCORRENCIAS -- Seleciona o número máximo de reincidências por indivíduo
FROM REINCIDENCIA_VD RVD -- Usa a CTE REINCIDENCIA_VD definida anteriormente
GROUP BY  
    Dados_envolvido -- Agrupa os resultados pelo campo 'Dados_envolvido'
HAVING MAX(RVD.ORDEM_OCORRENCIA) >= 2 -- Exibe apenas os indivíduos com pelo menos duas ocorrências
ORDER BY Dados_envolvido, QTDE_OCORRENCIAS -- Ordena os resultados pelo campo 'Dados_envolvido' e pela quantidade de ocorrências
