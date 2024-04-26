/*----------------------------------------------------------------------------------------------------------
 * Contagem de chamadas realizadas no CAD em 2023 e 2024 
 ---------------------------------------------------------------------------------------------------------*/
-- Seleciona o ID e o nome do município das chamadas de atendimento
SELECT 
    CA.local_municipio_id, 
    CA.local_municipio_nome,
    -- Conta o número distinto de chamadas para o ano de 2023
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2023 THEN CA.chamada_id END) AS '2023',   
    -- Conta o número distinto de chamadas para o ano de 2024
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2024 THEN CA.chamada_id END) AS '2024'  
-- Indica a tabela de onde os dados serão retirados
FROM tb_chamada_atendimento CA
-- Define as condições para a seleção dos dados
WHERE 
    -- Seleciona chamadas entre o início de 2023 e o final de março de 2024
    (CA.chamada_data_hora_inclusao) BETWEEN '2023-01-01' AND '2024-03-31'
    -- Filtra as chamadas atendidas pela Polícia Militar
    AND CA.orgao_sigla = 'PM'
-- Agrupa os resultados pelo ID e nome do município
GROUP BY CA.local_municipio_id, CA.local_municipio_nome
-- Ordena os resultados primeiro pelo nome do município e depois pelo ID do município
ORDER BY CA.local_municipio_nome, CA.local_municipio_id;



/*----------------------------------------------------------------------------------------------------------
 * Contagem de chamadas realizadas no CAD em 2023 e 2024 atendidas pela unidade específica
 ---------------------------------------------------------------------------------------------------------*/
SELECT 
    CA.local_municipio_id, 
    CA.local_municipio_nome,
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2023 THEN CA.chamada_id END) AS '2023',   
    COUNT(DISTINCT CASE WHEN YEAR(CA.chamada_data_hora_inclusao) = 2024 THEN CA.chamada_id END) AS '2024'    
-- Especifica a tabela principal de onde os dados serão retirados
FROM tb_chamada_atendimento CA
-- Realiza uma junção INNER JOIN com a tabela de empenhos para filtrar as chamadas que têm empenhos associados
INNER JOIN tb_empenho EMP 
ON CA.chamada_id = EMP.chamada_atendimento_id
-- Define as condições para a seleção dos dados
WHERE 
    -- Seleciona chamadas entre o início de 2023 e o final de março de 2024
    (CA.chamada_data_hora_inclusao) BETWEEN '2023-01-01' AND '2024-03-31'
    -- Filtra as chamadas atendidas pela Polícia Militar
    AND CA.orgao_sigla = 'PM'
    -- Filtra por empenhos que usam o tipo de recurso com código 'XX'
    AND EMP.tipo_recurso_codigo = 'XX'
-- Agrupa os resultados pelo ID e nome do município para contagem
GROUP BY CA.local_municipio_id, CA.local_municipio_nome
-- Ordena os resultados pelo nome do município e pelo ID do município para facilitar a visualização
ORDER BY CA.local_municipio_nome, CA.local_municipio_id;

