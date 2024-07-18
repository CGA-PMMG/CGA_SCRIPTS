 /*---------------------------------------------------------------------------------------------------------------------
  * Este código SQL tem como objetivo calcular e apresentar informações detalhadas sobre o total de envolvidos nas 
  * ocorrências registradas pela Polícia Militar de Minas Gerais no ano de 2024 e, mais especificamente, quantificar 
  * quantos desses registros estão sem CPF ou CNPJ informado. O foco é analisar ocorrências fechadas e filtrar por diversos 
  * critérios para garantir a relevância e precisão dos dados, especialmente visando a clareza na identificação das unidades 
  * responsáveis pelas ocorrências (RPM, BPM e CIA) e garantindo que os dados sejam apresentados de forma organizada
  * e hierárquica.
  ---------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS PARA IDENTIFICAÇÃO DO DIGITADOR E A UNIDADE RESPONSÁVEL
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- EXTRAI A MATRÍCULA DO DIGITADOR RESPONSÁVEL PELO REGISTRO
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI O ÚLTIMO SEGMENTO PARA IDENTIFICAR A RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI O PENÚLTIMO SEGMENTO PARA IDENTIFICAR O BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO PARA IDENTIFICAR A CIA
    COUNT(ENV.numero_envolvido) AS TOTAL_ENVOLVIDOS, -- CONTA O TOTAL DE ENVOLVIDOS NAS OCORRÊNCIAS
    SUM(CASE 
        WHEN ENV.numero_cpf_cnpj IS NULL  -- CALCULA QUANTOS REGISTROS NÃO POSSUEM CPF/CNPJ INFORMADO
        THEN 1 ELSE 0 
        END) AS Qtd_Null
-- TABELAS E JUNÇÕES UTILIZADAS PARA A CONSULTA
FROM tb_ocorrencia OCO
JOIN tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO DAS TABELAS DE OCORRÊNCIA E ENVOLVIDOS
-- FILTROS APLICADOS PARA A SELEÇÃO DOS DADOS
WHERE YEAR(ENV.data_hora_fato) = 2024  -- FILTRA OS DADOS PARA OCORRÊNCIAS DO ANO 2024
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- FILTRA PELOS CÓDIGOS DE ENVOLVIMENTO. APENAS VITIMAS.
  AND OCO.relator_sigla_orgao = 'PM' -- APENAS OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
  AND OCO.descricao_estado = 'FECHADO' -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- EXCLUI CERTAS CONDIÇÕES FÍSICAS 
  AND OCO.ocorrencia_uf = 'MG' -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- EXCLUI CERTOS TIPOS DE RELATÓRIOS
 -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO.
-- AGRUPAMENTO DOS DADOS PARA ESTRUTURAR OS RESULTADOS
GROUP BY MATRICULA_DIGITADOR, RPM, BPM, CIA
-- ORDENAÇÃO DOS RESULTADOS PELA HIERARQUIA DA UNIDADE
ORDER BY RPM, BPM, CIA
