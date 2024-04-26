/*--------------------------------------------------------------------------------------------------------------

 * Este script fornece uma visão detalhada sobre as ocorrências registradas, possibilitando análises 
 * específicas com base em vários parâmetros e condições detalhadas, úteis para estudos criminológicos,
 *  relatórios administrativos ou preparação de dados para medidas preventivas e reativas pelas forças de segurança.
 --------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE DIVERSOS CAMPOS DA TABELA DE OCORRÊNCIAS POLICIAIS PARA CONSULTA DETALHADA
SELECT 
    db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia,  -- NÚMERO ÚNICO IDENTIFICADOR DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.descricao_estado,  -- DESCRIÇÃO DO ESTADO ATUAL DA OCORRÊNCIA 
    db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio,  -- TIPO DO RELATÓRIO GERADO (POLICIAL, REFAP, TRÂNSITO)
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_fechamento,  -- DATA E HORA DE FECHAMENTO DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato,  -- DATA E HORA EM QUE O FATO OCORREU
    db_bisp_reds_reporting.tb_ocorrencia.natureza_codigo,  -- CÓDIGO DA NATUREZA PRINCIPAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_codigo,  -- CÓDIGO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_codigo,  -- CÓDIGO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_codigo,  -- CÓDIGO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.logradouro_nome,  -- NOME DO LOGRADOURO ONDE A OCORRÊNCIA FOI REGISTRADA
    db_bisp_reds_reporting.tb_ocorrencia.tipo_logradouro_descricao,  -- DESCRIÇÃO DO TIPO DE LOGRADOURO (RUA, AVENIDA, ETC.)
    db_bisp_reds_reporting.tb_ocorrencia.numero_endereco,  -- NÚMERO DO ENDEREÇO NO LOGRADOURO
    db_bisp_reds_reporting.tb_ocorrencia.nome_bairro,  -- NOME DO BAIRRO ONDE A OCORRÊNCIA FOI REGISTRADA
    db_bisp_reds_reporting.tb_ocorrencia.codigo_municipio,  -- CÓDIGO DO MUNICÍPIO ONDE A OCORRÊNCIA FOI REGISTRADA
    db_bisp_reds_reporting.tb_ocorrencia.nome_municipio,  -- NOME DO MUNICÍPIO ONDE A OCORRÊNCIA FOI REGISTRADA
    db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf,  -- SIGLA DA UNIDADE FEDERATIVA ONDE A OCORRÊNCIA FOI REGISTRADA
    db_bisp_reds_reporting.tb_ocorrencia.tipo_local_descricao,  -- DESCRIÇÃO DO TIPO DE LOCAL DA OCORRÊNCIA (COMERCIAL, RESIDENCIAL, ETC.)
    db_bisp_reds_reporting.tb_ocorrencia.numero_latitude,  -- LATITUDE DO LOCAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.numero_longitude,  -- LONGITUDE DO LOCAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_codigo,  -- CÓDIGO DA UNIDADE POLICIAL RESPONSÁVEL PELO REGISTRO
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome,  -- NOME DA UNIDADE POLICIAL RESPONSÁVEL PELO REGISTRO
    db_bisp_reds_reporting.tb_ocorrencia.sqtempo_fato,  -- SEQUÊNCIA DE TEMPO DO FATO
    db_bisp_reds_reporting.tb_ocorrencia.ind_estado,  -- INDICADOR DE ESTADO DA OCORRÊNCIA (FECHADA, ABERTA)
    db_bisp_reds_reporting.tb_ocorrencia.descricao_tipo_relatorio,  -- DESCRIÇÃO DETALHADA DO TIPO DE RELATÓRIO
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_inclusao,  -- DATA E HORA DA INCLUSÃO DA OCORRÊNCIA NO SISTEMA
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_alteracao,  -- DATA E HORA DA ÚLTIMA ALTERAÇÃO DA OCORRÊNCIA NO SISTEMA
    db_bisp_reds_reporting.tb_ocorrencia.operacao_codigo,  -- CÓDIGO DA OPERAÇÃO POLICIAL ASSOCIADA À OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.operacao_descricao,  -- DESCRIÇÃO DA OPERAÇÃO POLICIAL ASSOCIADA À OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_descricao,  -- DESCRIÇÃO DA NATUREZA PRINCIPAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_descricao,  -- DESCRIÇÃO DA PRIMEIRA NATUREZA SECUNDÁRIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_descricao,  -- DESCRIÇÃO DA SEGUNDA NATUREZA SECUNDÁRIA
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_descricao,  -- DESCRIÇÃO DA TERCEIRA NATUREZA SECUNDÁRIA
    db_bisp_reds_reporting.tb_ocorrencia.tipo_local_codigo,  -- CÓDIGO DO TIPO DE LOCAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.modo_acao_criminosa,  -- MODO DE AÇÃO CRIMINOSA DESCRITO NA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.descricao_endereco,  -- DESCRIÇÃO COMPLETA DO ENDEREÇO DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.relator_nome,  -- NOME DO RELATOR DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.relator_cargo,  -- CARGO DO RELATOR DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.ind_tco,  -- INDICADOR SE FOI LAVRADO TERMO CIRCUNSTANCIADO DE OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_final,  -- DATA E HORA FINAL DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.numero_atividade_cad,  -- NÚMERO DA ATIVIDADE CADASTRADA NO SISTEMA
    db_bisp_reds_reporting.tb_ocorrencia.numero_chamada_cad,  -- NÚMERO DA CHAMADA CADASTRADA NO SISTEMA
    db_bisp_reds_reporting.tb_ocorrencia.numero_chamada_principal_cad,  -- NÚMERO DA CHAMADA PRINCIPAL CADASTRADA NO SISTEMA
    db_bisp_reds_reporting.tb_ocorrencia.digitador_cargo_efetivo,  -- CARGO EFETIVO DO DIGITADOR DA OCORRÊNCIA
    db_bisp_reds_reporting.tb_ocorrencia.digitador_nome  -- NOME DO DIGITADOR QUE REGISTROU A OCORRÊNCIA
FROM db_bisp_reds_reporting.tb_ocorrencia
WHERE YEAR (db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) >= 2020
    AND YEAR (db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) <= 2022
    AND db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf = 'MG'  -- FILTRO POR ESTADO
    AND (db_bisp_reds_reporting.tb_ocorrencia.relator_sigla_orgao = 'PM' OR db_bisp_reds_reporting.tb_ocorrencia.relator_sigla_orgao = 'PC')  -- FILTRO POR ORGÃO EMISSOR
    AND (db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio = 'POLICIAL' OR db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio = 'REFAP' OR db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio = 'TRANSITO')  -- FILTRO POR TIPO DE RELATÓRIO
    AND ( 
        db_bisp_reds_reporting.tb_ocorrencia.natureza_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121') 
        OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
        OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
        OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121') -- FILTRO POR CÓDIGOS ESPECÍFICOS DAS NATUREZAS DA OCORRÊNCIA, INCLUINDO PRIMÁRIAS E SECUNDÁRIAS
    )
    -- AND db_bisp_reds_reporting.tb_ocorrencia.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/ RPM 
    -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 
    ;
