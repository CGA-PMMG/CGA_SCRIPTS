/*------------------------------------------------------------------------------------------------------------------------------------
 * O objetivo deste script SQL é extrair informações detalhadas sobre ocorrências relacionadas a Serviços do Portifólio da PMMG.
 ------------------------------------------------------------------------------------------------------------------------------------*/
SELECT EMP.tipo_recurso_codigo,  -- Seleciona o código do tipo de recurso empenhado
EMP.tipo_recurso_descricao, -- Seleciona a descrição do tipo de recurso empenhado
OCO.numero_ocorrencia, -- Seleciona o número da ocorrência
OCO.data_hora_fato, -- Seleciona a data/hora fato da ocorrência
OCO.natureza_codigo, -- Seleciona o código da natureza da ocorrência
OCO.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
OCO.natureza_ind_consumado, -- Seleciona o indicação de consumação da natureza da ocorrência
OCO.historico_ocorrencia, -- Seleciona o histórico da ocorrência
OCO.numero_latitude, -- Seleciona o número latitude da ocorrência
OCO.numero_longitude, -- Seleciona o número longitude da ocorrência
OCO.codigo_municipio, -- Seleciona o código do município da ocorrência
OCO.nome_municipio, -- Seleciona o nome do município da ocorrência
OCO.nome_bairro, -- Seleciona o nome do bairro da ocorrência
OCO.tipo_logradouro_descricao, -- Seleciona a descrição do tipo de logradouro da ocorrência
OCO.logradouro_nome, -- Seleciona o nome do logradouro da ocorrência
OCO.numero_endereco, -- Seleciona o número do endereço da ocorrência
OCO.descricao_endereco, -- Seleciona a descrição do endereço da ocorrência
OCO.digitador_sigla_orgao, -- Seleciona a sigla órgão do digitador 
OCO.unidade_area_militar_nome, -- Seleciona o nome da unidade da área militar
OCO.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
OCO.ocorrencia_uf, -- Seleciona a UF da ocorrência
IR.chamada_numero, -- Seleciona o número da chamada
OCO.relator_matricula,
OCO.digitador_matricula
FROM db_bisp_reds_reporting.tb_ocorrencia OCO -- Tabela Ocorrência 
INNER JOIN db_bisp_cad_reporting.tb_integracao_reds IR -- Junção da tabela Ocorrência com a Integração Reds pelo número da ocorrência ( O campo numero_ocorrencia na tabela Integração Reds retorna em formato diferente da tabela de Ocorrência, o campo foi formatado através de funções)
ON OCO.numero_ocorrencia = CONCAT(SUBSTRING(IR.reds_numero, 1, 4), '-', SUBSTRING(IR.reds_numero, 5, 9), '-', SUBSTRING(IR.reds_numero, 14))
INNER JOIN db_bisp_cad_reporting.tb_empenho EMP -- Junção tabela Integração Reds com Emepenho, pelo ID da chamada atendimento
ON IR.chamada_atendimento_id = EMP.chamada_atendimento_id 
WHERE OCO.data_hora_fato >='2024-08-06' -- Filtra data/hora do fato
AND OCO.ocorrencia_uf ='MG'
--AND EMP.tipo_recurso_descricao LIKE '%x%' -- Filtra a decrição do tipo de recurso
--AND OCO.natureza_codigo = 'x' -- Filtra o código da natureza
--AND OCO.unidade_responsavel_registro_nome LIKE '%X RPM' -- Filtra nome da unidade responsável pelo registro
--AND OCO.unidade_area_militar_nome LIKE '%X RPM%' -- Filtra nome da unidade área militar
--AND OCO.relator_matricula = 'X' -- Filtra matrícula do relator
--AND OCO.digitador_matricula ='X' -- Filtra matrícula do digitador