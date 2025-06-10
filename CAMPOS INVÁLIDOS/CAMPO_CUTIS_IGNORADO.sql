/*---------------------------------------------------------------------------------------------------------------------------------
 * Este script SQL foi desenvolvido para analisar e quantificar os envolvidos em ocorrências registradas 
 * pela Polícia Militar de Minas Gerais  no período especificado. O objetivo é a identificação de registros que não possuem 
 * informação sobre a cor da pele ou que apresentam o código '9800' (IGNORADA). 
 ---------------------------------------------------------------------------------------------------------------------------------*/
-- seleciona colunas específicas para identificação do digitador e da unidade responsável
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Seleciona a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro para identificar a RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro para identificar o BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo da unidade responsável pelo registro segmento para identificar a CIA
    COUNT(ENV.numero_envolvido) AS TOTAL_ENVOLVIDO, -- Conta o total de envolvidos nas ocorrências
    SUM(CASE 
        WHEN ENV.cor_pele_codigo IS NULL OR ENV.cor_pele_codigo = '9800' -- Verifica ausência ou código específico de cor de pele IGNORADA
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800 -- Soma os registros com cor de pele ausente ou código '9800'
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
GROUP BY 1, 2, 3, 4 -- utiliza os índices das colunas para simplificar
ORDER BY 2, 3, 4;
