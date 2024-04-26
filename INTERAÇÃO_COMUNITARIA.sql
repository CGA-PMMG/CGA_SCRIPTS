/*---------------------------------------------------------------------------------------------------------------
 * Esta consulta SQL tem como objetivo analisar a frequência de ocorrências de uma categoria específica, 
 * identificada pelo código inicial 'A19', em diferentes municípios de Minas Gerais ao longo dos anos de 2020 a 2022. 
 ---------------------------------------------------------------------------------------------------------------*/
SELECT 
    tb_ocorrencia.codigo_municipio,  -- Seleciona o código do município.
    tb_ocorrencia.nome_municipio,    -- Seleciona o nome do município.
    -- Conta o número de ocorrências únicas para cada ano especificado, classificando por ano.
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2020 THEN tb_ocorrencia.numero_ocorrencia END) as '2020',
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2021 THEN tb_ocorrencia.numero_ocorrencia END) as '2021',
    COUNT(DISTINCT CASE WHEN YEAR(tb_ocorrencia.data_hora_fato) = 2022 THEN tb_ocorrencia.numero_ocorrencia END) as '2022'
-- Especifica a tabela de onde os dados serão extraídos.
FROM db_bisp_reds_reporting.tb_ocorrencia
-- Define os critérios para filtragem dos registros:
WHERE YEAR(tb_ocorrencia.data_hora_fato) BETWEEN 2020 AND 2022  -- Restringe os registros aos anos de 2020 a 2022.
    AND tb_ocorrencia.ind_estado = 'F'                          -- Considera apenas as ocorrências finalizadas.
    AND tb_ocorrencia.ocorrencia_uf = 'MG'                      -- Foca nas ocorrências que ocorreram no estado de Minas Gerais.
    AND tb_ocorrencia.digitador_sigla_orgao = 'PM'              -- Limita a consulta aos registros inseridos pela Polícia Militar.
    AND tb_ocorrencia.nome_tipo_relatorio = 'BOS'               -- Seleciona apenas registros do tipo "Boletim de Ocorrência Simplificado".
    AND SUBSTRING(tb_ocorrencia.natureza_codigo, 1, 3) = 'A19'  -- Filtra registros cujo código de natureza começa com "A19".
-- Agrupa os resultados pelo código e nome do município para contabilizar as ocorrências por município.
GROUP BY 
    tb_ocorrencia.codigo_municipio, 
    tb_ocorrencia.nome_municipio;
