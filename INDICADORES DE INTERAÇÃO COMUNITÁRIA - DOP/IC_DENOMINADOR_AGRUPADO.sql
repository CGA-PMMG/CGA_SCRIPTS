/* ----------------------------------------------------------------------------------------------------------------------------------------------------=
 *  ====================================================================================================================================================
 *  ====================================================== INDICADORES IC  DENOMINADOR==================================================================
 *  ====================================================================================================================================================
 * 
 * Este script agrupa os Visitas Tranquilizadoras Denominador (VT) e Visitas Tranquilizadoras a Vítimas de Crimes Violentos Denominador (VTCV) para 
 * padronizar análises e dashboards.
 *-----------------------------------------------------------------------------------------------------------------------------------------------------*/
WITH FURTO AS (
    SELECT DISTINCT
        OCO.numero_ocorrencia, NULL as 'codigo_municipio'
    FROM db_bisp_reds_reporting.tb_ocorrencia OCO
   WHERE 1 = 1   
	AND OCO.data_hora_fato >= '2025-01-01 00:00:00.000' 
	AND OCO.natureza_codigo = 'C01155'                                         
AND(
    		((SUBSTRING(OCO.local_imediato_codigo , 1, 2) IN ('07', '10', '14', '15', '03')) OR OCO.local_imediato_codigo = '0512')
		AND OCO.complemento_natureza_codigo IN ('2002', '2004', '2005', '2015')
		)
	AND OCO.ocorrencia_uf = 'MG'                             
	AND OCO.digitador_sigla_orgao  IN ('PM','PC') 
	AND OCO.ind_estado = 'F'                               
), -- Reds de furtos a  residências e estabelecimentos
CV AS (
    SELECT 
       DISTINCT  env.numero_ocorrencia, env.codigo_municipio
    FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env
    WHERE 1 = 1      
   	AND env.id_envolvimento IN(25,1097, 27, 32, 28, 26, 872)        
	AND env.condicao_fisica_codigo <> '0100'
	AND env.natureza_ocorrencia_codigo IN('B01121','B01148','B02001','C01157','C01158','C01159','B01504') 
    AND env.data_hora_fato >= '2025-01-01 00:00:00.000' 
	AND env.digitador_id_orgao IN (0,1)                                                                                   
) -- Reds CV
SELECT 
DISTINCT 
    CASE 
        WHEN OCO.natureza_codigo = 'C01155' 
      AND(
    		((SUBSTRING(OCO.local_imediato_codigo , 1, 2) IN ('07', '10', '14', '15', '03')) OR OCO.local_imediato_codigo = '0512')
		AND OCO.complemento_natureza_codigo IN ('2002', '2004', '2005', '2015')
		) THEN 'FURTO'
        WHEN OCO.natureza_codigo IN ('B01121', 'B01148', 'B02001', 'C01157', 'C01158', 'C01159', 'B01504') THEN 'CV' 
        ELSE 'OUTROS'
    END AS TIPO_OCORRENCIA,
	OCO.numero_ocorrencia,   -- Número da ocorrência                                      
	OCO.natureza_codigo,                                         -- Código da natureza da ocorrência
	OCO.natureza_descricao,                                      -- Descrição da natureza da ocorrência
	OCO.local_imediato_codigo,  								 -- Código do local imediato
	OCO.local_imediato_descricao,								 -- Descrição do local imediato
	OCO.complemento_natureza_codigo,							 -- Código do complemento da natureza da ocorrência
	OCO.complemento_natureza_descricao,							 -- Descrição do complemento da natureza da ocorrência
	OCO.id_local,												-- Identificador do local área militar 
	LO.codigo_unidade_area,										-- Código da unidade militar da área
	LO.unidade_area_militar_nome,                                -- Nome da unidade militar da área
	OCO.unidade_responsavel_registro_codigo,                      -- Código da unidade que registrou a ocorrência
	OCO.unidade_responsavel_registro_nome,                        -- Nome da unidade que registrou a ocorrência                
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM_REGISTRO, 
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS UEOP_REGISTRO, 
	CAST(OCO.codigo_municipio AS INTEGER) codigo_municipio,                        -- Converte o código do município para número inteiro
	OCO.nome_municipio,                                           -- Nome do município da ocorrência
	OCO.tipo_logradouro_descricao,                                -- Tipo do logradouro (Rua, Avenida, etc)
	OCO.logradouro_nome,                                          -- Nome do logradouro
	OCO.numero_endereco,                                          -- Número do endereço
	OCO.nome_bairro,                                              -- Nome do bairro
	OCO.ocorrencia_uf,                                            -- Estado da ocorrência                                         
    REPLACE(CAST(OCO.numero_latitude AS STRING), '.', ',') AS local_latitude_formatado,
    REPLACE(CAST(OCO.numero_longitude AS STRING), '.', ',') AS local_longitude_formatado,
    OCO.data_hora_fato,   -- Data e hora do fato                                     
    YEAR(OCO.data_hora_fato) AS ano,            -- Ano do fato              
    MONTH(OCO.data_hora_fato) AS mes,            -- Mês do fato
    OCO.nome_tipo_relatorio,                                  -- Nome do tipo do relatório
    OCO.digitador_sigla_orgao                                -- Sigla do órgão do digitador
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
INNER JOIN (
	SELECT * FROM CV
	UNION
	SELECT * FROM FURTO 
) AS NAT_OCORRENCIA ON OCO.numero_ocorrencia = NAT_OCORRENCIA.numero_ocorrencia AND ((oco.codigo_municipio = NAT_OCORRENCIA.codigo_municipio) OR NAT_OCORRENCIA.codigo_municipio IS NULL)
LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg LO on OCO.id_local = LO.id_local
WHERE OCO.data_hora_fato >= '2025-01-01 00:00:00.000'