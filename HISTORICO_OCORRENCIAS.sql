/*-----------------------------------------------------------------------------------------------------------------------
 * Este código SQL é elaborado para fornecer informações de ocorrências policiais registradas 
 * pela Polícia Militar de Minas Gerais, filtrando palavras-chave no campo Histórico Ocorrência.
 -----------------------------------------------------------------------------------------------------------------------*/
-- SELEÇÃO DE CAMPOS RELEVANTES PARA ANÁLISE DAS OCORRÊNCIAS
SELECT 
    numero_ocorrencia,  -- NÚMERO IDENTIFICADOR DA OCORRÊNCIA
    nome_tipo_relatorio,  -- TIPO DE RELATÓRIO GERADO
    natureza_descricao_longa,  -- DESCRIÇÃO DETALHADA DA NATUREZA DA OCORRÊNCIA
    data_hora_fato,  -- DATA E HORA EM QUE O FATO OCORREU
    numero_latitude,  -- LATITUDE DO LOCAL DA OCORRÊNCIA
    unidade_responsavel_registro_nome,  -- UNIDADE RESPONSÁVEL PELO REGISTRO DA OCORRÊNCIA
    nome_municipio,  -- MUNICÍPIO ONDE OCORREU O FATO
    historico_ocorrencia  -- HISTÓRICO DETALHADO DA OCORRÊNCIA
-- TABELA DE ONDE OS DADOS SÃO EXTRAÍDOS
FROM db_bisp_reds_reporting.tb_ocorrencia
-- CONDIÇÕES PARA SELEÇÃO DE DADOS
WHERE 
    YEAR(data_hora_fato) BETWEEN 2018 AND 2022  -- INTERVALO TEMPORAL DAS OCORRÊNCIAS
    AND relator_sigla_orgao = 'PM'  -- OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR
    AND ocorrencia_uf = 'MG'  -- OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND descricao_estado = 'FECHADO'  -- SOMENTE OCORRÊNCIAS QUE JÁ FORAM FINALIZADAS (FECHADAS)
    AND natureza_codigo = 'A99000'  -- CÓDIGO ESPECÍFICO PARA TIPOS DE RESGATE OU SALVAMENTO
    AND (
        historico_ocorrencia LIKE '%SALVAMENTO%'  -- FILTRA TEXTOS QUE MENCIONAM SALVAMENTO
        OR historico_ocorrencia LIKE '%RESGATE%'  -- FILTRA TEXTOS QUE MENCIONAM RESGATE
        OR historico_ocorrencia LIKE '%SOCORRO%'  -- FILTRA TEXTOS QUE MENCIONAM SOCORRO
        OR historico_ocorrencia LIKE '%ALAGAMENTO%'  -- FILTRA TEXTOS QUE MENCIONAM ALAGAMENTO
        OR historico_ocorrencia LIKE '%ENCHENTE%'  -- FILTRA TEXTOS QUE MENCIONAM ENCHENTE
        OR historico_ocorrencia LIKE '%DESLIZAMENTO%'  -- FILTRA TEXTOS QUE MENCIONAM DESLIZAMENTO
        OR historico_ocorrencia LIKE '%DESABAMENTO%'  -- FILTRA TEXTOS QUE MENCIONAM DESABAMENTO
    )
   -- AND unidade_area_militar_nome LIKE '%1 BPM/1 RPM%' -- FILTRE SUA BPM/ RPM 
   -- AND nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
    ;