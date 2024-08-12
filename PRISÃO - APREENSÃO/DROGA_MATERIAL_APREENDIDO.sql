/*-------------------------------------------------------------------------------------------------
 * Este script SQL tem como objetivo selecionar e filtrar dados específicos de ocorrências de
 *  apreensão de materiais relacionados a drogas.
 -------------------------------------------------------------------------------------------------*/
SELECT MAO.numero_ocorrencia, -- Seleciona o número da ocorrêmcoa
MAO.tipo_objeto_codigo, -- Seleciona o código do tipo do objeto
MAO.tipo_objeto_descricao, -- Seleciona a descrição do tipo do objeto
MAO.quantidade_material, -- Seleciona a quantidade de material apreendido
MAO.unidade_medida_descricao,  -- Seleciona a descrição da unidade de medida
MAO.motivo_apreencao_descricao, -- Seleciona a descrição do motivo da apreensão
MAO.situacao_descricao, -- Seleciona a descrição da situação do material
MAO.unidade_responsavel_registro_nome -- Seleciona a unidade responsável pelo registro
FROM tb_material_apreendido_ocorrencia MAO -- Tabela de material apreendido na ocorrência
WHERE YEAR(MAO.data_hora_fato) = 2024 --Filtra ano da data/hora do fato
AND MONTH(MAO.data_hora_fato) BETWEEN 1 AND 3 -- Filtra mês da data/hora do fato dentro do intervalo especificado
AND MAO.digitador_id_orgao = 0 -- Filtra ID do orgão digitador, PM
AND MAO.unidade_responsavel_registro_nome LIKE '%X RPM%' -- Filtra a unidade responsável pleo registro
AND MAO.tipo_objeto_codigo IN('5800', '5599','5999','5699','5301','5503','5104','5399','5103','5102','5299',
'5603','5202','5605','5201','5499','5604','5601','5602','5302','5704','5101','5504','5199','5708') 
-- Filtra códigos relacionados a droga, são elas: MERLA, OUTROS - INALAVEIS, OUTROS - OPIACEOS, OUTROS - MACONHA
--HAXIXE EM BOLA, LANCA-PERFUME, PINO DE COCAINA, OUTROS - HAXIXE, COCAINA EM PO, PASTA DE COCAINA, OUTROS - CRACK
--PLANTACAO (PE) DE MACONHA, CRACK EM QUILOGRAMAS, SEMENTE DE MACONHA, CRACK EM PEDRAS, OUTROS - LSD
--MACONHA PRENSADA (BARRA / TABLETE), BUCHA DE MACONHA, CIGARRO DE MACONHA, HAXIXE EM TABLETE (QUILOGRAMA)
--ECSTASY / MDMA, PAPELOTES DE COCAINA, LOLO, OUTROS - COCAINA, DROGAS K
;