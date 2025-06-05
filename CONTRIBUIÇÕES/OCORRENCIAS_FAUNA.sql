/*-------------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem como objetivo extrair e consolidar informações sobre ocorrências envolvendo animais, filtradas 
 * por unidades do BPM MAMB. Ele agrupa os dados por número de ocorrência e ano, somando a quantidade de animais envolvidos,
 *  e exibindo detalhes como origem, tipo, situação dos animais, localização do incidente, e unidade responsável pelo registro.
 *  Além disso, o script categoriza as ocorrências de acordo com a Companhia PM MAMB responsável, facilitando a análise
 *  e o monitoramento das atividades relacionadas à fauna nas respectivas regiões.
 * 
 * Contribuição: Thiago Jardim de Castro, 3º Sgt PM
 -------------------------------------------------------------------------------------------------------------------------*/
SELECT 
    YEAR(ANIM.data_hora_fato) AS ano_ocorrencia,  -- Extrai o ano da data do fato para cada ocorrência animal e o nomeia como 'ano_ocorrencia'.
    ANIM.numero_ocorrencia,  -- Seleciona o número da ocorrência .
    SUM(ANIM.quantidade_animal) AS quantidade_animal_total,  -- Soma a quantidade total de animais envolvidos em cada ocorrência.
    MAX(ANIM.numero_animal) AS numero_animal,  -- Retorna o maior número de animais registrados na ocorrência.
    MAX(ANIM.numero_envolvido) AS numero_envolvido,  -- Retorna o maior número de indivíduos envolvidos na ocorrência.
    MAX(ANIM.descricao_origem_animal) AS descricao_origem_animal,  -- Retorna a descrição da origem dos animais.
    MAX(ANIM.descricao_situacao) AS descricao_situacao,  -- Retorna a situação dos animais (capturados, resgatados, etc.).
    MAX(ANIM.descricao_tipo_animal) AS descricao_tipo_animal,  -- Retorna a descrição do tipo de animal envolvido na ocorrência.
    MAX(ANIM.ind_ameacado_extincao) AS ind_ameacado_extincao,  -- Retorna o indicador se os animais estão ameaçados de extinção.
    MAX(ANIM.ind_vivo) AS ind_vivo,  -- Retorna o indicador se os animais estão vivos.
    MAX(OCO.natureza_codigo) AS natureza_codigo,  -- Retorna o código da natureza da ocorrência.
    MAX(OCO.natureza_descricao) AS natureza_descricao,  -- Retorna a descrição da natureza da ocorrência.
    MAX(OCO.data_hora_fato) AS data_hora_fato,  -- Retorna a data e hora do fato da ocorrência.
    MAX(OCO.unidade_responsavel_registro_nome) AS unidade_responsavel_registro_nome,  -- Retorna o nome da unidade responsável pelo registro da ocorrência.
    MAX(OCO.tipo_logradouro_descricao) AS tipo_logradouro_descricao,  -- Retorna a descrição do tipo de logradouro.
    MAX(OCO.logradouro_nome) AS logradouro_nome,  -- Retorna o nome do logradouro onde a ocorrência aconteceu.
    MAX(OCO.numero_endereco) AS numero_endereco,  -- Retorna o número do endereço da ocorrência.
    MAX(OCO.nome_bairro) AS nome_bairro,  -- Retorna o nome do bairro onde ocorreu a ocorrência.
    MAX(OCO.numero_latitude) AS numero_latitude,  -- Retorna a latitude do local da ocorrência.
    MAX(OCO.numero_longitude) AS numero_longitude,  -- Retorna a longitude do local da ocorrência.
    MAX(OCO.codigo_municipio) AS codigo_municipio,  -- Retorna o código do município da ocorrência.
    MAX(OCO.nome_municipio) AS nome_municipio,  -- Retorna o nome do município da ocorrência.
    MAX(OCO.digitador_matricula) AS digitador_matricula,  -- Retorna a matrícula do digitador que registrou a ocorrência.
    CASE  -- Verifica o nome da unidade responsável pelo registro da ocorrência e categoriza as Companhias PM MAMB.
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%7 CIA PM MAMB%' THEN '7 CIA PM MAMB'  
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%6 CIA PM MAMB%' THEN '6 CIA PM MAMB'
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%5 CIA PM MAMB%' THEN '5 CIA PM MAMB'
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%4 CIA PM MAMB%' THEN '4 CIA PM MAMB'
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%3 CIA PM MAMB%' THEN '3 CIA PM MAMB'
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%2 CIA PM MAMB%' THEN '2 CIA PM MAMB'
        WHEN MAX(OCO.unidade_responsavel_registro_nome) LIKE '%1 CIA PM MAMB%' THEN '1 CIA PM MAMB'
        ELSE ''  -- Caso o nome da unidade não corresponda a nenhum dos valores especificados, retorna vazio.
    END AS Numero_CIA_PM_MAMB  -- Nomeia a coluna do resultado como 'Numero_CIA_PM_MAMB'.
FROM  
    db_bisp_reds_reporting.tb_animal_ocorrencia ANIM  -- Seleciona a tabela de ocorrências de animais, com o alias 'ANIM'.
LEFT JOIN
    db_bisp_reds_reporting.tb_ocorrencia OCO ON OCO.numero_ocorrencia = ANIM.numero_ocorrencia  -- Faz um LEFT JOIN com a tabela de ocorrências, associando-as pelo número de ocorrência.
WHERE 
    YEAR(ANIM.data_hora_fato) = 2024  -- Filtra o ano da  data/hora fato.
    AND MONTH(ANIM.data_hora_fato) = 1 -- Filtra o mês da data/hora fato.
    AND OCO.unidade_responsavel_registro_nome LIKE '%BPM MAMB%'  -- Filtra as ocorrências onde a unidade responsável contém 'BPM MAMB' no nome.
GROUP BY 
    ANIM.numero_ocorrencia,  -- Agrupa os resultados pelo número da ocorrência.
    YEAR(ANIM.data_hora_fato)  -- Agrupa os resultados pelo ano da ocorrência.    
ORDER BY 
    ANIM.numero_ocorrencia;  -- Ordena os resultados pelo número da ocorrência.
