/*--------------------------------------------------------------------------------------------------------
 * Este código SQL é utilizado para identificar e retornar dados de ocorrências, especificamente 
 * focando em verificar se o campo de e-mail de envolvidos está preenchido ou não e retornando o motivo
 * do não preenchimento.
 -------------------------------------------------------------------------------------------------------*/
-- Seleciona campos relevantes das tabelas de ocorrência e envolvidos para visualização
SELECT
   OCO.NUMERO_OCORRENCIA,                          -- Número identificador da ocorrência
   TO_DATE(OCO.data_hora_inclusao) AS DATA_INCLUSAO, -- Data de inclusão da ocorrência convertida para o formato de data
   OCO.NOME_TIPO_RELATORIO,                        -- Tipo do relatório da ocorrência
   OCO.unidade_responsavel_registro_nome,          -- Nome completo da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Última parte do nome da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Penúltima parte do nome da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Terceira última parte do nome da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -4) AS PEL, -- Quarta última parte do nome da unidade responsável pelo registro
		SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -5) AS GP, -- Quinta última parte do nome da unidade responsável pelo registro
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
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia  
-- Filtros aplicados para selecionar ocorrências específicas
WHERE 1 = 1 
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela polícia militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- Exclui certas condições físicas
  AND OCO.nome_tipo_relatorio IN('POLICIAL', 'TRANSITO')      -- Filtra ocorrências com tipos de relatório 'POLICIAL' ou 'TRANSITO'
  AND OCO.data_hora_inclusao BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
-- Ordenação dos resultados pelo número da ocorrência
ORDER BY 1;
