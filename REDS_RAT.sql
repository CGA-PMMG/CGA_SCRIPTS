/*-----------------------------------------------------------------------------------------------------------------------
O objetivo deste script é extrair informações sobre RAT registrados. Incluindo dados sobre a natureza da ocorrência, local, datas e horas dos eventos, unidades responsáveis e geolocalização.
-------------------------------------------------------------------------------------------------------------------------*/
        SELECT	
                OCO.numero_ocorrencia AS 'RAT.NUM_ATIVIDADE',  -- SELECIONA O NÚMERO DA OCORRÊNCIA
                OCO.natureza_codigo AS 'NAT.CODIGO',  -- SELECIONA O CÓDIGO DA NATUREZA E
                OCO.natureza_descricao AS 'NAT.DESCRICAO',  -- SELECIONA A DESCRIÇÃO DA NATUREZA 
                FROM_TIMESTAMP(OCO.data_hora_inclusao, 'dd/MM/yyyy') AS DTA_INCLUSAO,  -- CONVERTE E FORMATA A DATA DE INCLUSÃO PARA 'dd/MM/yyyy' 
                FROM_TIMESTAMP(OCO.data_hora_inclusao, 'HH:mm') AS HORA_INCLUSAO,  -- CONVERTE E FORMATA HORA DE INCLUSÃO PARA 'HH:mm' 
                FROM_TIMESTAMP(OCO.data_hora_fato, 'dd/MM/yyyy') AS DTA_INICIO,  -- CONVERTE E FORMATA A DATA DO FATO PARA 'dd/MM/yyyy'
                FROM_TIMESTAMP(OCO.data_hora_fato, 'HH:mm') AS HRA_INICIO,  -- CONVERTE E FORMATA A HORA DO FATO PARA 'HH:mm' 
                FROM_TIMESTAMP(OCO.data_hora_final, 'dd/MM/yyyy') AS DTA_TERMINO,  -- CONVERTE E FORMATA A DATA FINAL PARA 'dd/MM/yyyy' 
                FROM_TIMESTAMP(OCO.data_hora_final, 'HH:mm') AS HRA_TERMINO,  -- CONVERTE E FORMATA A HORA FINAL PARA 'HH:mm' 
                OCO.complemento_natureza_descricao AS 'DES_ALVO_EVENTO',  -- SELECIONA A DESCRIÇÃO DO COMPLEMENTO DA NATUREZA
                OCO.local_imediato_descricao AS 'DESC_LUGAR',  -- SELECIONA A DESCRIÇÃO DO LOCAL IMEDIATO 
                OCO.nome_operacao AS 'NOME_OPERACAO',  -- SELECIONA O NOME DA OPERAÇÃO 
                OCO.unidade_responsavel_registro_codigo AS 'COD_UNIDADE_SERVICO',  -- SELECIONA O CÓDIGO DA UNIDADE RESPONSÁVEL PELO REGISTRO 
                OCO.unidade_responsavel_registro_nome AS 'NOME_UNID_RESPONSAVEL',  -- SELECIONA O NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO 
                OCO.tipo_logradouro_descricao AS 'TIPO_LOGRADOURO',  -- SELECIONA A DESCRIÇÃO DO TIPO DE LOGRADOURO 
                OCO.logradouro_nome AS 'LOGRADOURO',  -- SELECIONA O NOME DO LOGRADOURO 
                OCO.descricao_endereco AS 'DESC_ENDERECO',  -- SELECIONA A DESCRIÇÃO DO ENDEREÇO
                OCO.numero_endereco AS 'NUM_ENDERECO',  -- SELECIONA O NÚMERO DO ENDEREÇO 
                OCO.complemento_alfa AS 'COMPLEMENTO_ALFA',  -- SELECIONA O COMPLEMENTO ALFA 
                OCO.descricao_complemento_endereco AS 'COMPLEMENTO_ENDERECO',  -- SELECIONA A DESCRIÇÃO DO COMPLEMENTO DO ENDEREÇO
                OCO.numero_complementar AS 'NUM_COMPLEMENTAR',  -- SELECIONA O NÚMERO COMPLEMENTAR 
                OCO.codigo_bairro AS 'COD_BAIRRO',  -- SELECIONA O CÓDIGO DO BAIRRO 
                OCO.nome_bairro AS 'NOME_BAIRRO',  -- SELECIONA O NOME DO BAIRRO 
                OCO.tipo_logradouro2_descricao AS 'TIPO_LOGRADOURO2',  -- SELECIONA A DESCRIÇÃO DO TIPO DE LOGRADOURO SECUNDÁRIO 
                OCO.logradouro2_nome AS 'LOGRADOURO2',  -- SELECIONA O NOME DO LOGRADOURO SECUNDÁRIO 
                OCO.descricao_endereco_2 AS 'DES_ENDERECO2',  -- SELECIONA A DESCRIÇÃO DO ENDEREÇO SECUNDÁRIO 
                NULLIF(CAST(OCO.codigo_municipio AS INT), 0) AS 'COD_MUNICIPIO',  -- CONVERTE O CÓDIGO DO MUNICÍPIO PARA INTEIRO, SUBSTITUI 0 POR NULL
                OCO.nome_municipio AS 'MUNICIPIO',  -- SELECIONA O NOME DO MUNICÍPIO 
                OCO.numero_latitude AS 'LATITUDE',  -- SELECIONA A LATITUDE 
                OCO.numero_longitude AS 'LONGITUDE',  -- SELECIONA A LONGITUDE 
                MASTER.codigo_unidade_area AS 'COD_UNIDADE_AREA',  -- SELECIONA O CÓDIGO DA UNIDADE DE ÁREA 
                MASTER.unidade_area_militar_nome AS 'NOM_UNIDADE_AREA',  -- SELECIONA O NOME DA UNIDADE DE ÁREA MILITAR 
                CONCAT('PM', OCO.digitador_matricula) AS 'DIGITADOR'  -- CONCATENA 'PM' COM A MATRÍCULA DO DIGITADOR
        FROM
                db_bisp_reds_reporting.tb_ocorrencia OCO  
            LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg AS MASTER  
                ON OCO.id_local = MASTER.id_local  
        WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
        	AND OCO.digitador_sigla_orgao = 'PM'
            AND OCO.nome_tipo_relatorio = 'RAT'  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO É 'RAT'
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO É 'RECEBIDO' OU 'FECHADO'
            AND OCO.data_hora_fato BETWEEN '2024-01-01' AND '2024-05-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO ESTÃO NO INTERVALO ESPECIFICADO
--            AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE A UEOP - GP/PL/CIA/BPM/RPM
            ORDER BY OCO.data_hora_fato;  -- ORDENA OS RESULTADOS PELA DATA/HORA DO FATO
        


