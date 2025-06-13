/*--------------------------------------------------------------------------------------------------------------------------------------------------------------
 *  Este script foi desenvolvido para retornar dados detalhados de ocorrências indicadas como TCO (Termo Circunstanciado de Ocorrência). Ele coleta e organiza 
 *  informações gerais das ocorrências, tipo de TCO, dados do envolvido e material apreendido. Este script garante que apenas as ocorrências classificadas 
 *  como TCO sejam incluídas na busca. 
 *------------------------------------------------------------------------------------------------------------------------------------------------------------ */
SELECT OCO.ind_tco,                              -- Seleciona o indicador que classifica a ocorrência como TCO
       OCO.numero_ocorrencia,                    -- Seleciona o número identificador da ocorrência
       ENV.envolvimento_descricao,               -- Seleciona a descrição do tipo de envolvimento do indivíduo na ocorrência
       ENV.nome_completo_envolvido,              -- Seleciona o nome completo do envolvido na ocorrência
       ENV.data_nascimento,                      -- Seleciona a data de nascimento do envolvido
       ENV.nome_mae,                             -- Seleciona o nome da mãe do envolvido
       OCO.natureza_descricao,                   -- Seleciona a descrição da natureza da ocorrência
       TCO.numero_seq_tco,                       -- Seleciona o número sequencial do TCO
       TCO.codigo_tipo_tco,                      -- Seleciona o código do tipo de TCO
       TCO.descricao_tipo_tco,                   -- Seleciona a descrição do tipo de TCO
       MAO.quantidade_material,                  -- Seleciona a quantidade de material apreendido
       MAO.unidade_medida_descricao,             -- Seleciona a unidade de medida do material apreendido
       MAO.tipo_objeto_descricao,                -- Seleciona a descrição do tipo de objeto/material apreendido
       MAO.informacao_complementar,              -- Seleciona as informações complementares relacionadas ao material
       MAO.situacao_descricao,                   -- Seleciona a descrição da situação do material apreendido
       OCO.unidade_area_militar_nome,            -- Seleciona o nome da unidade da área militar responsável pela ocorrência
       OCO.unidade_responsavel_registro_nome,    -- Seleciona o nome da unidade responsável pelo registro da ocorrência
       TCO.codigo_comarca,                       -- Seleciona o código da comarca onde foi lavrado o TCO
       TCO.nome_comarca                          -- Seleciona o nome da comarca onde foi lavrado o TCO
FROM db_bisp_reds_reporting.tb_ocorrencia OCO                           -- Define a tabela principal de ocorrências
INNER JOIN db_bisp_reds_reporting.tb_tco_ocorrencia TCO                 -- Realiza junção obrigatória com a tabela de TCOs por número da ocorrência
	ON OCO.numero_ocorrencia = TCO.numero_ocorrencia 
INNER JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV           -- Realiza junção obrigatória com a tabela de envolvidos na ocorrência
	ON OCO.numero_ocorrencia = ENV.numero_ocorrencia 
LEFT JOIN db_bisp_reds_reporting.tb_material_apreendido_ocorrencia MAO  -- Realiza junção opcional com a tabela de materiais apreendidos
	ON OCO.numero_ocorrencia = MAO.numero_ocorrencia                        -- Relaciona o material apreendido à ocorrência
WHERE 1 = 1
AND OCO.ind_tco ='S'                                                    -- Garante que apenas ocorrências com indicador de TCO sejam selecionadas
--AND OCO.unidade_area_militar_nome LIKE '%X BPM%'                      -- Filtra as ocorrências por nome da unidade militar (RPM ou UEOP)
AND YEAR(OCO.data_hora_fato)= :ANO                                      -- Prompt para filtrar o ano da data hora do fato 
AND MONTH(OCO.data_hora_fato)=:MES                                         -- Prompt para filtrar o mês da data hora do fato
ORDER BY OCO.numero_ocorrencia, TCO.numero_seq_tco                      -- Ordena os resultados por número da ocorrência e sequência do TCO
