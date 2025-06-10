/*---------------------------------------------------------------------------------------------------------------------
 * Este código sql tem como objetivo calcular e apresentar informações detalhadas sobre o total de envolvidos nas 
 * ocorrências  registradas pela Polícia Militar de Minas Gerais  no período especificado e, mais especificamente, 
 * quantificar quantos desses registros estão sem CPF ou CNPJ informado. 
 ---------------------------------------------------------------------------------------------------------------------*/
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Extrai a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento para identificar a RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento para identificar o BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo segmento para identificar a CIA
    COUNT(ENV.numero_envolvido) AS TOTAL_ENVOLVIDOS, -- conta o total de envolvidos nas ocorrências
    SUM(CASE 
        WHEN ENV.numero_cpf_cnpj IS NULL  -- Calcula quantos registros não possuem cpf/cnpj informado
        THEN 1 ELSE 0 
        END) AS Qtd_Null -- Soma os registros sem cpf/cnpj informado
-- tabelas e junções utilizadas para a consulta
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- junção das tabelas de ocorrência e envolvidos
-- filtros aplicados para a seleção dos dados
WHERE 1 = 1
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela polícia militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- Filtra pelos códigos de envolvimento: apenas vítimas
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- Exclui certas condições físicas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
  -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro
-- agrupamento dos dados para estruturar os resultados
GROUP BY MATRICULA_DIGITADOR, RPM, BPM, CIA
ORDER BY MATRICULA_DIGITADOR,RPM, BPM, CIA;
