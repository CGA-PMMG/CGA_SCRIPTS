/*----------------------------------------------------------------------------------------------------------------------------------
 * Este script SQL foi desenvolvido para fornecer uma análise detalhada sobre a integridade dos dados de escolaridade dos envolvidos 
 * em ocorrências fechadas registradas pela Polícia Militar de Minas Gerais no período especificado. O objetivo está em identificar 
 * e quantificar os registros que não possuem informação sobre escolaridade ou que estão classificados com o código '9800' 
 * (ESCOLARIDADE - IGNORADA).
 ----------------------------------------------------------------------------------------------------------------------------------*/
-- seleciona colunas específicas para identificação do digitador e da unidade responsávelpelo registro
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Seleciona a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro para identificar a RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro para identificar o BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo da unidade responsável pelo registro segmento para identificar a CIA
    COUNT(ENV.numero_envolvido) AS total_envolvidos, -- Conta o total de envolvidos nas ocorrências
    SUM(CASE 
        WHEN ENV.escolaridade_codigo IS NULL OR ENV.escolaridade_codigo = '9800' -- Verifica ausência ou ESCOLARIDADE - IGNORADA
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800 -- Soma os registros com escolaridade ausente ou código '9800' (ESCOLARIDADE - IGNORADA)
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- junção das tabelas de ocorrência e envolvidos
WHERE 1 = 1
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela polícia militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- Filtra pelos códigos de envolvimento: apenas vítimas
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- Exclui certas condições físicas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
   -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro (opcional)
-- agrupamento dos dados para estruturar os resultados
GROUP BY OCO.digitador_matricula, RPM, BPM, CIA
-- ordenação dos resultados pela hierarquia da unidade
ORDER BY RPM, BPM, CIA;
