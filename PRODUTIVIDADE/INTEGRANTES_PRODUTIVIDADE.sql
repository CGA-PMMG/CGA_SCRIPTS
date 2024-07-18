/*------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem o objetivo de fornecer uma visão clara sobre os membros da equipe que atendem a 
 * ocorrências, identificando suas respectivas funções e unidades durante as ocorrências.
------------------------------------------------------------------------------------------------------------------*/
-- Seleção das colunas de interesse na tabela de integrantes de guarnição
SELECT 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_ocorrencia, -- Número da ocorrência
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_sequencial_viatura, -- Número sequencial da viatura
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.nome_cargo, -- Cargo do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_matricula, -- Matrícula do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.nome, -- Nome do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.unidade_servico_codigo, -- Código da unidade de serviço
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.unidade_servico_nome, -- Nome da unidade de serviço
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.data_hora_fato -- Data e hora do fato
FROM 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia -- Tabela de integrantes de guarnição
LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia -- Junção com a tabela de ocorrências
    ON db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia = db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_ocorrencia 
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) BETWEEN 2018 AND 2022 -- FILTRA O PERIODO
    AND db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf = 'MG' -- Somente ocorrências no estado de MG
    AND (db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXX%'
    OR db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXXX%')  -- Unidades de polícia 
 -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
