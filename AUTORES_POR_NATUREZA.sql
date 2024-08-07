/*﻿----------------------------------------------------------------------------------------------------------------------------
Este código SQL foi elaborado com o propósito de identificar e relatar informações sobre indivíduos envolvidos em roubos 
ou furtos de bicicletas em Minas Gerais, durante os anos de 2023 e 2024, conforme registros da Polícia Militar. 
Ele busca informações específicas sobre os envolvidos, as ocorrências associadas, e os veículos (bicicletas) envolvidos.
 O foco está nos autores desses crimes, utilizando códigos específicos para natureza da ocorrência e tipos de veículos.

Esta consulta é útil para análises detalhadas das circunstâncias e frequências de roubos e furtos de bicicletas, 
ajudando na tomada de decisões para estratégias de prevenção, investigação e ações de segurança pública. Os resultados 
são apresentados de forma organizada para facilitar a interpretação e a análise subsequente dos dados coletados.
----------------------------------------------------------------------------------------------------------------------------*/
SELECT DISTINCT
    ENV.nome_completo_envolvido, -- NOME COMPLETO DO ENVOLVIDO
    OCO.numero_ocorrencia, -- NÚMERO DA OCORRÊNCIA
    OCO.natureza_descricao, -- DESCRIÇÃO DA NATUREZA DA OCORRÊNCIA
    VEI.tipo_veiculo_descricao, -- DESCRIÇÃO DO TIPO DE VEÍCULO ENVOLVIDO
    ENV.tipo_prisao_apreensao_descricao -- DESCRIÇÃO DO TIPO DE PRISÃO OU APREENSÃO
-- TABELAS UTILIZADAS PARA A CONSULTA COM AS DEVIDAS JUNÇÕES
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
INNER JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV  
    ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO PARA ASSOCIAR ENVOLVIDOS ÀS OCORRÊNCIAS
INNER JOIN db_bisp_reds_reporting.tb_veiculo_ocorrencia VEI 
    ON VEI.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO PARA ASSOCIAR VEÍCULOS ÀS OCORRÊNCIAS
-- CONDIÇÕES ESPECÍFICAS PARA FILTRAR OS DADOS DE OCORRÊNCIAS
WHERE YEAR(OCO.data_hora_fato) BETWEEN 2023 AND 2024 -- OCORRÊNCIAS ENTRE OS ANOS DE 2023 E 2024
    AND OCO.relator_sigla_orgao = 'PM' -- OCORRÊNCIAS RELATADAS PELA POLÍCIA MILITAR
    AND OCO.ocorrencia_uf = 'MG' -- OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND OCO.natureza_codigo IN('X01155','X01156','X01157') -- CÓDIGOS ESPECÍFICOS DE NATUREZA DA OCORRÊNCIA 
    AND ENV.envolvimento_codigo IN ('0100', '0200') -- CÓDIGO DE ENVOLVIMENTO 
   -- AND OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/ RPM 
   -- AND OCO.nome_municipio  LIKE '%BELO HOR%'-- FILTRE O MUNICIPIO 
-- ORDENAMENTO DOS RESULTADOS
ORDER BY 1,2,4,5; -- ORDEM ALFABÉTICA E NUMÉRICA BASEADA EM NOME, NÚMERO DE OCORRÊNCIA, TIPO DE VEÍCULO E TIPO DE PRISÃO/APREENSÃO

