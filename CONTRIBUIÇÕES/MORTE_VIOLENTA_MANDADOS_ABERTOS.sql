/*-----------------------------------------------------------------------------------------------------------
 * O objetivo do script é identificar indivíduos envolvidos em ocorrências de morte violenta que possuem 
 * mandados de prisão abertos.Além disso, o script busca trazer informações sobre a última passagem desses
 * indivíduos pelo sistema prisional, como admissão, desligamento e unidade prisional. 
 * 
 * OBS.: A junção desta busca para a tabela 'tb_individuo_sigpri' é feita pelo NOME DO INDIVIDUO, 
 * NOME DA MÃE DO INDIVIDUO E DATA DE NASCIMENTO. Evitando homônimo e sendo mais precisa.
 * 
 * O resultado é filtrado por eventos fatais a partir de 2019 e organizado pela data mais recente do fato.
 * 
 * Contribuição: Gabriel A S e Brito, Sd PM
 -----------------------------------------------------------------------------------------------------------*/
WITH ultima_admissao AS 
( -- Cria uma CTE (Common Table Expression) chamada ultima_admissao
    SELECT 
        sig.nome_individuo, -- Seleciona o nome do indivíduo
		from_unixtime(unix_timestamp(sig.data_nascimento_individuo, 'dd/M/yyyy'), 'yyyy-MM-dd')   as data_nascimento, -- Seleciona e converte a data de nascimento do individuo para o padrão da tabela Envolvido - DB Reds Reporting
        sig.mae_individuo, -- Seleciona o nome da mãe do indivíduo
        sig.pai_individuo, -- Seleciona o nome do pai do indivíduo
        MAX(oco.numero_ocorrencia) as numero_Reds, -- Seleciona o maior número de ocorrência (última ocorrência)
        MAX(env.data_hora_fato) AS ultima_data_hora_fato, -- Seleciona a data/hora do último fato ocorrido
        MAX(oco.nome_municipio) as municipio_fato, -- Seleciona o nome do município do fato 
        sig.numero_sip, -- Seleciona o número SIP do indivíduo
        sig.numero_infopen, -- Seleciona o número Infopen do indivíduo
        MAX(adm.data_de_admissao) AS ultima_admissao_presidio, -- Seleciona a última data de admissão no presídio
        COALESCE(MAX(adm.data_do_desligamento), NULL) AS ultimo_desligamento_presidio, -- Seleciona a última data de desligamento ou NULL se não houver
        MAX(adm.nome_unidade_admissao) AS nome_unidade_admissao, -- Seleciona o nome da unidade onde ocorreu a última admissão
        MAX(adm.descricao_motivo_admissao) AS descricao_motivo_admissao, -- Seleciona a descrição do motivo da última admissão
        MAX(adm.descricao_motivo_do_desligamento) AS descricao_motivo_do_desligamento, -- Seleciona a descrição do motivo do último desligamento
        MAX(sip.mandados) AS mandados, -- Seleciona o maior número de mandados do indivíduo
        MAX(sip.mandadosabertos) AS mandadosabertos, -- Seleciona o maior número de mandados abertos do indivíduo
        'MORTE_VIOLENTA' AS Autor_De -- Define uma constante 'MORTE_VIOLENTA' como o valor para Autor_De
    FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env -- Tabela de envolvidos na ocorrência
    INNER JOIN db_bisp_sip_reporting.vw_individuo_sip AS sip -- Faz um INNER JOIN com a view vw_individuo_sip baseada no número SIP
        ON env.numero_individuo_sip = sip.numero_sip
    INNER JOIN db_bisp_sigpri_reporting.tb_individuo_sigpri sig -- Faz um INNER JOIN com a tabela tb_individuo_sigpri baseada no nome do indivíduo,da mãe e sua data de nascimento.
        ON (env.nome_completo_envolvido = sig.nome_individuo
        AND env.nome_mae = sig.mae_individuo 
        AND CAST(env.data_nascimento AS DATE) =  from_unixtime(unix_timestamp(sig.data_nascimento_individuo, 'dd/M/yyyy'), 'yyyy-MM-dd'))
    INNER JOIN db_bisp_sigpri_reporting.tb_admissao adm -- Faz um INNER JOIN com a tabela tb_admissao baseado no número Infopen
        ON sig.numero_infopen = adm.numero_infopen
    INNER JOIN db_bisp_reds_reporting.tb_ocorrencia oco -- Faz um INNER JOIN com a tabela tb_ocorrencia baseado no número da ocorrência
        ON env.numero_ocorrencia = oco.numero_ocorrencia 
    WHERE
    1=1 -- Condição sempre verdadeira para facilitar adição de mais filtros
          AND env.data_hora_fato >= '2019-01-01' -- Filtra data/hora fato maior igual a x
        --AND oco.codigo_municipio in (0,0,...) -- Filtre por códigos de municípios específicos
        AND env.digitador_id_orgao in (0,1) -- Filtra por digitadores de órgãos com ID 0 ou 1
		AND env.id_tipo_prisao_apreensao IN (1,2,3,4,6,7) -- Filtra por tipos de prisão/apreensão específicos (FLAGRANTE DE ATO INFRACIONAL, FLAGRANTE DE CRIME / CONTRAVEN, MANDADO JUDICIAL, RECAPTURA, OUTRAS - PRISAO / APREENSAO, TCO/FLAGRANTE INFRACAO DE MENOR POTENCIAL OFENSIVO)
        AND env.numero_ocorrencia IN 
        ( 
            SELECT -- Subconsulta para obter ocorrências com base nos critérios
                ENV2.numero_ocorrencia
            FROM
                db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV2 
            WHERE
                1 = 1 -- Condição sempre verdadeira para facilitar adição de mais filtros
                AND ENV2.data_hora_fato >= '2019-01-01' -- Filtra fatos ocorridos a partir de 1 de janeiro de 2019
                AND ENV2.digitador_id_orgao in (0,1) -- Filtra por digitadores de órgãos com ID 0 ou 1
                AND ENV2.natureza_ocorrencia_codigo IN ( -- Filtra por códigos de natureza da ocorrência
                    'B01121', -- Homicídio 
                    'C01157', -- Roubo
                    'B02001', -- Tortura
                    'B01129' -- Lesão Corporal
                )
                AND ENV2.condicao_fisica_descricao = 'FATAL' -- Filtra ocorrências onde a condição física foi 'FATAL'
                AND ENV2.id_envolvimento IN (25,32,1097,26,27,28,872) -- Filtra por códigos de envolvimento que representam vítimas 
        )
        AND sip.mandadosabertos <> 0 -- Filtra indivíduos que possuem mandados abertos, diferente de zero
    GROUP BY 
        sig.nome_individuo, -- Agrupa pelo nome do indivíduo
        data_nascimento, -- Agrupa pela data de nascimento do individuo
        sig.mae_individuo, -- Agrupa pelo nome da mãe do indivíduo
        sig.pai_individuo, -- Agrupa pelo nome do pai do indivíduo
        sig.numero_sip, -- Agrupa pelo número SIP
        sig.numero_infopen -- Agrupa pelo número Infopen
)
SELECT * -- Seleciona todos os campos da CTE criada
FROM ultima_admissao -- Consulta a CTE ultima_admissao
ORDER BY ultima_data_hora_fato DESC  -- Ordena os resultados pela última data e hora do fato ocorrido, em ordem decrescente
