/*----------------------------------------------------------------------------------------------------------------
 * Este código SQL está projetado para extrair informações detalhadas relacionadas a chamadas de atendimento, 
 * eventos, empenhos e integrações de registros de eventos específicos dentro de um banco de dados CAD de relatórios 
 * da Polícia Militar. O foco é obter dados para chamadas atendidas por unidades específicas da PM.
 ---------------------------------------------------------------------------------------------------------------*/
-- SELECIONA AS COLUNAS DE INTERESSE DAS TABELAS CORRESPONDENTES
SELECT 
    tb_atendimento.chamada_id,                              -- ID DA CHAMADA DE ATENDIMENTO
    tb_atendimento.chamada_numero,                          -- NÚMERO DA CHAMADA DE ATENDIMENTO
    tb_evento.id_evento,                                    -- ID DO EVENTO ASSOCIADO
    tb_evento.descricao_evento,                             -- DESCRIÇÃO DO EVENTO
    tb_atendimento.data_hora_inicio_n,                      -- DATA E HORA DE INÍCIO DO ATENDIMENTO
    tb_atendimento.data_hora_fim_n,                         -- DATA E HORA DE FIM DO ATENDIMENTO
    tb_chamada_atendimento.chamada_id,                      -- ID DA CHAMADA NA TABELA DE CHAMADAS
    tb_chamada_atendimento.chamada_numero,                  -- NÚMERO DA CHAMADA
    tb_chamada_atendimento.chamada_data_hora_inclusao,      -- DATA E HORA DE INCLUSÃO DA CHAMADA
    tb_chamada_atendimento.chamada_classificacao_data_hora, -- DATA E HORA DA CLASSIFICAÇÃO DA CHAMADA
    tb_chamada_atendimento.chamada_classificacao_descricao, -- DESCRIÇÃO DA CLASSIFICAÇÃO DA CHAMADA
    tb_chamada_atendimento.orgao_sigla,                     -- SIGLA DO ÓRGÃO (PM)
    tb_chamada_atendimento.natureza_codigo,                 -- CÓDIGO DA NATUREZA DA CHAMADA
    tb_chamada_atendimento.natureza_descricao,              -- DESCRIÇÃO DA NATUREZA DA CHAMADA
    tb_chamada_atendimento.unidade_servico_nome,            -- NOME DA UNIDADE DE SERVIÇO
    tb_chamada_atendimento.chamada_atendimento_id,          -- ID DO ATENDIMENTO DA CHAMADA
    tb_empenho.recurso_tipo_empenho,                        -- TIPO DE EMPENHO DO RECURSO
    tb_empenho.tipo_recurso_codigo,                         -- CÓDIGO DO TIPO DE RECURSO
    tb_empenho.tipo_recurso_descricao,                      -- DESCRIÇÃO DO TIPO DE RECURSO
    tb_empenho.viatura_numero_prefixo,                      -- PREFIXO DA VIATURA
    tb_empenho.empenho_data_hora_inicio,                    -- DATA E HORA DE INÍCIO DO EMPENHO
    tb_empenho.empenho_data_hora_fim,                       -- DATA E HORA DE FIM DO EMPENHO
    CONCAT(SUBSTRING(tb_integracao_reds.reds_numero, 1, 4), '-', SUBSTRING(tb_integracao_reds.reds_numero, 5, 9), '-', SUBSTRING(tb_integracao_reds.reds_numero, 14)) AS reds_numero,  -- FORMATO DO NÚMERO DO REDS
    tb_situacao.empenho_situacao_descricao,                 -- DESCRIÇÃO DA SITUAÇÃO DO EMPENHO
    tb_situacao.empenho_situacao_data_hora_inicio,          -- DATA E HORA DE INÍCIO DA SITUAÇÃO DO EMPENHO
    tb_situacao.empenho_situacao_data_hora_fim              -- DATA E HORA DE FIM DA SITUAÇÃO DO EMPENHO
-- ESPECIFICA AS TABELAS E AS JUNÇÕES NECESSÁRIAS PARA ACESSAR AS INFORMAÇÕES
FROM 
    db_bisp_cad_reporting.tb_atendimento AS tb_atendimento
LEFT JOIN 
    db_bisp_cad_reporting.tb_chamada_atendimento AS tb_chamada_atendimento ON tb_atendimento.chamada_id = tb_chamada_atendimento.chamada_id
LEFT JOIN 
    db_bisp_cad_reporting.tb_empenho AS tb_empenho ON tb_chamada_atendimento.chamada_atendimento_id = tb_empenho.chamada_atendimento_id
LEFT JOIN 
    db_bisp_cad_reporting.tb_empenho_situacao AS tb_situacao ON tb_empenho.empenho_id = tb_situacao.empenho_id    
LEFT JOIN 
    db_bisp_cad_reporting.vw_chamada_evento AS tb_evento ON tb_empenho.chamada_atendimento_id = tb_evento.id_chamada_atendimento
LEFT JOIN 
    db_bisp_cad_reporting.tb_integracao_reds AS tb_integracao_reds ON tb_integracao_reds.chamada_atendimento_id = tb_empenho.chamada_atendimento_id
-- CONDIÇÕES PARA A FILTRAGEM DOS DADOS
WHERE 
    tb_chamada_atendimento.orgao_sigla = 'PM' -- FILTRA PELA SIGLA DA POLÍCIA MILITAR
    AND YEAR(tb_atendimento.data_hora_inicio_n) = 2024 -- FILTRA PELO ANO DE 2024
    AND MONTH(tb_atendimento.data_hora_inicio_n) BETWEEN 1 AND 3 -- FILTRA PELOS MESES DE JANEIRO A MARÇO
    AND (tb_chamada_atendimento.unidade_servico_nome LIKE '%/X BPM%' OR tb_chamada_atendimento.unidade_servico_nome LIKE '%/X BPM%' ) -- FILTRA PELAS UNIDADES ESPECÍFICAS DA PM
