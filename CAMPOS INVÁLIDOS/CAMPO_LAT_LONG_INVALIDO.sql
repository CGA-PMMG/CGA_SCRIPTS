/*﻿-----------------------------------------------------------------------------------------------------------------------------------------
 * Este script SQL foi projetado para fornecer uma visão geral das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais
 *  no período especificado. O principal objetivo é contar o total de ocorrências únicas e determinar quantas delas não possuem 
 * informações sobre logitude e latitude.
 ﻿-----------------------------------------------------------------------------------------------------------------------------------------*/
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Matrícula do digitador responsável pela entrada dos dados.
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro para identificar a RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro para identificar o BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo da unidade responsável pelo registro segmento para identificar a CIA
    COUNT(DISTINCT OCO.numero_ocorrencia) AS Total_Registros, -- Conta o total de registros únicos de ocorrências.
    SUM(CASE
        WHEN OCO.numero_longitude IS NULL OR OCO.numero_latitude IS NULL THEN 1 ELSE 0
        END) AS Qtd_Null_BSC -- Calcula a quantidade de registros que não possuem dados de longitude ou latitude, indicando possíveis falhas na geolocalização.
-- A fonte de dados vem da tabela de ocorrências.
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
-- Aplica filtros para restringir os dados:
WHERE 1 = 1 
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela Polícia Militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
 -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro
-- Agrupa os resultados pelas colunas selecionadas para permitir uma análise detalhada por unidade e digitador.
GROUP BY
    OCO.digitador_matricula, RPM, BPM, CIA
-- Ordena os resultados pela Região, Batalhão e Companhia para facilitar a visualização e análise.
ORDER BY RPM, BPM, CIA;
