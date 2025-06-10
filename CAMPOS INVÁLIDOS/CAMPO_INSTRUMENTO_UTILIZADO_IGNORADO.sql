/*-----------------------------------------------------------------------------------------------------------------------------------------
 * Este script SQ foi desenvolvido para fornecer uma visão geral das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais 
 * no período especificado, com foco na análise do uso de instrumentos utilizados. O objetivo +é contabilizar o total de ocorrências únicas 
 * e identificar quantas delas não possuem informação sobre o instrumento utilizado ou estão classificadas com o código '9800'(ignorado).
 -----------------------------------------------------------------------------------------------------------------------------------------*/
-- seleção de colunas específicas para identificação do digitador e da unidade responsável
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Seleciona a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável  pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável  pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo segmento da unidade responsável  pelo registro
    COUNT(OCO.numero_ocorrencia) AS Total_Registros, -- Conta o total de ocorrências únicas
    SUM(CASE 
        WHEN OCO.instrumento_utilizado_codigo IS NULL OR OCO.instrumento_utilizado_codigo = '9800' -- verifica ausência ou campo preenchido com código =  IGNORADO
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800 -- Soma os registros com instrumento utilizado ausente ou código '9800'
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
WHERE 1 = 1
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela polícia militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
  -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro (opcional)
-- agrupamento dos dados para estruturar os resultados
GROUP BY 1, 2, 3, 4
-- ordenação dos resultados pela hierarquia da unidade
ORDER BY 2, 3, 4;
