/*---------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como objetivo principal extrair e organizar dados releantes e detalhados sobre ocorrências 
 * relacionadas à Patrulha de Prevenção à Violência Doméstica (PPVD).
 * 
 * Contribuição: Valfrido de Novais Santos, Analista P3/19º BPM
 ---------------------------------------------------------------------------------------------------------------*/
SELECT DISTINCT 
    OCO.numero_ocorrencia AS NR_OCORRENCIA,  -- SELECIONA O NÚMERO DA OCORRÊNCIA
    -- DEFINE A NATUREZA DA OCORRÊNCIA COM BASE EM CÓDIGOS ESPECÍFICOS
    CASE 
        WHEN OCO.natureza_codigo = 'U33004' 
             OR OCO.natureza_secundaria1_codigo = 'U33004' 
             OR OCO.natureza_secundaria2_codigo = 'U33004' 
             OR OCO.natureza_secundaria3_codigo = 'U33004' 
             THEN 'U33004'  -- SE EM UMA DESTAS NATUREZAS(PRINCIPAL OU SECUNDÁRIAS) O CÓDIGO SEJA IGUAL A  'U33004' -VIOLÊNCIA DOMÉSTICA-. RETORNE 'U33004'
        WHEN OCO.natureza_codigo IN ('Q04008', 'Q04009', 'Q04010') THEN 'PALESTRA'  -- SE UM DESTES CÓDIGOS (RESPECTIVAMENTE, MEDIDAS DE AUTOPROTEÇÃO, PALESTRA SOBRE AS REDES DE PROTEÇÃO, REUNIOES SOBRE PREVENCAO A VIOLENCIA DOMESTICA ) FOR VERDADEIRO, RETORNE 'PALESTRA'
        WHEN OCO.natureza_codigo BETWEEN 'A20003' AND 'A20020' THEN 'SEGUNDA RESPOSTA'  -- SE O CÓDIGO DA NATUREZA ESTIVER ENTRE 'A20003' E 'A20020', RETORNE 'SEGUNDA RESPOSTA'
        ELSE '' -- SENÃO, RETORNE VAZIO
    END AS NATUREZA_POS, -- NOMEANDO A COLUNA CRIADA COMO 'NATUREZA_POS'
    OCO.natureza_codigo AS NATUREZA_CODIGO,       -- SELECIONA O CÓDIGO DA NATUREZA DA OCORRÊNCIA
    OCO.natureza_descricao_longa AS NATUREZA_DESCRICAO, -- SELECIONA A DESCRIÇÃO DETALHADA DA NATUREZA DA OCORRÊNCIA
    OCO.nome_municipio AS MUNICIPIO, -- SELECIONA O NOME DO MUNICÍPIO DA OCORRÊNCIA
    OCO.codigo_municipio AS COD_MUNICIPIO,  -- SELECIONA O CÓDIGO DO MUNICÍPIO DA OCORRÊNCIA
    OCO.nome_bairro AS BAIRRO, -- SELECIONA O NOME DO BAIRRO DA OCORRÊNCIA
    CAST(OCO.data_hora_fato AS date) AS DATA_FATO,  -- SELECIONA A DATA DA OCORRÊNCIA (CONVERTIDA PARA O TIPO DATE)
    OCO.digitador_matricula AS NR_PM, -- SELECIONA O NÚMERO DA MATRICULA DO  PM QUE REGISTROU A OCORRÊNCIA
    OCO.ind_violencia_domestica AS IND_PVD, -- INDICADOR DE VIOLÊNCIA DOMÉSTICA 
    OCO.digitador_nome AS MILITAR, -- SELECIONA O NOME DO PM QUE DIGITOU A OCORRÊNCIA
    CASE 
        WHEN ENV.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304') THEN ENV.envolvimento_codigo 
        ELSE NULL 
    END AS VITIMA, -- IDENTIFICA SE O ENVOLVIDO É UMA VÍTIMA COM BASE NOS CÓDIGOS DE ENVOLVIMENTO
    CASE 
        WHEN ENV.envolvimento_codigo IN ('0100', '1100', '0200') THEN ENV.envolvimento_codigo
        ELSE NULL 
    END AS AUTOR, -- IDENTIFICA SE O ENVOLVIDO É UM AUTOR COM BASE NOS CÓDIGOS DE ENVOLVIMENTO
    ENV.envolvimento_descricao AS ENVOLVIMENTO_DESCRICAO, -- SELECIONA A DESCRIÇÃO DO ENVOLVIMENTO DO INDIVÍDUO NA OCORRÊNCIA
    ENV.nome_completo_envolvido AS NOME_ENVOLVIDO,  -- SELECIONA O NOME COMPLETO DO ENVOLVIDO
    ENV.numero_cpf_cnpj,  -- SELECIONA O CPF/CNPJ DO ENVOLVIDO
    ENV.numero_documento_id, -- SELECIONA O NÚMERO DO DOCUMENTO DE IDENTIFICAÇÃO DO ENVOLVIDO (SE DISPONÍVEL)
    VITIMAS.nome_completo_envolvido AS NOME_VITIMA,-- SELECIONA O NOME COMPLETO DA VÍTIMA (SE APLICÁVEL)
    AUTORES.nome_completo_envolvido AS NOME_AUTOR, -- SELECIONA O NOME COMPLETO DO AUTOR (SE APLICÁVEL)
    ENV.relacao_vitima_autor_descricao_longa -- SELECIONA A DESCRIÇÃO DETALHADA DA RELAÇÃO ENTRE VÍTIMA E AUTOR (SE APLICÁVEL)
FROM db_bisp_reds_reporting.tb_ocorrencia AS OCO  -- TABELA PRINCIPAL: OCORRÊNCIAS
    LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV -- TABELA DE ENVOLVIDOS
       ON ENV.numero_ocorrencia = OCO.numero_ocorrencia 
    LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia VITIMAS -- LEFT JOIN COM A TABELA VITIMAS (ENVOLVIDO CUJO NÚMERO DA OCORRÊNCIA É CORRESPONDENTE, O CÓDIGO DE ENVOLVIMENTO INDICA VITIMA E O SEXO É IGUAL A FEMININO)
        ON VITIMAS.numero_ocorrencia = OCO.numero_ocorrencia 
        AND VITIMAS.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304')  -- CÓDIGOS DE ENVOLVIMENTO QUE INDICAM VÍTIMAS
        AND VITIMAS.codigo_sexo ='F'  -- CONSIDERA APENAS VÍTIMAS DO SEXO FEMININO
    LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia AUTORES -- LEFT JOIN COM A TABELA VITIMAS (ENVOLVIDO CUJO NÚMERO DA OCORRÊNCIA É CORRESPONDENTE E O CÓDIGO DE ENVOLVIMENTO INDICA AUTOR)
        ON AUTORES.numero_ocorrencia = OCO.numero_ocorrencia 
        AND AUTORES.envolvimento_codigo IN ('0100', '1100', '0200')   -- CÓDIGOS DE ENVOLVIMENTO QUE INDICAM AUTORES
WHERE 
    1 = 1  -- CONDIÇÃO SEMPRE VERDADEIRA (PERMITE ADICIONAR OUTRAS CONDIÇÕES FACILMENTE)
    AND OCO.codigo_municipio = 000  -- FILTRA POR MUNICÍPIO
    AND (
        (OCO.natureza_codigo BETWEEN 'A20003' AND 'A20020') 
        OR OCO.natureza_codigo IN ('U33004', 'U33025', 'Q04008', 'Q04009', 'Q04010') 
        OR OCO.natureza_secundaria1_codigo = 'U33004'
        OR OCO.natureza_secundaria2_codigo = 'U33004'
        OR OCO.natureza_secundaria3_codigo = 'U33004'
       ) -- FILTRA POR NATUREZAS DE OCORRÊNCIA RELEVANTES PARA A PPVD
    AND ENV.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304', '0100', '1100', '0200') -- FILTRA POR NATUREZAS DE OCORRÊNCIA RELEVANTES PARA A PPVD
    AND YEAR(OCO.data_hora_fato) >= 2023  -- CONSIDERA APENAS OCORRÊNCIAS A PARTIR DE 2023
    AND (
        VITIMAS.nome_completo_envolvido <> AUTORES.nome_completo_envolvido 
        OR VITIMAS.nome_completo_envolvido IS NULL 
        OR AUTORES.nome_completo_envolvido IS NULL
        )  -- GARANTE QUE A VÍTIMA E O AUTOR SEJAM PESSOAS DIFERENTES
