/*-----------------------------------------------------------------------------------------------------------------
 * Este script foi elaborado com o propósito de identificar produtividade do RAT. O código 
 * seleciona o número do RAT, a descrição do indicador, a quantidade relacionada, a data e hora do fato,
 * além de identificar a unidade responsável pelo registro, decomposta em seus diferentes 
 * níveis hierárquicos (RPM, BPM, Companhia, e Pelotão).
 -----------------------------------------------------------------------------------------------------------------*/
SELECT        
                PROD.numero_ocorrencia AS 'RAT.NUM_ATIVIDADE', -- SELECIONA O NÚMERO DO RAT (OCORRÊNCIA-RAT)
                PROD.indicador_descricao AS DESCRICAO, -- SELECIONA A DESCRIÇÃO DO INDICADOR
                PROD.quantidade AS QUANTIDADE, -- SELECIONA A QUANTIDADE INDICADOR
                PROD.data_hora_fato AS DATA_FATO, -- SELECIONA A DATA/HORA DO RAT
	SPLIT_PART(PROD.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- EXTRAI O ÚLTIMO SEGMENTO PARA IDENTIFICAR A RPM
SPLIT_PART(PROD.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- EXTRAI O PENÚLTIMO SEGMENTO PARA IDENTIFICAR O BPM
SPLIT_PART(PROD.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- EXTRAI O ANTEPENÚLTIMO SEGMENTO PARA IDENTIFICAR A CIA
 SPLIT_PART(PROD.unidade_responsavel_registro_nome, '/', -4) AS PELOTAO -- EXTRAI O ANTEPENÚLTIMO SEGMENTO PARA IDENTIFICAR O PELOTAO
FROM
                db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia PROD
WHERE 1=1 -- FILTRA SEMPRE VERDADEIRO
            AND PROD.quantidade != 0 -- FILTRA QUANTIDADE DIFERENTE DE 0 (ZERO)
            AND PROD.data_hora_fato BETWEEN '2023-01-01' AND '2024-05-01' -- FILTRA DATA/HORA DO RAT ENTRE 'DATAX' E 'DATAY' 
            AND PROD.unidade_responsavel_registro_nome LIKE '%/X RPM' -- FILTRE PELA RPM/BPM/CIA/PEL
            ORDER BY RPM, BPM, CIA, PELOTAO, PROD.data_hora_fato -- ORDENA PELA UNIDADE RESPONSÁVEL PELO REGISTRO E A DATA/HORA 
