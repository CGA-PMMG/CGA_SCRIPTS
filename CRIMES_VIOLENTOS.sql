/*--------------------------------------------------------------------------------------------------------------
 *  Este script fornece uma visão detalhada sobre as ocorrências registradas, possibilitando análises 
 *  específicas com base em vários parâmetros e condições detalhadas, úteis para estudos criminológicos,
 *  relatórios administrativos ou preparação de dados para medidas preventivas e reativas pelas forças de segurança.
 --------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE DIVERSOS CAMPOS DA TABELA DE OCORRÊNCIAS POLICIAIS PARA CONSULTA DETALHADA
SELECT 
    OCO.numero_ocorrencia,  -- NÚMERO DA OCORRÊNCIA
    OCO.descricao_estado,  -- DESCRIÇÃO DO ESTADO ATUAL DA OCORRÊNCIA 
    OCO.nome_tipo_relatorio,  -- TIPO DO RELATÓRIO GERADO 
    OCO.data_hora_fechamento,  -- DATA HORA DE FECHAMENTO DA OCORRÊNCIA
    OCO.data_hora_fato,  -- DATA  HORA DO FATO 
    OCO.natureza_codigo,  -- CÓDIGO DA NATUREZA PRINCIPAL DA OCORRÊNCIA
    OCO.natureza_secundaria1_codigo,  -- CÓDIGO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    OCO.natureza_secundaria2_codigo,  -- CÓDIGO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    OCO.natureza_secundaria3_codigo,  -- CÓDIGO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    OCO.logradouro_nome,  -- NOME DO LOGRADOURO ONDE A OCORRÊNCIA FOI REGISTRADA
    OCO.tipo_logradouro_descricao,  -- DESCRIÇÃO DO TIPO DE LOGRADOURO 
    OCO.numero_endereco,  -- NÚMERO DO ENDEREÇO NO LOGRADOURO
    OCO.nome_bairro,  -- NOME DO BAIRRO  DA OCORRÊNCIA
    OCO.codigo_municipio,  -- CÓDIGO DO MUNICÍPIO DA OCORRÊNCIA
    OCO.nome_municipio,  -- NOME DO MUNICÍPIO DA OCORRÊNCIA
    OCO.ocorrencia_uf,  -- SIGLA DA UNIDADE FEDERATIVA DA OCORRÊNCIA
    OCO.tipo_local_descricao,  -- DESCRIÇÃO DO TIPO DE LOCAL DA OCORRÊNCIA 
    OCO.numero_latitude,  -- LATITUDE DO LOCAL DA OCORRÊNCIA
    OCO.numero_longitude,  -- LONGITUDE DO LOCAL DA OCORRÊNCIA
    OCO.unidade_responsavel_registro_codigo,  -- CÓDIGO DA UNIDADE POLICIAL RESPONSÁVEL PELO REGISTRO
    OCO.unidade_responsavel_registro_nome,  -- NOME DA UNIDADE POLICIAL RESPONSÁVEL PELO REGISTRO
    OCO.sqtempo_fato,  -- SEQUÊNCIA DE TEMPO DO FATO
    OCO.ind_estado,  -- INDICADOR DE ESTADO DA OCORRÊNCIA 
    OCO.descricao_tipo_relatorio,  -- DESCRIÇÃO DETALHADA DO TIPO DE RELATÓRIO
    OCO.data_hora_inclusao,  -- DATA HORA DA INCLUSÃO DA OCORRÊNCIA NO SISTEMA
    OCO.data_hora_alteracao,  -- DATA HORA DA ÚLTIMA ALTERAÇÃO DA OCORRÊNCIA NO SISTEMA
    OCO.operacao_codigo,  -- CÓDIGO DA OPERAÇÃO POLICIAL ASSOCIADA À OCORRÊNCIA
    OCO.operacao_descricao,  -- DESCRIÇÃO DA OPERAÇÃO POLICIAL ASSOCIADA À OCORRÊNCIA
    OCO.natureza_descricao,  -- DESCRIÇÃO DA NATUREZA PRINCIPAL DA OCORRÊNCIA
    OCO.natureza_secundaria1_descricao,  -- DESCRIÇÃO DA PRIMEIRA NATUREZA SECUNDÁRIA
    OCO.natureza_secundaria2_descricao,  -- DESCRIÇÃO DA SEGUNDA NATUREZA SECUNDÁRIA
    OCO.natureza_secundaria3_descricao,  -- DESCRIÇÃO DA TERCEIRA NATUREZA SECUNDÁRIA
    OCO.tipo_local_codigo,  -- CÓDIGO DO TIPO DE LOCAL DA OCORRÊNCIA
    OCO.modo_acao_criminosa,  -- MODO DE AÇÃO CRIMINOSA DESCRITO NA OCORRÊNCIA
    OCO.descricao_endereco,  -- DESCRIÇÃO COMPLETA DO ENDEREÇO DA OCORRÊNCIA
    OCO.relator_nome,  -- NOME DO RELATOR DA OCORRÊNCIA
    OCO.relator_cargo,  -- CARGO DO RELATOR DA OCORRÊNCIA
    OCO.ind_tco,  -- INDICADOR SE FOI LAVRADO TERMO CIRCUNSTANCIADO DE OCORRÊNCIA
    OCO.data_hora_final,  -- DATA HORA FINAL DA OCORRÊNCIA
    OCO.numero_atividade_cad,  -- NÚMERO DA ATIVIDADE CADASTRADA NO SISTEMA
    OCO.numero_chamada_cad,  -- NÚMERO DA CHAMADA CADASTRADA NO SISTEMA
    OCO.digitador_cargo_efetivo,  -- CARGO EFETIVO DO DIGITADOR DA OCORRÊNCIA
    OCO.digitador_nome  -- NOME DO DIGITADOR QUE REGISTROU A OCORRÊNCIA
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
WHERE YEAR (OCO.data_hora_fato) BETWEEN 2023 AND 2024 -- FILTRA O PERIODO DOS FATOS
    AND OCO.ocorrencia_uf = 'MG'  -- FILTRO POR ESTADO
    AND (OCO.relator_sigla_orgao = 'PM' OR OCO.relator_sigla_orgao = 'PC')  -- FILTRO POR ORGÃO EMISSOR
    AND (OCO.nome_tipo_relatorio = 'POLICIAL' OR OCO.nome_tipo_relatorio = 'REFAP' OR OCO.nome_tipo_relatorio = 'TRANSITO')  -- FILTRO POR TIPO DE RELATÓRIO
    AND ( 
        OCO.natureza_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121') 
        OR OCO.natureza_secundaria1_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
        OR OCO.natureza_secundaria2_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
        OR OCO.natureza_secundaria3_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121') -- FILTRO POR CÓDIGOS ESPECÍFICOS DAS NATUREZAS DA OCORRÊNCIA, INCLUINDO PRIMÁRIAS E SECUNDÁRIAS
        )
    -- AND OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/ RPM 
    -- AND OCO.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 
    ;
