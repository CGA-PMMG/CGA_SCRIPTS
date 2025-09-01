/*----------------------------------------------------------------------------------------------------------------
 * Este código SQL está projetado para extrair informações detalhadas relacionadas a chamadas de atendimento, 
 * eventos, empenhos e integrações de registros de eventos específicos dentro de um banco de dados CAD de relatórios 
 * da Polícia Militar. O foco é obter dados para chamadas atendidas por unidades específicas da PM.
 ---------------------------------------------------------------------------------------------------------------*/
SELECT
EMP.recurso_tipo_empenho,                        -- TIPO DE EMPENHO DO RECURSO
EMP.tipo_recurso_codigo,                         -- CÓDIGO DO TIPO DE RECURSO
EMP.tipo_recurso_descricao,                      -- DESCRIÇÃO DO TIPO DE RECURSO
EMP.viatura_numero_prefixo,                      -- PREFIXO DA VIATURA
EMP.empenho_data_hora_inicio,                    -- DATA E HORA DE INÍCIO DO EMPENHO
EMP.empenho_data_hora_fim,                       -- DATA E HORA DE FIM DO EMPENHO 
CA.chamada_id,                      -- ID DA CHAMADA NA TABELA DE CHAMADAS
CA.chamada_numero,                  -- NÚMERO DA CHAMADA
CA.chamada_data_hora_inclusao,      -- DATA E HORA DE INCLUSÃO DA CHAMADA
CA.chamada_classificacao_data_hora, -- DATA E HORA DA CLASSIFICAÇÃO DA CHAMADA
CA.chamada_classificacao_descricao, -- DESCRIÇÃO DA CLASSIFICAÇÃO DA CHAMADA
CA.orgao_sigla,                     -- SIGLA DO ÓRGÃO (PM)
CA.natureza_codigo,                 -- CÓDIGO DA NATUREZA DA CHAMADA
CA.natureza_descricao,              -- DESCRIÇÃO DA NATUREZA DA CHAMADA
CA.unidade_servico_nome,            -- NOME DA UNIDADE DE SERVIÇO
SPLIT_PART(LO.unidade_area_militar_nome,'/',-1) RPM, -- PRIMEIRA POSIÇÃO DA DIRETA PRA ESQUERDA DA UNIDADE DE AREA MILITAR, REPRESENTA A RPM
SPLIT_PART(LO.unidade_area_militar_nome,'/',-2) UEOP, -- SEGUNDA POSIÇÃO DA DIRETA PRA ESQUERDA DA UNIDADE DE AREA MILITAR, REPRESENTA A UEOP
LO.unidade_area_militar_nome -- NOME DA UNIDADE DE AREA MILITAR 
FROM db_bisp_cad_reporting.tb_empenho EMP 
INNER JOIN db_bisp_cad_reporting.tb_chamada_atendimento CA ON EMP.chamada_atendimento_id = CA.chamada_atendimento_id
INNER JOIN db_bisp_cad_reporting.tb_chamada TC ON TC.id_chamada = CA.chamada_id
LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg LO ON LO.id_local = TC.id_local 
--INNER JOIN db_bisp_reds_reporting.tb_ocorrencia AS OCO ON CA.chamada_numero = OCO.numero_chamada_cad  
WHERE 1 = 1
AND EMP.unidade_servico_codigo_tipo  = 'PM' 
AND EMP.tipo_recurso_codigo = 'x'
AND EMP.viatura_numero_prefixo IN ('123a', '123b',' 123c')
--AND CA.unidade_servico_nome LIKE '%22 BPM%'-- FILTRA PELA UNIDADE DE SERVIÇO
--AND LO.unidade_area_militar_nome LIKE '%22 BPM%'-- FILTRA PELA UNIDADE DE AREA
AND EMP.empenho_data_hora_inicio  BETWEEN '2025-01-01 00:00:00' AND '2025-08-24 23:59:59' -- DATA HORA DO INICIO DO EMPENHO
ORDER BY EMP.viatura_numero_prefixo, EMP.empenho_data_hora_inicio
