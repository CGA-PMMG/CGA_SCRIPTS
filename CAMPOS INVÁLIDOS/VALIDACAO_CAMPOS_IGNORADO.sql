/*-------------------------------------------------------------------------------------------------------------------------------
 * A finalidade deste código é identificar detalhes sobre as partes envolvidas em ocorrências
 *  policiais fechadas, avaliando se informações críticas, como identificação por CPF ou CNPJ, estão sendo 
 * adequadamente registradas.
 * 
 * PARA FAZER A VERIFICAÇÃO DE OUTROS CAMPOS, APENAS TROQUE A CLAUSULA DO CASE WHEN 
 * EXEMPLO:
 * PARA VALIDAR A CUTIS TROCAR O 'ENV.numero_cpf_cnpj IS NULL' PARA 'ENV.cor_pele_codigo IS NULL OR ENV.cor_pele_codigo = '9800'' 
 ---------------------------------------------------------------------------------------------------------------------------------*/
-- Seleciona campos relevantes das tabelas de ocorrência e envolvidos
SELECT 
    OCO.numero_ocorrencia,  -- Número da ocorrência
    ENV.numero_envolvido,   -- Número identificador do envolvido
    OCO.digitador_matricula,  -- Matrícula de quem digitou a ocorrência
    YEAR(OCO.data_hora_fato),  -- Ano em que o fato ocorreu
    -- Verifica se o campo CPF/CNPJ está preenchido ou não
    CASE WHEN ENV.numero_cpf_cnpj IS NULL THEN 'NÃO PREENCHIDO' ELSE 'PREENCHIDO' END AS Status_CPF_CNPJ
FROM 
    db_bisp_reds_reporting.tb_ocorrencia OCO
    -- Junta a tabela de ocorrências com a tabela de envolvidos
    JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia
WHERE 1 = 1
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela polícia militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND ENV.envolvimento_codigo IN ('1300', '1301', '1302', '1303', '1304', '1305', '1399') -- Filtra pelos códigos de envolvimento: apenas vítimas
  AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100') -- Exclui certas condições físicas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
 -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro
