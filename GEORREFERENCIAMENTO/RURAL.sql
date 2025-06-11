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
	CASE 																			-- Case when para retornar se o território é Urbano ou Rural segundo o IBGE
    	WHEN oco.pais_codigo <> 1 AND oco.ocorrencia_uf IS NULL THEN 'Outro_Pais'  	-- Trata erro - ocorrência de fora do Brasil
		WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF'								-- Trata erro - ocorrência de fora de MG
    	WHEN oco.numero_latitude IS NULL THEN 'Invalido'							-- Trata erro - ocorrência sem latitude
        WHEN geo.situacao_codigo = 9 THEN 'Agua'									-- Trata erro - ocorrência dentro de curso d'água
       	WHEN geo.situacao_zona IS NULL THEN 'Erro_Processamento'					-- Checa se restou alguma ocorrencia com erro, se sim, retorna 'Erro_Processamento'
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
 WHERE 1 = 1
   AND  oco.data_hora_inclusao BETWEEN '2025-01-01 00:00:00' AND  '2025-06-01 00:00:00' 	-- 	Filtra a data hora da inclusão dentro do intervalo especificado
   AND oco.codigo_tipo_ocorrencia IN ('0', '1', '2', '3', '8', '11', '12', '13'	) 	-- Somente os tipos de formulário de interesse da PMMG
ORDER BY  oco.numero_ocorrencia DESC; 

