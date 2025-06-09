/*----------------------------------------------------------------------------------------------------------------
 * Este código SQL está projetado para extrair informações detalhadas relacionadas a chamadas de atendimento, 
 * eventos, empenhos e integrações de registros de eventos específicos dentro de um banco de dados do CAD, 
 * oriundo de relatórios da Polícia Militar. O foco é obter dados para chamadas atendidas por unidades específicas 
 * da PM, com ênfase nos militares associados ao recurso e no tempo de atuação nas ocorrências.  
 ----------------------------------------------------------------------------------------------------------------*/

-- Início da cláusula SELECT: define os campos a serem extraídos da base de dados
SELECT 
    CA.chamada_id,                          -- Seleciona o identificador único da chamada 
    CA.chamada_numero,                      -- Seleciona o número da chamada de atendimento
    CA.chamada_data_hora_inclusao,          -- Seleciona a data e hora da inclusão da chamada
    CA.chamada_classificacao_data_hora,     -- Seleciona a data e hora da classificação da chamada
    CA.orgao_sigla,                         -- Seleciona a sigla do órgão responsável 
    CA.natureza_codigo,                     -- Seleciona o código da natureza atribuída à chamada
    CA.natureza_descricao,                  -- Seleciona a descrição da natureza atribuída à chamada
    CA.chamada_classificacao_descricao,     -- Seleciona a descrição da classificação da chamada
    CA.unidade_servico_nome,                -- Seleciona o nome da unidade de serviço
    CA.chamada_atendimento_id,              -- Seleciona o identificador único do atendimento vinculado à chamada
    EMP.recurso_tipo_empenho,               -- Seleciona o tipo do recurso empenhado 
    EMP.tipo_recurso_codigo,                -- Seleciona o código do tipo do recurso empenhado 
    EMP.tipo_recurso_descricao,             -- Seleciona a descrição tipo do recurso empenhado 
    EMP.viatura_numero_prefixo,             -- Seleciona o prefixo da viatura 
    EMP.empenho_data_hora_inicio,           -- Seleciona a data e hora de início do empenho do recurso
    EMP.empenho_data_hora_fim,              -- Seleciona a data e hora de término do empenho do recurso
    REC_COMP.funcao_componente_orgao_sigla, -- Seleciona a sigla do órgão do componente do recurso
    REC_COMP.nome_unidade,                  -- Seleciona o nome da unidade à qual o componente do recurso está vinculado
    REC_COMP.funcao_componente_codigo,      -- Seleciona o código da função desempenhada pelo militar (componente do recurso)
    REC_COMP.funcao_componente_descricao,   -- Seleciona a descrição da função desempenhada 
    REC_COMP.pessoa_codigo_usuario,         -- Seleciona o código de identificação do usuário (matricula)
    REC_COMP.pessoa_cargo_efetivo,          -- Seleciona o cargo efetivo do componente 
    REC_COMP.pessoa_id,                     -- Seleciona o identificador único  do militar
    REC_COMP.pessoa_nome,                   -- Seleciona o nome completo do militar
    REC_COMP.pessoa_sexo,                   -- Seleciona o sexo da do militar
    REC_COMP.pessoa_codigo_status,          -- Seleciona o código de status funcional do militar
    SIT_EMP.empenho_situacao_descricao,     -- Seleciona  a descrição da situação do empenho 
    SIT_EMP.empenho_situacao_data_hora_inicio, -- Seleciona a data e hora de início da situaçãodo empenho registrada
    SIT_EMP.empenho_situacao_data_hora_fim, --Seleciona o data e hora de fim da situação do empenho registrada
    REDS.reds_numero                        -- Número da ocorrência gerada
-- Especifica as tabelas envolvidas na consulta e estabelece as junções necessárias
FROM db_bisp_cad_reporting.tb_chamada_atendimento AS CA            -- Tabela principal contendo os atendimentos   
LEFT JOIN db_bisp_cad_reporting.tb_empenho AS EMP ON CA.chamada_atendimento_id = EMP.chamada_atendimento_id        -- Junção com os empenhos relacionados
LEFT JOIN db_bisp_cad_reporting.tb_recurso_componente AS REC_COMP  ON EMP.recurso_id = REC_COMP.recurso_id                          -- Junção com dados dos componentes dos recursos
LEFT JOIN db_bisp_cad_reporting.vw_chamada_evento AS EV  ON EMP.chamada_atendimento_id = EV.id_chamada_atendimento        -- Junção com a visão de eventos das chamadas
LEFT JOIN db_bisp_cad_reporting.tb_empenho_situacao AS SIT_EMP  ON EMP.empenho_id = SIT_EMP.empenho_id                           -- Junção com as situações de cada empenho
LEFT JOIN db_bisp_cad_reporting.tb_integracao_reds AS REDS  ON REDS.chamada_atendimento_id = EMP.chamada_atendimento_id      -- Junção com a integração de chamadas ao sistema REDS
-- Aplica filtros para restringir os dados conforme os critérios estabelecidos
WHERE 1 = 1                                                          -- Condição inicial verdadeira (facilita adições de filtros)
    AND CA.orgao_sigla = 'PM'                                        -- Filtra apenas registros da Polícia Militar
    AND CA.unidade_servico_nome LIKE '%/X BPM%'                      -- Filtro opcional por unidade específica (comentado)
    AND CA.empenho_data_hora_inicio  BETWEEN '2025-01-01 00:00:00' AND '2025-02-01 00:00:00'       -- Filtra registros com início de empenho no mês de janeiro de 2025
