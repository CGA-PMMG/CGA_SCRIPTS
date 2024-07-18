/*﻿-----------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL foi projetado para fornecer uma visão geral das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais
 * no ano de 2024, focando em analisar o uso de instrumentos utilizados. O principal objetivo é contar o 
 * total de ocorrências únicas e determinar quantas delas não possuem informações sobre logitude e latitude.
 ﻿-----------------------------------------------------------------------------------------------------------------------------------------*/
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Matrícula do digitador responsável pela entrada dos dados.
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro 
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro 
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo segmento da unidade responsável pelo registro 
    COUNT(DISTINCT OCO.numero_ocorrencia) AS Total_Registros, -- Conta o total de registros únicos de ocorrências.
    SUM(CASE
        WHEN OCO.numero_longitude IS NULL OR OCO.numero_latitude IS NULL THEN 1 ELSE 0
        END) AS Qtd_Null_BSC -- Calcula a quantidade de registros que não possuem dados de longitude ou latitude, indicando possíveis falhas na geolocalização.
-- A fonte de dados vem da tabela de ocorrências.
FROM tb_ocorrencia OCO
-- Aplica filtros para restringir os dados:
WHERE YEAR(OCO.data_hora_fato) = 2024 -- Considera apenas ocorrências do ano de 2024.
    AND OCO.nome_tipo_relatorio NOT IN('RAT', 'BOS', 'BOS AMPLO') -- Exclui tipos de relatórios que não são de interesse, como Relatório de Atendimento Tático (RAT) e Boletim de Ocorrência Simplificado (BOS).
    AND OCO.relator_sigla_orgao = 'PM' -- Foca apenas nos registros inseridos pela Polícia Militar.
    AND OCO.descricao_estado = 'FECHADO' -- Restringe a análise para casos já finalizados.
    AND OCO.ocorrencia_uf = 'MG' -- Limita a consulta a ocorrências no estado de Minas Gerais.
    -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO.
-- Agrupa os resultados pelas colunas selecionadas para permitir uma análise detalhada por unidade e digitador.
GROUP BY
    OCO.digitador_matricula, RPM, BPM, CIA
-- Ordena os resultados pela Região, Batalhão e Companhia para facilitar a visualização e análise.
ORDER BY RPM, BPM, CIA;
