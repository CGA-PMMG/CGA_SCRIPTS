/*----------------------------------------------------------------------------------------------------------------------------------
 * Este código sql foi desenvolvido para fornecer uma análise detalhada sobre a integridade dos dados de escolaridade dos envolvidos 
 * em ocorrências fechadas registradas pela polícia militar de minas gerais no ano de 2024. o foco principal está em identificar 
 * e quantificar os registros que não possuem informação sobre escolaridade ou que estão classificados com o código '9800' 
 * (informação ignorada). a consulta estrutura os resultados com base na hierarquia das unidades responsáveis (cia, bpm e rpm), 
 * permitindo uma visualização clara e ordenada para facilitar a interpretação e a análise dos dados.
 ----------------------------------------------------------------------------------------------------------------------------------*/
-- seleciona colunas específicas para identificação do digitador e da unidade responsável
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Extrai a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo segmento da unidade responsável pelo registro
    COUNT(ENV.numero_envolvido) AS total_envolvidos, -- Conta o total de envolvidos nas ocorrências
    SUM(CASE 
        WHEN ENV.escolaridade_codigo IS NULL OR ENV.escolaridade_codigo = '9800' -- Verifica ausência ou código específico de escolaridade
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800 -- Soma os registros com escolaridade ausente ou código '9800'
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
-- agrupamento dos dados para estruturar os resultados
GROUP BY OCO.digitador_matricula, RPM, BPM, CIA
-- ordenação dos resultados pela hierarquia da unidade
ORDER BY RPM, BPM, CIA;
