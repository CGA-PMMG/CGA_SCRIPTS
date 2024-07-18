/*------------------------------------------------------------------------------------------------------------
 * O objetivo deste código SQL é extrair informações detalhadas sobre BOS E BOS AMPLO e os envolvidos, 
 * incluindo dados pessoais dos envolvidos, endereços e informações da ocorrência, para análises e relatórios.
------------------------------------------------------------------------------------------------------------*/
            SELECT	
                OCO.numero_ocorrencia AS NUM_OCORRENCIA,  -- SELECIONA O NÚMERO DA OCORRÊNCIA
                OCO.data_hora_fato AS DATA_FATO,
                UPPER(ENV.nome_completo_envolvido) AS NOME_ENVOLVIDO,  -- SELECIONA O NOME COMPLETO DO ENVOLVIDO EM MAIÚSCULO
                UPPER(ENV.nome_mae) AS NOME_MAE,  -- SELECIONA O NOME DA MÃE DO ENVOLVIDO EM MAIÚSCULO
                ENV.data_nascimento AS DATA_NASCIMENTO, -- SELECIONA DATA DE NASCIMENTO DO ENVOLVIDO
                ENV.envolvimento_descricao AS TIPO_ENVOLVIMENTO,  -- SELECIONA A DESCRIÇÃO DO TIPO DE ENVOLVIMENTO 
                ENV.tipo_logradouro_descricao AS TIPO_LOGRADOURO,  -- SELECIONA A DESCRIÇÃO DO TIPO DE LOGRADOURO 
                ENV.logradouro_nome AS LOGRADOURO,  -- SELECIONA O NOME DO LOGRADOURO 
                ENV.numero_endereco AS NUM_ENDERECO,  -- SELECIONA O NÚMERO DO ENDEREÇO 
                ENV.compl_alfa AS COMPLEMENTO_ALFA,  -- SELECIONA O COMPLEMENTO ALFA 
                ENV.descricao_complementar_endereco AS COMPLEMENTO_ENDERECO,  -- SELECIONA A DESCRIÇÃO DO COMPLEMENTO DO ENDEREÇO 
                ENV.numero_complementar AS NUM_COMPLEMENTAR,  -- SELECIONA O NÚMERO COMPLEMENTAR 
                ENV.codigo_bairro AS COD_BAIRRO,  -- SELECIONA O CÓDIGO DO BAIRRO 
                ENV.nome_bairro AS NOME_BAIRRO,  -- SELECIONA O NOME DO BAIRRO 
                NULLIF(CAST(ENV.codigo_municipio AS INT), 0) AS COD_MUNICIPIO,  -- CONVERTE O CÓDIGO DO MUNICÍPIO PARA INTEIRO, SUBSTITUI 0 POR NULL
                MUN.dsmunicipiosemacentomaiusc AS MUNICIPIO  -- SELECIONA A DESCRIÇÃO DO MUNICÍPIO SEM ACENTOS EM MAIÚSCULAS
            FROM
                db_bisp_reds_reporting.tb_ocorrencia OCO 
            LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia AS ENV  
                ON OCO.numero_ocorrencia = ENV.numero_ocorrencia  
            LEFT JOIN db_bisp_shared.tb_dim_municipio AS MUN 
                ON ENV.codigo_municipio = MUN.cdmunicipioibge6  
            WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
            AND OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO')  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO BOS E BOS AMPLO
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO É RECEBIDO OU FECHADO
            AND OCO.data_hora_fato IS NOT NULL -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO NÃO SÃO NULAS
            AND OCO.data_hora_alteracao  BETWEEN '2024-01-01' AND '2024-05-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DA ALTERAÇÃO ESTÃO NO INTERVALO ESPECIFICADO
            AND ENV.nome_completo_envolvido IS NOT NULL   -- FILTRA NOME COMPLETO DO ENVOLVIDO NÃO É NULO
--          AND UPPER(ENV.nome_completo_envolvido) = 'XXX' -- FILTRA NOME COMPLETO DO ENVOLVIDO EM LETRAS MAIÚSCULAS
--	    AND UPPER (ENV.nome_mae) = 'YYYY' -- FILTRE PELO NOME DA MÃE EM LETRAS MAÍUSCULAS 
--	    AND ENV.data_nascimento = '1899-01-01' -- FILTRE A DATA DE NASCIMENTO DO ENVOLVIDO
            ORDER BY OCO.data_hora_fato  -- ORDENA OS RESULTADOS PELA DATA/HORA DO FATO
