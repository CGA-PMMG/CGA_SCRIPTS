/*﻿-----------------------------------------------------------------------------------------------------------------------------------------
 * Este script SQL foi projetado para fornecer uma visão geral das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais
 *  no período especificado. O principal objetivo é avaliar ocorrências que, por ventura, tenham sido registradas sem LOGRADOURO válido na base.
 ﻿-----------------------------------------------------------------------------------------------------------------------------------------*/
SELECT 
	oco.numero_ocorrencia,
    oco.digitador_matricula AS MATRICULA_DIGITADOR, -- Extrai a matrícula do digitador responsável pelo registro
    SPLIT_PART(oco.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro para identificar a RPM
    SPLIT_PART(oco.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro para identificar o BPM
    SPLIT_PART(oco.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo da unidade responsável pelo registro segmento para identificar a CIA
    oco.logradouro_nome AS endereco_valido, -- logradouro automatizado do GeoPM
	oco.descricao_endereco  AS endereco_fora_base, 	 -- logradouro automatizado do GeoPM
	oco.descricao_complemento_endereco AS complemento_endereco,
	oco.numero_latitude,
	oco.numero_longitude
FROM db_bisp_reds_reporting.tb_ocorrencia oco
WHERE 1=1 
AND oco.logradouro_nome IS NULL			-- seleciona ocorrencias sem numero de logradouro automatico da base
  AND oco.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela Polícia Militar
  AND oco.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND oco.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
--  AND oco.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND oco.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
 -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro
GROUP BY OCO.digitador_matricula, RPM, BPM, CIA
-- ordenação dos resultados pela hierarquia da unidade
ORDER BY RPM, BPM, CIA
;