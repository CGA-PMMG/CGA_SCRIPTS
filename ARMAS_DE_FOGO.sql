/*﻿--------------------------------------------------------------------------------------------------------------------------
 * Este codigo SQL foi desenvolvido para fornecer uma analise detalhada das armas apreendidas ou recuperadas em 
 * ocorrencias policiais registradas pela Policia Militar de Minas Gerais entre os anos de 2018 e 2022. A consulta 
 * é util para rastrear a quantidade e o tipo de armas envolvidas em crimes ao longo do tempo, permitindo às autoridades 
 * policiais avaliar a eficacia das iniciativas de controle de armas e planejar estratégias futuras de prevenção e 
 * repressão ao crime.
 * --------------------------------------------------------------------------------------------------------------------------*/
SELECT 
    YEAR(tb_ocorrencia.data_hora_fato) AS ANO,  -- EXTRAI O ANO DA DATA DO FATO
    tb_arma_ocorrencia.numero_arma,  -- NÚMERO DE IDENTIFICAÇÃO DA ARMA
    tb_arma_ocorrencia.numero_serie,  -- NÚMERO DE SÉRIE DA ARMA
    tb_arma_ocorrencia.calibre_arma_codigo,  -- CÓDIGO DO CALIBRE DA ARMA
    tb_arma_ocorrencia.tipo_arma_descricao,  -- DESCRIÇÃO DO TIPO DE ARMA
    tb_ocorrencia.numero_ocorrencia,  -- NÚMERO DA OCORRÊNCIA POLICIAL
    tb_ocorrencia.relator_sigla_orgao,  -- SIGLA DO ÓRGÃO RELATOR (PM, PC, ETC.)
    tb_ocorrencia.descricao_estado,  -- ESTADO DA OCORRÊNCIA (FECHADO, ABERTO, ETC.)
    tb_ocorrencia.nome_municipio,  -- NOME DO MUNICÍPIO ONDE OCORREU O FATO
    tb_ocorrencia.data_hora_fato  -- DATA E HORA DO FATO
-- FONTES DOS DADOS
FROM db_bisp_reds_reporting.tb_ocorrencia
JOIN db_bisp_reds_reporting.tb_arma_ocorrencia 
ON tb_ocorrencia.numero_ocorrencia = tb_arma_ocorrencia.numero_ocorrencia 
-- CONDIÇÕES PARA SELEÇÃO DE DADOS
WHERE 
    YEAR(tb_ocorrencia.data_hora_fato) BETWEEN 2018 AND 2022  -- INTERVALO TEMPORAL DAS OCORRÊNCIAS
    AND (tb_arma_ocorrencia.situacao_descricao IN ('APREENDIDO', 'RECUPERADO'))  -- FILTRA ARMAS QUE FORAM APREENDIDAS OU RECUPERADAS
    AND tb_arma_ocorrencia.tipo_arma_descricao NOT IN (  -- EXCLUI TIPOS DE ARMAS QUE NÃO SÃO RELEVANTES PARA A ANÁLISE
        'ARMA DE PRESSAO IGUAL FZ 7,62MM', 
        'ARMAS DE PRESSAO ACIMA DE 6MM',
        'ARMAS DE PRESSAO IGUAL OU INFERIOR A 6MM', 
        'NAO INFORMADO' )
    AND tb_ocorrencia.relator_sigla_orgao = 'PM'  -- OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR
    AND tb_ocorrencia.ocorrencia_uf = 'MG'  -- OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND tb_ocorrencia.descricao_estado = 'FECHADO'  -- SOMENTE OCORRÊNCIAS QUE ESTÃO FECHADAS
   -- AND tb_ocorrencia.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/RPM
-- (OPCIONAL) ORDENAMENTO DOS RESULTADOS POR ANO, MUNICÍPIO OU OUTRO CAMPO RELEVANTE
 ORDER BY ANO DESC, nome_municipio;
