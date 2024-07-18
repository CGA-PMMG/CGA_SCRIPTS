/*--------------------------------------------------------------------------------------------------------------
 * O objetivo deste script  é extrair informações sobre viaturas empenhadas em ocorrências registradas, 
 * incluindo número da ocorrência, número sequencial da viatura, placa, número de registro e unidade responsável.
----------------------------------------------------------------------------------------------------------------*/
            SELECT	
                OCO.numero_ocorrencia AS 'NUM_OCORRENCIA',  -- SELECIONA O NÚMERO DA OCORRÊNCIA 
                VTR.numero_sequencial_viatura AS 'NUM_SEQ_RECURSO',  -- SELECIONA O NÚMERO SEQUENCIAL DA VIATURA
                VTR.placa AS 'NUM_PLACA',  -- SELECIONA A PLACA DA VIATURA 
                VTR.numero_reg AS 'NUM_PREFIXO' , -- SELECIONA O NÚMERO DE REGISTRO DA VIATURA 
                OCO.unidade_responsavel_registro_nome 'UEOP'-- SELECIONA A UNIDADE RESPONSÁVEL PELO REGRISTRO
            FROM
                db_bisp_reds_reporting.tb_ocorrencia AS OCO  
            LEFT JOIN db_bisp_reds_reporting.tb_viatura_ocorrencia VTR  
                ON  OCO.numero_ocorrencia = VTR.numero_ocorrencia  
            WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
            AND orgao_sigla = 'PM'  -- FILTRA OCORRÊNCIAS ONDE A SIGLA DO ÓRGÃO É 'PM'
            AND OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO')  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO BOS E BOS AMPLO
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO É RECEBIDO OU FECHADO
			AND OCO.data_hora_fato IS NOT NULL -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO NÃO SÃO NULAS
            AND VTR.data_hora_fato  BETWEEN '2024-01-01' AND '2024-02-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO ESTÃO NO INTERVALO ESPECIFICADO
--          AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE A UEOP - GP/PL/CIA/BPM/RPM
-- 	        AND VTR.placa = 'XXX' -- FILTRE PELA PLACA DA VIATURA
-- 	        AND OCO.numero_ocorrencia = 'XXX'--FILTRE PELO NÚMERO DO BOS/BOS AMPLO
            ORDER BY VTR.data_hora_fato  -- ORDENA OS RESULTADOS PELA DATA E HORA DO FATO
