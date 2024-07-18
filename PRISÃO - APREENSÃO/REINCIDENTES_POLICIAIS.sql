/*-- ------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL é projetado para identificar indivíduos reincidindo em diversos tipos de crimes, com base em registros 
 * documentados pela polícia entre 2023 e 2024. A consulta é realizada nas tabelas de ocorrências e envolvidos, filtrando por 
 * tipos específicos de naturezas de crime e garantindo que os envolvidos tenham informações pessoais completas.
      Os resultados incluem o nome completo, nome da mãe, data de nascimento do envolvido, e listas consolidadas de 
       códigos e descrições das naturezas das ocorrências em que eles estiveram envolvidos, facilitando uma análise detalhada
       de padrões de reincidência entre os envolvidos. Isso é particularmente útil para análises criminológicas, planejamento 
       de prevenção de crimes, e estratégias de intervenção baseadas em evidências de reincidência.
 -- ------------------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE DADOS PESSOAIS E REGISTROS DE OCORRÊNCIAS DOS ENVOLVIDOS
SELECT 
    ENV.nome_completo_envolvido,  -- NOME COMPLETO DO ENVOLVIDO
    ENV.nome_mae,  -- NOME DA MÃE DO ENVOLVIDO
    ENV.data_nascimento,  -- DATA DE NASCIMENTO DO ENVOLVIDO
    COUNT(DISTINCT OCO.numero_ocorrencia) AS REINCIDENCIA,  -- CONTAGEM DE OCORRÊNCIAS DISTINTAS PARA MEDIR REINCIDÊNCIA
    GROUP_CONCAT(DISTINCT OCO.natureza_codigo) AS Naturezas_codigo,  -- LISTA DE CÓDIGOS DE NATUREZA DAS OCORRÊNCIAS
    GROUP_CONCAT(DISTINCT OCO.natureza_descricao) AS Naturezas_descricao  -- LISTA DE DESCRIÇÕES DE NATUREZA DAS OCORRÊNCIAS
-- TABELAS UTILIZADAS NA CONSULTA E JUNÇÕES
FROM tb_ocorrencia OCO 
INNER JOIN tb_envolvido_ocorrencia ENV 
   ON (ENV.numero_ocorrencia = OCO.numero_ocorrencia)  -- JUNÇÃO PARA ASSOCIAR ENVOLVIDOS ÀS OCORRÊNCIAS
-- FILTROS PARA SELEÇÃO DE DADOS
WHERE OCO.natureza_codigo IN ('B01121','B01148','B01149','B01147','C01155','C01157','C01159','D01213','D01217','E01250','I04033')  -- FILTRA POR CÓDIGOS ESPECÍFICOS DE NATUREZA DE CRIME
AND YEAR(OCO.data_hora_fato) BETWEEN 2023 AND 2024  -- SELEÇÃO DE OCORRÊNCIAS ENTRE 2023 E 2024
AND ENV.envolvimento_codigo IN ('0100', '0200', '1100')  -- FILTRA POR CÓDIGOS DE ENVOLVIMENTO (AUTOR, CO-AUTOR, SUSPEITO)
AND (ENV.nome_completo_envolvido IS NOT NULL AND ENV.nome_mae IS NOT NULL AND ENV.data_nascimento IS NOT NULL)  -- EXIGE QUE INFORMAÇÕES PESSOAIS ESSENCIAIS NÃO SEJAM NULAS
-- AND OCO.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
-- GRUPO PARA AGRUPAR RESULTADOS POR INDIVÍDUO
GROUP BY 
    ENV.nome_completo_envolvido, 
    ENV.nome_mae,
    ENV.data_nascimento 
-- CONDIÇÃO PARA FILTRAR REINCIDENTES
HAVING 
    (COUNT(DISTINCT OCO.numero_ocorrencia) > 1)  -- SELECIONA APENAS INDIVÍDUOS COM MAIS DE UMA OCORRÊNCIA REGISTRADA
