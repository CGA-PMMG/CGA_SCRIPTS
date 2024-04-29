/*-------------------------------------------------------------------------------------------------------------------
 * Esse código proporciona uma visão detalhada das ocorrências da PMMG por faixa etária e unidade operacional,
 * o que pode ser crucial para análises estratégicas e de desempenho das unidades. Ele foi estruturado para 
 * facilitar modificações, como filtrar por unidades específicas ou ajustar o intervalo de idades conforme necessário.
 -------------------------------------------------------------------------------------------------------------------*/
SELECT  
    OCO.numero_ocorrencia, -- Número da ocorrência
    YEAR(OCO.data_hora_fato), -- Ano da data fato da ocorrência
    YEAR(ENV.data_nascimento), -- Ano de nascimento do envolvido
    ((YEAR(OCO.data_hora_fato)) - (YEAR(ENV.data_nascimento))) AS IDADE, -- Calculo de idade, baseado na diferença entre a data do fato e a data de nascimento do envolvido
    OCO.nome_municipio, -- Nome do município
    OCO.unidade_area_militar_nome -- Unidade da área militar
FROM 
    tb_ocorrencia OCO
    INNER JOIN tb_envolvido_ocorrencia ENV 
    ON OCO.numero_ocorrencia = ENV.numero_ocorrencia 
WHERE 
    YEAR(OCO.data_hora_fato) = 2024 --Filtra o ano da data hora do fato
    AND OCO.DIGITADOR_SIGLA_ORGAO = 'PM' -- Filtra registros digitados pela PM
    AND OCO.ocorrencia_uf = 'MG' -- Filtr o estado de Minas Gerais
    AND OCO.descricao_estado = 'FECHADO' -- Filtra registros com a descrição do estado como FECHADO
    AND ENV.tipo_prisao_apreensao_codigo IN ('9900', '0400', '0100', '0300', '0600', '0200') -- Filtra determinado tippo de apreensão
    AND OCO.nome_municipio  LIKE '%XXXX%' -- Filtre seu município
	--AND OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%'-- FILTRE SUA CIA/BM/RPM
-- ORDENAÇÃO DOS RESULTADOS PELA IDADE DOS ENVOLVIDOS PARA FACILITAR ANÁLISES DEMOGRÁFICAS
ORDER BY IDADE
