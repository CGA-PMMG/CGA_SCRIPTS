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
    AND natureza_codigo = 'X99000'  -- CÓDIGO ESPECÍFICO PARA NATUREZA
    AND (
        historico_ocorrencia LIKE '%xxxxxxxxxx%'  -- FILTRA TEXTOS QUE MENCIONAM X
        OR historico_ocorrencia LIKE '%xxxxxxxxxx%'  -- FILTRA TEXTOS QUE MENCIONAM X
         )
   -- AND unidade_area_militar_nome LIKE '%x BPM/x RPM%' -- FILTRE SUA BPM/ RPM 
   -- AND nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
    ;
