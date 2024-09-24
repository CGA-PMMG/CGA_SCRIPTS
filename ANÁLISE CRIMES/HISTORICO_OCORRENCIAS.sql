/*-----------------------------------------------------------------------------------------------------------------------
 * Este código SQL é elaborado para fornecer informações de ocorrências policiais registradas 
 * pela Polícia Militar de Minas Gerais, filtrando palavras-chave no campo Histórico Ocorrência.
 -----------------------------------------------------------------------------------------------------------------------*/
SELECT 
    OCO.numero_ocorrencia,  -- NÚMERO IDENTIFICADOR DA OCORRÊNCIA
    OCO.nome_tipo_relatorio,  -- TIPO DE RELATÓRIO GERADO
    OCO.natureza_descricao_longa,  -- DESCRIÇÃO DETALHADA DA NATUREZA DA OCORRÊNCIA
    OCO.data_hora_fato,  -- DATA E HORA EM QUE O FATO OCORREU
    OCO.numero_latitude,  -- LATITUDE DO LOCAL DA OCORRÊNCIA
    OCO.unidade_responsavel_registro_nome,  -- UNIDADE RESPONSÁVEL PELO REGISTRO DA OCORRÊNCIA
    OCO.nome_municipio,  -- MUNICÍPIO ONDE OCORREU O FATO
    OCO.historico_ocorrencia  -- HISTÓRICO DETALHADO DA OCORRÊNCIA
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
WHERE 
    YEAR(OCO.data_hora_fato) BETWEEN 2018 AND 2022  -- INTERVALO TEMPORAL DAS OCORRÊNCIAS
    AND OCO.relator_sigla_orgao = 'PM'  -- OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR
    AND OCO.ocorrencia_uf = 'MG'  -- OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND OCO.descricao_estado = 'FECHADO'  -- SOMENTE OCORRÊNCIAS QUE JÁ FORAM FINALIZADAS (FECHADAS)
    AND OCO.natureza_codigo = 'X99000'  -- CÓDIGO ESPECÍFICO PARA NATUREZA
    AND (
	       OCO.historico_ocorrencia LIKE '%xxxxxxxxxx%'  -- FILTRA TEXTOS QUE MENCIONAM X
	       OR OCO.historico_ocorrencia LIKE '%xxxxxxxxxx%'  -- FILTRA TEXTOS QUE MENCIONAM X
        )
   -- AND OCO.unidade_area_militar_nome LIKE '%x BPM/x RPM%' -- FILTRE SUA BPM/ RPM 
   -- AND OCO.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
    ;
