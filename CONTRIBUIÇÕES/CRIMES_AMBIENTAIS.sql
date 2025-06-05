/*---------------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem como objetivo extrair e consolidar informações sobre ocorrências ambientais registradas, com foco 
 * em crimes classificadas por categorias como fauna, flora e poluição.
 * 
 * Contribuição: Thiago Jardim de Castro, 3º Sgt PM
 ---------------------------------------------------------------------------------------------------------------------------*/
SELECT 
    oco.numero_ocorrencia, -- Seleciona o número único da ocorrência
    YEAR(oco.data_hora_fato) AS Ano, -- Extrai o ano da data/hora do fato e atribui o alias 'Ano'
    MONTH(oco.data_hora_fato) AS Mes, -- Extrai o mês da data/hora do fato e atribui o alias 'Mês'
    oco.data_hora_fato, -- Seleciona a data/hora completa do fato
    CAST(oco.data_hora_fato AS DATE) AS data_ocorrencia, -- Converte a data/hora do fato para o formato de data (sem hora) e atribui o alias 'data_ocorrência'
    oco.codigo_municipio, -- Seleciona o código do município onde a ocorrência foi registrada
    oco.nome_municipio, -- Seleciona o nome do município onde a ocorrência da ocorrência
    oco.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
    oco.natureza_codigo, -- Seleciona o código da natureza da ocorrência
    oco.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
    CASE
        -- Classificação dos crimes ambientais com base no código da natureza da ocorrência
        WHEN oco.natureza_codigo IN 
        (
        'L30054', 'L30055', 'L30056', 'L30060', 'L30061', 'L30062', 'L30063', 'L30064', 'L30065', 'L30066', 'L30067', 'L30068', 'L30069', 'L30169', 'L30999'
        ) 
            THEN 'POLUIÇÃO' -- Classifica como 'POLUIÇÃO' se o código de natureza for um dos listados
        WHEN oco.natureza_codigo IN 
        (
        'M30999', 'M30032', 'M30031', 'M30030', 'M30029', 'M3035', 'M30034', 'M30033'
        ) 
            THEN 'FAUNA' -- Classifica como 'FAUNA' se o código de natureza for um dos listados
        WHEN oco.natureza_codigo IN 
        (
        'N30138', 'N30999', 'N30052', 'N30051', 'N30050', 'N30049', 'N30048', 'N30046', 'N30045', 'N30044', 'N30042', 'N30041', 'N30040', 'N30039', 'N30038'
        ) 
            THEN 'FLORA' -- Classifica como 'FLORA' se o código de natureza for um dos listados
        ELSE 'OUTROS' -- Classifica como 'OUTROS' se o código de natureza não se enquadrar nas categorias anteriores
    END AS Crimes_Ambientais -- Define a coluna resultante com o nome 'Crimes_Ambientais'
FROM 
    db_bisp_reds_reporting.tb_ocorrencia oco -- Seleciona os dados da tabela 'tb_ocorrencia' no banco 'db_bisp_reds_reporting'
WHERE
    YEAR(oco.data_hora_fato) IN (2023, 2024) -- Filtra os registros para os anos de 2023 e 2024
    AND oco.natureza_codigo IN ( -- Filtra as ocorrências cujos códigos de natureza estão dentro da lista fornecida
        'L30054', 'L30055', 'L30056', 'L30060', 'L30061', 'L30062', 'L30063', 'L30064', 'L30065', 'L30066', -- Crimes relativos à poluição
        'L30067', 'L30068', 'L30069', 'L30169', 'L30999', -- Crimes adicionais relativos à poluição                      
        'M30999', 'M30032', 'M30031', 'M30030', 'M30029', 'M3035', 'M30034', 'M30033', -- Crimes relativos à fauna                
        'N30138', 'N30999', 'N30052', 'N30051', 'N30050', 'N30049', 'N30048', 'N30046', 'N30045', 'N30044', -- Crimes relativos à flora
        'N30042', 'N30041', 'N30040', 'N30039', 'N30038' -- Crimes adicionais relativos à flora 
    )               
ORDER BY 
    oco.data_hora_fato; -- Ordena os resultados pela data e hora do fato
