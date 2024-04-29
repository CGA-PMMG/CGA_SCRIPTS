/*﻿-----------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL foi projetado para fornecer uma visão geral das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais
 * no ano de 2024, focando em analisar o uso de instrumentos utilizados. O principal objetivo é contar o 
 * total de ocorrências únicas e determinar quantas delas não possuem informações sobre o instrumento utilizado ou estão registradas 
 * com um código '9800', que pode indicar uma categoria específica ou ausência de informação.
 ﻿-----------------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS PARA IDENTIFICAÇÃO DO DIGITADOR E A UNIDADE RESPONSÁVEL
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- EXTRAI A MATRÍCULA DO DIGITADOR RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI O ÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI O PENÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    COUNT(OCO.numero_ocorrencia) AS Total_Registros, -- CONTA O TOTAL DE OCORRÊNCIAS 
    SUM(CASE 
        WHEN OCO.instrumento_utilizado_codigo IS NULL OR OCO.instrumento_utilizado_codigo = '9800' 
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800 -- VERIFICA A AUSÊNCIA OU CÓDIGO ESPECÍFICO DE INSTRUMENTO UTILIZADO
-- TABELAS UTILIZADAS PARA A CONSULTA
FROM tb_ocorrencia OCO
-- FILTROS APLICADOS PARA A SELEÇÃO DOS DADOS
WHERE YEAR(OCO.data_hora_fato) = 2024  -- FILTRA OS DADOS PARA OCORRÊNCIAS DO ANO 2024
  AND OCO.relator_sigla_orgao = 'PM' -- APENAS OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
  AND OCO.ocorrencia_uf = 'MG' -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
  AND OCO.descricao_estado = 'FECHADO' -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- EXCLUI CERTOS TIPOS DE RELATÓRIOS
  -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO.
-- AGRUPAMENTO DOS DADOS PARA ESTRUTURAR OS RESULTADOS
GROUP BY 1, 2, 3, 4
-- ORDENAÇÃO DOS RESULTADOS PELA HIERARQUIA DA UNIDADE
ORDER BY 2, 3, 4
