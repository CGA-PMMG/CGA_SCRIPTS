/*----------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem como objetivo extrair informações sobre ocorrências relacionadas a cibercrimes, ou seja, crimes cometidos por 
 * meio eletrônico, como o uso da internet ou SMS, a partir da tabela 'tb_ocorrencia'. Ele filtra os registros  que 
 * envolvem instrumentos eletrônicos (código "2600") e cujas naturezas dos grupos 'B' a 'N', representando diversas categorias de crimes.
 * A consulta também restringe os resultados a ocorrências fechadas, registradas por órgãos  como a Polícia Militar ou Polícia Civil 
 * no estado de Minas Gerais.
----------------------------------------------------------------------------------------------------------------------------------------- */
SELECT 
    OCO.numero_ocorrencia, -- Seleciona o número da ocorrência
    OCO.data_hora_fato,  -- Seleciona a data/hora da ocorrência
    OCO.instrumento_utilizado_codigo, -- Seleciona o código do instrumento utilizado na ocorrência
    OCO.instrumento_utilizado_descricao, -- Seleciona a descrição do instrumento utilizado
    OCO.natureza_codigo, -- Seleciona o código da natureza 
    OCO.natureza_descricao, -- Seleciona a descrição da natureza
    OCO.natureza_consumado, -- Indicador de se o crime foi consumado ou não
    OCO.historico_ocorrencia, -- Seleciona o histórico da ocorrência 
    OCO.codigo_municipio, -- Seleciona o código do município da ocorrência
    OCO.nome_municipio, -- Seleciona o código do município da ocorrência
    OCO.nome_bairro, -- Seleciona o nome do bairro da ocorrência
    OCO.logradouro_nome, -- Seleciona o nome logradouro da ocorrência
    OCO.numero_endereco, -- Seleciona o número do endereço da ocorrência
    OCO.numero_latitude, -- Seleciona a coordenada de latitude do local da ocorrência
    OCO.numero_longitude, -- Seleciona a coordenada de longitude do local da ocorrência
    OCO.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro da ocorrência
    OCO.unidade_area_militar_nome, -- Seleciona o nome da área militar responsável pela ocorrência
    OCO.digitador_sigla_orgao -- Seleciona a sigla do órgão responsável pelo digitador que registrou a ocorrência
FROM db_bisp_reds_reporting.tb_ocorrencia OCO -- Seleciona os dados da tabela tb_ocorrencia, alias como OCO
WHERE 1=1 -- Filtro sempre verdadeiro, usado como ponto de partida para adicionar condições subsequentes
AND OCO.instrumento_utilizado_codigo = '2600' -- Filtra ocorrências onde o código do instrumento utilizado é '2600' - 'MEIO ELETRÔNICO (INTERNET / SMS)'
AND (
    SUBSTRING(OCO.natureza_codigo, 1, 1) = 'B' -- Filtra por natureza cujo código começa com 'B'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'C' -- Filtra por natureza cujo código começa com 'C'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'D' -- Filtra por natureza cujo código começa com 'D'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'E' -- Filtra por natureza cujo código começa com 'E'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'F' -- Filtra por natureza cujo código começa com 'F'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'G' -- Filtra por natureza cujo código começa com 'G'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'H' -- Filtra por natureza cujo código começa com 'H'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'I' -- Filtra por natureza cujo código começa com 'I'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'J' -- Filtra por natureza cujo código começa com 'J'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'K' -- Filtra por natureza cujo código começa com 'K'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'L' -- Filtra por natureza cujo código começa com 'L'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'M' -- Filtra por natureza cujo código começa com 'M'
    OR SUBSTRING(OCO.natureza_codigo, 1, 1) = 'N' -- Filtra por natureza cujo código começa com 'N'
)
AND YEAR(OCO.data_hora_fato) = 2024 -- Filtra data/hora da ocorrência
AND MONTH(OCO.data_hora_fato) BETWEEN 1 AND 5 -- Filtra data/hora da ocorrência nos meses entre o período espefificado
AND OCO.digitador_id_orgao IN (0, 1) -- Filtra registros digitados por órgãos (PM, PC)
AND OCO.ind_estado = 'F' -- Filtra ocorrências onde o estado é fechado
AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
-- AND OCO.unidade_responsavel_registro_nome LIKE '%x RPM%' -- Filtra nome da unidade responsável pelo registro
-- AND OCO.unidade_area_militar_nome LIKE '%x BPM%' -- Filtra nome da unidade área militar
-- AND OCO.nome_municipio LIKE '%xxx%' -- Filtra nome do município da ocorrência. Caso prefira, use: -- AND OCO.codigo_municipio = 000 -- Filtra código do município da ocorrência
ORDER BY data_hora_inclusao, OCO.numero_ocorrencia -- Ordena os resultados pela data de inclusão e número da ocorrência
