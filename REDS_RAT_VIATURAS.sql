/*---------------------------------------------------------------------------------------------------------------------
* O objetivo deste scriot é extrair informações sobre viaturas empenhadas no RAT. Incluindo o número da ocorrência, 
* número sequencial da viatura, placa, e número de registro, para análises e relatórios.
---------------------------------------------------------------------------------------------------------------------*/
    SELECT	
                OCO.numero_ocorrencia AS 'NUM_ATIVIDADE',  -- SELECIONA O NÚMERO DA OCORRÊNCIA 
                VTR.numero_sequencial_viatura AS 'NUM_SEQ_RECURSO',  -- SELECIONA O NÚMERO SEQUENCIAL DA VIATURA 
                VTR.placa AS 'NUM_PLACA',  -- SELECIONA A PLACA DA VIATURA 
                VTR.numero_reg AS 'NUM_PREFIXO'  -- SELECIONA O NÚMERO DE REGISTRO DA VIATURA 
    FROM
                db_bisp_reds_reporting.tb_ocorrencia AS OCO  -- ESPECIFICA A TABELA DE OCORRÊNCIAS COMO FONTE DOS DADOS
        LEFT JOIN db_bisp_reds_reporting.tb_viatura_ocorrencia VTR  -- FAZ UM LEFT JOIN COM A TABELA DE VIATURAS NAS OCORRÊNCIAS
        ON  OCO.numero_ocorrencia = VTR.numero_ocorrencia  -- DEFINE A CONDIÇÃO DE JUNÇÃO BASEADA NO NÚMERO DA OCORRÊNCIA
    WHERE 1=1  -- CONDIÇÃO SEMPRE VERDADEIRA PARA FACILITAR A ADIÇÃO DE OUTRAS CONDIÇÕES
            AND orgao_sigla = 'PM'  -- FILTRA OCORRÊNCIAS ONDE A SIGLA DO ÓRGÃO É 'PM'
            AND OCO.nome_tipo_relatorio = 'RAT'  -- FILTRA OCORRÊNCIAS ONDE O TIPO DE RELATÓRIO É 'RAT'
            AND OCO.ind_estado IN ('R', 'F')  -- FILTRA OCORRÊNCIAS ONDE O ESTADO É RECEBIDO OU FECHADO
            AND OCO.data_hora_fato IS NOT NULL  -- FILTRA OCORRÊNCIAS ONDE A DATA/HORA DO FATO NÃO SÃO NULAS
            AND VTR.data_hora_fato BETWEEN '2024-01-02' AND '2024-05-01'  -- FILTRA OCORRÊNCIAS ONDE A DATA E HORA DO FATO ESTÃO NO INTERVALO ESPECIFICADO
--            AND OCO.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE A UEOP   
--            AND OCO.numero_ocorrencia = 'XXXX'   -- FILTRE PELO NÚMERO DA OCORRÊNCIA
--	      AND VTR.placa = 'XXX'-- FILTRE PELA PLACA DA VIATURA
 ORDER BY VTR.data_hora_fato;  -- ORDENA OS RESULTADOS PELA DATA E HORA DO FATO
