--------------------------------------------------------------------------------------------------------
/*
 * Este código SQL é utilizado para identificar e retornar dados de ocorrências, especificamente 
 * focando em verificar se o campo de e-mail de envolvidos está preenchido ou não, além de incluir 
 * diversas informações adicionais sobre as ocorrências e os envolvidos
 */
--------------------------------------------------------------------------------------------------------
-- Seleciona campos relevantes das tabelas de ocorrência e envolvidos para visualização
SELECT
   OCO.NUMERO_OCORRENCIA,                          -- Número identificador da ocorrência
   TO_DATE(OCO.data_hora_inclusao) AS DATA_INCLUSAO, -- Data de inclusão da ocorrência convertida para o formato de data
   OCO.NOME_TIPO_RELATORIO,                        -- Tipo do relatório da ocorrência
   OCO.unidade_responsavel_registro_nome,          -- Nome completo da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS N1, -- Última parte do nome da unidade
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS N2, -- Penúltima parte do nome
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS N3, -- Terceira última parte do nome
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -4) AS N4, -- Quarta última parte do nome
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -5) AS N5, -- Quinta última parte do nome
   ENV.motivo_ausencia_telmail_codigo,            -- Código do motivo da ausência de telefone ou e-mail
   ENV.motivo_ausencia_telmail_descricao,         -- Descrição do motivo da ausência de telefone ou e-mail
   ENV.envolvimento_codigo,                       -- Código do tipo de envolvimento do indivíduo na ocorrência
   ENV.envolvimento_descricao,                    -- Descrição do tipo de envolvimento
   ENV.condicao_fisica_codigo,                    -- Código da condição física do envolvido
   ENV.condicao_fisica_descricao,                 -- Descrição da condição física
   ENV.EMAIL,                                     -- E-mail do envolvido
   CASE 
        WHEN ENV.email IS NULL                    -- Verifica se o campo de e-mail está preenchido
        THEN 'NÃO PREENCHIDO' ELSE 'PREENCHIDO'   -- Retorna 'NÃO PREENCHIDO' se email for NULL, senão 'PREENCHIDO'
        END AS Qtd_Null
-- Fonte dos dados e a condição de junção entre tabelas
FROM tb_ocorrencia OCO
JOIN tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia  
-- Filtros aplicados para selecionar ocorrências específicas
WHERE YEAR(OCO.data_hora_inclusao) = 2023                    -- Filtra ocorrências do ano 2023
 AND MONTH(OCO.data_hora_inclusao) BETWEEN 11 AND 12         -- Filtra ocorrências nos meses de novembro e dezembro
 AND OCO.relator_sigla_orgao = 'PM'                          -- Filtra ocorrências relatadas pela Polícia Militar
 AND OCO.descricao_estado = 'FECHADO'                        -- Filtra ocorrências que estão com status 'FECHADO'
 AND OCO.ocorrencia_uf = 'MG'                                -- Filtra ocorrências no estado de Minas Gerais
 AND OCO.nome_tipo_relatorio IN('POLICIAL', 'TRANSITO')      -- Filtra ocorrências com tipos de relatório 'POLICIAL' ou 'TRANSITO'
-- Ordenação dos resultados pelo número da ocorrência
ORDER BY 1;
