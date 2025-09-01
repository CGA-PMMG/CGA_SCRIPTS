WITH 
AGUAS AS (
SELECT '310800810000009' AS setor_codigo, 'Rural'  AS zona_agua UNION ALL
    SELECT '311440205000086', 'Rural'  UNION ALL
    SELECT '312520005000014', 'Rural'  UNION ALL
    SELECT '312570510000021', 'Rural'  UNION ALL
    SELECT '312610910000009', 'Rural'  UNION ALL
    SELECT '315180005000418', 'Rural'  UNION ALL
    SELECT '315430905000031', 'Urbana' UNION ALL
    SELECT '315690810000020', 'Rural'  UNION ALL
    SELECT '316225205000015', 'Urbana' UNION ALL
    SELECT '316720205010026', 'Urbana' UNION ALL
    SELECT '316935605000093', 'Urbana' UNION ALL
    SELECT '310160705000238', 'Rural'  UNION ALL
    SELECT '310160705000241', 'Rural'  UNION ALL
    SELECT '310430405000063', 'Rural'  UNION ALL
    SELECT '310430405000071', 'Rural'  UNION ALL
    SELECT '311130905000043', 'Rural'  UNION ALL
    SELECT '311860105280029', 'Urbana' UNION ALL
    SELECT '312570508000008', 'Rural'  UNION ALL
    SELECT '312700805000039', 'Urbana' UNION ALL
    SELECT '313760105000244', 'Urbana' UNION ALL
    SELECT '314330205000733', 'Urbana' UNION ALL
    SELECT '314350005000030', 'Rural'  UNION ALL
    SELECT '315050510000006', 'Rural'  UNION ALL
    SELECT '316720205010022', 'Urbana' UNION ALL
    SELECT '310160710000006', 'Rural'  UNION ALL
    SELECT '310430405000056', 'Rural'  UNION ALL
    SELECT '310430405000058', 'Rural'  UNION ALL
    SELECT '310430405000065', 'Rural'  UNION ALL
    SELECT '310710905000056', 'Rural'  UNION ALL
    SELECT '314990305000064', 'Rural'  UNION ALL
    SELECT '316130405000021', 'Rural'  UNION ALL
    SELECT '316935610000016', 'Rural'  UNION ALL
    SELECT '310110205000035', 'Urbana' UNION ALL
    SELECT '312520005000012', 'Rural'  UNION ALL
    SELECT '312710705000131', 'Rural'  UNION ALL
    SELECT '313115805000020', 'Urbana' UNION ALL
    SELECT '314350010000007', 'Rural'  UNION ALL
    SELECT '316250030000015', 'Rural'  UNION ALL
    SELECT '316720205020024', 'Urbana' UNION ALL
    SELECT '310070805000015', 'Rural'  UNION ALL
    SELECT '312700805000037', 'Rural'  UNION ALL
    SELECT '312700820000008', 'Urbana' UNION ALL
    SELECT '313000205000017', 'Rural'  UNION ALL
    SELECT '313450905000031', 'Urbana' UNION ALL
    SELECT '314460720000006', 'Rural'  UNION ALL
    SELECT '315180005000419', 'Rural'  UNION ALL
    SELECT '310430405000068', 'Rural'  UNION ALL
    SELECT '310670505090031', 'Urbana' UNION ALL
    SELECT '311160605000065', 'Rural'  UNION ALL
    SELECT '311160610000011', 'Rural'  UNION ALL
    SELECT '311460005000033', 'Rural'  UNION ALL
    SELECT '312070605000007', 'Urbana' UNION ALL
    SELECT '312570505000047', 'Rural'  UNION ALL
    SELECT '316250010000008', 'Rural'  UNION ALL
    SELECT '311440210000014', 'Rural'  UNION ALL
    SELECT '312570510000030', 'Rural'  UNION ALL
    SELECT '312610925000020', 'Rural'  UNION ALL
    SELECT '313040805000023', 'Rural'  UNION ALL
    SELECT '313430120000010', 'Rural'  UNION ALL
    SELECT '313450905000023', 'Rural'  UNION ALL
    SELECT '313820305000223', 'Rural'  UNION ALL
    SELECT '315050505000027', 'Rural'  UNION ALL
    SELECT '315160205000036', 'Rural'  UNION ALL
    SELECT '317010705000100', 'Rural'
) -- !!!!!  ESTA CTE NÃO DEVE SER ALTERADA !!!!!
SELECT -- Colunas que deseja inserir na saida
    oco.numero_ocorrencia, --Seleciona o número da ocorrência
    oco.nome_tipo_relatorio, -- Seleciona o nome do tipo do relatório
    oco.codigo_tipo_ocorrencia, -- Seleciona o código do tipo da ocorrência
    oco.ocorrencia_uf,   -- Seleciona a UF da ocorrência
    oco.numero_latitude,					-- Seleciona o número  latitude
    oco.numero_longitude,					-- Seleciona o número longitude
    oco.descricao_localizacao_ocorrencia,	-- Seleciona a descrição da localização da ocorrência
    geo.latitude_sirgas2000,				-- Seleciona o número da latitude SIRGAS2000
    geo.longitude_sirgas2000,				-- Seleciona o número da longitude SIRGAS2000
    CASE 													--  Case when para retornar se a ocorrência é no Estado de Minas Gerais, cao não seja, retorna 'Outra_UF'
    	WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF' 		
    	ELSE geo.setor_codigo
	END AS setor_codigo,						 
CASE 																			-- se o território é Urbano ou Rural segundo o IBGE
    	WHEN oco.pais_codigo <> 1 AND oco.ocorrencia_uf IS NULL THEN 'Outro_Pais'  	-- trata erro - ocorrencia de fora do Brasil
		WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF'								-- trata erro - ocorrencia de fora de MG
    	WHEN oco.numero_latitude IS NULL THEN 'Invalido'							-- trata erro - ocorrencia sem latitude
        WHEN geo.situacao_codigo = 9 THEN AG.zona_agua									-- trata erro - ocorrencia dentro de curso d'água
       	WHEN geo.situacao_zona IS NULL THEN 'Erro_Processamento'					-- checa se restou alguma ocorrencia com erro
    	ELSE geo.situacao_zona
    END AS situacao_zona,                 							
    ibge.tipo_descricao, 					-- Seleciona a descrição do território segundo o IBGE 
    oco.unidade_area_militar_nome,			-- Seleciona o nome da unidade de área militar
    MUB.udi,								-- Seleciona a articulação RPM conforme Setor 
    MUB.ueop,								-- Seleciona a articulação BPM conforme Setor 
    MUB.cia,								-- Seleciona a articulação CIA conforme Setor 
    MUB.codigo_espacial_pm AS setor_PM		-- Seleciona a articulação SETOR PM conforme Setor     
FROM db_bisp_reds_reporting.tb_ocorrencia AS oco -- Tabela principal que servirá de base
 LEFT JOIN db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo ON oco.numero_ocorrencia = geo.numero_ocorrencia AND oco.ocorrencia_uf = 'MG'							-- Tabela de apoio que compara as lat/long com os setores IBGE -- ignora os registros de fora de MG, para evitar erro
 LEFT JOIN db_bisp_shared.tb_ibge_setores_geodata AS ibge ON geo.setor_codigo = ibge.setor_codigo -- Tabela de secundaria com dados gerais do IBGE inclusive se o território é Favela
 LEFT JOIN db_bisp_shared.tb_pmmg_setores_geodata AS MUB	 ON geo.setor_codigo = MUB.setor_codigo-- Tabela de secundaria com dados do GeoPM MUB compatilizados com a malha censitária
 LEFT JOIN AGUAS AG ON geo.setor_codigo = AG.setor_codigo
 WHERE 1 = 1
   AND  oco.data_hora_inclusao BETWEEN '2025-01-01 00:00:00' AND  '2025-06-01 00:00:00' 	-- 	Filtra a data hora da inclusão dentro do intervalo especificado
   AND oco.codigo_tipo_ocorrencia IN ('0', '1', '2', '3', '8', '11', '12', '13'	) 	-- Somente os tipos de formulário de interesse da PMMG
ORDER BY  oco.numero_ocorrencia DESC; 
