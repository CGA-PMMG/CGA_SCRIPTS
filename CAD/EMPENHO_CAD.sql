/*----------------------------------------------------------------------------------------------------------------
 * Este código SQL está projetado para extrair informações detalhadas relacionadas a chamadas de atendimento, 
 * eventos, empenhos e integrações de registros de eventos específicos dentro de um banco de dados CAD de relatórios 
 * da Polícia Militar. O foco é obter dados para chamadas atendidas por unidades específicas da PM.
 ---------------------------------------------------------------------------------------------------------------*/
-- SELECIONA AS COLUNAS DE INTERESSE DAS TABELAS CORRESPONDENTES
SELECT 
    AT.chamada_id,                              -- ID DA CHAMADA DE ATENDIMENTO
    AT.chamada_numero,                          -- NÚMERO DA CHAMADA DE ATENDIMENTO
    EV.id_evento,                                    -- ID DO EVENTO ASSOCIADO
    EV.descricao_evento,                             -- DESCRIÇÃO DO EVENTO
    AT.data_hora_inicio_n,                      -- DATA E HORA DE INÍCIO DO ATENDIMENTO
    AT.data_hora_fim_n,                         -- DATA E HORA DE FIM DO ATENDIMENTO
    CA.chamada_id,                      -- ID DA CHAMADA NA TABELA DE CHAMADAS
    CA.chamada_numero,                  -- NÚMERO DA CHAMADA
    CA.chamada_data_hora_inclusao,      -- DATA E HORA DE INCLUSÃO DA CHAMADA
    CA.chamada_classificacao_data_hora, -- DATA E HORA DA CLASSIFICAÇÃO DA CHAMADA
    CA.chamada_classificacao_descricao, -- DESCRIÇÃO DA CLASSIFICAÇÃO DA CHAMADA
    CA.orgao_sigla,                     -- SIGLA DO ÓRGÃO (PM)
    CA.natureza_codigo,                 -- CÓDIGO DA NATUREZA DA CHAMADA
    CA.natureza_descricao,              -- DESCRIÇÃO DA NATUREZA DA CHAMADA
    CA.unidade_servico_nome,            -- NOME DA UNIDADE DE SERVIÇO
    CA.chamada_atendimento_id,          -- ID DO ATENDIMENTO DA CHAMADA
    EMP.recurso_tipo_empenho,                        -- TIPO DE EMPENHO DO RECURSO
    EMP.tipo_recurso_codigo,                         -- CÓDIGO DO TIPO DE RECURSO
    EMP.tipo_recurso_descricao,                      -- DESCRIÇÃO DO TIPO DE RECURSO
    EMP.viatura_numero_prefixo,                      -- PREFIXO DA VIATURA
    EMP.empenho_data_hora_inicio,                    -- DATA E HORA DE INÍCIO DO EMPENHO
    EMP.empenho_data_hora_fim,                       -- DATA E HORA DE FIM DO EMPENHO
    REDS.reds_numero, -- NÚMERO DO REDS
    SIT_EMP.empenho_situacao_descricao,                 -- DESCRIÇÃO DA SITUAÇÃO DO EMPENHO
    SIT_EMP.empenho_situacao_data_hora_inicio,          -- DATA E HORA DE INÍCIO DA SITUAÇÃO DO EMPENHO
    SIT_EMP.empenho_situacao_data_hora_fim              -- DATA E HORA DE FIM DA SITUAÇÃO DO EMPENHO
-- ESPECIFICA AS TABELAS E AS JUNÇÕES NECESSÁRIAS PARA ACESSAR AS INFORMAÇÕES
FROM db_bisp_cad_reporting.tb_atendimento AS AT
LEFT JOIN  db_bisp_cad_reporting.tb_chamada_atendimento AS CA ON AT.chamada_id = CA.chamada_id
LEFT JOIN db_bisp_cad_reporting.tb_empenho AS EMP ON CA.chamada_atendimento_id = EMP.chamada_atendimento_id
LEFT JOIN db_bisp_cad_reporting.tb_empenho_situacao AS SIT_EMP ON EMP.empenho_id = SIT_EMP.empenho_id    
LEFT JOIN db_bisp_cad_reporting.vw_chamada_evento AS EV ON EMP.chamada_atendimento_id = EV.id_chamada_atendimento
LEFT JOIN  db_bisp_cad_reporting.tb_integracao_reds AS REDS ON REDS.chamada_atendimento_id = EMP.chamada_atendimento_id
-- CONDIÇÕES PARA A FILTRAGEM DOS DADOS
WHERE 1 = 1
    AND CA.orgao_sigla = 'PM' -- FILTRA PELA SIGLA DA POLÍCIA MILITAR
    AND CA.unidade_servico_nome LIKE '%/X BPM%'-- FILTRA PELAS UNIDADES ESPECÍFICAS DA PM
    AND AT.data_hora_inicio_n BETWEEN '2025-01-01 00:00:00' AND '2025-02-01 00:00:00'
