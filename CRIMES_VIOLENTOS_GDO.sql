/*﻿-----------------------------------------------------------------------------------------------------------------
 * Esta consulta seleciona informações detalhadas sobre ocorrências, incluindo dados sobre a natureza do incidente, 
 * localização, e entidade responsável pelo registro. Ela é útil para análises de padrões de criminalidade, 
 * acompanhamento de ocorrências específicas, e geração de relatórios detalhados para a administração 
 ﻿-----------------------------------------------------------------------------------------------------------------*/
-- Seleciona várias colunas da tabela 'tb_ocorrencia' relacionadas aos detalhes das ocorrências
SELECT 
    db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia,  -- Número único de identificação da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.natureza_codigo,  -- Código que identifica a natureza principal da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.natureza_descricao,  -- Descrição natureza principal
    db_bisp_reds_reporting.tb_ocorrencia.natureza_consumado,  -- Indica se a natureza da ocorrência foi consumada ou tentada
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_codigo,  -- Código da primeira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_codigo,  -- Código da segunda natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_codigo,  -- Código da terceira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.complemento_natureza_descricao,  -- Descrição complementar sobre a natureza
    db_bisp_reds_reporting.tb_ocorrencia.outras_naturezas_descricao,  -- Descrições de outras naturezas envolvidas
    db_bisp_reds_reporting.tb_ocorrencia.motivo_presumido_descricao,  -- Descrição do motivo presumido da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.instrumento_utilizado_descricao,  -- Descrição do instrumento utilizado no incidente
    db_bisp_reds_reporting.tb_ocorrencia.ind_estado,  -- Indicador do estado do registro (por exemplo, 'F' para fechado)
    db_bisp_reds_reporting.tb_ocorrencia.codigo_municipio,  -- Código identificador do município onde ocorreu o incidente
    db_bisp_reds_reporting.tb_ocorrencia.nome_municipio,  -- Nome do município onde ocorreu o incidente
    db_bisp_reds_reporting.tb_ocorrencia.logradouro_nome,  -- Nome do logradouro onde ocorreu o incidente
    db_bisp_reds_reporting.tb_ocorrencia.nome_bairro,  -- Nome do bairro onde ocorreu o incidente
    db_bisp_reds_reporting.tb_ocorrencia.unidade_area_militar_codigo,  -- Código da unidade de área militar responsável
    db_bisp_reds_reporting.tb_ocorrencia.unidade_area_militar_nome,  -- Nome da unidade de área militar responsável
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_codigo,  -- Código da unidade responsável pelo registro
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome,  -- Nome da unidade responsável pelo registro
    db_bisp_reds_reporting.tb_ocorrencia.relator_sigla_orgao,  -- Sigla do órgão que relatou a ocorrência
    MONTH(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) AS mes_ocorrencia,  -- Extrai o mês da data da ocorrência
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) AS ano_ocorrencia  -- Extrai o ano da data da ocorrência
FROM 
    db_bisp_reds_reporting.tb_ocorrencia  -- A tabela de onde os dados são extraídos
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) BETWEEN 2020 AND 2022  -- Filtra ocorrências entre os anos 2020 e 2022
    AND MONTH(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) = 1  -- Filtra ocorrências que aconteceram em janeiro
    AND db_bisp_reds_reporting.tb_ocorrencia.ind_estado = 'F'  -- Filtra por ocorrências com estado 'F'
    AND db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf = 'MG'  -- Filtra ocorrências no estado de Minas Gerais
    AND (db_bisp_reds_reporting.tb_ocorrencia.relator_sigla_orgao = 'PM' OR db_bisp_reds_reporting.tb_ocorrencia.relator_sigla_orgao = 'PC')  -- Filtra por ocorrências reportadas pela Polícia Militar ou Civil
    AND (
        db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio IN ('POLICIAL', 'REFAP', 'TRANSITO')  -- Filtra por tipos de relatórios específicos
        AND (
            -- Filtra por códigos específicos de natureza principal ou secundária da ocorrência
            db_bisp_reds_reporting.tb_ocorrencia.natureza_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
            OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
            OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
            OR db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_codigo IN ('C01157', 'C01158', 'C01159', 'B01148', 'D01213', 'D01217', 'B01121')
        )
    )
     -- AND db_bisp_reds_reporting.tb_ocorrencia.unidade_area_militar_nome LIKE '%1 BPM/1 RPM%' -- FILTRE SUA BPM/ RPM 
  	 -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 