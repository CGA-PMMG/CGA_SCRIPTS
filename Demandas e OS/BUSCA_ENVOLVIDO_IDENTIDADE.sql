/*----------------------------------------------------------------------------------------------------------------------------
 * Este script foi desenvolvido para realizar uma análise detalhada de envolvidos.
 * A análise é feita através da criação de uma tabela temporária de dados do envolvido e da junção CTE com a
 * tabela de envolvidos e ocorrências, retornando todas ocorrências vinculadas ao número do documento.
 *
 ---------------------------------------------------------------------------------------------------------------------------*/
WITH 
-- CTE PARA CRIAR TABELA TEMPORARIA COM DADO (NUMERO DA IDENTIDADE) DO ENVOLVIDO.
DADOS_ENVOLVIDO AS
(
SELECT ('numero_identidade_envolvido') AS numero_documento UNION
SELECT ('numero_identidade_envolvido') AS numero_documento 
)-- 
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
        ENV.natureza_ocorrencia_codigo natureza_envolvido_codigo, -- SELECIONA A CÓDIGO DA NATUREZA DO ENVOLVIDO
        ENV.tipo_prisao_apreensao_descricao,  -- SELECIONA A DESCRIÇÃO DO TIPO PRISÃO/APREENSÃO DO ENVOLVIDO
        OCO.natureza_codigo natureza_ocorrencia_codigo, -- SELECIONA O CÓDIGO DA NATUREZA DA OCORRÊNCIA
        OCO.natureza_descricao natureza_ocorrencia_descricao, -- SELECIONA A DESCRIÇÃO DA NATUREZA DA OCORRÊNCIA
        OCO.natureza_ind_consumado, -- SELECIONA O INDICADOR DE ATO CONSUMADO DA NATUREZA DA OCORRÊNCIA
        OCO.natureza_secundaria1_codigo, -- SELECIONA O CÓDIGO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria1_descricao, -- SELECIONA A DESCRIÇÃO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria1_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA PRIMEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria2_codigo,-- SELECIONA O CÓDIGO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria2_descricao,  -- SELECIONA A DESCRIÇÃO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria2_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA SEGUNDA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria3_codigo, -- SELECIONA O CÓDIGO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria3_descricao,  -- SELECIONA A DESCRIÇÃO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        OCO.natureza_secundaria3_ind_consumado,  -- SELECIONA O INDICADOR DE ATO CONSUMADO DA TERCEIRA NATUREZA SECUNDÁRIA DA OCORRÊNCIA
        cast(OCO.codigo_municipio as integer) as codigo_municipio, -- SELECIONA E CONVERTE PARA INTEIRO O NÚMERO DO CÓDIGO DO MUNICÍPIO
        OCO.nome_municipio, -- SELECIONA O NOME DO MUNICÍPIO DA OCORRÊNCIA
        OCO.nome_bairro, --SELECIONA O NOME DO BAIRRO DA OCORRÊNCIA
        OCO.descricao_endereco, -- SELECIONA A DESCRIÇÃO DO ENDEREÇO DA OCORRÊNCIA
        OCO.numero_endereco, -- SELECIONA O NÚMERO DO ENDEREÇO DA OCORRÊNCIA
        OCO.unidade_area_militar_codigo, -- SELECIONA O CÓDIGO DA UNIDADE ÁREA MILITAR
        OCO.unidade_area_militar_nome, -- SELECIONA O NOME DA UNIDADE ÁREA MILITAR
        OCO.unidade_responsavel_registro_codigo, -- SELECIONA O  CÓDIGO DA UNIDADE RESPONSÁVEL PELO REGISTRO
        OCO.unidade_responsavel_registro_nome -- SELECIONA O  NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO
    FROM
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV -- TABELA DE ENVOLVIDOS
    INNER JOIN DADOS_ENVOLVIDO DADOS_ENV ON ENV.numero_documento_id = DADOS_ENV.numero_documento -- JUNÇÃO COM A CTE DADOS_ENVOLVIDO PELO NUMERO DE IDENTIDADE DO ENVOLVIDO
    INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO ON ENV.numero_ocorrencia = OCO.numero_ocorrencia -- JUNÇÃO COM A TABELA DE OCORRENCIAS PELO NUMERO DA OCORRENCIA
    WHERE
        1 = 1
        AND ENV.data_hora_fato BETWEEN '2012-01-01 00:00:00' AND '2025-01-01 23:59:59' -- FILTRA A DATA/HORA DO FATO ENTRE O INTERVALO ESPECÍFICADO
        AND ENV.digitador_id_orgao in (0,1) -- FILTRA ID DO ORGÃO DIGITADOR, PM OU PC
        AND OCO.nome_tipo_relatorio = 'POLICIAL' -- FILTRA O NOME/TIPO RELATÓRIO POLICIAL
        AND OCO.ocorrencia_uf = 'MG' -- FILTRA A UF DA OCORRÊNCIA 'MG'
        AND OCO.ind_estado = 'F' -- FILTRA ESTADO DA OCORRÊNCIA, FECHADO

  