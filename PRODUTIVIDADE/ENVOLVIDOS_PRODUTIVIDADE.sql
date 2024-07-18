/*---------------------------------------------------------------------------------------------------------------------
 * O objetivo deste código SQL é extrair informações detalhadas sobre indivíduos envolvidos em ocorrências policiais
 * registradas entre os anos de 2018 e 2022. A consulta foca em ocorrências onde as unidades responsáveis pelo 
 * registro são especificamente relacionadas XXXX
 ---------------------------------------------------------------------------------------------------------------------*/
-- Seleciona colunas relacionadas aos envolvidos nas ocorrências registradas
SELECT 
    ENV.numero_envolvido,  -- Número identificador do envolvido na ocorrência
    ENV.numero_ocorrencia,  -- Número identificador da ocorrência
    ENV.natureza_ocorrencia_codigo,  -- Código da natureza da ocorrência associada ao envolvido
    ENV.ind_consumado,  -- Indicador se a ocorrência foi consumada ou tentada
    ENV.condicao_fisica_descricao,  -- Descrição da condição física do envolvido
    ENV.envolvimento_descricao,  -- Descrição do tipo de envolvimento na ocorrência (ex: suspeito, vítima)
    ENV.ind_mandado_prisao,  -- Indica se havia um mandado de prisão para o envolvido
    ENV.ind_origem_sip,  -- Indica se a informação veio do sistema SIP (Sistema de Informações Policiais)
    ENV.tipo_prisao_apreensao_descricao,  -- Descrição do tipo de prisão ou apreensão
    ENV.ind_mandado_prisao_atual,  -- Indica se atualmente há um mandado de prisão
    ENV.id_indicador_uso_etilometro,  -- Indicador de uso de etilômetro (bafômetro)
    ENV.data_hora_fato  -- Data e hora do fato ocorrido
FROM 
    db_bisp_reds_reporting.tb_envolvido_ocorrencia  ENV 
LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia OCO
    ON ENV.numero_ocorrencia = OCO.numero_ocorrencia  
WHERE 
    YEAR(OCO.data_hora_fato) BETWEEN 2018 AND 2022  -- Filtra ocorrências entre os anos de 2018 e 2022
    AND (
        OCO.unidade_responsavel_registro_nome LIKE '%XXXX%' OR  -- 
        OCO.unidade_responsavel_registro_nome LIKE '%XXXX%'  -- Filtra ocorrências onde a unidade responsável contém 'XXXX' Ouunidade responsável contém 'XXXX'
    	);
