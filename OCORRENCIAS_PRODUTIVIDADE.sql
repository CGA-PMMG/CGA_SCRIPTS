/*----------------------------------------------------------------------------------------------------------------------
 * Este código visa coletar informações abrangentes sobre ocorrências policiais em Minas Gerais, detalhando aspectos 
 * como o tipo de ocorrência, localização, envolvimento e procedimentos subsequentes. A intenção é fornecer uma 
 * base de dados rica para análises, relatórios e aprimoramento das operações de segurança, focando nas unidades.
 ----------------------------------------------------------------------------------------------------------------------*/
-- Selecionando detalhes específicos de cada ocorrência registrada
SELECT 
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato,  -- Data e hora do fato ocorrido
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_comunicacao,  -- Data e hora quando o fato foi comunicado
    db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia,  -- Número identificador da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.descricao_estado,  -- Estado da ocorrência (ex: Fechado, Aberto)
    db_bisp_reds_reporting.tb_ocorrencia.nome_tipo_relatorio,  -- Tipo de relatório (ex: Policial, REFAP, Trânsito)
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_fechamento,  -- Data e hora do fechamento da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.natureza_codigo,  -- Código da natureza principal da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_codigo,  -- Código da primeira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_codigo,  -- Código da segunda natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_codigo,  -- Código da terceira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.logradouro_nome,  -- Nome do logradouro onde ocorreu o fato
    db_bisp_reds_reporting.tb_ocorrencia.tipo_logradouro_descricao,  -- Descrição do tipo de logradouro
    db_bisp_reds_reporting.tb_ocorrencia.numero_endereco,  -- Número no endereço do fato
    db_bisp_reds_reporting.tb_ocorrencia.nome_bairro,  -- Nome do bairro onde ocorreu o fato
    db_bisp_reds_reporting.tb_ocorrencia.codigo_municipio,  -- Código do município
    db_bisp_reds_reporting.tb_ocorrencia.nome_municipio,  -- Nome do município
    db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf,  -- Estado onde a ocorrência foi registrada (MG)
    db_bisp_reds_reporting.tb_ocorrencia.tipo_local_descricao,  -- Descrição do tipo de local onde ocorreu o fato
    db_bisp_reds_reporting.tb_ocorrencia.numero_latitude,  -- Latitude do local do fato
    db_bisp_reds_reporting.tb_ocorrencia.numero_longitude,  -- Longitude do local do fato
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_codigo,  -- Código da unidade responsável pelo registro
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome,  -- Nome da unidade responsável pelo registro
    db_bisp_reds_reporting.tb_ocorrencia.sqtempo_fato,  -- Sequencial de tempo do fato
    db_bisp_reds_reporting.tb_ocorrencia.ind_estado,  -- Indicador de estado da ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.descricao_tipo_relatorio,  -- Descrição do tipo de relatório
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_inclusao,  -- Data e hora da inclusão do registro no sistema
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_alteracao,  -- Data e hora da última alteração do registro
    db_bisp_reds_reporting.tb_ocorrencia.operacao_codigo,  -- Código da operação associada
    db_bisp_reds_reporting.tb_ocorrencia.operacao_descricao,  -- Descrição da operação
    db_bisp_reds_reporting.tb_ocorrencia.natureza_descricao,  -- Descrição da natureza principal
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria1_descricao,  -- Descrição da primeira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria2_descricao,  -- Descrição da segunda natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.natureza_secundaria3_descricao,  -- Descrição da terceira natureza secundária
    db_bisp_reds_reporting.tb_ocorrencia.tipo_local_codigo,  -- Código do tipo de local
    db_bisp_reds_reporting.tb_ocorrencia.modo_acao_criminosa,  -- Modo de ação criminosa descrito
    db_bisp_reds_reporting.tb_ocorrencia.descricao_endereco,  -- Descrição completa do endereço
    db_bisp_reds_reporting.tb_ocorrencia.relator_nome,  -- Nome do relator do registro
    db_bisp_reds_reporting.tb_ocorrencia.relator_cargo,  -- Cargo do relator
    db_bisp_reds_reporting.tb_ocorrencia.ind_tco,  -- Indicador se foi lavrado um Termo Circunstanciado de Ocorrência
    db_bisp_reds_reporting.tb_ocorrencia.data_hora_final,  -- Data e hora final registrada para o fato
    db_bisp_reds_reporting.tb_ocorrencia.numero_atividade_cad,  -- Número da atividade no sistema CAD
    db_bisp_reds_reporting.tb_ocorrencia.numero_chamada_cad,  -- Número da chamada no sistema CAD
    db_bisp_reds_reporting.tb_ocorrencia.numero_chamada_principal_cad,  -- Número da chamada principal no sistema CAD
    db_bisp_reds_reporting.tb_ocorrencia.digitador_cargo_efetivo,  -- Cargo efetivo do digitador
    db_bisp_reds_reporting.tb_ocorrencia.digitador_nome  -- Nome do digitador
FROM 
    db_bisp_reds_reporting.tb_ocorrencia -- Tabela de ocorrências
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) >= 2018 -- Filtro pelo ano do fato (2018 a 2022)
    and YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) <= 2022
    and (db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%CPRV%' -- Filtro pelas unidades de polícia rodoviária
    or db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%BPMRV%') -- Incluindo CPRV e BPMRV
 -- AND db_bisp_reds_reporting.tb_ocorrencia.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO
