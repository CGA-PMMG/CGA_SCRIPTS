WITH LETALIDADE AS                                                        -- Define uma tabela temporária para filtrar ocorrências com letalidade policial
( 
    SELECT                                                                 -- Inicia a seleção dos campos para a CTE
        ENV.numero_ocorrencia,                                            -- Seleciona o número identificador da ocorrência
        ENV.digitador_id_orgao,                                          -- Seleciona o ID do órgão que digitou a ocorrência
        ENV.natureza_ocorrencia_codigo,                                  -- Seleciona o código da natureza da ocorrência
        ENV.data_hora_fato,                                             -- Seleciona a data e hora do fato
        ENV.ind_militar_policial_servico                                -- Seleciona o indicador se o militar estava em serviço
    FROM 
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV              -- Define a tabela fonte dos dados de envolvidos
    WHERE 1=1                                                           -- Inicia as condições de filtro
        AND ENV.natureza_ocorrencia_codigo IN ('B01121','B01148','B02001')  -- Filtra pelas naturezas específicas de letalidade (Homicídio,Sequestro e Cárcere Privado,Tortura)
        AND ENV.id_envolvimento IN (35,36,44)                          -- Filtra pelos tipos de envolvimento (autor, co-autor, suspeito)
        AND ENV.ind_militar_policial IS NOT DISTINCT FROM 'M'          -- Filtra apenas militares
        AND ENV.ind_militar_policial_servico IS NOT DISTINCT FROM 'S'  -- Filtra apenas militares em serviço
        AND YEAR(ENV.data_hora_fato) = :ANO                           -- Filtra pelo ano parametrizado
        AND MONTH(ENV.data_hora_fato) >= :MESINICIAL                  -- Filtra a partir do mês inicial parametrizado
        AND MONTH(ENV.data_hora_fato) <= :MESFINAL                    -- Filtra até o mês final parametrizado
)

SELECT                                                                 -- Inicia a seleção principal da query
    OCO.numero_ocorrencia,                                            -- Número identificador da ocorrência
    ENV.envolvimento_codigo,                                          -- Código do tipo de envolvimento na ocorrência
    ENV.envolvimento_descricao,                                       -- Descrição do tipo de envolvimento
    ENV.numero_envolvido,                                            -- Número identificador do envolvido
    ENV.nome_completo_envolvido,                                     -- Nome completo do envolvido
    ENV.nome_mae,                                                    -- Nome da mãe do envolvido
    ENV.data_nascimento,                                            -- Data de nascimento do envolvido
    LET.ind_militar_policial_servico,                               -- Indicador se militar estava em serviço
    ENV.condicao_fisica_descricao,                                  -- Descrição da condição física do envolvido
    ENV.natureza_ocorrencia_codigo,                                 -- Código da natureza da ocorrência
    ENV.natureza_ocorrencia_descricao,                              -- Descrição da natureza da ocorrência
    ENV.ind_consumado,                                              -- Indicador se o crime foi consumado ou tentado

[... CASE WHEN para RPM_2024 omitido para brevidade ...]            -- Mapeia municípios para suas respectivas RPMs

[... CASE WHEN para UEOP_2024 omitido para brevidade ...]           -- Mapeia municípios para suas respectivas UEOPs

    OCO.unidade_area_militar_codigo,                                -- Código da unidade militar da área
    OCO.unidade_area_militar_nome,                                 -- Nome da unidade militar da área
    OCO.unidade_responsavel_registro_codigo,                       -- Código da unidade que registrou a ocorrência
    OCO.unidade_responsavel_registro_nome,                         -- Nome da unidade que registrou a ocorrência
    CAST(OCO.codigo_municipio AS INTEGER),                         -- Converte o código do município para número inteiro
    OCO.nome_municipio,                                           -- Nome do município da ocorrência
    OCO.tipo_logradouro_descricao,                               -- Tipo do logradouro (Rua, Avenida, etc)
    OCO.logradouro_nome,                                         -- Nome do logradouro
    OCO.numero_endereco,                                         -- Número do endereço
    OCO.nome_bairro,                                            -- Nome do bairro
    OCO.ocorrencia_uf,                                          -- Estado da ocorrência
    OCO.numero_latitude,                                        -- Latitude da localização
    OCO.numero_longitude,                                       -- Longitude da localização
    OCO.data_hora_fato,                                        -- Data e hora do fato
    YEAR(OCO.data_hora_fato) AS ano,                           -- Ano do fato
    MONTH(OCO.data_hora_fato) AS mes,                          -- Mês do fato
    OCO.nome_tipo_relatorio,                                   -- Tipo do relatório
    OCO.digitador_sigla_orgao                                  -- Sigla do órgão que registrou

FROM db_bisp_reds_reporting.tb_ocorrencia AS OCO                    -- Tabela principal de ocorrências
INNER JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia AS ENV    -- Join com tabela de envolvidos
    ON OCO.numero_ocorrencia = ENV.numero_ocorrencia 
LEFT JOIN LETALIDADE LET                                            -- Join com a CTE de letalidade
    ON OCO.numero_ocorrencia = LET.numero_ocorrencia 

WHERE 1=1                                                           -- Início das condições de filtro
    AND LET.numero_ocorrencia IS NULL                              -- Exclui ocorrências que estão na CTE de letalidade
    AND ENV.id_envolvimento IN (25,32,1097,26,27,28,872)          -- Filtra tipos específicos de envolvimento(Todos vitima)
    AND ENV.natureza_ocorrencia_codigo IN ('B01121','B01148','B02001')  -- Filtra naturezas específicas(Homicídio,Sequestro e Cárcere Privado,Tortura)
    AND ENV.ind_consumado IN ('S','N')                            -- Filtra ocorrências consumadas e tentadas
    AND ENV.condicao_fisica_codigo <> '0100'                      -- Exclui condição física específica(Fatal)
    AND OCO.ocorrencia_uf = 'MG'                                  -- Filtra apenas ocorrências de Minas Gerais
    AND OCO.digitador_sigla_orgao IN ('PM','PC')                  -- Filtra registros da PM ou PC
    AND OCO.nome_tipo_relatorio IN ('POLICIAL','REFAP')           -- Filtra tipos específicos de relatório
    AND YEAR(OCO.data_hora_fato) = :ANO                           -- Filtra pelo ano parametrizado
    AND MONTH(OCO.data_hora_fato) >= :MESINICIAL                  -- Filtra a partir do mês inicial
    AND MONTH(OCO.data_hora_fato) <= :MESFINAL                    -- Filtra até o mês final
    AND OCO.ind_estado = 'F'                                      -- Filtra apenas ocorrências finalizadas

ORDER BY                                                           -- Define a ordem de apresentação dos resultados
    RPM_2024,                                                     -- Primeiro por RPM
    UEOP_2024,                                                    -- Depois por UEOP
    OCO.data_hora_fato,                                          -- Depois por data/hora
    OCO.numero_ocorrencia,                                       -- Depois por número da ocorrência
    ENV.nome_completo_envolvido,                                 -- Depois por nome do envolvido
    ENV.nome_mae,                                                -- Depois por nome da mãe
    ENV.data_nascimento;                                         -- Por fim, por data de nascimento