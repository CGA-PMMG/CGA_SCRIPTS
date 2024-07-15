/*--------------------------------------------------------------------------------------------------------------
O objetivo deste script é extrair informações detalhadas de BOS E BOS AMPLO registrados, incluindo dados sobre
a natureza, local, datas e horas dos eventos, e unidades responsáveis, útil em análises e relatórios.
---------------------------------------------------------------------------------------------------------------*/

SELECT	
                OCO.numero_ocorrencia AS 'NUM_OCORRENCIA',  -- Seleciona o número da ocorrência 
                OCO.natureza_codigo AS 'NAT.CODIGO',  -- Seleciona o código da natureza 
                OCO.natureza_descricao AS 'NAT.DESCRICAO',  -- Seleciona a descrição da natureza 
                FROM_TIMESTAMP(OCO.data_hora_inclusao, 'dd/MM/yyyy') AS DTA_INCLUSAO,  -- Converte e formata a data de inclusão da ocorrência para dd/MM/yyyy
                FROM_TIMESTAMP(OCO.data_hora_inclusao, 'HH:mm') AS HRA_INCLUSAO, -- Converte e formata a hora da inclusão da ocorrência para HH:mm 
                FROM_TIMESTAMP(OCO.data_hora_fato, 'dd/MM/yyyy') AS DTA_INICIO,  -- Converte e formata a data do fato da ocorrência para dd/MM/yyyy 
                FROM_TIMESTAMP(OCO.data_hora_fato, 'HH:mm') AS HRA_INICIO,  -- Converte e formata a hora do fato da ocorrência para HH:mm 
                FROM_TIMESTAMP(OCO.data_hora_final, 'dd/MM/yyyy') AS DTA_TERMINO,  -- Converte e formata a data final da ocorrência para dd/MM/yyyy 
                FROM_TIMESTAMP(OCO.data_hora_final, 'HH:mm') AS HRA_TERMINO,  -- Converte e formata a hora final da ocorrência para HH:mm 
                OCO.complemento_natureza_descricao AS DES_ALVO_EVENTO,  -- Seleciona a descrição do complemento da natureza 
                OCO.local_imediato_descricao AS DES_LUGAR,  -- Seleciona a descrição do local imediato da ocorrência
                OCO.unidade_responsavel_registro_codigo AS COD_UNIDADE_SERVICO,  -- Seleciona o código da unidade responsável pelo registro 
                OCO.unidade_responsavel_registro_nome AS NOME_UNID_RESPONSAVEL,  -- Seleciona o nome da unidade responsável pelo registro 
                OCO.tipo_logradouro_descricao AS TIPO_LOGRADOURO,  -- Seleciona a descrição do tipo de logradouro 
                OCO.logradouro_nome AS LOGRADOURO,  -- Seleciona o nome do logradouro 
                OCO.descricao_endereco AS DESC_ENDERECO,  -- Seleciona a descrição do endereço 
                OCO.numero_endereco AS NUM_ENDERECO,  -- Seleciona o número do endereço 
                OCO.complemento_alfa AS COMPLEMENTO_ALFA,  -- Seleciona o complemento alfa 
                OCO.descricao_complemento_endereco AS COMPLEMENTO_ENDERECO,  -- Seleciona a descrição do complemento do endereço 
                OCO.numero_complementar AS NUM_COMPLEMENTAR,  -- Seleciona o número complementar 
                OCO.codigo_bairro AS COD_BAIRRO,  -- Seleciona o código do bairro 
                OCO.nome_bairro AS NOME_BAIRRO,  -- Seleciona o nome do bairro 
                OCO.tipo_logradouro2_descricao AS TIPO_LOGRADOURO2,  -- Seleciona a descrição do tipo de logradouro secundário 
                OCO.logradouro2_nome AS LOGRADOURO2,  -- Seleciona o nome do logradouro secundário 
                OCO.descricao_endereco_2 AS DESC_ENDERECO2,  -- Seleciona a descrição do endereço secundário 
                NULLIF(CAST(OCO.codigo_municipio AS INT), 0) AS COD_MUNICIPIO,  -- Converte o código do município para inteiro, substitui 0 por NULL
                OCO.nome_municipio AS MUNICIPIO,  -- Seleciona o nome do município 
                OCO.numero_latitude AS LATITUDE,  -- Seleciona a latitude 
                OCO.numero_longitude AS lONGITUDE,  -- Seleciona a longitude 
                MASTER.codigo_unidade_area AS COD_UNIDADE_AREA,  -- Seleciona o código da unidade de área 
                MASTER.unidade_area_militar_nome AS NOM_UNIDADE_AREA,  -- Seleciona o nome da unidade de área militar 
                CONCAT('PM', OCO.digitador_matricula) AS DIGITADOR  -- Concatena PM com a matrícula do digitador 
            FROM
                db_bisp_reds_reporting.tb_ocorrencia OCO  
            LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg AS MASTER  -- Faz um LEFT JOIN com a tabela de unidades de área
                ON OCO.id_local = MASTER.id_local  
            WHERE 1=1  -- Condição sempre verdadeira 
            AND OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO')  -- Filtra ocorrências onde o tipo de relatório está na lista especificada
            AND OCO.ind_estado IN ('R', 'F')  -- Filtra ocorrências onde o estado é Recebido ou Fechado
            AND OCO.data_hora_fato BETWEEN '2024-01-01' AND '2024-03-01'  -- Filtra ocorrências onde a data/hora do fato estão no intervalo especificado
--            AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- Filtre a UEOp - GP/PL/CIA/BPM/RPM
            ORDER BY OCO.data_hora_fato;  -- Ordena os resultados pela data/hora do fato

            
