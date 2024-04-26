/*﻿-- --------------------------------------------------------------------------------------------------------------------

Este código SQL foi desenvolvido para fornecer uma análise detalhada das ocorrências policiais registradas por 
municípios em Minas Gerais de 2020 a 2022. Ele permite visualizar a evolução anual das ocorrências policiais, 
oferecendo insights sobre tendências e variações no volume de casos ao longo do tempo.

Os dados são filtrados para incluir apenas ocorrências fechadas e específicas por tipo de relatório e natureza da 
ocorrência, garantindo que a análise seja relevante para avaliações de eficácia policial e planejamento de segurança pública. 
As ocorrências são categorizadas por município, facilitando análises regionais e suporte na alocação de recursos 
e iniciativas de prevenção ao crime. 
﻿-- --------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE DADOS E CONTAGEM DE OCORRÊNCIAS POR ANO E MUNICÍPIO
SELECT  
    -- CÓDIGO E NOME DO MUNICÍPIO ONDE A OCORRÊNCIA FOI REGISTRADA
    tb_ocorrencia.codigo_municipio, 
    tb_ocorrencia.nome_municipio,     
    -- CONTAGEM DE OCORRÊNCIAS POR ANO UTILIZANDO CASE STATEMENTS PARA FILTRAR CADA ANO ESPECÍFICO
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2020 THEN tb_ocorrencia.numero_ocorrencia END) AS '2020',
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2021 THEN tb_ocorrencia.numero_ocorrencia END) AS '2021',
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2022 THEN tb_ocorrencia.numero_ocorrencia END) AS '2022'    
-- TABELA DE ONDE OS DADOS SÃO EXTRAÍDOS
FROM db_bisp_reds_reporting.tb_ocorrencia
-- CONDIÇÕES PARA SELEÇÃO DE DADOS
WHERE 
    YEAR(tb_ocorrencia.data_hora_fato) BETWEEN 2020 AND 2022
    AND tb_ocorrencia.ind_estado = 'F'  -- FILTRA OCORRÊNCIAS QUE ESTÃO FECHADAS
    AND tb_ocorrencia.ocorrencia_uf = 'MG'  -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND (tb_ocorrencia.relator_sigla_orgao = 'PM' OR tb_ocorrencia.relator_sigla_orgao = 'PC')  -- OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR OU CIVIL
    AND (tb_ocorrencia.nome_tipo_relatorio IN ('POLICIAL', 'REFAP', 'TRANSITO'))  -- FILTRA TIPOS ESPECÍFICOS DE RELATÓRIOS
    AND (SUBSTRING(tb_ocorrencia.natureza_codigo, 1, 1) IN ('B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'T'))  -- FILTRA OCORRÊNCIAS POR CÓDIGOS DE NATUREZA ESPECÍFICOS
    AND tb_ocorrencia.natureza_codigo NOT IN ('T00007', 'T00008', 'T00009', 'T10161', 'T99000')  -- EXCLUI CÓDIGOS DE NATUREZA ESPECÍFICOS
 -- AND db_bisp_reds_reporting.tb_ocorrencia.unidade_area_militar_nome LIKE '%1 BPM/1 RPM%' -- FILTRE SUA BPM/ RPM 
 -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 
    -- AGRUPAMENTO DOS RESULTADOS PELO CÓDIGO E NOME DO MUNICÍPIO PARA CONSOLIDAR OS DADOS
GROUP BY tb_ocorrencia.codigo_municipio, tb_ocorrencia.nome_municipio;
-- ORDENAMENTO DOS RESULTADOS (OPCIONAL)
ORDER BY '2020' DESC, '2021' DESC, '2022' DESC;