/*---------------------------------------------------------------------------------------------------------
 * Esta consulta seleciona informações sobre envolvidos que computam para o IPQ, GDO 2024. Ela é útil para análises 
 * do indicador, gerando de relatórios detalhados para a administração. 
 ---------------------------------------------------------------------------------------------------------*/
-- CTE para criar uma tabela temporária com dados fictícios de mandados de prisão
WITH MANDADO_PRISAO AS (
SELECT UPPER('NOME DO ENVOLVIDO') AS nome_envolvido, UPPER('NOME DA MAE DO ENVOLVIDO') AS nome_mae_envolvido, TO_TIMESTAMP('01/01/1899', 'dd/MM/yyyy') AS data_nascimento_envolvido   UNION
SELECT UPPER('NOME DO ENVOLVIDO DOIS') AS nome_envolvido, UPPER('NOME DA MAE DO ENVOLVIDO DOIS') AS nome_mae_envolvido, TO_TIMESTAMP('31/01/1899', 'dd/MM/yyyy') AS data_nascimento_envolvido   
),
PRESOS_MV AS (
    SELECT
        ENV.nome_completo_envolvido,  -- Seleciona nome completo do envolvido
        ENV.nome_mae,  -- Seleciona nome da mãe do envolvido
        ENV.nome_pai,  -- Seleciona nome do pai do envolvido
        ENV.numero_documento_id,  -- Seleciona número do documento de identidade do envolvido
        ENV.numero_cpf_cnpj,  -- Seleciona CPF/CNPJ do envolvido
        ENV.data_hora_fato,  -- Seleciona data e hora do fato ocorrido
        ENV.data_nascimento  -- Seleciona data de nascimento do envolvido
    FROM
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV  -- Da tabela de envolvidos em ocorrências
    WHERE
        YEAR(ENV.data_hora_fato) >= 2019  -- Considera apenas fatos a partir de 2019
        AND ENV.tipo_prisao_apreensao_descricao IN 
        (  
            'FLAGRANTE DE ATO INFRACIONAL', 
            'FLAGRANTE DE CRIME / CONTRAVEN',
            'MANDADO JUDICIAL',
            'OUTRAS - PRISAO / APREENSAO',
            'RECAPTURA'
        ) -- Filtra por tipos de prisão específicos
        AND ENV.numero_ocorrencia IN 
        (
            SELECT
                ENV2.numero_ocorrencia
            FROM
                db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV2
            WHERE
                YEAR(ENV2.data_hora_fato) >= 2019
                AND ENV2.natureza_ocorrencia_codigo IN 
                (  
                    'B01121', 'C01157', 'B02001', 'B01129'
                ) -- Filtra por ocorrências natureza específica
                AND ENV2.condicao_fisica_descricao = 'FATAL'  -- Condição física fatal
                AND ENV2.envolvimento_descricao LIKE '%VITIMA%'  -- Descrição de envolvimento inclui 'vítima'
        )
),
PRESOS_ROUBO_FURTO AS (
    SELECT
       ENV.nome_completo_envolvido,  -- Seleciona nome completo do envolvido
        ENV.nome_mae,  -- Seleciona nome da mãe do envolvido
        ENV.nome_pai,  -- Seleciona ome do pai do envolvido
        ENV.numero_documento_id,  -- Seleciona número do documento de identidade do envolvido
        ENV.numero_cpf_cnpj,  -- Seleciona CPF/CNPJ do envolvido
        ENV.data_hora_fato,  -- Seleciona data e hora do fato ocorrido
        ENV.data_nascimento  -- Seleciona data de nascimento do envolvido
    FROM
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV
    WHERE
        1 = 1
        AND YEAR (ENV.data_hora_fato) >=2019
        AND (
            ENV.natureza_ocorrencia_codigo IN 
            (
                'C01157',
                'C01155',
                'C01158'
            )-- Filtra por ocorrências natureza específica
        )
        AND ENV.tipo_prisao_apreensao_descricao IN 
        (
            'FLAGRANTE DE ATO INFRACIONAL',
            'FLAGRANTE DE CRIME / CONTRAVEN',
            'MANDADO JUDICIAL',
            'OUTRAS - PRISAO / APREENSAO',
            'RECAPTURA'
        ) -- Filtra por tipos de prisão específicos
),
PRESOS_VDOM AS (
    SELECT
      ENV.nome_completo_envolvido,  -- Seleciona nome completo do envolvido
        ENV.nome_mae,  -- Seleciona nome da mãe do envolvido
        ENV.nome_pai,  -- Seleciona nome do pai do envolvido
        ENV.numero_documento_id,  -- Seleciona número do documento de identidade do envolvido
        ENV.numero_cpf_cnpj,  -- Seleciona CPF/CNPJ do envolvido
        ENV.data_hora_fato,  -- Seleciona data e hora do fato ocorrido
        ENV.data_nascimento  -- Seleciona data de nascimento do envolvido
    FROM
       db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV
    WHERE
        1 = 1
        AND ENV.tipo_prisao_apreensao_descricao IN 
        (
            'FLAGRANTE DE ATO INFRACIONAL',
            'FLAGRANTE DE CRIME / CONTRAVEN',
            'MANDADO JUDICIAL',
            'OUTRAS - PRISAO / APREENSAO',
            'RECAPTURA'
        ) -- Filtra por tipos de prisão específicos
        AND ENV.numero_ocorrencia IN 
        (
            SELECT
                ENV2.numero_ocorrencia
            FROM
                db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV2
            WHERE
                1 = 1
                AND YEAR (ENV2.data_hora_fato) >=2019
                AND ENV2.codigo_sexo ='F' 
				AND ENV2.relacao_vitima_autor_descricao IN ('CONJUGE / COMPANHEIRO','EX-CONJUGE / EX-COMPANHEIRO','CONJUGE','EX-CONJUGE' ,'FILHO / ENTEADO','IRMAO','NAMORADO (A)','RELACIONAMENTO EXTRA-CONJUGAL','PAIS / RESPONSAVEL LEGAL','CO-HABITACAO / HOSPITALIDADE / RELACOES DOMESTICAS','AVOS / BISAVOS / TATARAVOS','NETOS / BISNETOS / TATARANETOS') 
				AND ENV2.envolvimento_descricao IN ('VITIMA','VITIMA - OUTROS','VITIMA DE ACAO CRIMINAL / CIVEL')
        ) -- Filtra por ocorrências de violência doméstica com vitima do sexo feminino, onde o envolvido pesquisado foi preso
),
PRISAO_APREENSAO AS (
    SELECT 
        OCO.digitador_sigla_orgao,  -- Sigla do órgão digitador
        OCO.ind_violencia_domestica,  -- Indicador de violência doméstica
        OCO.numero_ocorrencia,  -- Número da ocorrência
        OCO.natureza_codigo,  -- Código da natureza da ocorrência
        OCO.natureza_descricao,  -- Descrição da natureza da ocorrência
        OCO.data_hora_fato,  -- Data e hora do fato
        ENV.ind_mandado_prisao,  -- Indicador de mandado de prisão
        ENV.ind_mandado_prisao_atual,  -- Indicador de mandado de prisão atual
        ENV.natureza_ocorrencia_codigo,  -- Código da natureza da ocorrência envolvendo o indivíduo
        ENV.natureza_ocorrencia_descricao,  -- Descrição da natureza da ocorrência envolvendo o indivíduo
        ENV.nome_completo_envolvido,  -- Nome completo do envolvido
        ENV.nome_mae,  -- Nome da mãe do envolvido
        ENV.nome_pai,  -- Nome do pai do envolvido
        ENV.numero_documento_id,  -- Número do documento de identidade do envolvido
        ENV.data_nascimento,  -- Data de nascimento do envolvido
        ENV.tipo_prisao_apreensao_descricao  -- Descrição do tipo de prisão/apreensão      
    FROM
        db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV
        INNER JOIN tb_ocorrencia OCO ON OCO.numero_ocorrencia = ENV.numero_ocorrencia  -- Junção das tabelas de ocorrência e envolvidos
    WHERE
        ENV.tipo_prisao_apreensao_descricao IN 
        (  
            'FLAGRANTE DE ATO INFRACIONAL',
            'FLAGRANTE DE CRIME / CONTRAVEN',
            'MANDADO JUDICIAL',
            'OUTRAS - PRISAO / APREENSAO',
            'RECAPTURA',
            'TCO/FLAGRANTE INFRACAO DE MENOR POTENCIAL OFENSIVO'
        ) -- Filtra por tipos específicos de prisão/apreensão
        AND OCO.digitador_sigla_orgao = 'PM'  -- Filtra por ocorrências registradas pela Polícia Militar
)
SELECT
    CASE
        WHEN MV.nome_completo_envolvido IS NOT NULL THEN 'MV_COMUM'
        WHEN RF.nome_completo_envolvido IS NOT NULL THEN 'ROUBO_FURTO'
        WHEN VD.nome_completo_envolvido IS NOT NULL THEN 'VIOLENCIA_DOMESTICA'
    END AS ICCP,     -- Classifica os envolvidos com base na presença de seus nomes nas tabelas temporárias
    PA.ind_mandado_prisao,  -- Indicador de mandado de prisão
    PA.ind_mandado_prisao_atual,  -- Indicador de mandado de prisão atual
    PA.ind_violencia_domestica,  -- Indicador de violência doméstica
    PA.nome_completo_envolvido,  -- Nome completo do envolvido
    PA.nome_mae,  -- Nome da mãe do envolvido
    PA.data_nascimento,  -- Data de nascimento do envolvido
    PA.numero_ocorrencia,  -- Número da ocorrência
    PA.data_hora_fato,  -- Data e hora do fato
    PA.tipo_prisao_apreensao_descricao,  -- Descrição do tipo de prisão/apreensão
    PA.natureza_codigo AS CODIGO_NATUREZA_OCORRENCIA,  -- Código da natureza da ocorrência
    PA.natureza_descricao AS DESCRICAO_NATUREZA_OCORRENCIA,  -- Descrição da natureza da ocorrência
    PA.natureza_ocorrencia_codigo AS C_NATUREZA_ENVOLVIDO,  -- Código da natureza envolvendo o indivíduo
    PA.natureza_ocorrencia_descricao AS NATUREZA_ENVOLVIDO,  -- Descrição da natureza envolvendo o indivíduo
    PA.digitador_sigla_orgao  -- Sigla do órgão digitador
FROM
    MANDADO_PRISAO MP
    LEFT JOIN PRESOS_MV MV 
    	ON MP.nome_envolvido = MV.nome_completo_envolvido
		    AND MP.nome_mae_envolvido = MV.nome_mae 
		    AND MP.data_nascimento_envolvido = MV.data_nascimento
    LEFT JOIN PRESOS_ROUBO_FURTO RF 
    	ON MP.nome_envolvido = RF.nome_completo_envolvido 
		    AND MP.nome_mae_envolvido = RF.nome_mae 
		    AND MP.data_nascimento_envolvido = RF.data_nascimento
    LEFT JOIN PRESOS_VDOM VD 
   	 	ON MP.nome_envolvido = VD.nome_completo_envolvido 
		    AND MP.nome_mae_envolvido = VD.nome_mae 
		    AND MP.data_nascimento_envolvido = VD.data_nascimento
    LEFT JOIN PRISAO_APREENSAO  PA 
    	ON MP.nome_envolvido = PA.nome_completo_envolvido 
		    AND MP.nome_mae_envolvido = PA.nome_mae 
		    AND MP.data_nascimento_envolvido = PA.data_nascimento
WHERE
    YEAR(PA.data_hora_fato) >= 2019  -- Filtra ocorrências a partir de 2019
    AND (
        MV.nome_completo_envolvido IS NOT NULL OR  
        RF.nome_completo_envolvido IS NOT NULL OR  
        VD.nome_completo_envolvido IS NOT NULL  
    	) -- Retorna apenas indivíduos que tem passagem por pelo menos um destes indicadores
ORDER BY 
    PA.ind_mandado_prisao,  -- Ordena primeiramente pelo indicador de mandado de prisão
    PA.nome_completo_envolvido,  -- Ordena pelo nome do envolvido
    PA.data_hora_fato,  -- Ordena pela data e hora do fato
    PA.numero_ocorrencia  -- Ordena pelo número da ocorrência
