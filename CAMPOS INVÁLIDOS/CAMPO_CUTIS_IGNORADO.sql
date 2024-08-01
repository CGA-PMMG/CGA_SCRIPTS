/*﻿-- ---------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL é projetado para analisar e quantificar os envolvidos em ocorrências registradas pela 
 * Polícia Militar de Minas Gerais no ano de 2024, particularmente identificando quantos registros não possuem informação sobre 
 * a cor da pele ou têm a cor da pele listada como código '9800'(Ignorado). O foco está em analisar dados de ocorrências fechadas, 
 * assegurando uma análise precisa. A consulta também é configurada para exibir resultados agrupados e ordenados com
 *  base na hierarquia das unidades responsáveis.
 ﻿-- ---------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS PARA IDENTIFICAÇÃO DO DIGITADOR E A UNIDADE RESPONSÁVEL
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- EXTRAI A MATRÍCULA DO DIGITADOR RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI O ÚLTIMO SEGMENTO DA UNIDADE 
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI O PENÚLTIMO SEGMENTO DA UNIDADE
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO DA UNIDADE
    COUNT(ENV.numero_envolvido) AS TOTAL_ENVOLVIDO, -- CONTA O TOTAL DE ENVOLVIDOS NAS OCORRÊNCIAS
    SUM(CASE 
        WHEN ENV.cor_pele_codigo IS NULL OR ENV.cor_pele_codigo = '9800' -- VERIFICA A AUSÊNCIA OU CÓDIGO ESPECÍFICO DE COR DE PELE
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800
-- TABELAS E JUNÇÕES UTILIZADAS PARA A CONSULTA
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO DAS TABELAS DE OCORRÊNCIA E ENVOLVIDOS
-- FILTROS APLICADOS PARA A SELEÇÃO DOS DADOS
WHERE YEAR(ENV.data_hora_fato) = 2024  -- FILTRA OS DADOS PARA OCORRÊNCIAS DO ANO 2024
  AND OCO.relator_sigla_orgao = 'PM' -- APENAS OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
  AND OCO.descricao_estado = 'FECHADO' -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
  AND OCO.ocorrencia_uf = 'MG' -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- EXCLUI CERTOS TIPOS DE RELATÓRIOS
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- FILTRA PELOS CÓDIGOS DE ENVOLVIMENTO. APENAS VITIMAS.
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- EXCLUI CERTAS CONDIÇÕES FÍSICAS
   -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO.
-- AGRUPAMENTO DOS DADOS PARA ESTRUTURAR OS RESULTADOS
GROUP BY 1, 2, 3, 4 -- UTILIZA OS ÍNDICES DAS COLUNAS PARA SIMPLIFICAR
-- ORDENAÇÃO DOS RESULTADOS PELA HIERARQUIA DA UNIDADE
ORDER BY 2, 3, 4
