/*---------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem como objetivo extrair e consolidar informações sobre ocorrências ambientais registradas 
 * no estado de Minas Gerais em 2023, focando em eventos envolvendo animais, autuações e infrações ambientais. 
--------------------------------------------------------------------------------------------------------------------- */
SELECT 
    OCO.numero_ocorrencia, -- Seleciona o número da ocorrência.
    OCO.data_hora_fato, -- Seleciona a data/hora do fato da ocorrência.
    OCO.natureza_codigo, -- Seleciona o código da natureza da ocorrência.
    OCO.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência.
    OCO.natureza_consumado, -- Indica se a natureza do crime foi consumada ou tentada.
    ANIM.numero_animal, -- Seleciona o número do animal envolvido na ocorrência.
    ANIM.descricao_origem_animal, -- Seleciona a descrição da origem do animal envolvido.
    ANIM.descricao_tipo_animal, -- Seleciona a descrição do tipo de animal envolvido.
    ANIM.quantidade_animal, -- Seleciona a quantidade de animais envolvidos na ocorrência.
    ANIM.descricao_observacao, -- Seleciona as observações feitas sobre a ocorrência envolvendo animais.
    ANIM.descricao_situacao, -- Seleciona a descrição da situação dos animais.
    AUT.numero_autuacao, -- Seleciona o número da autuação da ocorrência.
    AUT.numero_auto_infracao, -- Seleciona o número do auto de infração vinculado à ocorrência.
    AUT.valor_auto_infracao, -- Seleciona o valor do auto de infração vinculado à ocorrência.
    OCO.historico_ocorrencia, -- Seleciona o histórico da ocorrência.
    AMB.descricao_local, -- Seleciona a descrição do local da ocorrência ambiental.
    OCO.codigo_municipio, -- Seleciona o código do município da ocorrência.
    OCO.nome_municipio, -- Seleciona o nome do município da ocorrência.
    OCO.nome_bairro, -- Seleciona o nome do bairro da ocorrência.
    OCO.logradouro_nome, -- Seleciona o nome do logradouro da ocorrência.
    OCO.numero_endereco, -- Seleciona o número do endereço da ocorrência.
    OCO.numero_latitude, -- Seleciona a latitude do local da ocorrência.
    OCO.numero_longitude, -- Seleciona a longitude do local da ocorrência.
    OCO.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro da ocorrência.
    OCO.unidade_area_militar_nome, -- Seleciona o nome da área militar responsável pela ocorrência.
    AMB.descricao_acao_desenvolvida, -- Seleciona a descrição das ações desenvolvidas na ocorrência ambiental.
    OCO.digitador_sigla_orgao -- Seleciona a sigla do órgão responsável pelo registro da ocorrência.
FROM 
    db_bisp_reds_reporting.tb_ocorrencia OCO -- Seleciona dados da tabela de ocorrências (alias 'OCO').
LEFT JOIN 
    db_bisp_reds_reporting.tb_anexo_meio_ambiente_ocorrencia AMB -- Realiza um LEFT JOIN com a tabela de anexo de meio ambiente.
    ON OCO.numero_ocorrencia = AMB.numero_ocorrencia -- Junta as duas tabelas pelo número de ocorrência.
LEFT JOIN 
    db_bisp_reds_reporting.tb_autuacao_procedimento_ocorrencia AUT -- Realiza um LEFT JOIN com a tabela de autuações de procedimentos.
    ON OCO.numero_ocorrencia = AUT.numero_ocorrencia -- Junta as tabelas pelo número de ocorrência.
LEFT JOIN 
    db_bisp_reds_reporting.tb_animal_ocorrencia ANIM -- Realiza um LEFT JOIN com a tabela de ocorrências de animais.
    ON OCO.numero_ocorrencia = ANIM.numero_ocorrencia -- Junta as tabelas pelo número de ocorrência.
WHERE 
    YEAR(OCO.data_hora_fato) = 2023 -- Filtra ano da data/hora da ocorrência.
    AND MONTH(OCO.data_hora_fato) BETWEEN 1 AND 4 -- Filtra mês da data/hora da ocorrência.
    AND OCO.digitador_id_orgao IN (0,1) -- Filtra as ocorrências registradas pela PM e PC.
    AND OCO.ind_estado ='F' -- Filtra apenas ocorrências com estado 'Fechado'.
    AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências registradas no estado de Minas Gerais.
    AND (
        SUBSTRING(OCO.natureza_codigo,1,1) = 'L'  -- Filtra ocorrências cuja natureza começa com 'L'.
        OR SUBSTRING(OCO.natureza_codigo,1,1) = 'M' -- Ou ocorrências cuja natureza começa com 'M'.
        OR SUBSTRING(OCO.natureza_codigo,1,1) = 'N' -- Ou ocorrências cuja natureza começa com 'N'.
    )
ORDER BY 
    OCO.data_hora_fato, -- Ordena os resultados pela data e hora do fato.
    OCO.numero_ocorrencia, -- Ordena os resultados pelo número da ocorrência.
    ANIM.numero_animal, -- Ordena os resultados pelo número do animal.
    AUT.numero_autuacao; -- Ordena os resultados pelo número de autuação.
