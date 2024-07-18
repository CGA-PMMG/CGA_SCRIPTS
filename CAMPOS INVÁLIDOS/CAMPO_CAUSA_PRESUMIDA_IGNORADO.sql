/*﻿----------------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL foi desenvolvido para fornecer uma visão detalhada sobre a integridade dos dados relacionados aos motivos presumidos 
 * das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais no ano de 2024. O foco principal está em identificar 
 * quantas dessas ocorrências não têm um motivo presumido registrado ou estão categorizadas com códigos específicos ('9800', '0133') 
 * que podem indicar categorias padrão ou dados genéricos. Ao contabilizar o total de ocorrências e avaliar a frequência ou a falta desses códigos, 
 * o relatório ajuda a entender a qualidade da documentação das motivações nas ocorrências.
 ﻿----------------------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS PARA IDENTIFICAÇÃO DO DIGITADOR E A UNIDADE RESPONSÁVEL
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- EXTRAI A MATRÍCULA DO DIGITADOR RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI O ÚLTIMO SEGMENTO DA UNIDADE (MAIS ESPECÍFICO)
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI O PENÚLTIMO SEGMENTO DA UNIDADE
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO DA UNIDADE
    COUNT(OCO.numero_ocorrencia) AS Total_Registros, -- CONTA O TOTAL DE OCORRÊNCIAS ÚNICAS
    SUM(CASE 
        WHEN OCO.motivo_presumido_codigo IS NULL 
             OR OCO.motivo_presumido_codigo IN ('9800', '0133') -- VERIFICA A AUSÊNCIA OU CÓDIGOS ESPECÍFICOS DE MOTIVO PRESUMIDO
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800_0133
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
GROUP BY OCO.digitador_matricula, RPM, BPM, CIA
-- ORDENAÇÃO DOS RESULTADOS PELA HIERARQUIA DA UNIDADE
ORDER BY RPM, BPM, CIA;
