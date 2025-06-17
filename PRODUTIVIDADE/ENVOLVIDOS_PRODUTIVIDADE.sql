/*---------------------------------------------------------------------------------------------------------------------
 * O objetivo deste código SQL é extrair informações detalhadas sobre indivíduos envolvidos em ocorrências policiais
 * registradas entre o periodo especificado. 
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
WHERE 1 = 1 
AND OCO.digitador_id_orgao = 0  -- Filtra pelo ID do órgão digitador - PM 
AND OCO.ocorrencia_uf ='MG'                  -- Filtra apenas ocorrências de Minas Gerais
AND YEAR(OCO.data_hora_fato) BETWEEN 2018 AND 2022  -- Filtra ocorrências entre os anos de 2018 e 2022
 -- AND OCO.unidade_area_militar_nome LIKE '%x BPM/x RPM%' -- Filtra pelo nome da unidade área militar
	-- AND OCO.unidade_responsavel_registro_nome LIKE '%xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	-- AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.
