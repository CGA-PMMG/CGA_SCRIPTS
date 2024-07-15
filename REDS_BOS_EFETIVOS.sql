/*-----------------------------------------------------------------------------------------------------------------
O objetivo deste script é extrair informações sobre os efetivos que registraram ocorrências, incluindo o número 
da ocorrência, matrícula, nome, cargo do digitador, e detalhes da unidade responsável, dentro de um período específico, 
forncento uma análise sobre o efetivo empenhado em um BOS ou BOS AMPLO.
------------------------------------------------------------------------------------------------------------------*/
 SELECT	
                OCO.numero_ocorrencia AS NUM_REDS,  -- SELECIONA O NÚMERO DA OCORRÊNCIA 
                OCO.digitador_matricula AS NUM_MATRICULA,  -- SELECIONA A MATRÍCULA DO DIGITADOR 
                OCO.digitador_nome AS NOME,  -- SELECIONA O NOME DO DIGITADOR 
                OCO.digitador_cargo_efetivo AS NOME_CARGO,  -- SELECIONA O CARGO EFETIVO DO DIGITADOR
                OCO.unidade_responsavel_registro_codigo AS COD_UNIDADE_SERVICO,  -- SELECIONA O CÓDIGO DA UNIDADE RESPONSÁVEL PELO REGISTRO 
                OCO.unidade_responsavel_registro_nome AS NOME_UNIDADE  -- SELECIONA O NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO 
FROM
                db_bisp_reds_reporting.tb_ocorrencia OCO  -- ESPECIFICA A TABELA DE OCORRÊNCIAS COMO FONTE DOS DADOS
WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA GERALMENTE UTILIZAMOS PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
            AND OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO')  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO BOS E BOS AMPLO
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO RECEBIDO E FECHADO
            AND OCO.data_hora_fato BETWEEN '2024-01-01' AND '2024-05-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO ESTÃO NO INTERVALO ESPECIFICADO
            AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE A UEOP - GP/PL/CIA/BPM/RPM
            ORDER BY OCO.data_hora_fato;  -- ORDENA OS RESULTADOS PELA DATA/HORA DO FATO