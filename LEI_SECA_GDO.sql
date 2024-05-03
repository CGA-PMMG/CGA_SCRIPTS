/*---------------------------------------------------------------------------------------------------------
 * Esta consulta seleciona informações detalhadas sobre RAT, opeções LEI SECA.  Ela é útil para análises 
 * de eficiência e eficácia de operações, GDO 2023, gerando de relatórios detalhados para a administração. 
 ---------------------------------------------------------------------------------------------------------*/
SELECT 				rat.numero_ocorrencia,  -- Seleciona o número da ocorrência 
					rat.natureza_codigo,  -- Seleciona o código natureza da ocorrência
					rat.natureza_descricao_longa, -- Seleciona a descrição natureza da ocorrência
					rat.natureza_consumado, -- Seleciona o valor 'tentado'/'consumado'
                    rat.natureza_secundaria1_codigo, -- Seleciona a primeira natureza secundária 
                    rat.natureza_secundaria2_codigo, -- Seleciona a segunda natureza secundária 
                    rat.natureza_secundaria3_codigo, -- Seleciona a terceira natureza secundária 
                    rat.complemento_natureza_descricao_longa, -- Seleciona o complemento da natureza 
                    rat.data_hora_fato, -- Seleciona a data hora do fato
                    rat.data_hora_final, -- Seleciona a data hora final do fato
                    rat.nome_tipo_relatorio, -- Seleciona o nome do relatório 
                    rat.digitador_nome, -- Seleciona o nome do digitador 
                    rat.digitador_cargo_efetivo, -- Seleciona o cargo do digitador
                    rat.relator_matricula, -- Selciona a matrícula do relator
                    rat.relator_cargo, -- Selciona o cargo do relator
                    rat.relator_nome, -- Selciona o nome do relator
                    rat.digitador_matricula, -- Selciona a matrícula do digitador
                    rat.unidade_responsavel_registro_nome_orgao, -- Seleciona o orgão da unidade responsável pelo registro
                    rat.ocorrencia_uf, -- UF da ocorrência 
                    (unix_timestamp(rat.data_hora_final) - unix_timestamp(rat.data_hora_fato)) / 60 AS diferenca_minutos, -- Calcula a diferença em minutos do final e inicio do fato 
                    integ.EFETIVO, -- Seleciona a quantidade do efetivo
                    viatu.VIATURA, -- Seleciona a quantidade de viatura 
                    prod.PESS_ABORDADAS, -- Seleciona a quantidade de pessoas abordadas 
                    prod.TESTE_ETILOMETRO, -- Seleciona a quantidade de testes de etilometro realizados 
                    prod.VEIC_FISCALIZADOS, -- Seleciona a quantidade de veículos fiscalizados 
                    rat.unidade_responsavel_registro_nome, -- Seleciona a unidade responsável pelo registro
                    rat.unidade_area_militar_nome, -- Seleciona a área militar
                    rat.tipo_logradouro_descricao, -- Seleciona a descrição do  logradouro do fato
                    rat.logradouro_nome, -- Seleciona o logradouro do fato          
                    rat.descricao_endereco, -- Seleciona a descrição do endereço 
                    rat.numero_endereco, -- Seleciona o número do endereço 
                    rat.descricao_complemento_endereco, -- Seleciona a descrição do endereço 
                    rat.descricao_ponto_referencia, -- Seleciona o ponto de referência do endereço 
                    rat.nome_bairro, -- Seleciona o nome do bairro
                    rat.numero_latitude, -- Seleciona a latitude
                    rat.numero_longitude, -- Seleciona a longitude
                    rat.nome_municipio, -- Seleciona o nome do município
                    rat.descricao_estado, -- Seleciona a estado da ocorrêcia 
                    case -- cálculo EFICIENCIA : Tempo de duração maior ou igual a 30 minutos, efetivo maior ou igual a 02 policiais militares e emprego de pelo menos 01 (uma) viatura
                        when efetivo >= 2
                        and viatura >= 1
                        and (unix_timestamp(data_hora_final) - unix_timestamp(data_hora_fato)) / 60 >= 30 -- minutos
                        then 1
                        else 0
                        end as EFICIENCIA,  --  
                    case -- cálculo EFICACIA: : 03 pessoas abordadas ou 03 testes de etilômetro realizados ou 03 veículos fiscalizado
                        when pess_abordadas >= 3
                        or teste_etilometro >= 3
                        or veic_fiscalizados >= 3
                        then 1
                        else 0
                        end as EFICACIA
                  FROM tb_ocorrencia AS rat
                  LEFT JOIN (SELECT numero_ocorrencia, count(*) as EFETIVO FROM tb_integrante_guarnicao_ocorrencia
                              GROUP BY numero_ocorrencia
                              )integ -- Seleciona campo 'numero_ocorrencia' e conta a quantidade de efetivo empenhado na ocorrência para retornar no join 
                  ON integ.numero_ocorrencia=rat.numero_ocorrencia
                  LEFT JOIN (SELECT numero_ocorrencia, count(*) as VIATURA FROM tb_viatura_ocorrencia
                              GROUP BY numero_ocorrencia
                              )viatu -- Seleciona campo 'numero_ocorrencia' e conta a quantidade de viaturas empenhadas na ocorrência para retornar no join 
                  ON viatu.numero_ocorrencia=rat.numero_ocorrencia
                  LEFT JOIN (SELECT  numero_ocorrencia, SUM(quantidade) as QTDE,   
                              SUM(
                                    CASE
                                        WHEN indicador_descricao ='Qde de pessoas abordadas' -- descrição na tabela produtividade 
                                        THEN quantidade
                                        ELSE 0
                                    	END
                                 ) AS PESS_ABORDADAS, -- Seleciona campo 'numero_ocorrencia', conta a quantidade de pessoas abordadas na ocorrência, soma o contador e retorna ao join 
                              SUM(
                                    CASE
                                        WHEN indicador_descricao ='Qde de pessoas que sopraram o etilômetro'
                                        THEN quantidade
                                        ELSE 0
                                    	END
                                 ) AS TESTE_ETILOMETRO, -- Seleciona campo 'numero_ocorrencia', conta a quantidade de testes de etilometro realizados na ocorrência, soma o contador e retorna ao join    
                                SUM(
                                    CASE
                                        WHEN indicador_descricao ='Qde de veículos fiscalizados'
                                        THEN quantidade
                                        ELSE 0
                                    	END
                                 	) AS VEIC_FISCALIZADOS   -- Seleciona campo 'numero_ocorrencia', conta a quantidade de veículos fiscalizados na ocorrência, soma o contador e retorna ao join 
                              FROM tb_rat_produtividade_ocorrencia
                              GROUP BY numero_ocorrencia
                              )prod
                  ON prod.numero_ocorrencia=rat.numero_ocorrencia
                  WHERE YEAR(data_hora_fato) = 2023 -- Filtra o ano da data hora fato
                  and nome_tipo_relatorio = 'RAT' -- Filtra tipo específico de relatório
                  and nome_municipio like '%BELO HORIZONTE%' -- Filtra município 
				  and natureza_codigo = 'Y04012'  -- Filtra naturza específica
                 