/*----------------------------------------------------------------------------------------------------------
 * Contagem de chamadas realizadas no CAD em 2023 e 2024 
 ---------------------------------------------------------------------------------------------------------*/
-- Seleciona o ID e o nome do município das chamadas de atendimento
SELECT 
    CA.local_municipio_id, -- ID do município
    CA.local_municipio_nome, -- Nome do município
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2023 THEN CA.chamada_id END) AS '2023',  -- Conta o número distinto de chamadas para o ano de 2023
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2024 THEN CA.chamada_id END) AS '2024'   -- Conta o número distinto de chamadas para o ano de 2024
FROM db_bisp_cad_reporting.tb_chamada_atendimento CA
WHERE 
    CA.chamada_data_hora_inclusao BETWEEN '2023-01-01' AND '2024-03-31'  -- Seleciona chamadas entre o início de 2023 e o final de março de 202
    AND CA.orgao_sigla = 'PM'  -- Filtra as chamadas atendidas pela Polícia Militar
GROUP BY CA.local_municipio_id, CA.local_municipio_nome -- Agrupa os resultados pelo ID e nome do município
ORDER BY CA.local_municipio_nome, CA.local_municipio_id; -- Ordena os resultados primeiro pelo nome do município e depois pelo ID do município



/*----------------------------------------------------------------------------------------------------------
 * Contagem de chamadas realizadas no CAD em 2023 e 2024 atendidas pelo recurso específico
 ---------------------------------------------------------------------------------------------------------*/
SELECT 
    CA.local_municipio_id, -- ID do município
    CA.local_municipio_nome, -- Nome do município
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2023 THEN CA.chamada_id END) AS '2023',   -- Conta o número distinto de chamadas para o ano de 2023
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2024 THEN CA.chamada_id END) AS '2024'    -- Conta o número distinto de chamadas para o ano de 2024
FROM db_bisp_cad_reporting.tb_chamada_atendimento CA
INNER JOIN db_bisp_cad_reporting.tb_empenho EMP 
ON CA.chamada_id = EMP.chamada_atendimento_id
WHERE 
    (CA.chamada_data_hora_inclusao) BETWEEN '2023-01-01' AND '2024-03-31'     -- Seleciona chamadas entre o início de 2023 e o final de março de 2024
    AND CA.orgao_sigla = 'PM'    -- Filtra as chamadas atendidas pela Polícia Militar
    AND EMP.tipo_recurso_codigo = 'XX'   -- Filtra por empenhos que usam o tipo de recurso com código 'XX'
GROUP BY CA.local_municipio_id, CA.local_municipio_nome -- Agrupa os resultados pelo ID e nome do município para contagem
ORDER BY CA.local_municipio_nome, CA.local_municipio_id; -- Ordena os resultados pelo nome do município e pelo ID do município para facilitar a visualização

