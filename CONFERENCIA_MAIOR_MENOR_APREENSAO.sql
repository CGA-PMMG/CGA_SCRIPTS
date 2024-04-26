/*-------------------------------------------------------------------------------------------------------------------
 * Esse código proporciona uma visão detalhada das ocorrências da PMMG por faixa etária e unidade operacional,
 * o que pode ser crucial para análises estratégicas e de desempenho das unidades. Ele foi estruturado para 
 * facilitar modificações, como filtrar por unidades específicas ou ajustar o intervalo de idades conforme necessário.
 -------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DOS CAMPOS RELEVANTES, INCLUINDO NÚMERO DA OCORRÊNCIA, ANO DA OCORRÊNCIA, ANO DE NASCIMENTO DO ENVOLVIDO E ATRIBUIÇÃO DA UNIDADE OPERACIONAL BASEADA NO CÓDIGO DO MUNICÍPIO
SELECT  
    OCO.numero_ocorrencia,
    YEAR(OCO.data_hora_fato),
    YEAR(ENV.data_nascimento),
    ((YEAR(ENV.data_hora_fato)) - (YEAR(ENV.data_nascimento))) AS IDADE, -- CALCULO DA IDADE BASEADO NA DIFERENÇA ENTRE O ANO DO FATO E O ANO DE NASCIMENTO DO ENVOLVIDO
    OCO.unidade_area_militar_nome
-- ESPECIFICAÇÃO DAS TABELAS E A CONDIÇÃO DE JUNÇÃO
FROM 
    tb_ocorrencia OCO
    INNER JOIN tb_envolvido_ocorrencia ENV ON OCO.numero_ocorrencia = ENV.numero_ocorrencia 
-- FILTROS PARA LIMITAR OS RESULTADOS ÀS OCORRÊNCIAS DE INTERESSE
WHERE 
    YEAR(OCO.data_hora_fato) = 2024
    AND OCO.DIGITADOR_SIGLA_ORGAO = 'PM'
    AND OCO.ocorrencia_uf = 'MG'
    AND OCO.descricao_estado = 'FECHADO'
    AND tipo_prisao_apreensao_codigo IN ('9900', '0400', '0100', '0300', '0600', '0200')
  --AND OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%'-- FILTRE SUA CIA/BM/RPM
-- ORDENAÇÃO DOS RESULTADOS PELA IDADE DOS ENVOLVIDOS PARA FACILITAR ANÁLISES DEMOGRÁFICAS
ORDER BY IDADE;
ORDER BY 4
