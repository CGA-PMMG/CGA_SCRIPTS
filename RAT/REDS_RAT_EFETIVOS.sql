/*-----------------------------------------------------------------------------------------------------------------
 * O objetivo deste código SQL é extrair informações sobre os efetivos empenhado no RAT. Incluindo o 
 * número da ocorrência, matrícula, nome, cargo do digitador, e  unidade responsável.
--------------------------------------------------------------------------------------------------------------------*/
            SELECT	
                OCO.numero_ocorrencia AS 'NUM_ATIVIDADE',  -- SELECIONA O NÚMERO DA OCORRÊNCIA 
                OCO.digitador_matricula AS 'NUM_MATRICULA',  -- SELECIONA A MATRÍCULA DO DIGITADOR
                OCO.digitador_nome AS 'NOME',  -- SELECIONA O NOME DO DIGITADOR
                OCO.digitador_cargo_efetivo AS 'CARGO',  -- SELECIONA O CARGO EFETIVO DO DIGITADOR 
                OCO.unidade_responsavel_registro_codigo AS 'COD_UNIDADE_SERVICO',  -- SELECIONA O CÓDIGO DA UNIDADE RESPONSÁVEL PELO REGISTRO
                OCO.unidade_responsavel_registro_nome AS 'NOME_UNIDADE',  -- SELECIONA O NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO
            OCO.data_hora_alteracao,
            OCO.data_hora_fato
                FROM
                db_bisp_reds_reporting.tb_ocorrencia OCO  
            WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
         	AND OCO.digitador_sigla_orgao = 'PM'  
            AND OCO.nome_tipo_relatorio = 'RAT'  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO É 'RAT'
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO É RECEBIDO OU FECHADO
            AND OCO.data_hora_fato IS NOT NULL -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO NÃO SÃO NULAS
            AND OCO.data_hora_alteracao  BETWEEN '2024-01-01' AND '2024-05-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DA ALTERAÇÃO ESTÃO NO INTERVALO ESPECIFICADO
--          AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE A UEOP - GP/PL/CIA/BPM/RPM
--	        AND OCO.digitador_matricula ='XXXX' -- FILTRE A MATRÍCULA DO DIGITADOR
            ORDER BY OCO.data_hora_fato  -- ORDENA OS RESULTADOS PELA DATA/HORA DO FATO;
