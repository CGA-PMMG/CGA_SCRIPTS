/*-----------------------------------------------------------------------------------------------------------
 * O objetivo do script é relacionar os indivíduos que possuem mandado de prisão em aberto, sinalizados na tabela SIP, 
 * cruzando dados para captar o número do CPF e/ou CNH, caso disponível.
 * 
 * OBS.: A tabela normaliza os campos nome_do_individuo, nome_da_mae, nome_do_pai, e propoe uma chave de pesquisa,
 * apto para comparar com outras base.
 * 
 * Contribuição: Lázaro S A Filho, Cap PM
 -----------------------------------------------------------------------------------------------------------*/
          WITH CNH_CPF AS                                                                                   -- cruzamento dos dados para captar número de CPF ou CNH relacionado ao mesmo número de RG expedido em MG (utiliza a base de condutores, então só consegue captar de quem tem ou já teve CNH)
                (SELECT
                    numero_registro_renach,
                    numero_cpf,
                    CAST(REPLACE(REPLACE(numero_documento_identificacao, 'M', ''), 'G', '') AS BIGINT) AS numero_registro_geral
                FROM
                    db_bisp_ss06_reporting.tb_pessoa
                WHERE
                    uf_expedidor_documento = 'MG'
                    AND CAST(REPLACE(REPLACE(numero_documento_identificacao, 'M', ''), 'G', '') AS BIGINT) IS NOT NULL)

    SELECT DISTINCT
        s.numero_registro_geral,
        CPF.numero_cpf,
        CPF.numero_registro_renach,

        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            TRANSLATE(s.nome_do_individuo,
                    'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ',
                    'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC'),
            ',', ''),
            '.', ''),
            '-', ''),
            '/', ''),
            '_', '')) AS nome_do_individuo,
        
        CAST(s.data_nascimento_formatada AS DATE) AS 'data_nascimento',

        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            TRANSLATE(s.nome_da_mae,
                    'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ',
                    'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC'),
            ',', ''),
            '.', ''),
            '-', ''),
            '/', ''),
            '_', '')) AS nome_da_mae,

        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            TRANSLATE(s.nome_do_pai,
                    'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ',
                    'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC'),
            ',', ''),
            '.', ''),
            '-', ''),
            '/', ''),
            '_', '')) AS nome_do_pai,

        CONCAT(
            UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                TRANSLATE(s.nome_do_individuo,
                        'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ',
                        'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC'),
                ',', ''),
                '.', ''),
                '-', ''),
                '/', ''),
                '_', '')),
            '-',
            CAST(DATEDIFF(s.data_nascimento_formatada, '1900-01-01') + 2 AS STRING)
        ) AS NOME_NASC,

        CAST(vma.data_emissao AS DATE) AS 'data',
        vma.numero_processo

    FROM 
        db_bisp_sip_reporting.vw_individuo_sip s
    LEFT JOIN                                                                                       -- capta dados do(s) MP(s) cadastrados para o indivíduo (data e nº processo)
        db_bisp_sip_reporting.vw_mandados_abertos vma
        ON s.numero_sip = vma.numero_sip
    LEFT JOIN                                                                                      -- integra a pesquisa cruzada de CPF e CNH do início do código
        CNH_CPF AS CPF
        ON CPF.numero_registro_geral = s.numero_registro_geral
    WHERE                                                                                          -- só retorna os indivíduos que possuem pelo menos um MP cadastrado, e tenha RG pesquisável
        s.mandadosabertos <> 0
        AND s.numero_registro_geral <> 0
    ORDER BY
        CAST(vma.data_emissao AS DATE) DESC
