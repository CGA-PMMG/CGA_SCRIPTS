/*﻿----------------------------------------------------------------------------------------------------------------------------------------
 * O código SQL tem como objetivo extrair informações detalhadas sobre ocorrências registradas pela Polícia Militar de Minas Gerais. 
 * O código realiza uma análise detalhada 
 * que inclui:
--Identificação do Digitador: Mostra a matrícula do funcionário que digitou o registro da ocorrência.
--Unidades da Polícia Militar: Desdobra o nome da unidade responsável pelo registro da ocorrência em três níveis hierárquicos: 
Região de Polícia Militar (RPM), Batalhão de Polícia Militar (BPM) e Companhia (CIA).
--Total de Envolvidos: Conta quantas pessoas estão envolvidas em cada ocorrência.
--Análise de Estado Civil: Calcula quantos envolvidos possuem o estado civil não especificado, ou registrado como '9800' ou '9700', 
que representam dados incompletos.

Os filtros aplicados garantem que apenas os dados das ocorrências do ano de 2024 sejam considerados, além de aplicar critérios específicos como:
Apenas ocorrências que estão fechadas.
Exclusão de determinados tipos de condições físicas dos envolvidos.
Exclusão de certos tipos de relatórios.

O resultado final é agrupado por matrícula do digitador e por unidade da PM, ordenado de forma hierárquica por RPM, BPM e CIA.
Isso fornece uma visão clara e organizada sobre o volume e características das ocorrências em diferentes níveis da estrutura 
organizacional da Polícia Militar, focando especialmente no 1º BPM.
﻿----------------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE COLUNAS ESPECÍFICAS DA TABELA DE OCORRÊNCIAS E ENVOLVIDOS
SELECT
   
    OCO.digitador_matricula AS MATRICULA_DIGITADOR,  -- EXTRAI A MATRÍCULA DO DIGITADOR DA OCORRÊNCIA
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI A UNIDADE RPM (ÚLTIMO ELEMENTO DO NOME DA UNIDADE SEPARADO POR '/') 
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI A UNIDADE BPM (PENÚLTIMO ELEMENTO DO NOME DA UNIDADE SEPARADO POR '/')
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI A UNIDADE CIA (ANTEPENÚLTIMO ELEMENTO DO NOME DA UNIDADE SEPARADO POR '/') 
    COUNT(ENV.numero_envolvido) AS TOTAL_ENVOLVIDOS, -- CONTA O NÚMERO TOTAL DE ENVOLVIDOS NA OCORRÊNCIA  
    SUM(CASE 
        WHEN ENV.estado_civil_codigo IS NULL OR ENV.estado_civil_codigo IN ('9800','9700') 
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800_9700 -- CALCULA A QUANTIDADE DE REGISTROS COM CÓDIGO DE ESTADO CIVIL NULO, '9800' OU '9700'
-- TABELAS DE ONDE OS DADOS SERÃO EXTRAÍDOS
FROM tb_ocorrencia OCO
JOIN tb_envolvido_ocorrencia ENV
   ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO DAS TABELAS POR NÚMERO DA OCORRÊNCIA
-- CONDIÇÕES PARA A SELEÇÃO DOS DADOS
WHERE YEAR(ENV.data_hora_fato) = 2024  -- APENAS OCORRÊNCIAS DO ANO DE 2024
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- FILTRO DE CÓDIGOS DE ENVOLVIMENTO, APENAS VITIMAS
  AND OCO.relator_sigla_orgao = 'PM' -- OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
  AND OCO.descricao_estado = 'FECHADO' -- APENAS OCORRÊNCIAS QUE ESTÃO FECHADAS
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100')  -- EXCLUI CONDIÇÕES FÍSICAS ESPECÍFICAS
  AND OCO.ocorrencia_uf = 'MG' -- OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
  AND OCO.nome_tipo_relatorio NOT IN('RAT','BOS','BOS AMPLO') -- EXCLUI TIPOS DE RELATÓRIOS ESPECÍFICOS
--AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- FILTRA OCORRÊNCIAS RELACIONADAS A UNIDADE DE REGISTRO. 
-- AGRUPAMENTO DOS RESULTADOS PARA QUE CADA COMBINAÇÃO ÚNICA DE MATRÍCULA, RPM, BPM, CIA SEJA UMA LINHA
GROUP BY MATRICULA_DIGITADOR, RPM, BPM, CIA
-- ORDENANDO OS RESULTADOS POR RPM, BPM E CIA
ORDER BY RPM, BPM, CIA

