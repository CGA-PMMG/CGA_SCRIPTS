/*-- --------------------------------------------------------------------------------------------------------------------------------------
 *  Este código SQL é projetado para fornecer uma análise detalhada sobre a integridade dos dados de escolaridade dos envolvidos em 
 *  ocorrências fechadas registradas pela Polícia Militar de Minas Gerais no ano de 2024. O foco principal está em identificar
 *  e quantificar os registros que não possuem informações sobre escolaridade ou estão marcados com o código '9800'. A consulta
 *  estrutura os resultados com base na hierarquia das unidades responsáveis pela ocorrência, garantindo uma visualização clara
 *  e ordenada que facilita a interpretação e análise dos dados coletados.
 -- --------------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS PARA IDENTIFICAÇÃO DO DIGITADOR E A UNIDADE RESPONSÁVEL
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- EXTRAI A MATRÍCULA DO DIGITADOR RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS N1, -- EXTRAI O ÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS N2, -- EXTRAI O PENÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS N3, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO DA UNIDADE RESPONSÁVEL PELO REGISTRO
    COUNT(ENV.numero_envolvido) AS total_envolvidos, -- CONTA O TOTAL DE ENVOLVIDOS NAS OCORRÊNCIAS
    SUM(CASE 
        WHEN ENV.escolaridade_codigo IS NULL OR ENV.escolaridade_codigo = '9800' -- VERIFICA A AUSÊNCIA OU CÓDIGO ESPECÍFICO DE ESCOLARIDADE
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800
-- TABELAS E JUNÇÕES UTILIZADAS PARA A CONSULTA
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO DAS TABELAS DE OCORRÊNCIA E ENVOLVIDOS
-- FILTROS APLICADOS PARA A SELEÇÃO DOS DADOS
WHERE YEAR(OCO.data_hora_fato) = 2024  -- FILTRA OS DADOS PARA OCORRÊNCIAS DO ANO 2024
  AND OCO.relator_sigla_orgao = 'PM' -- APENAS OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
  AND OCO.descricao_estado = 'FECHADO' -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
  AND OCO.ocorrencia_uf = 'MG' -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- EXCLUI CERTOS TIPOS DE RELATÓRIOS
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- FILTRA PELOS CÓDIGOS DE ENVOLVIMENTO
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- EXCLUI CONDIÇÕES FÍSICAS 
   -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO.
-- AGRUPAMENTO DOS DADOS PARA ESTRUTURAR OS RESULTADOS
GROUP BY OCO.digitador_matricula, N1, N2, N3
-- ORDENAÇÃO DOS RESULTADOS PELA HIERARQUIA DA UNIDADE
ORDER BY N1, N2, N3
