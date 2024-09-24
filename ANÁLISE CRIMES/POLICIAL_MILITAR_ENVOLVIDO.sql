/*-----------------------------------------------------------------------------------------------------------
Este scrit tem o objetivo de selecionar informações sobre ocorrências envolvendo policiais militares 
em Minas Gerais. Buscando informações sobre a ocorrência e envolvidos, focando especificamente em casos
onde pelo menos um ou mais policiais militares estão envolvidos, sendo autor ou vítima.
------------------------------------------------------------------------------------------------------------*/
SELECT 
    OCO.numero_ocorrencia,          -- Seleciona o número da ocorrência
    OCO.data_hora_fato,             -- Seleciona a data e hora do fato
    OCO.natureza_codigo,            -- Seleciona o código natureza da ocorrência
    OCO.natureza_descricao,         -- Seleciona a descrição da natureza da ocorrência
    ENV.envolvimento_codigo,        -- Seleciona o código de envolvimento
    ENV.envolvimento_descricao,     -- Seleciona a descrição do envolvimento
    ENV.numero_matr_militar_policial, -- Seleciona o número de matrícula do policial militar
    ENV.nome_cargo_militar_policial,-- Seleciona o nome do cargo do policial militar
    ENV.nome_completo_envolvido,    -- Seleciona o nome completo do envolvido
    ENV.data_nascimento,            -- Seleciona a data de nascimento do envolvido
    ENV.nome_mae,                   -- Seleciona o nome da mãe do envolvido
    ENV.condicao_fisica_codigo,     -- Seleciona o código da condição física do envolvido
    ENV.condicao_fisica_descricao,  -- Seleciona a descrição da condição física do envolvido
    ENV.ind_militar_policial,       -- Indica se é um policial militar
    ENV.ind_militar_policial_servico,-- Indica se o policial militar estava em serviço
    OCO.historico_ocorrencia        -- Seleciona o histórico da ocorrência
FROM 
    db_bisp_reds_reporting.tb_ocorrencia OCO              
INNER JOIN 
    db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV     
ON 
    OCO.numero_ocorrencia = ENV.numero_ocorrencia
WHERE 
    YEAR(OCO.data_hora_fato) = 2023 -- Filtra ocorrências do ano de 2023
    AND OCO.ocorrencia_uf = 'MG'    -- Filtra ocorrências no estado de Minas Gerais
    AND ENV.ind_militar_policial = 'M' -- Filtra ocorrências envolvendo policiais militares
    AND ENV.envolvimento_codigo IN ('0100', '1303', '1302', '1301', '1304', '1305', '1300', '1399') -- Filtra envolvimentos específicos (autor, vítima)
    AND ENV.orgao_lotacao_policial_sigla ='PM' -- Filtra a sigla do orgão de lotação policial
    AND ENV.uf_orgao_lotacao_policial ='MG'-- Filtra a unidade federativa da lotação policial
    AND EXISTS (
        SELECT 1
        FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV2
        WHERE ENV2.numero_ocorrencia = OCO.numero_ocorrencia -- Verifica se há pelo menos outro envolvido na mesma ocorrência
        AND ENV2.ind_militar_policial = 'M' -- Filtra novamente para garantir que o outro envolvido também é policial militar
        AND ENV2.envolvimento_codigo IN ('0100', '1303', '1302', '1301', '1304', '1305', '1300', '1399') -- Verifica os  códigos de envolvimento
        AND ENV2.orgao_lotacao_policial_sigla ='PM' -- Filtra a sigla do orgão de lotação policial
        AND ENV2.uf_orgao_lotacao_policial ='MG'-- Filtra a unidade federativa da lotação policial
    )
    AND ENV.numero_matr_militar_policial IS NOT NULL -- Filtra registros onde a matrícula do policial militar não é nula
--AND OCO.nome_municipio = 'XXX' -- Filtra o municipio da ocorrência
