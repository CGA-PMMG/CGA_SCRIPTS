/*﻿----------------------------------------------------------------------------------------------------------------------
Este código SQL foi desenvolvido para fornecer uma análise detalhada das ocorrências policiais registradas por 
municípios em Minas Gerais de 2020 a 2022. Ele permite visualizar a evolução anual das ocorrências policiais, 
oferecendo insights sobre tendências e variações no volume de casos ao longo do tempo.
Os dados são filtrados para incluir apenas ocorrências fechadas e específicas por tipo de relatório e natureza da 
ocorrência, garantindo que a análise seja relevante para avaliações de eficácia policial e planejamento de segurança pública. 
As ocorrências são categorizadas por município, facilitando análises regionais e suporte na alocação de recursos 
e iniciativas de prevenção ao crime. 
﻿-- --------------------------------------------------------------------------------------------------------------------*/
SELECT  
    OCO.codigo_municipio, -- CÓDIGO DO MUNICÍPIO
    OCO.nome_municipio,    -- NOME DO MUNICÍPIO
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2020 THEN OCO.numero_ocorrencia END) AS '2020', -- CONTADOR DE OCORRÊNCIAS EM 2020
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2021 THEN OCO.numero_ocorrencia END) AS '2021', -- CONTADOR DE OCORRÊNCIAS EM 2021
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2022 THEN OCO.numero_ocorrencia END) AS '2022'  -- CONTADOR DE OCORRÊNCIAS EM 2022 
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
WHERE 
    YEAR(OCO.data_hora_fato) BETWEEN 2020 AND 2022 -- FILTRA PERIODO
    AND OCO.ind_estado = 'F'  -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
    AND OCO.ocorrencia_uf = 'MG'  -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND (OCO.relator_sigla_orgao = 'PM' OR OCO.relator_sigla_orgao = 'PC')  -- OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR OU CIVIL
    AND (OCO.nome_tipo_relatorio IN ('POLICIAL', 'REFAP', 'TRANSITO'))  -- FILTRA TIPOS ESPECÍFICOS DE RELATÓRIOS
    AND (SUBSTRING(OCO.natureza_codigo, 1, 1) IN ('B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'T'))  -- FILTRA OCORRÊNCIAS POR CÓDIGOS DE NATUREZA ESPECÍFICOS
    AND OCO.natureza_codigo NOT IN ('T00007', 'T00008', 'T00009', 'T10161', 'T99000')  -- EXCLUI CÓDIGOS DE NATUREZA ESPECÍFICOS
 -- AND db_bisp_reds_reporting.OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/ RPM 
 -- AND db_bisp_reds_reporting.OCO.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 
GROUP BY OCO.codigo_municipio, OCO.nome_municipio -- AGRUPAMENTO DOS RESULTADOS 
ORDER BY '2020' DESC, '2021' DESC, '2022' DESC -- ORDENAMENTO DOS RESULTADOS
