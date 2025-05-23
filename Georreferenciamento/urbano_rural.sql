SELECT -- Colunas que deseja inserir na saida
    oco.numero_ocorrencia,
    oco.codigo_tipo_ocorrencia,
    oco.nome_tipo_relatorio, 
    oco.numero_latitude,					--latitude original SAD69
    oco.numero_longitude,					--longitude original SAD69
    geo.latitude_sirgas2000,				-- reprojeção da latitude de SAD69 para SIRGAS2000
    geo.longitude_sirgas2000,				-- reprojeção da longitude de SAD69 para SIRGAS2000
  	geo.setor_codigo,						-- codigo do Setor Censitário no IBGE
	geo.situacao_zona, 						-- se o território é Urbano ou Rural segundo o IBGE
    ibge.tipo_descricao, 					-- se o território é Favela segundo o IBGE
    mub.codigo_espacial_pm AS setor_PM		-- articulação SETORPM conforme Setor IBGE
    
FROM
    db_bisp_reds_reporting.tb_ocorrencia AS oco -- Tabela principal que servirá de base
LEFT JOIN
    db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo -- Tabela de apoio que compara as lat/long com os setores IBGE
    ON oco.numero_ocorrencia = geo.numero_ocorrencia
--    AND oco.ocorrencia_uf = 'MG'							-- ignora os registros de fora de MG, para evitar erro
LEFT JOIN
    db_bisp_shared.tb_ibge_setores_geodata AS ibge			-- Tabela de secundaria com dados gerais do IBGE inclusive se o território é Favela
    ON geo.setor_codigo = ibge.setor_codigo
LEFT JOIN
    db_bisp_shared.tb_pmmg_setores_geodata AS mub			-- Tabela de secundaria com dados do GeoPM MUB compatilizados com a malha censitária
    ON geo.setor_codigo = mub.setor_codigo

WHERE
	oco.ocorrencia_uf ='MG' -- FILTRA OCORRENCIAS EM MINAS GERAIS 
	AND oco.data_hora_inclusao >= '2025-01-01 00:00:00'			-- Filtro de data inicial
    AND oco.data_hora_inclusao < '2025-02-01 00:00:00' 			-- Filtro de data final
    --AND (oco.unidade_area_militar_nome LIKE '%/XX RPM%') 		-- Filtro pela Unide de Área Militar (CIA/BPM/RPM)
   -- AND oco.nome_municipio = 'XXX' 							-- Filtro pelo Município

ORDER BY  oco.numero_ocorrencia DESC
; 
