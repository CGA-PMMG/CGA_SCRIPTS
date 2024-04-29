/*﻿--------------------------------------------------------------------------------------------------------------------------
 * Este codigo SQL foi desenvolvido para fornecer uma analise detalhada das armas apreendidas ou recuperadas em 
 * ocorrencias policiais registradas pela Policia Militar de Minas Gerais entre os anos de 2018 e 2022. A consulta 
 * é util para rastrear a quantidade e o tipo de armas envolvidas em crimes ao longo do tempo, permitindo às autoridades 
 * policiais avaliar a eficacia das iniciativas de controle de armas e planejar estratégias futuras de prevenção e 
 * repressão ao crime.
 * --------------------------------------------------------------------------------------------------------------------------*/
SELECT 
  YEAR(OCO.data_hora_fato) AS ANO,  -- EXTRAI O ANO DA DATA DO FATO
  AFO.numero_arma,  -- NÚMERO DE IDENTIFICAÇÃO DA ARMA
  AFO.numero_serie,  -- NÚMERO DE SÉRIE DA ARMA
  AFO.calibre_arma_codigo,  -- CÓDIGO DO CALIBRE DA ARMA
  AFO.tipo_arma_descricao,  -- DESCRIÇÃO DO TIPO DE ARMA
  OCO.numero_ocorrencia,  -- NÚMERO DA OCORRÊNCIA POLICIAL
  OCO.relator_sigla_orgao,  -- SIGLA DO ÓRGÃO RELATOR (PM, PC, ETC.)
  OCO.descricao_estado,  -- ESTADO DA OCORRÊNCIA (FECHADO, ABERTO, ETC.)
  OCO.nome_municipio,  -- NOME DO MUNICÍPIO ONDE OCORREU O FATO
  OCO.data_hora_fato  -- DATA E HORA DO FATO
-- FONTES DOS DADOS
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_arma_ocorrencia AFO
ON OCO.numero_ocorrencia = AFO.numero_ocorrencia 
-- CONDIÇÕES PARA SELEÇÃO DE DADOS
WHERE 
    YEAR(OCO.data_hora_fato) BETWEEN 2018 AND 2022  -- FILTRA INTERVALO TEMPORAL DAS OCORRÊNCIAS
    AND (AFO.situacao_descricao IN ('APREENDIDO', 'RECUPERADO'))  -- FILTRA ARMAS QUE FORAM APREENDIDAS OU RECUPERADAS
    AND AFO.tipo_arma_descricao NOT IN ( 
							'ARMA DE PRESSAO IGUAL FZ 7,62MM', 
						        'ARMAS DE PRESSAO ACIMA DE 6MM',
							'ARMAS DE PRESSAO IGUAL OU INFERIOR A 6MM', 
							'NAO INFORMADO' 
				        ) -- EXCLUI TIPOS DE ARMAS QUE NÃO SÃO RELEVANTES PARA A ANÁLISE
    AND OCO.relator_sigla_orgao = 'PM'  -- FILTRA OCORRÊNCIAS REGISTRADAS PELA POLÍCIA MILITAR
    AND OCO.ocorrencia_uf = 'MG'  -- FILTRA OCORRÊNCIAS NO ESTADO DE MINAS GERAIS
    AND OCO.descricao_estado = 'FECHADO'  -- FILTRA SOMENTE OCORRÊNCIAS QUE ESTÃO FECHADAS
   -- AND OCO.unidade_area_militar_nome LIKE '%X BPM/X RPM%' -- FILTRE SUA BPM/RPM
-- ORDENAMENTO DOS RESULTADOS POR ANO, MUNICÍPIO
 ORDER BY ANO DESC, nome_municipio;
