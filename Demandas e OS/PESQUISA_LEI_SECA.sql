/*--------------------------------------------------------------------------------------------------------------------------------------------------
 * Coleção de scrips Lei Seca
 -------------------------------------------------------------------------------------------------------------------------------------------------*/

--Qtde de AIT embriaguez em Op Lei Seca RESUMO
SELECT 
OCO.nome_municipio, -- Seleciona o nome do município da ocorrência
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2020 THEN AIT.codigo END) AS Qtde_2020, -- Contador do número de códigos (tabela Infração Ocorrência) do ano 2020
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2021 THEN AIT.codigo END) AS Qtde_2021, -- Contador do número  de códigos (tabela Infração Ocorrência) do ano 2021
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2022 THEN AIT.codigo END) AS Qtde_2022, -- Contador do número  de códigos (tabela Infração Ocorrência) do ano 2022
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2023 THEN AIT.codigo END) AS Qtde_2023, -- Contador do número  de códigos (tabela Infração Ocorrência) do ano 2023
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2024 AND MONTH(OCO.data_hora_fato) IN (1,2,3,4,5,6,7) THEN AIT.codigo END) AS Qtde_2024 -- Contador do número  de códigos (tabela Infração Ocorrência) do ano 2024 dos meses de Janeiro a Julho
FROM 
db_bisp_reds_reporting.tb_infracao_ocorrencia AIT -- Tabela Infração Ocorrência
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO -- Junção com a tabela Ocorrência através do número da ocorrência
ON AIT.numero_ocorrencia = OCO.numero_ocorrencia 
WHERE 
AIT.codigo in ('51691','5169-1','516901','51692','5169-2','516902','75790') -- Filtra as infrações realcionadas a embreaguez e recusa
AND OCO.data_hora_fato BETWEEN '2020-01-01' AND '2024-07-31' -- Filtra a data/hora do fato dentre do intervalo especificado
AND OCO.digitador_sigla_orgao = 'PM' -- Filtra a sigla do orgão do digitador Policia Militar
AND OCO.ocorrencia_uf ='MG' -- Filtra Uf da ocorrência Minas Gerais
AND OCO.ind_estado = 'F' -- Filtra estado da ocorrência Fechado
AND OCO.operacao_codigo ='Y04012' -- Filtra código da operação da ocorrência Operação Lei Seca
GROUP BY 1 -- Agrupa pelo nome do município
ORDER BY 1 -- Ordena pelo número do município
;

--Qtde de prisões por embriaguez em Op Lei Seca RESUMO
SELECT 
OCO.nome_municipio, -- Seleciona o nome do município da ocorrência
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2020 THEN ENV.numero_envolvido END) AS Qtde_2020, -- Contador do número de prisões do ano 2020
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2021 THEN ENV.numero_envolvido END) AS Qtde_2021, -- Contador do número de prisões do ano 2021
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2022 THEN ENV.numero_envolvido END) AS Qtde_2022, -- Contador do número de prisões do ano 2022
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2023 THEN ENV.numero_envolvido END) AS Qtde_2023, -- Contador do número de prisões do ano 2023
COUNT(CASE WHEN YEAR(OCO.data_hora_fato)= 2024 AND MONTH(OCO.data_hora_fato) IN (1,2,3,4,5,6,7) THEN ENV.numero_envolvido END) AS Qtde_2024 -- Contador do número de prisões do ano 2024 dos meses de Janeiro a Julho
--COUNT(ENV.numero_envolvido)qtde_prisoes_embriaguez
--MONTH (OCO.data_hora_fato) mes_fato
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV -- Tabela envolvido  
inner JOIN db_bisp_reds_reporting.tb_ocorrencia OCO -- Junção com a tabela Ocorrência, pelo número da ocorrência
ON ENV.numero_ocorrencia = OCO.numero_ocorrencia 
WHERE 
OCO.data_hora_fato BETWEEN '2020-01-01' AND '2024-07-31' -- Filtra data/hora do fato dentro do intervalo especificado 
AND OCO.digitador_sigla_orgao = 'PM' -- Filtra sigla do orgão digitador Policia Militar
AND OCO.ocorrencia_uf ='MG' -- FIltra UF da ocorrência Minas Gerais
AND OCO.ind_estado = 'F' -- Filtra estado da ocorrência Fechado
AND ENV.natureza_ocorrencia_codigo ='T10306' -- Filtra código da naturza da ocorrência 'CONDUZIR VEICULO SOB INFLUENCIA DE ALCOOL/SUBST. PSICOATIVA'
AND ENV.envolvimento_descricao in ('CONDUTOR DO VEICULO','CONDUTOR DE VEICULO E VITIMA') -- Filtra descrição do envolvimento
AND ENV.tipo_prisao_apreensao_descricao in('FLAGRANTE DE ATO INFRACIONAL','FLAGRANTE DE CRIME / CONTRAVEN') -- Filtra descrição do tipo prisão/apreensão
--AND OCO.operacao_codigo ='Y04012' -- Filtre o código da operação 
--AND OCO.nome_municipio ='BELO HORIZONTE'  -- Filtre o nome do município
GROUP BY 1 -- Agrupa pelo nome do município
ORDER BY 1; -- Orderna pelo nome do município 



--Quantidade de motoristas autuados em operações Y04012
SELECT
oco.nome_municipio, -- Nome do município
SUM(CASE WHEN YEAR(oco.data_hora_fato)= 2020 THEN rat_prod.quantidade else 0 END) AS Qtde_2020, -- Soma das quantidades para o ano de 2020
SUM(CASE WHEN YEAR(oco.data_hora_fato)= 2021 THEN rat_prod.quantidade else 0 END) AS Qtde_2021, -- Soma das quantidades para o ano de 2021
SUM(CASE WHEN YEAR(oco.data_hora_fato)= 2022 THEN rat_prod.quantidade else 0 END) AS Qtde_2022, -- Soma das quantidades para o ano de 2022
SUM(CASE WHEN YEAR(oco.data_hora_fato)= 2023 THEN rat_prod.quantidade else 0 END) AS Qtde_2023, -- Soma das quantidades para o ano de 2023
SUM(CASE WHEN YEAR(oco.data_hora_fato)= 2024 AND MONTH(oco.data_hora_fato) IN (1,2,3,4,5,6,7) THEN rat_prod.quantidade else 0 END) AS Qtde_2024 -- Soma das quantidades para o ano de 2024, limitado aos meses de janeiro a julho
FROM 
db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia rat_prod -- Tabela de RAT Produtividade 
LEFT JOIN tb_ocorrencia oco -- Junção à esquerda com a tabela  Ocorrências, pelo número da ocorrência
ON rat_prod.numero_ocorrencia = oco.numero_ocorrencia 
WHERE 
oco.natureza_codigo = 'Y04012' -- Filtra o código de natureza da ocorrência Operação Lei Seca
AND oco.data_hora_fato BETWEEN '2020-01-01' AND '2024-07-31' -- Filtra as ocorrências dentro do intervalo especificado
AND rat_prod.indicador_descricao IN ('Das pessoas que recusaram soprar etilômetro quantas apresentaram sintomas', 
'Das pessoas que recusaram soprar etilômetro quantas não apresentaram sintomas',
'Qde de pessoas que sopraram e resultou embriaguez crime',
'Qde de pessoas que sopraram e resultou embriaguez infração') -- Filtra descrições de indicadores especificados
AND rat_prod.quantidade > 0 -- Filtra quantidades(do RAT) maiores que zero
GROUP BY 1 -- Agrupa pelo nome do município
ORDER BY 1; -- Ordena pelo nome do município



-- Quantidade de operações Lei Seca RESUMO
SELECT
nome_municipio, -- Seleciona o nome do município
COUNT(CASE WHEN YEAR(data_hora_fato)= 2020 THEN numero_ocorrencia END) AS Qtde_2020, -- Conta o número de ocorrências no ano de 2020
COUNT(CASE WHEN YEAR(data_hora_fato)= 2021 THEN numero_ocorrencia END) AS Qtde_2021, -- Conta o número de ocorrências no ano de 2021
COUNT(CASE WHEN YEAR(data_hora_fato)= 2022 THEN numero_ocorrencia END) AS Qtde_2022, -- Conta o número de ocorrências no ano de 2022
COUNT(CASE WHEN YEAR(data_hora_fato)= 2023 THEN numero_ocorrencia END) AS Qtde_2023, -- Conta o número de ocorrências no ano de 2023
COUNT(CASE WHEN YEAR(data_hora_fato)= 2024 AND MONTH(data_hora_fato) IN (1,2,3,4,5,6,7) THEN numero_ocorrencia END) AS Qtde_2024 -- Conta o número de ocorrências no ano de 2024, limitado aos meses de janeiro a julho
FROM db_bisp_reds_reporting.tb_ocorrencia -- Tabela de ocorrências
WHERE natureza_codigo = 'Y04012' -- Filtra o código de natureza da ocorrência -'Operação Lei Seca'
AND data_hora_fato BETWEEN '2020-01-01' AND '2024-07-31' -- Filtra data/hora do fato dentro do intervalo especificado
AND OCO.ocorrencia_uf ='MG' -- Filtra as ocorrências na UF de Minas Gerais
GROUP BY 1 -- Agrupa pelo nome do município
ORDER BY 1 ASC; -- Ordena pelo nome do município em ordem crescente



-- Quantidade de REDS T10306 (Conduzir veículo sob influência de álcool/substância psicoativa) em Op Lei Seca RESUMO
SELECT
nome_municipio, -- Seleciona o nome do município
COUNT(CASE WHEN YEAR(data_hora_fato)= 2020 THEN numero_ocorrencia END) AS Qtde_2020, -- Conta o número de ocorrências no ano de 2020
COUNT(CASE WHEN YEAR(data_hora_fato)= 2021 THEN numero_ocorrencia END) AS Qtde_2021, -- Conta o número de ocorrências no ano de 2021
COUNT(CASE WHEN YEAR(data_hora_fato)= 2022 THEN numero_ocorrencia END) AS Qtde_2022, -- Conta o número de ocorrências no ano de 2022
COUNT(CASE WHEN YEAR(data_hora_fato)= 2023 THEN numero_ocorrencia END) AS Qtde_2023, -- Conta o número de ocorrências no ano de 2023
COUNT(CASE WHEN YEAR(data_hora_fato)= 2024 AND MONTH(data_hora_fato) IN (1,2,3,4,5,6,7) THEN numero_ocorrencia END) AS Qtde_2024 -- Conta o número de ocorrências no ano de 2024, limitado aos meses de janeiro a julho
FROM db_bisp_reds_reporting.tb_ocorrencia -- Tabela de ocorrências
WHERE natureza_codigo = 'T10306' -- Filtra o código de natureza da ocorrência - 'CONDUZIR VEICULO SOB INFLUENCIA DE ALCOOL/SUBST. PSICOATIVA'
--AND operacao_codigo ='Y04012' --  Filtra o código da operação -'Operação Lei Seca'
AND data_hora_fato BETWEEN '2020-01-01' AND '2024-07-31' -- Filtra as ocorrências dentro do intervalo especificado
AND ocorrencia_uf ='MG' -- Filtra as ocorrências na UF de Minas Gerais
GROUP BY 1 -- Agrupa pelo nome do município
ORDER BY 1 ASC; -- Ordena pelo nome do município em ordem crescente


