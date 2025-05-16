/*﻿----------------------------------------------------------------------------------------------------------------------
Este código SQL foi desenvolvido para fornecer uma análise detalhada das ocorrências policiais registradas por 
municípios em Minas Gerais de 2020 a 2025. Ele permite visualizar a evolução anual das ocorrências policiais, 
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
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2022 THEN OCO.numero_ocorrencia END) AS '2022',  -- CONTADOR DE OCORRÊNCIAS EM 2022 
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2023 THEN OCO.numero_ocorrencia END) AS '2023',  -- CONTADOR DE OCORRÊNCIAS EM 2022 
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2024 THEN OCO.numero_ocorrencia END) AS '2024',  -- CONTADOR DE OCORRÊNCIAS EM 2022 
    COUNT(DISTINCT CASE WHEN YEAR(OCO.data_hora_fato) = 2025 THEN OCO.numero_ocorrencia END) AS '2025'  -- CONTADOR DE OCORRÊNCIAS EM 2022 
   FROM db_bisp_reds_reporting.tb_ocorrencia OCO  -- TABELA DE OCORRÊNCIAS COM ALIÁS "OCO"
   LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg LO ON OCO.id_local = LO.id_local
WHERE 1=1 -- Filtro sempre verdadeiro, usado como ponto de partida para adicionar condições subsequentes
AND OCO.data_hora_fato BETWEEN '2020-01-01 00:00:00.000' AND '2025-04-30 23:59:59.000' -- Filtra ocorrências por período específico (todo o ano de 2024 até fevereiro/2025)
AND OCO.nome_tipo_relatorio IN ('POLICIAL', 'REFAP', 'TRANSITO')  -- FILTRA TIPOS ESPECÍFICOS DE RELATÓRIOS
AND (SUBSTRING(OCO.natureza_codigo, 1, 1) IN ('B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'T')  -- FILTRA OCORRÊNCIAS POR CÓDIGOS DE NATUREZA ESPECÍFICOS
	 AND OCO.natureza_codigo NOT IN ('T00007', 'T00008', 'T00009', 'T10161', 'T99000')  )-- EXCLUI CÓDIGOS DE NATUREZA ESPECÍFICOS'
AND OCO.digitador_id_orgao IN (0, 1) -- Filtra registros digitados por órgãos (PM, PC)
AND OCO.ind_estado = 'F' -- Filtra ocorrências onde o estado é fechado
AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  -- AND OCO.unidade_area_militar_nome LIKE '%x BPM/x RPM%' -- Filtra pelo nome da unidade área militar
	-- AND OCO.unidade_responsavel_registro_nome LIKE '%xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	-- AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.
GROUP BY OCO.codigo_municipio, OCO.nome_municipio -- AGRUPAMENTO DOS RESULTADOS 
ORDER BY '2020' DESC, '2021' DESC, '2022' DESC, '2023' DESC, '2024' DESC, '2025' DESC -- ORDENAMENT
