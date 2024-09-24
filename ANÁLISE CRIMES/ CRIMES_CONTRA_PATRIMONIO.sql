/*---------------------------------------------------------------------------------------------------------------------------------
 *  Este script SQL tem como objetivo principal extrair e organizar dados detalhados sobre ocorrências de crime contra o patrimônio. 
 ----------------------------------------------------------------------------------------------------------------------------------*/
SELECT 
OCO.numero_ocorrencia,  -- SELECIONA O NÚMERO DA OCORRÊNCIA
OCO.data_hora_fato,  -- SELECIONA A DATA E HORA DO FATO
OCO.natureza_codigo,  -- SELECIONA O CÓDIGO DA NATUREZA PRINCIPAL DO FATO
OCO.natureza_descricao,  -- SELECIONA A DESCRIÇÃO DA NATUREZA PRINCIPAL DO FATO
UPPER(OCO.historico_ocorrencia),  -- SELECIONA O HISTÓRICO DA OCORRÊNCIA
OCO.numero_latitude,  -- SELECIONA A LATITUDE DO FATO
OCO.numero_longitude,  -- SELECIONA A LONGITUDE DO FATO
OCO.nome_municipio,  -- SELECIONA O NOME DO MUNICÍPIO DO FATO
OCO.nome_bairro,  -- SELECIONA O BAIRRO DO FATO
OCO.numero_endereco,  -- SELECIONA O NÚMERO DO ENDEREÇO DO FATO
OCO.logradouro_nome,  -- SELECIONA O NOME DO LOGRADOURO DO FATO
OCO.unidade_responsavel_registro_nome,  -- SELECIONA O NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO
OCO.unidade_area_militar_nome,  -- SELECIONA O NOME DA UNIDADE DA ÁREA MILITAR
OCO.digitador_sigla_orgao  -- SELECIONA A SIGLA DO ÓRGÃO DO DIGITADOR
FROM db_bisp_reds_reporting.tb_ocorrencia OCO  -- TABELA DE OCORRÊNCIAS COM ALIÁS "OCO"
WHERE 
    YEAR(data_hora_fato) = :ANO  -- FILTRA PELO ANO DA OCORRÊNCIA
    AND MONTH(data_hora_fato) BETWEEN :MESINICIAL AND :MESFINAL  -- FILTRA PELO INTERVALO DE MESES DEFINIDOS
    AND (
    		OCO.natureza_codigo = 'C01155'  -- FILTRA NATUREZA DA OCORÊNCIA, FURTO
    		--OR OCO.natureza_codigo = 'C01157'  -- FILTRA NATUREZA DA OCORÊNCIA, ROUBO
    		--OR OCO.natureza_codigo = 'C01158'  -- FILTRA NATUREZA DA OCORÊNCIA, EXTORSÃO
    		)
    AND OCO.digitador_id_orgao IN (0,1)  -- FILTRA PELOS ID DE ÓRGÃOS DOS DIGITADORES (PM E PC)
    AND OCO.ocorrencia_uf = 'MG'  -- FILTRA OCORRÊNCIAS DO ESTADO DE MINAS GERAIS
    AND OCO.ind_estado ='F'
    AND UPPER(OCO.nome_municipio) LIKE UPPER('%XXX%')  -- FILTRO PELO NOME DO MUNICÍPIO. SE PREFERIR USE : --and OCO.codigo_municipio = 00  --  FILTRO PELO CÓDIGO DO MUNICÍPIO 
ORDER BY data_hora_fato , numero_ocorrencia;
