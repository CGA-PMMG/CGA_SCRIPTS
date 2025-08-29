WITH 
 OCORRENCIAS AS (
 SELECT
	numero_ocorrencia
FROM
	db_bisp_reds_reporting.tb_ocorrencia
WHERE
numero_ocorrencia in (
'2029-000001111-001',
'2029-001100110-001',
'2029-010101010-001'
)-- COLOQUE AQUI OS NÚMEROS DE REDS A SEREM TESTADOS
 ),
/*------------------------------------
 
 
 
 
 
******** ATENÇÃO: ********
 
 NÃO ALTERE NADA NO RESTANTE DO CODIGO
 
 
 
 
 
 
 
 --------------------------------------*/
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
),
 BASE AS(
 SELECT 
 DISTINCT 
    tb.REDS,
    oco.numero_ocorrencia as reds_no_historico,
    oco.natureza_codigo,
    oco.complemento_natureza_descricao,
    oco.complemento_natureza_codigo,
    oco.local_imediato_descricao,
    oco.local_imediato_codigo,
    CASE 
    	WHEN natureza_codigo = 'C01155' 
    	AND(
    		((SUBSTRING(oco.local_imediato_codigo , 1, 2) IN ('07', '10', '14', '15', '03')) OR oco.local_imediato_codigo = '0512')
				AND oco.complemento_natureza_codigo IN ('2002', '2004', '2005', '2015')
			) THEN 'VALIDO'
			ELSE 'INVALIDO'
    END AS VALIDO_FURTO_RESIDCOM,
   CASE
   	WHEN natureza_codigo IN ('B01121','B01148','B02001','C01157','C01158','C01159','B01504') 
   	AND  (ENV.condicao_fisica_codigo <> '0100' AND ENV.id_envolvimento IN(25,1097, 27, 32, 28, 26, 872) )   
   	THEN 'VALIDO' ELSE 'INVALIDO'
   	END AS VALIDO_CV   
   FROM db_bisp_reds_reporting.tb_ocorrencia oco
   INNER  JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = oco.numero_ocorrencia   AND ((oco.codigo_municipio = ENV.codigo_municipio) OR ENV.codigo_municipio IS NULL)
  INNER JOIN (
			    			SELECT numero_ocorrencia as REDS, 
			           		       REGEXP_EXTRACT(oco.historico_ocorrencia, '([0-9]{4}-[0-9]{9}-[0-9]{3})', 0) AS BO_HISTORICO
						 	FROM db_bisp_reds_reporting.tb_ocorrencia oco
						 	WHERE 
						    digitador_sigla_orgao = 'PM'
						    AND ocorrencia_uf = 'MG'
						    AND ind_estado IN ('F','R')
						    AND data_hora_fato >= '2025-01-01 00:00:00'
							    AND (
									    (oco.natureza_codigo = 'A20000' AND oco.data_hora_fato BETWEEN '2025-01-01 00:00:00.000' AND '2025-07-31 23:59:59.000')
									    OR oco.natureza_codigo = 'A20028'
									    OR oco.natureza_codigo = 'A20001'
									) 
			  )tb 
ON oco.numero_ocorrencia = tb.BO_HISTORICO 
),
FILTRO AS (
SELECT OCO.numero_ocorrencia, 
oco.natureza_codigo,
COUNT(
    CASE 
      WHEN ENV.numero_cpf_cnpj IS NOT NULL 
        OR (ENV.tipo_documento_codigo IN ('0801','0802', '0803', '0809') AND ENV.numero_documento_id IS NOT NULL)
      THEN 1 
      ELSE NULL 
    END
  ) AS QTD_ENVOLVIDOS,
CASE
	WHEN OCO.natureza_codigo IN ('A21000','A21007') THEN 'VCP'
	WHEN OCO.natureza_codigo IN('A20000','A20028') THEN 'VT'
	WHEN OCO.natureza_codigo = 'A20001' THEN 'VTCV'
	WHEN OCO.natureza_codigo in ('A19000', 'A19001','A19004','A19099') THEN 'RC / RCR'
	WHEN OCO.natureza_codigo in ('A19006', 'A19007','A19008','A19009', 'A19010', 'A19011') THEN 'MRPP'
ELSE 'Natureza Invalida'
END AS 'QUAL_INDICADOR',
CASE 
	WHEN
OCO.data_hora_fato >= '2025-01-01 00:00:00.000'
THEN 'Data Valida'
ELSE 'Data Invalida'
END as DATA_FATO,
CASE
	WHEN 
OCO.natureza_codigo IN ('A19000', 'A19001','A19004','A19099','A19006', 'A19007','A19008','A19009', 'A19010', 'A19011','A20000','A20001','A20028','A21007')
THEN 'Natureza Valida'
WHEN 
OCO.natureza_codigo IN ('A21000','A20000') AND OCO.data_hora_fato BETWEEN '2025-01-01' AND '2025-07-31 23:59:59'
THEN 'Natureza Valida (até julho)'
WHEN
OCO.natureza_codigo IN ('A21000','A20000') AND OCO.data_hora_fato >= '2025-08-01'
THEN 'Natureza Invalida (após julho)'
ELSE 'Natureza Invalida'
END AS NATUREZA,
CASE
	WHEN
OCO.ocorrencia_uf = 'MG'                            
THEN 'UF Valida'
ELSE 'UF Invalida'
END as UF,
CASE 																			-- se o território é Urbano ou Rural segundo o IBGE
    	WHEN oco.pais_codigo <> 1 AND oco.ocorrencia_uf IS NULL THEN 'Outro_Pais'  	-- trata erro - ocorrencia de fora do Brasil
		WHEN oco.ocorrencia_uf <> 'MG' THEN 'Outra_UF'								-- trata erro - ocorrencia de fora de MG
    	WHEN oco.numero_latitude IS NULL THEN 'Invalido'							-- trata erro - ocorrencia sem latitude
        WHEN geo.situacao_codigo = 9 THEN AG.zona_agua									-- trata erro - ocorrencia dentro de curso d'água
       	WHEN geo.situacao_zona IS NULL THEN 'Erro_Processamento'					-- checa se restou alguma ocorrencia com erro
    	ELSE geo.situacao_zona
    END AS RURAL_URBANO,
CASE
	WHEN
OCO.digitador_sigla_orgao  ='PM'
THEN 'Orgão Valido'
ELSE 'Orgão Invalido'
END as ORGAO,
CASE
WHEN OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO') THEN 'Tipo Relatório Válido' ELSE 'Tipo Relatório Invalido'
END AS TIPO_RELATORIO,
CASE
	WHEN OCO.unidade_responsavel_registro_nome NOT LIKE '%IND PE%'
AND OCO.unidade_responsavel_registro_nome NOT LIKE '%PVD%'
AND (
    OCO.unidade_responsavel_registro_nome NOT REGEXP '/[A-Za-z]'
    OR OCO.unidade_responsavel_registro_nome LIKE '%/PEL TM%'
)
AND (
    OCO.unidade_responsavel_registro_nome REGEXP '^(SG|PEL|GP)'
    OR OCO.unidade_responsavel_registro_nome REGEXP '^[^A-Za-z]'
) THEN 'Unidade Registro Válida' ELSE 'Unidade Registro Inválida'
END AS UNIDADE_REGISTRO,
CASE
	WHEN
OCO.ind_estado IN ('F','R') 
THEN 'Estado Valido (Fechado/Pendente)'
ELSE 'Estado Invalido (Não Fechado/Pendente)'
END as ESTADO,
MUB.udi as RPM_AREA,								-- articulação RPM conforme Setor IBGE
    MUB.ueop as UEOP_AREA,								-- articulação BPM conforme Setor IBGE
    MUB.cia as CIA_AREA,								-- articulação CIA conforme Setor IBGE
    MUB.codigo_espacial_pm AS SETOR_PM
  FROM db_bisp_reds_reporting.tb_ocorrencia OCO
LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV  ON OCO.numero_ocorrencia = ENV.numero_ocorrencia
  LEFT JOIN
    db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo -- Tabela de apoio que compara as lat/long com os setores IBGE
    ON oco.numero_ocorrencia = geo.numero_ocorrencia
    AND oco.ocorrencia_uf = 'MG'
LEFT JOIN
    db_bisp_shared.tb_pmmg_setores_geodata AS MUB			-- Tabela de secundaria com dados do GeoPM MUB compatilizados com a malha censitária
    ON geo.setor_codigo = MUB.setor_codigo
LEFT JOIN AGUAS AG ON geo.setor_codigo = AG.setor_codigo
WHERE 1=1
AND oco.numero_ocorrencia in (SELECT numero_ocorrencia from OCORRENCIAS)
GROUP BY 1,2,4,5,6,7,8,9,10,11,12,13,14,15,16
)
SELECT
F.numero_ocorrencia,
F.natureza_codigo,
NATUREZA,
CASE
WHEN QUAL_INDICADOR = 'RC / RCR' AND RURAL_URBANO = 'Rural' THEN 'RC e tambem RCR'
WHEN QUAL_INDICADOR = 'RC / RCR' AND RURAL_URBANO NOT IN ('Rural') THEN 'Apenas RC'
ELSE QUAL_INDICADOR
END AS 'CONTA PARA QUAL INDICADOR',
RURAL_URBANO,
CASE
	WHEN F.QUAL_INDICADOR = 'VCP' AND QTD_ENVOLVIDOS > 0 THEN '1 OU MAIS - VALIDO'
	WHEN F.QUAL_INDICADOR = 'RC / RCR' AND QTD_ENVOLVIDOS > 2 THEN '3 OU MAIS - VALIDO'
	WHEN F.QUAL_INDICADOR = 'MRPP' AND QTD_ENVOLVIDOS > 2 THEN '3 OU MAIS - VALIDO'
	WHEN F.QUAL_INDICADOR = 'VT' AND QTD_ENVOLVIDOS > 0 THEN '1 OU MAIS - VALIDO'
	WHEN F.QUAL_INDICADOR = 'VTCV' AND QTD_ENVOLVIDOS > 0 THEN '1 OU MAIS - VALIDO'
	ELSE CONCAT(CAST(QTD_ENVOLVIDOS AS STRING), ' - INVALIDO')
END AS QUANTIDADE_ENVOLVIDOS,
CASE
	WHEN F.QUAL_INDICADOR IN ('VT','VTCV') AND B.reds_no_historico IS NOT NULL THEN B.reds_no_historico
	WHEN F.QUAL_INDICADOR IN ('VT','VTCV') AND B.reds_no_historico IS NULL THEN 'REDS invalido no Historico'
	ELSE '---'
END AS REDS_HISTORICO,
CASE
	WHEN F.QUAL_INDICADOR IN ('VT') AND B.reds_no_historico IS NOT NULL THEN B.VALIDO_FURTO_RESIDCOM
	WHEN F.QUAL_INDICADOR IN ('VT') AND B.reds_no_historico IS NULL THEN 'REDS invalido no Historico'
	ELSE '---'
END AS VALIDO_FURTO_RESID_COMERCIO,
CASE
	WHEN F.QUAL_INDICADOR IN ('VTCV') AND B.reds_no_historico IS NOT NULL THEN B.VALIDO_CV
	WHEN F.QUAL_INDICADOR IN ('VTCV') AND B.reds_no_historico IS NULL THEN 'REDS invalido no Historico'
	ELSE '---'
END AS VALIDO_CRIME_VIOLENTO,
DATA_FATO,
UF,
ORGAO,
TIPO_RELATORIO,
UNIDADE_REGISTRO,
ESTADO,
RPM_AREA, UEOP_AREA, CIA_AREA, SETOR_PM
FROM FILTRO F
LEFT JOIN BASE B ON F.numero_ocorrencia = B.REDS
ORDER BY NUMERO_OCORRENCIA
;
