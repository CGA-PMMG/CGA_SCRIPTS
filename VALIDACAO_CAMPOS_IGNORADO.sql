/*-------------------------------------------------------------------------------------------------------------------------------
 * A finalidade deste código é identificar detalhes sobre as partes envolvidas em ocorrências
 *  policiais fechadas, avaliando se informações críticas, como identificação por CPF ou CNPJ, estão sendo 
 * adequadamente registradas. Isso pode ser útil para auditorias internas, garantindo a integridade 
 * e completude dos registros policiais.
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
    tb_ocorrencia OCO
    -- Junta a tabela de ocorrências com a tabela de envolvidos
    JOIN tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia
WHERE 
    YEAR(OCO.data_hora_fato) = 2024  -- Filtra ocorrências do ano de 2024
    AND OCO.relator_sigla_orgao = 'PM'  -- Apenas ocorrências relatadas pela Polícia Militar
    AND OCO.ocorrencia_uf = 'MG'  -- Apenas ocorrências no estado de Minas Gerais
    AND OCO.descricao_estado = 'FECHADO'  -- Apenas ocorrências que estão com o estado fechado
    AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO')  -- Exclui tipos de relatório específicos
    AND ENV.envolvimento_codigo IN ('1300','1301','1302','1303','1304','1305','1399') -- Filtra por códigos de envolvimento específicos
    AND ENV.condicao_fisica_codigo NOT IN ('0300', '0100')  -- Exclui códigos de condição física 
