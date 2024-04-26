/*---------------------------------------------------------------------------------------------------------------------
 * O objetivo deste código SQL é extrair informações detalhadas sobre indivíduos envolvidos em ocorrências policiais
 * registradas entre os anos de 2018 e 2022. A consulta foca em ocorrências onde as unidades responsáveis pelo 
 * registro são especificamente relacionadas à Polícia Rodoviária, como indicado pelas siglas 
 * 'CPRV' (Companhia de Polícia Rodoviária) e 'BPMRV' (Batalhão de Polícia Militar Rodoviária).
 ---------------------------------------------------------------------------------------------------------------------*/
-- Seleciona colunas relacionadas aos envolvidos nas ocorrências registradas
SELECT 
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.numero_envolvido,  -- Número identificador do envolvido na ocorrência
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.numero_ocorrencia,  -- Número identificador da ocorrência
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.natureza_ocorrencia_codigo,  -- Código da natureza da ocorrência associada ao envolvido
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.ind_consumado,  -- Indicador se a ocorrência foi consumada ou tentada
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.condicao_fisica_descricao,  -- Descrição da condição física do envolvido
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.envolvimento_descricao,  -- Descrição do tipo de envolvimento na ocorrência (ex: suspeito, vítima)
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.ind_mandado_prisao,  -- Indica se havia um mandado de prisão para o envolvido
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.ind_origem_sip,  -- Indica se a informação veio do sistema SIP (Sistema de Informações Policiais)
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.tipo_prisao_apreensao_descricao,  -- Descrição do tipo de prisão ou apreensão
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.ind_mandado_prisao_atual,  -- Indica se atualmente há um mandado de prisão
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.id_indicador_uso_etilometro,  -- Indicador de uso de etilômetro (bafômetro)
    db_bisp_reds_reporting.tb_envolvido_ocorrencia.data_hora_fato  -- Data e hora do fato ocorrido
FROM 
    db_bisp_reds_reporting.tb_envolvido_ocorrencia  -- Tabela que contém os dados dos envolvidos nas ocorrências
LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia  -- Tabela que contém os dados das ocorrências
    ON db_bisp_reds_reporting.tb_envolvido_ocorrencia.numero_ocorrencia = db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia  -- Condição para unir as tabelas pelo número da ocorrência
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) BETWEEN 2018 AND 2022  -- Filtra ocorrências entre os anos de 2018 e 2022
    AND (
        db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXX%' OR  -- Filtra ocorrências onde a unidade responsável contém 'XXXX'
        db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%XXXX%'  -- Ou filtra ocorrências onde a unidade responsável contém 'XXXX'
    );
