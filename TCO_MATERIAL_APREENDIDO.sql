/*------------------------------------------------------------------------------------------------------
Este script foi desenvolvido para retornar dados detalhados de ocorrências indicadas como 
TCO (Termo Circunstanciado de Ocorrência). Ele coleta e organiza informações gerais das ocorrências,
tipo de TCO, dados do envolvido e  material apreendido.
Este script garante que apenas as ocorrências classificadas como TCO sejam incluídas na busca. 
--------------------------------------------------------------------------------------------------------*/

SELECT OCO.ind_tco,                              -- INDICADOR TCO
       OCO.numero_ocorrencia,                    -- NUMERO OCORRENCIA
       ENV.envolvimento_descricao,               -- TIPO ENVOLVIMENTO DESCRICAO
       ENV.nome_completo_envolvido,              -- NOME COMPLETO ENVOLVIDO
       ENV.data_nascimento,                      -- DATA DE NASCIMENTO DO ENVOLVIDO
       ENV.nome_mae,                             -- NOME DA MAE DO ENVOLVIDO
       OCO.natureza_descricao,                   -- DESCRIÇAO DA NATUREZA DA OCORRENCIA
       TCO.numero_seq_tco,                       -- NUMERO SEQUENCIAL TCO
       TCO.codigo_tipo_tco,                      -- CODIGO DO TIPO DO TCO
       TCO.descricao_tipo_tco,                   -- DESCRIÇAO DO TIPO DO TCO
       MAO.quantidade_material,                  -- QUANTIDADE MATERIAL APREENDIDO
       MAO.unidade_medida_descricao,             -- DESCRIÇAO DA UNIDADE DE MEDIDA DO MATERIAL APREENDIDO
       MAO.tipo_objeto_descricao,                -- DESCRICAO DO TIPO DE MATERIAL APREENDIDO
       MAO.informacao_complementar,              -- INFORMAÇOES COMPLEMENTARES DO MATERIAL APREENDIDO
       MAO.situacao_descricao,                   -- DESCRIÇAO DA SITUAÇAO DO MATERIAL APREENDIDO
       OCO.unidade_area_militar_nome,            -- NOME DA UNIDADE AREA MILITAR
       OCO.unidade_responsavel_registro_nome,    -- NOME DA UNIDADE RESPONSAVEL PELO REGISTRO
       TCO.codigo_comarca,                       -- CODIGO DA COMACA TCO
       TCO.nome_comarca                          -- NOME DA COMARCA TCO
FROM tb_ocorrencia OCO                           
INNER JOIN tb_tco_ocorrencia TCO                 -- A NUM OCORRENCIA DEVE EXISTIR NAS DUAS TABELAS
ON OCO.numero_ocorrencia = TCO.numero_ocorrencia 
LEFT JOIN tb_material_apreendido_ocorrencia MAO  -- 
ON OCO.numero_ocorrencia = MAO.numero_ocorrencia -- 
INNER JOIN tb_envolvido_ocorrencia ENV 
ON OCO.numero_ocorrencia = ENV.numero_ocorrencia 
WHERE OCO.unidade_area_militar_nome LIKE '%X BPM%' -- FILTRA RPM/UEOP
AND YEAR(OCO.data_hora_fato)=2024                -- FILTRA ANO DO FATO
AND MONTH(OCO.data_hora_fato)=5                  -- FILTRA MES DO FATO
AND OCO.ind_tco ='S'                             -- FILTRA APENAS OCORRENCIAS COM INDICADOR DE TCO
ORDER BY OCO.numero_ocorrencia, TCO.numero_seq_tco 
 