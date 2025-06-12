WITH 
 OCORRENCIAS AS (
 SELECT numero_ocorrencia
 FROM db_bisp_reds_reporting.tb_ocorrencia
 WHERE numero_ocorrencia in ('2025-000000000-001') -- COLOQUE AQUI OS REDS A SEREM TESTADOS
 ),
/*------------------------------------
 
 
 
 
 
******** ATENÇÃO: ********
 
 NÃO ALTERE NADA NO RESTANTE DO CODIGO
 
 
 
 
 
 
 
 
 --------------------------------------*/
 BASE AS(
 SELECT 
    tb.REDS,
    oco.numero_ocorrencia as reds_no_historico,
    natureza_codigo,
    complemento_natureza_descricao,
    complemento_natureza_codigo,
    local_imediato_descricao,
    local_imediato_codigo,
    CASE 
    	WHEN natureza_codigo = 'C01155' 
    	AND(
    	SUBSTRING(OCO.local_imediato_codigo ,1,2) = '07' 
    	OR SUBSTRING(OCO.local_imediato_codigo,1,2) = '10' 
		OR SUBSTRING(OCO.local_imediato_codigo,1,2) = '14' 
		OR OCO.local_imediato_codigo IN ('1501','1502','1503','1599')
		OR OCO.complemento_natureza_codigo IN ('2002','2003','2004','2005','2015')
		) THEN 'VALIDO' ELSE 'INVALIDO'
    END AS VALIDO_FURTO_RESIDCOM,
   CASE
   	WHEN natureza_codigo IN ('B01121','B01148','B02001','C01157','C01158','C01159','B01504') THEN 'VALIDO' ELSE 'INVALIDO'
   END AS VALIDO_CV   
   FROM db_bisp_reds_reporting.tb_ocorrencia oco
  INNER JOIN (
    SELECT numero_ocorrencia as REDS, 
            REGEXP_EXTRACT(oco.historico_ocorrencia, '([0-9]{4}-[0-9]{9}-[0-9]{3})', 0) AS BO_HISTORICO
  FROM db_bisp_reds_reporting.tb_ocorrencia oco
  WHERE 
    digitador_sigla_orgao = 'PM'
    AND ocorrencia_uf = 'MG'
    AND ind_estado IN ('F','R')
    AND data_hora_fato >= '2024-01-01 00:00:00'
	AND oco.natureza_codigo IN ('A20000', 'A20001')
  )tb ON oco.numero_ocorrencia = tb.BO_HISTORICO 
),
FILTRO AS (
SELECT OCO.numero_ocorrencia, 
oco.natureza_codigo,
COUNT(
    CASE 
      WHEN ENV.numero_cpf_cnpj IS NOT NULL 
        OR (ENV.tipo_documento_codigo = '0801' AND ENV.numero_documento_id IS NOT NULL)
      THEN 1 
      ELSE NULL 
    END
  ) AS QTD_ENVOLVIDOS,
CASE
	WHEN OCO.natureza_codigo = 'A21000' THEN 'VCP'
	WHEN OCO.natureza_codigo = 'A20000' THEN 'VT'
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
OCO.natureza_codigo IN ('A21000','A19000', 'A19001','A19004','A19099','A19006', 'A19007','A19008','A19009', 'A19010', 'A19011','A20000','A20001')
THEN 'Natureza Valida'
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
        WHEN geo.situacao_codigo = 9 THEN 'Agua'									-- trata erro - ocorrencia dentro de curso d'água
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
END as ESTADO
  FROM db_bisp_reds_reporting.tb_ocorrencia OCO
LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV  ON OCO.numero_ocorrencia = ENV.numero_ocorrencia
  LEFT JOIN
    db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo -- Tabela de apoio que compara as lat/long com os setores IBGE
    ON oco.numero_ocorrencia = geo.numero_ocorrencia
    AND oco.ocorrencia_uf = 'MG'
WHERE 1=1
AND oco.numero_ocorrencia in (SELECT numero_ocorrencia from OCORRENCIAS)
GROUP BY 1,2,4,5,6,7,8,9,10,11,12
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
ESTADO
FROM FILTRO F
LEFT JOIN BASE B ON F.numero_ocorrencia = B.REDS
;