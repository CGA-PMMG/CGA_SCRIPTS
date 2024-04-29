/*﻿----------------------------------------------------------------------------------------------------------------------------
Este código SQL foi elaborado com o propósito de identificar e relatar informações sobre furtos de telefones celulares 
em Minas Gerais, durante o ano de 2024, conforme registros da Polícia Militar. 
Busca informações específicas sobre ocorrências relacionadas e materiais envolvidos.
----------------------------------------------------------------------------------------------------------------------------*/
SELECT OCO.numero_ocorrencia, -- NÚMERO DA OCORRÊNCIA
OCO.data_hora_fato, -- DATA HORA DO FATO
OCO.natureza_descricao, -- DESCRIÇÃO DA NATUREZA
MAO.tipo_objeto_codigo,  -- CÓDIGO DO TIPO DO OBJETO
MAO.tipo_objeto_descricao,  -- DESCRIÇÃO DO TIPO DO OBJETO
MAO.situacao_codigo,  -- CÓDIGO DA SITUAÇÃO DO MATERIAL APREENDIDO
MAO.situacao_descricao, -- DESCRIÇÃO DA SITUAÇÃO DO MATERIAL APREENDIDO
MAO.cor, -- COR DO MATERIAL
MAO.marca, -- MARCA DO MATERIAL
MAO.modelo, -- MODELO DO MATERIAL
MAO.informacao_complementar,  -- INFORMAÇÃO COMPLEMENTAR REFERENTE AO MATERIAL 
OCO.numero_endereco, -- Nº DO ENDEREÇO DO FATO
OCO.logradouro_nome, -- LOGRADOURO DO FATO
OCO.nome_bairro, -- BAIRRO DO FATO
OCO.nome_municipio, -- MUNICÍPIO DO FATO
OCO.numero_latitude, -- LATITUDE
OCO.numero_longitude,  -- LONGITUDE
MAO.numero_imei -- IMEI DO APARELHO
FROM tb_ocorrencia OCO
INNER JOIN tb_material_apreendido_ocorrencia MAO
ON OCO.numero_ocorrencia = MAO.numero_ocorrencia 
WHERE YEAR(OCO.data_hora_fato) = 2024 -- FILTRA O ANO DO FATO
 AND OCO.relator_sigla_orgao = 'PM' -- FILTRA OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
 AND OCO.ocorrencia_uf = 'MG' -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
 AND OCO.descricao_estado = 'FECHADO'  -- FILTRA APENAS OCORRÊNCIAS FECHADAS
 AND OCO.natureza_codigo = 'X01155' -- FILTRA CÓDIGO ESPECÍFICO DE NATUREZA DA OCORRÊNCIA (FURTO)
 AND MAO.tipo_objeto_codigo = '0902' -- FILTRA CÓDIGO ESPCÍFICO DE TIPO DO OBJETO (TELEFONE CELULAR)
 AND MAO.situacao_codigo IN ('0500','0700')  -- FILTRA CÓDIGO ESPCÍFICO DE SITUAÇÃO (FURTADO / ROUBADO (NAO RECUPERADO) OU RECUPERADO)
-- AND OCO.nome_municipio LIKE '%XXXXXX%' -- FILTRE A CIDADE
-- AND OCO.unidade_area_militar_nome LIKE '%/xxx BPM%' -- FILTRE A CIA/BPM/RPM 
 ORDER BY OCO.nome_bairro, OCO.nome_municipio  -- ORDERNA O NOME DO MUNICÍPIO E O BAIRRO 
