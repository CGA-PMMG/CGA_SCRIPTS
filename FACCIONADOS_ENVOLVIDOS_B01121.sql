/*----------------------------------------------------------------------------------------------------------------------------
 * Este script foi desenvolvido para realizar uma análise detalhada de faccionados envolvidos em crimes de homicídio 
 * classificados sob o código de natureza 'B01121'. A análise é feita através da criação de uma tabela temporária de faccionados 
 * e da junção CTE com a tabela de envolvidos e ocorrências.
 * 
 * Número da OS: 464014
 ---------------------------------------------------------------------------------------------------------------------------*/
WITH 
-- CTE para criar uma tabela temporária com dados de faccionados
FACCIONADOS AS
(
SELECT UPPER('NOME COMPLETO DO FACCIONADO') AS nome_completo_faccionado, UPPER('NOME DA MÃE DO FACCIONADO') AS nome_mae_fac, TO_TIMESTAMP('1899/01/01', 'dd/MM/yyyy') AS data_nascimento_fac UNION -- SELECIONA O NOME DO FACCIONADO, O NOME DA MÃE DO FACCIONADO E A DATA DE NASCIMENTO DO FACCIONADO E CRIA UMA UNIÃO COM O PRÓXIMO SELECT CONSTRUINDO UMA TABELA TEMPORÁRIA ----- PARA INSERIR N FACCIONADOS, REPLIQUE ESTA LINHA COM OS DADOS DE CADA UM DOS FACCIONADOS. -----										
SELECT UPPER('NOME COMPLETO DO FACCIONADO DOIS') AS nome_completo_faccionado, UPPER('NOME DA MÃE DO FACCIONADO DOIS') AS nome_mae_fac, TO_TIMESTAMP('23/10/2001', 'dd/MM/yyyy') AS data_nascimento_fac	-- SELECIONA O NOME DO FACCIONADO, O NOME DA MÃE DO FACCIONADO E A DATA DE NASCIMENTO DO FACCIONADO								
)
    SELECT
        UPPER(ENV.nome_completo_envolvido) as NOME_COMPLETO_ENVOLVIDO, -- SELECIONA O NOME COMPLETO DO ENVOLVIDO
        UPPER(ENV.nome_mae) AS NOME_MAE, -- SELECIONA O NOME DA MÃE DO ENVOLVIDO
        ENV.nome_pai, -- SELECIONA O NOME DO PAI DO ENVOLVIDO
        ENV.numero_documento_id, -- SELECIONA O NÚMERO DO DOCUMENTO DE IDENTIDADE DO ENVOLVIDO
        ENV.numero_cpf_cnpj, -- SELECIONA O NÚMERO DO CPF/CNPJ DO ENVOLVIDO
        ENV.data_hora_fato, -- SELECIONA A DATA/HORA DO FATO
        YEAR (ENV.data_hora_fato) as ano, -- SELECIONA O ANO DA DATA/HORA DO FATO
        MONTH (ENV.data_hora_fato) as MES, -- SELECIONA O MÊS DA DATA/HORA DO FATO
        DAY (ENV.data_hora_fato) as DIA, -- SELECIONA O DIA DA DATA/HORA DO FATO
        cast(ENV.data_nascimento as date) as 'data_nascimento', -- SELECIONA E CONVERTE PARA DATA A DATA DE NASCIMENTO DO ENVOLVIDO
        ENV.envolvimento_descricao, -- SELECIONA A DESCRIÇÃO DO TIPO ENVOLVIMENTO 
        ENV.natureza_ocorrencia_codigo, -- SELECIONA A CÓDIGO DA NATUREZA DO ENVOLVIDO
        ENV.tipo_prisao_apreensao_descricao,  -- SELECIONA A DESCRIÇÃO DO TIPO PRISÃO/APREENSÃO DO ENVOLVIDO
        bo.natureza_codigo, -- SELECIONA O CÓDIGO DA NATUREZA DA OCORRÊNCIA
        bo.natureza_descricao, -- SELECIONA A DESCRIÇÃO DA NATUREZA DA OCORRÊNCIA
        bo.natureza_ind_consumado, -- SELECIONA O INDICADOR DE ATO CONSUMADO DA NATUREZA DA OCORRÊNCIA
        bo.natureza_secundaria1_codigo, -- SELECIONA O CÓDIGO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria1_descricao, -- SELECIONA A DESCRIÇÃO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria1_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria2_codigo,-- SELECIONA O CÓDIGO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria2_descricao,  -- SELECIONA A DESCRIÇÃO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria2_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria3_codigo, -- SELECIONA O CÓDIGO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria3_descricao,  -- SELECIONA A DESCRIÇÃO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        bo.natureza_secundaria3_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        cast(bo.codigo_municipio as integer) as codigo_municipio, -- SELECIONA E CONVERTE PARA INTEIRO O NÚMERO DO CÓDIGO DO MUNICÍPIO
        bo.nome_municipio, -- SELECIONA O NOME DO MUNICÍPIO DA OCORRÊNCIA
        bo.nome_bairro, --SELECIONA O NOME DO BAIRRO DA OCORRÊNCIA
        bo.descricao_endereco, -- SELECIONA A DESCRIÇÃO DO ENDEREÇO DA OCORRÊNCIA
        bo.numero_endereco, -- SELECIONA O NÚMERO DO ENDEREÇO DA OCORRÊNCIA
        bo.unidade_area_militar_codigo, -- SELECIONA O CÓDIGO DA UNIDADE ÁREA MILITAR
        bo.unidade_area_militar_nome, -- SELECIONA O NOME DA UNIDADE ÁREA MILITAR
        bo.unidade_responsavel_registro_codigo, -- SELECIONA O  CÓDIGO DA UNIDADE RESPONSÁVEL PELO REGISTRO
        bo.unidade_responsavel_registro_nome -- SELECIONA O  NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO
    FROM
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV -- TABELA DE ENVOLVIDOS
    INNER JOIN FACCIONADOS F ON 
    (
                UPPER(F.nome_completo_faccionado) = UPPER(ENV.nome_completo_envolvido)
                AND UPPER(F.nome_mae_fac) = UPPER(ENV.nome_mae)
                AND F.data_nascimento_fac = ENV.data_nascimento
     ) -- REALIZA JUNÇÃO COM A CTE FACCIONADOS PARA RETORNAR APENAS OS FACCIONADOS QUE EXISTAM NAS DUAS TABELAS, USANDO COMO CHAVE O NOME COMPLETO, NOME DA MÃE E DATA DE NASCIMENTO
    LEFT JOIN db_bisp_reds_reporting.tb_ocorrencia bo ON ENV.numero_ocorrencia = bo.numero_ocorrencia
    WHERE
        1 = 1
        AND ENV.data_hora_fato BETWEEN '2024-01-01 00:00:00' AND '2024-06-30 23:59:59' -- FILTRA A DATA/HORA DO FATO ENTRE O INTERVALO ESPECÍFICADO
        AND ENV.digitador_id_orgao in (0,1) -- FILTRA ID DO ORGÃO DIGITADOR, PM OU PC
        AND bo.nome_tipo_relatorio NOT IN ('RAT','BOS') -- FILTRA O NOME/TIPO RELATÓRIO NÃO É 'RAT' OU 'BOS'
        AND bo.ocorrencia_uf = 'MG' -- FILTRA A UF DA OCORRÊNCIA 'MG'
        AND bo.ind_estado IN ('F','R') -- FILTRA ESTADO DA OCORRÊNCIA, FECHADO OU RECEBIDO
        AND ( 
        	bo.natureza_codigo = 'B01121' OR
        	bo.natureza_secundaria1_codigo = 'B01121' OR
        	bo.natureza_secundaria2_codigo = 'B01121' OR
        	bo.natureza_secundaria3_codigo = 'B01121' 
        	) -- FILTRA O CÓDIGO DA NATUREZA DA OCORRÊNCIA ONDE PELO MENOS EM UM DEVE SER 'HOMICÍDIO'
  ;
  
/*------------------------------------------------------------------------------------------------------------------
 * Este script foi desenvolvido para realizar uma análise das ocorrências de homicídios que têm 
 * o motivo presumido de "Ação de Gangues / Facções Criminosas"
 -----------------------------------------------------------------------------------------------------------------*/
 SELECT 
    OCO.numero_ocorrencia, -- SELECIONA O NÚMERO DE OCORRÊNCIA
    OCO.motivo_presumido_descricao, -- SELECIONA A DESCRIÇÃO DO MOTIVO PRESUMIDO
    OCO.motivo_presumido_codigo,  -- SELECIONA O CÓDIGO DO MOTIVO PRESUMIDO
    OCO.natureza_descricao, -- SELECIONA A DESCRIÇÃO DA NATUREZA DA OCORRÊNCIA
    OCO.natureza_codigo, -- SELECIONA O CÓDIGO DA NATUREZA DA OCORRÊNCIA
    OCO.data_hora_fato, -- SELECIONA A DATA/HORA DO FATO DA OCORRÊNCIA
    OCO.unidade_area_militar_nome, -- SELECIONA O NOME DA UNIDADE ÁREA MLITAR DA OCORRÊNCIA
    OCO.logradouro_nome, -- SELECIONA O NOME DO LOGRADOURO DA OCORRÊNCIA 
    OCO.numero_endereco, -- SELECIONA O NÚMERO DO ENDEREÇO DA OCORRÊNCIA 
    OCO.nome_bairro -- SELECIONA O NOME DO BAIRRO DA OCORRÊNCIA 
FROM 
  db_bisp_reds_reporting.tb_ocorrencia OCO -- TABELA OCORRÊNCIA

WHERE 
    OCO.data_hora_fato BETWEEN '2024-01-01 00:00:00' AND '2024-06-30 23:59:59' -- FILTRA A DATA/HORA DENTRO DO INTERVALO ESPECÍFICADO
    AND (
        OCO.natureza_codigo = 'B01121' OR
        OCO.natureza_secundaria1_codigo = 'B01121' OR
        OCO.natureza_secundaria2_codigo = 'B01121' OR
        OCO.natureza_secundaria3_codigo = 'B01121'
        ) -- FILTRA O CÓDIGO DA NATUREZA DA OCORRÊNCIA ONDE AO MENOS UM É HOMICÍDIO
    AND OCO.motivo_presumido_codigo = '0125' -- FILTRA O CÓDIGO DO MOTIVO PRESUMIDO 'ACAO DE GANGUES / FACCOES CRIMINOSAS'
    AND OCO.unidade_area_militar_nome LIKE '%X BPM%' -- FILTRE A UEOP
    ;
    