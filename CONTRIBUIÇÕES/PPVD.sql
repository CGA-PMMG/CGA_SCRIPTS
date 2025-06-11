/*---------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como objetivo principal extrair e organizar dados relevantes e detalhados sobre ocorrências 
 * relacionadas à Patrulha de Prevenção à Violência Doméstica (PPVD), dentro do período especificado.
 * A consulta identifica a natureza da ocorrência com base em códigos específicos, destaca a natureza principal 
 * (violência doméstica, palestra ou segunda resposta), e apresenta informações completas sobre vítimas e autores,
 * filtrando por município e assegurando que vítima e autor não sejam a mesma pessoa.
 * 
 * Contribuição: Valfrido de Novais Santos, Analista P3/19º BPM
 ---------------------------------------------------------------------------------------------------------------*/

SELECT DISTINCT 
    OCO.numero_ocorrencia AS NR_OCORRENCIA, -- Seleciona o número da ocorrência
    -- Define a classificação da natureza da ocorrência com base em códigos específicos
    CASE 
        WHEN OCO.natureza_codigo = 'U33004' 
             OR OCO.natureza_secundaria1_codigo = 'U33004' 
             OR OCO.natureza_secundaria2_codigo = 'U33004' 
             OR OCO.natureza_secundaria3_codigo = 'U33004' 
             THEN 'U33004'  -- Caso possua como natureza principal ou secundária o código de natureza U33004, atribui o valor U33004 a NATUREZA_POS
        WHEN OCO.natureza_codigo IN ('Q04008', 'Q04009', 'Q04010') THEN 'PALESTRA' -- Caso possua como natureza principal um dos códigos 'Q04008', 'Q04009', 'Q04010', atribui o valor PALESTRA
        WHEN OCO.natureza_codigo BETWEEN 'A20003' AND 'A20020' THEN 'SEGUNDA RESPOSTA' -- Caso possua como natureza principal códigos entre A20003 e A20020 , atribui o valor SEGUNDA RESPOSTA
        ELSE '' -- Demais casos retornam vazio
    END AS NATUREZA_POS, -- Nomeia a coluna de classifição da natureza da ocorrência como 'NATUREZA_POS'
    OCO.natureza_codigo AS NATUREZA_CODIGO, -- Seleciona o código da natureza da ocorrência
    OCO.natureza_descricao_longa AS NATUREZA_DESCRICAO, -- Seleciona a descrição detalhada da natureza
    OCO.nome_municipio AS MUNICIPIO, -- Seleciona o nome do município da ocorrência
    OCO.codigo_municipio AS COD_MUNICIPIO, -- Seleciona o código do município
    OCO.nome_bairro AS BAIRRO, -- Seleciona o nome do bairro
    CAST(OCO.data_hora_fato AS date) AS DATA_FATO, -- Converte e seleciona a data do fato
    OCO.digitador_matricula AS NR_PM, -- Seleciona a matrícula do digitador
    OCO.ind_violencia_domestica AS IND_PVD, -- Indicador de violência doméstica
    OCO.digitador_nome AS MILITAR, -- Seleciona o nome do digitador    
    CASE 
        WHEN ENV.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304') THEN ENV.envolvimento_codigo 
        ELSE NULL 
    END AS VITIMA, -- Identifica se o envolvido é vítima com base nos códigos de envolvimento 
    CASE 
        WHEN ENV.envolvimento_codigo IN ('0100', '1100', '0200') THEN ENV.envolvimento_codigo
        ELSE NULL 
    END AS AUTOR, -- Identifica se o envolvido é autor com base nos códigos de envolvimento
    ENV.envolvimento_descricao AS ENVOLVIMENTO_DESCRICAO, -- Seleciona a descrição do envolvimento
    ENV.nome_completo_envolvido AS NOME_ENVOLVIDO, -- Seleciona o nome completo do envolvido
    ENV.numero_cpf_cnpj, -- Seleciona o cpf ou cnpj do envolvido
    ENV.numero_documento_id, -- Seleciona o número do documento de identificação do envolvido
    VITIMAS.nome_completo_envolvido AS NOME_VITIMA, -- Seleciona o nome da vítima (sexo feminino)
    AUTORES.nome_completo_envolvido AS NOME_AUTOR, -- Seleciona o nome do autor (envolvimento com código correspondente)
    ENV.relacao_vitima_autor_descricao_longa -- Seleciona a descrição da relação entre vítima e autor
FROM db_bisp_reds_reporting.tb_ocorrencia AS OCO -- tabela principal de ocorrências
 LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON OCO.numero_ocorrencia = ENV.numero_ocorrencia -- tabela de envolvidos  
 LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia VITIMAS 
   ON VITIMAS.numero_ocorrencia = OCO.numero_ocorrencia 
   AND VITIMAS.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304') 
   AND VITIMAS.codigo_sexo = 'F' -- join com tb_envolvido_ocorrencia, focando em vítimas do sexo feminino
 LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia AUTORES -- join com autores
   ON AUTORES.numero_ocorrencia = OCO.numero_ocorrencia 
   AND AUTORES.envolvimento_codigo IN ('0100', '1100', '0200') -- join com tb_envolvido_ocorrencia, focando em autores
 WHERE 1 = 1 -- condição sempre verdadeira para facilitar a adição de filtros
  AND OCO.ocorrencia_uf = 'MG'      -- Filtra apenas ocorrências do estado de Minas Gerais
  AND OCO.digitador_id_orgao = 0 -- Filtra pelo ID do órgão digitador - PM 
  AND (
        (OCO.natureza_codigo BETWEEN 'A20003' AND 'A20020') 
        OR OCO.natureza_codigo IN ('U33004', 'U33025', 'Q04008', 'Q04009', 'Q04010') 
        OR OCO.natureza_secundaria1_codigo = 'U33004'
        OR OCO.natureza_secundaria2_codigo = 'U33004'
        OR OCO.natureza_secundaria3_codigo = 'U33004'
      ) -- Filtra por naturezas relevantes à PPVD
  AND ENV.envolvimento_codigo IN ('1300', '1399', '1301', '1302', '1303', '1304', '0100', '1100', '0200') -- Filtra por códigos de envolvimento válidos
  AND (
        VITIMAS.nome_completo_envolvido <> AUTORES.nome_completo_envolvido 
        OR VITIMAS.nome_completo_envolvido IS NULL 
        OR AUTORES.nome_completo_envolvido IS NULL
      ) -- Garante que vítima e autor não sejam a mesma pessoa
  AND OCO.data_hora_fato BETWEEN '2025-05-01 00:00:00.000' AND '2025-05-30 23:59:59.000'
-- AND OCO.unidade_responsavel_registro_nome LIKE '%xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
-- AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.
