/*--------------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como objetivo identificar reincidências de vítima de VD em ocorrências 
 * registradas pela Polícia Militar de Minas Gerais, classificando o 
 * tipo de violência (sexual, psicológica, patrimonial, moral ou física) com base no código da natureza da ocorrência.
 * Esse script é essencial para análises de padrões de reincidência de VD, auxiliando na análise, formulação de 
 * políticas preventivas e estratégicas de segurança pública.
 ---------------------------------------------------------------------------------------------------------------------*/
WITH REINCIDENCIA_VD AS
(
    SELECT 
        UPPER(ENV.nome_completo_envolvido) as nome_completo_envolvido, -- Seleciona e converte o nome completo do envolvido para letras maiúsculas
        UPPER(ENV.nome_mae) as nome_mae, -- Seleciona e converte o nome da mãe do envolvido para letras maiúsculas
        ENV.data_nascimento, -- Seleciona a data de nascimento do envolvido
        ENV.envolvimento_descricao, -- Seleciona a descrição do envolvimento do indivíduo na ocorrência
        OCO.numero_ocorrencia, -- Seleciona o número da ocorrência
        OCO.data_hora_fato, -- Seleciona a data/hora do fato 
        OCO.natureza_codigo, -- Seleciona o código da natureza da ocorrência
        OCO.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
        ENV.condicao_fisica_descricao, -- Seleciona a descrição da condição física do envolvido
        OCO.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
        OCO.unidade_area_militar_nome, -- Seleciona o nome da área militar
        OCO.codigo_municipio, -- Seleciona o código do município da ocorrência 
        OCO.nome_municipio, -- Seleciona o nome do município da ocorrência 
        CASE  
            WHEN OCO.natureza_codigo IN ('D01213', 'D01217', 'B01124', 'D01502', 'B05502', 'C01173', 'B05503', 'D08061', 'B05505', 'B05241', 'D01504', 'D01530', 'B05501', 'D01228', 'D99000', 'D01230', 'B01125', 'B05240', 'D01505', 'D01229', 'D01227', 'B05504') THEN 'SEXUAL'  -- Classifica a natureza da ocorrência como violência sexual
            WHEN OCO.natureza_codigo IN ('B01147', 'A02000', 'D08065', 'B01150', 'B01146', 'B01148', 'B05237', 'B05232', 'H01212', 'B05230', 'K06071', 'K26056', 'K07011', 'K19581', 'K07014', 'D01506', 'K26154', 'D01216', 'G01337', 'B05238', 'B13096', 'K07005') THEN 'PSICOLOGICA' -- Classifica a natureza da ocorrência como violência psicológica
            WHEN OCO.natureza_codigo IN ('C01155', 'C01163', 'C01171', 'C01168', 'C99000', 'C01157', 'C01161', 'C01501', 'B26056', 'G01300', 'C01158', 'C01180', 'G01314', 'C01160', 'B13104', 'C08026', 'C01156', 'B01154', 'B01153', 'L29004', 'B01151', 'C01176', 'C01182', 'C01177', 'M31014', 'C01181', 'K23078', 'C01159', 'E01264', 'B24040', 'J20295') THEN 'PATRIMONIAL' -- Classifica a natureza da ocorrência como violência patrimonial
            WHEN OCO.natureza_codigo IN ('B01140', 'B01139', 'B01138', 'G01339') THEN 'MORAL' -- Classifica a natureza da ocorrência como violência moral
            WHEN OCO.natureza_codigo IN ('B01129', 'B08021', 'B01136', 'E08042', 'B01121', 'B02001', 'B01137', 'B01123', 'B01122', 'H18020', 'F01200') THEN 'FISICA' -- Classifica a natureza da ocorrência como violência física
            ELSE 'OUTROS'  -- Classifica outras ocorrências que não se encaixam nas categorias acima
        END AS TIPO_VIOLENCIA, -- Atribui o tipo de violência com base no código da natureza
        ROW_NUMBER() OVER (PARTITION BY ENV.nome_completo_envolvido, ENV.nome_mae, ENV.data_nascimento ORDER BY OCO.data_hora_fato) AS ORDEM_OCORRENCIA -- Gera uma ordem para as ocorrências do mesmo indivíduo
    FROM tb_ocorrencia OCO -- Tabela de ocorrências
    INNER JOIN tb_envolvido_ocorrencia ENV  -- Junção com a tabela de envolvidos nas ocorrências
        ON OCO.numero_ocorrencia = ENV.numero_ocorrencia -- Condição de junção entre as duas tabelas com base no número da ocorrência
    WHERE 1=1 -- Condição padrão para facilitar a inclusão de outras cláusulas WHERE
        AND OCO.data_hora_fato BETWEEN '2022-01-01 00:00:00' AND '2024-10-18 23:59:59' -- Filtro de data/hora do fato
        AND ENV.codigo_sexo = 'F' -- Filtro para selecionar apenas vítimas do sexo feminino
        AND ENV.id_relacao_vitima_autor IN (22,21,15,6,7,19,18,16,5,20) -- Filtro para selecionar as relações específicas entre a vítima e o autor
        AND ENV.id_envolvimento IN (25,32,872) -- Filtro para selecionar tipos específicos de envolvimento do indivíduo
        AND OCO.natureza_codigo NOT LIKE 'A20%' -- Exclui ocorrências cuja natureza comece com 'A20'
        AND OCO.relator_sigla_orgao = 'PM' -- Filtra ocorrências registradas pela Polícia Militar
        AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências que ocorreram no estado de Minas Gerais
)
SELECT  
    UPPER(RVD.nome_completo_envolvido) as nome_completo_envolvido, -- Seleciona e converte o nome completo do envolvido para letras maiúsculas
    UPPER(RVD.nome_mae) as nome_mae, -- Seleciona e converte o nome da mãe do envolvido para letras maiúsculas
    RVD.data_nascimento, -- Seleciona a data de nascimento do envolvido
    RVD.envolvimento_descricao, -- Seleciona a descrição do envolvimento do envolvido na ocorrência
    RVD.numero_ocorrencia, -- Seleciona o número da ocorrência
    RVD.data_hora_fato, -- Seleciona a data/hora do fato
    RVD.natureza_codigo, -- Seleciona o código da natureza da ocorrência
    RVD.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
    RVD.condicao_fisica_descricao, -- Seleciona a descrição da condição física do envolvido
    RVD.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
    RVD.unidade_area_militar_nome, -- Seleciona o nome da área militar 
    RVD.codigo_municipio, -- Seleciona o código do município da ocorrência
    RVD.nome_municipio, -- Seleciona o nome do município da ocorrência
    RVD.TIPO_VIOLENCIA, -- Seleciona o tipo de violência classificado anteriormente
    RVD.ORDEM_OCORRENCIA -- Seleciona a ordem da ocorrência para o indivíduo
FROM REINCIDENCIA_VD RVD -- Seleciona os dados da CTE (Common Table Expression) criada anteriormente
GROUP BY  
    RVD.nome_completo_envolvido, 
    RVD.nome_mae, 
    RVD.data_nascimento,
    RVD.ORDEM_OCORRENCIA,
    RVD.envolvimento_descricao,
    RVD.numero_ocorrencia,
    RVD.data_hora_fato,
    RVD.natureza_codigo,
    RVD.natureza_descricao,
    RVD.condicao_fisica_descricao,
    RVD.unidade_responsavel_registro_nome,
    RVD.unidade_area_militar_nome,
    RVD.codigo_municipio,
    RVD.nome_municipio,
    RVD.TIPO_VIOLENCIA -- Agrupa os dados pelos campos relevantes
HAVING RVD.ORDEM_OCORRENCIA >= 2 -- Filtra para mostrar apenas ocorrências a partir da segunda para o mesmo indivíduo
ORDER BY 
    RVD.nome_completo_envolvido, 
    RVD.nome_mae, 
    RVD.data_nascimento, 
    RVD.ORDEM_OCORRENCIA -- Ordena o resultado pelo nome completo, nome da mãe, data de nascimento e ordem da ocorrência
