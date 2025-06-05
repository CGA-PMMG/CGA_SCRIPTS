SELECT -- Colunas que deseja inserir na saida
    oco.numero_ocorrencia,
    oco.nome_tipo_relatorio,
    oco.ocorrencia_uf,
    oco.numero_latitude,					--latitude original SAD69
    oco.numero_longitude,					--longitude original SAD69
    oco.descricao_localizacao_ocorrencia,	-- campo parametrizado RURAL preenchido pelo usuário
    geo.latitude_sirgas2000,				-- reprojeção da latitude de SAD69 para SIRGAS2000
    geo.longitude_sirgas2000,				-- reprojeção da longitude de SAD69 para SIRGAS2000
    CASE 													-- codigo do Setor Censitário no IBGE
    	WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF' 		-- ignora ocorrencias de fora de MG
    	ELSE geo.setor_codigo
	END AS setor_codigo,						 
	CASE 																			-- se o território é Urbano ou Rural segundo o IBGE
    	WHEN oco.pais_codigo <> 1 AND oco.ocorrencia_uf IS NULL THEN 'Outro_Pais'  	-- trata erro - ocorrencia de fora do Brasil
		WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF'								-- trata erro - ocorrencia de fora de MG
    	WHEN oco.numero_latitude IS NULL THEN 'Invalido'							-- trata erro - ocorrencia sem latitude
        WHEN geo.situacao_codigo = 9 THEN 'Agua'									-- trata erro - ocorrencia dentro de curso d'água
       	WHEN geo.situacao_zona IS NULL THEN 'Erro_Processamento'					-- checa se restou alguma ocorrencia com erro
    	ELSE geo.situacao_zona
    END AS situacao_zona,                  							
    ibge.tipo_descricao, 					-- se o território é Favela segundo o IBGE
    oco.unidade_area_militar_nome,			-- artigulação PMMG conforme GeoMUB
    MUB.udi,								-- articulação RPM conforme Setor IBGE
    MUB.ueop,								-- articulação BPM conforme Setor IBGE
    MUB.cia,								-- articulação CIA conforme Setor IBGE
    MUB.codigo_espacial_pm AS setor_PM		-- articulação SETORPM conforme Setor IBGE    
FROM
    db_bisp_reds_reporting.tb_ocorrencia AS oco -- Tabela principal que servirá de base
LEFT JOIN
    db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo -- Tabela de apoio que compara as lat/long com os setores IBGE
    ON oco.numero_ocorrencia = geo.numero_ocorrencia
    AND oco.ocorrencia_uf = 'MG'							-- ignora os registros de fora de MG, para evitar erro
LEFT JOIN
    db_bisp_shared.tb_ibge_setores_geodata AS ibge			-- Tabela de secundaria com dados gerais do IBGE inclusive se o território é Favela
    ON geo.setor_codigo = ibge.setor_codigo
LEFT JOIN
    db_bisp_shared.tb_pmmg_setores_geodata AS MUB			-- Tabela de secundaria com dados do GeoPM MUB compatilizados com a malha censitária
    ON geo.setor_codigo = MUB.setor_codigo
WHERE
    oco.data_hora_inclusao >= '2025-01-01 00:00:00'			-- Filtro de data inicial
    AND oco.data_hora_inclusao < '2025-06-01 00:00:00' 		-- Filtro de data final
   AND oco.codigo_tipo_ocorrencia IN (					-- Somente os tipos de formulário de interesse da PMMG
        '0', 		-- BOLETIM DE OCORRÊNCIA POLICIAL
        '1', 		-- BOLETIM DE OCORRÊNCIA DE ACIDENTE DE TRÂNSITO
        '2',		-- BOLETIM DE OCORRÊNCIA AMBIENTAL
        '3',		-- REFAP 
        '8', 		-- DESAPARECIMENTO / LOCALIZAÇÃO DE PESSOAS
        '11',		-- RAT
        '12', 		-- BOS
        '13'		-- BOS AMPLO
    )
ORDER BY  oco.numero_ocorrencia DESC
;
