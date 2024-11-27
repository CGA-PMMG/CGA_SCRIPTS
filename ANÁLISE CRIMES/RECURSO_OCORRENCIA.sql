/*﻿----------------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL foi desenvolvido para fornecer dados sobre ocorrências policiais e recursos empenhados 
 * permitindo uma análise indidualizado por viatura.
 ﻿----------------------------------------------------------------------------------------------------------------------------------------------*/
SELECT 
OCO.numero_ocorrencia, -- NUMERO OCORRENCIA
OCO.natureza_codigo, -- CÓDIGO DA NATUREZA DA OCORRÊNCIA
OCO.natureza_descricao, -- DESCRIÇÃO DA NATUREZA DA OCORRÊNCIA
VO.placa, -- PLACA DA VIATURA POLICIAL
VO.tipo, -- TIPO DA VIATURA POLICIAL
VO.descricao_tipo_viatura, -- DESCRIÇÃO DA VIATURA POLICIAL
OCO.unidade_responsavel_registro_nome,
FROM_TIMESTAMP(OCO.data_hora_fato,'dd/MM/yy') as 'data_fato', -- DATA DO FATO (ESTA LINHA SEGMENTA O CAMPO DATA HORA DO FATO, EXTRAINDO APENAS A DATA)
FROM_TIMESTAMP(OCO.data_hora_fato,'HH:mm') as 'hora_fato', -- HORA DO FATO (ESTA LINHA SEGMENTA O CAMPO DATA HORA DO FATO, EXTRAINDO APENAS A HORA)
VO.orgao_sigla -- SIGLA ORGAO DA VIATURA POLICIAL
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
LEFT JOIN db_bisp_reds_reporting.tb_viatura_ocorrencia VO on OCO.numero_ocorrencia = VO.numero_ocorrencia -- RETORNA OCORRÊNCIAS MESMO QUE NÃO TENHAM RECURSO RELACIONADO
WHERE YEAR(OCO.data_hora_fato) = :ANO -- PROMPT PARA FILTRAR ANO DO FATO
AND OCO.unidade_responsavel_registro_nome LIKE '%XX BPM/X RPM'-- FILTRA RPM/UEOP 
AND OCO.ind_estado = 'F' -- FILTRA ESTADO DA OCORRÊNCIA
AND OCO.ocorrencia_uf = 'MG' -- FILTRA UF
AND OCO.digitador_sigla_orgao = 'PM' -- FILTRA ORGÃO DIGITADOR DO REGISTRO
AND VO.placa = 'XXXXX' -- FILTRA PLACA DA VIATURA POLICIAL
