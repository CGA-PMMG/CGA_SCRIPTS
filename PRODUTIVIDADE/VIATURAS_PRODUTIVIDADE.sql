/*---------------------------------------------------------------------------------------------------------------------

 * Este código tem como objetivo fornecer detalhes específicos sobre as viaturas envolvidas em ocorrências policiais 
 * em Minas Gerais, detalhando aspectos como tipo de viatura e unidade a que pertence. A análise desses dados pode 
 * ser útil para gestão de recursos, planejamento operacional e auditorias internas, permitindo uma melhor compreensão
 * da distribuição e uso de viaturas em situações específicas de policiamento
 ---------------------------------------------------------------------------------------------------------------------
*/
-- Seleção de campos relacionados às viaturas envolvidas em ocorrências
SELECT 
    VT.numero_ocorrencia,  -- Número da ocorrência
    VT.numero_sequencial_viatura,  -- Número sequencial da viatura na ocorrência
    VT.descricao_tipo_viatura,  -- Descrição do tipo de viatura (ex: carro, moto, etc.)
    VT.unidade_servico_codigo,  -- Código da unidade de serviço a que a viatura pertence
    VT.unidade_servico_nome,  -- Nome da unidade de serviço
    VT.codigo_tipo_viatura,  -- Código do tipo de viatura
    VT.orgao_sigla  -- Sigla do órgão ao qual a viatura pertence
FROM 
    db_bisp_reds_reporting.tb_viatura_ocorrencia as VT -- Tabela que registra as viaturas envolvidas em ocorrências
 LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia as OCO ON OCO.numero_ocorrencia = VT.numero_ocorrencia  -- Junção com a tabela de ocorrências
WHERE 1 = 1 
AND OCO.digitador_id_orgao = 0 -- Filtra pelo ID do órgão digitador - PM 
AND OCO.ocorrencia_uf ='MG'                  -- Filtra apenas ocorrências de Minas Gerais
AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00.000' AND '2025-02-01 00:00:00.000'  -- Filtra ocorrências entre o periodo especificado
 --  AND OCO.unidade_responsavel_registro_nome LIKE '%xx BPM/xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	--  AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIOUEOP.
