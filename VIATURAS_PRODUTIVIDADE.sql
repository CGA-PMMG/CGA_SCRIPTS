/*---------------------------------------------------------------------------------------------------------------------

 * Este código tem como objetivo fornecer detalhes específicos sobre as viaturas envolvidas em ocorrências policiais 
 * em Minas Gerais, detalhando aspectos como tipo de viatura e unidade a que pertence. A análise desses dados pode 
 * ser útil para gestão de recursos, planejamento operacional e auditorias internas, permitindo uma melhor compreensão
 * da distribuição e uso de viaturas em situações específicas de policiamento
 ---------------------------------------------------------------------------------------------------------------------
*/
-- Seleção de campos relacionados às viaturas envolvidas em ocorrências
SELECT 
    db_bisp_reds_reporting.tb_viatura_ocorrencia.numero_ocorrencia,  -- Número da ocorrência
    db_bisp_reds_reporting.tb_viatura_ocorrencia.numero_sequencial_viatura,  -- Número sequencial da viatura na ocorrência
    db_bisp_reds_reporting.tb_viatura_ocorrencia.descricao_tipo_viatura,  -- Descrição do tipo de viatura (ex: carro, moto, etc.)
    db_bisp_reds_reporting.tb_viatura_ocorrencia.unidade_servico_codigo,  -- Código da unidade de serviço a que a viatura pertence
    db_bisp_reds_reporting.tb_viatura_ocorrencia.unidade_servico_nome,  -- Nome da unidade de serviço
    db_bisp_reds_reporting.tb_viatura_ocorrencia.codigo_tipo_viatura,  -- Código do tipo de viatura
    db_bisp_reds_reporting.tb_viatura_ocorrencia.orgao_sigla  -- Sigla do órgão ao qual a viatura pertence
FROM 
    db_bisp_reds_reporting.tb_viatura_ocorrencia -- Tabela que registra as viaturas envolvidas em ocorrências
LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia -- Junção com a tabela de ocorrências
ON 
    db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia = db_bisp_reds_reporting.tb_viatura_ocorrencia.numero_ocorrencia 
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) >= 2018 -- Filtra ocorrências entre 2018 e 2022
    AND YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) <= 2022
    AND (db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXXX%'  -- Ocorrências registradas por unidades de polícia rodoviária
    OR db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXXXX%')
 -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
;
